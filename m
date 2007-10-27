Return-Path: <linux-kernel-owner+w=401wt.eu-S1764307AbXJ0BHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764307AbXJ0BHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 21:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXJ0BHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 21:07:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33775 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752759AbXJ0BHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 21:07:16 -0400
Date: Fri, 26 Oct 2007 18:07:13 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071026180713.aeedfac2.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Issue:

    Are the nodes and nodemasks passed into set_mempolicy() to be
    presumed relative to the cpuset or not?  [Careful, this question
    doesn't mean what you might think it means.]

Let's say our system has 100 nodes, numbered 0-99, and we have a task
in a cpuset that includes the twenty nodes 10-29 at the moment.

Currently, if that task does say an MPOL_PREFERRED on node 12, we take
that to mean the 3rd node of its cpuset.  If we move that task to a
cpuset on nodes 40-59, the kernel will change that MPOL_PREFERRED to
node 42.  Similarly for the other MPOL_* policies.

Ok so far ... seems reasonable.  Node numbers passed into the
set_mempolicy call are taken to be absolute node numbers that are to
be mapped relative to the tasks current cpuset, perhaps unbeknownst
to the calling task, and remapped if that cpuset changes.

But now imagine that a task happens to be in a cpuset of just two
nodes, and wants to request an MPOL_PREFERRED policy for the fourth
node of its cpuset, anytime there actually is a fourth node.  That
task can't say that using numbering relative to its current cpuset,
because that cpuset only has two nodes.  It could say it relative to
a mask of all possible nodes by asking for the fourth possible node,
likely numbered node 3.

If that task happened to be in a cpuset on nodes 10 and 11, asking
for the fourth node in the system (node 3) would still be rather
unambiguous, as node 3 can't be either of 10 or 11, so must be
relative to all possible nodes, meaning "the fourth available node,
if I'm ever fortunate enough to have that many nodes."

But if that task happened to be in a cpuset on nodes 2 and 3, then
the node number 3 could mean:

Choice A:
    as it does today, the second node in the tasks cpuset or it could
    mean

Choice B:
    the fourth node in the cpuset, if available, just as
    it did in the case above involving a cpuset on nodes 10 and 11.

Let me restate this.

Either way, passing in node 3 means node 3, as numbered in the system.

But the question is whether (Choice A) node 3 is specified because
it is the second node in the tasks cpuset, or (Choice B) because it
is the fourth node in the system.

Choice A is what we do now.  But if we stay with Choice A, then a
task stuck in a small cpuset at the moment can't express non-trivial
mempolicy's for larger cpusets that it might be in later.

Choice B lets the task calculate its mempolicy mask as if it owned
the entire system, and express whatever elaborate mempolicy placement
it might need, when blessed with enough memory nodes to matter.
The system would automatically scrunch that request down to whatever
is the current size and placement of the cpuset holding that task.

Given a clean slate, I prefer Choice B.

But Choice B is incompatible.   Switching now would break tasks that
had been carefully adapting their set_mempolicy requests to whatever
nodes were in their current cpuset.  This is probably too incompatible
to be acceptable.

Therefore it must be Choice A.

However ...

If I approach this from another angle, I can show it should be
Choice B.  Fasten your seatbelt ...

Before the days of cpusets, Choice B was essentially how it was.
Tasks computing memory policies for set_mempolicy() calls computed
node numbers as if they owned the entire system.

Essentially, cpusets introduced an incompatibility, imposing Choice
A instead.  If a task wants to name the fourth node allowed to it in
a memory policy, it can no longer just say node "3", but now has to
determine its cpuset, and count off the fourth node that is currently
allowed to it.  This is an inherently racey calculation, of the sort
that some of us would find unacceptable, because it can't cope very
easily with simultaneously changing cpusets.

My hunch (unsupported by any real evidence or experience) is that
there is very little user level code that actually depends on this
incompatible change imposed by cpusets.  I'm guessing that most
codes making heavy use of memory policies are still coded as if the
task owns the system, and would be ill prepared to cope with a heavy
cpuset environment.

If that's the case, we'd break less user code by going with Choice B.

I have a little bit of code that will notice the difference (so if
we go with Choice B, there has to be a way for user level code that
cares to probe which choice applies), but I'm not a major user of
mempolicy calls.

I'll have to rely on the experience of others more involved with memory
policy aware user code as to which Choice would be less disruptive.

Recommendations?


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

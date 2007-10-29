Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbXJ2HQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbXJ2HQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXJ2HP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:15:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43865 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751581AbXJ2HP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:15:56 -0400
Date: Mon, 29 Oct 2007 00:15:54 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071029001554.c12b6b6c.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
	<20071028164637.8d1b45b0.pj@sgi.com>
	<alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
	<20071028212745.57a7db67.pj@sgi.com>
	<alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> The problem that I see with immediately offering both choices is that we 
> don't know if anybody is actually reverting back to Choice A behavior 
> because libnuma, by default, would use it.  That's going to making it very 
> painful to remove later.

Yes, that's a problem.  I would rather end up with both Choices
forever, than breaking stuff because we changed how memory policy
nodes are numbered.

> We should only 
> support both choices if they will both be used and there's no hard 
> evidence to suggest that at this point.

No.  We could only remove Choice A if we had hard evidence that
it wouldn't break things, especially for the libnuma-Oracle stack.

Either way, we obviously have to decide this lacking sufficient
hard evidence.  Changing memory policy node numbering is just way
too likely to break things, in ways that users initially find
difficult to diagnose.  We -can-not- inflict that on our users
in a single, sudden, change.  We must stage it, starting by
adding the new.

> You earlier insisted on an ease of documentation for the MPOL_INTERLEAVE 
> case and now this dual support that you're proposing is going to make the 
> documentation very difficult to understand for anyone who simply wants to 
> use mempolicies.

Yup - that's a problem.  But it is one that users can control.
If they just continue using memory policies and libnuma as before,
it continues to work as before.  If they need to deal with situations
in which applications using memory policies are being moved around
between larger and smaller cpusets, and they are willing and able to
modify and improve the part of their code that handles memory policies,
then they can read the new section of the documentation about this
improved cpuset-relative node numbering, and give it a try.

Blind siding users with a unilateral change like this will leave
orphaned bits gasping in agony on the computer room floor.  It can
sometimes takes months of elapsed time and hundreds of hours of various
peoples time across a dozen departments in three to five corporations
to track down the root cause of such a problem, from the point of the
initial failure, back to the desk of someone like you or me.  And then
it can take tens or hundreds more hours of human effort to deliver a
fix.  I refuse to knowingly go down that road.

I will not agree to suddenly replacing Choice A with Choice B.


> And that application would need to [...] Choice A can't possibly
> be what they want.

People do this sort of stuff all the time; they just don't realize
what all is going on beneath the surface of the various tools,
libraries, scripts and magic incantations that they cobble together to
meet their needs.

Choice A is meeting most of our needs.  Not until you brought
up this case of MPOL_INTERLEAVE across the nodes of a job being
moved between varying size cpusets did it prove inadequate.


> I hope you still support what we earlier talked about in 
> terms of adding a field to struct mempolicy to remember the intended 
> nodemask the application asked to interleave over.

Yes - that's a key element of the Choice B implementation.

> I thought what we agreed upon and what you were going to implement was 
> adding a nodemask_t to struct mempolicy for the intended nodemask of the 
> memory policy and then AND it with pol->cpuset_mems_allowed.

Not "AND".  Fold - the n-th bit is set in a tasks mems_allowed iff
there exists m such that (m % w) == n, and such that the m-th bit is
set in the tasks mempolicy's remembered nodemask, where w is the weight
(number of '1' bits) in the tasks current cpusets mems_allowed. See
lib/bitmap.c:bitmap_remap(), and its wrapper nodes_remap() for the
implementation.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

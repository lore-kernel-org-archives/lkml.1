Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbYBWMJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbYBWMJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYBWMJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:09:26 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49223 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751500AbYBWMJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:09:25 -0500
Date: Sat, 23 Feb 2008 06:09:11 -0600
From: Paul Jackson <pj@sgi.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Dilger <adilger@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Spang <daniel.spang@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jon Masters <jonathan@jonmasters.org>,
       Marcelo Tosatti <marcelo@kvack.org>, Paul Menage <menage@google.com>,
       Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Tiny cpusets -- cpusets for small systems?
Message-Id: <20080223060911.e1d13cc1.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of proposals have been made recently by people working Linux
on smaller systems, for improving realtime isolation and memory
pressure handling:

(1) cpu isolation for hard(er) realtime
	http://lkml.org/lkml/2008/2/21/517
	Max Krasnyanskiy <maxk@qualcomm.com>
	[PATCH sched-devel 0/7] CPU isolation extensions

(2) notify user space of tight memory
	http://lkml.org/lkml/2008/2/9/144
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
	[PATCH 0/8][for -mm] mem_notify v6

In both cases, some of us have responded "why not use cpusets", and the
original submitters have replied "cpusets are too fat"  (well, they
were more diplomatic than that, but I guess I can say that ;)

I wonder if there might be room for a "tiny cpusets" configuration
option:
  * provide the same hooks to the rest of the kernel, and
  * provide the same syntactic interface to user space, but
  * with more limited semantics.

The primary semantic limit I'd suggest would be supporting exactly
one layer depth of cpusets, not a full hierarchy.  So one could still
successfully issue from user space 'mkdir /dev/cpuset/foo', but trying
to do 'mkdir /dev/cpuset/foo/bar' would fail.  This reminds me of
very early FAT file systems, which had just a single, fixed size
root directory ;).  There might even be a configurable fixed upper
limit on how many /dev/cpuset/* directories were allowed, further
simplifying the locking and dynamic memory behavior of this apparatus.

Some other features that aren't so easy to implement, and which have
less value on small systems, such as notify_on_release, could also be
stubbed out and always disabled, simply returning error if requested
to be enabled from user space.  The recent, chunky piece of code
needed to compute dynamic sched domains from the cpuset hierarchy
probably admits of a simpler variant in the tiny cpuset configuration.

I suppose it would still be a vfs-based pseudo file system (even
embedded Linux still has that infrastructure), except that the vfs
operator functions could be simpler, as this would really be just
a flat set of cpumask_t's and nodemask_t's at the core of the
implementation, not an arbitrarily nested hierarchy of them.  See
further my comments on cgroups, below.

The rest of the kernel would see no difference ... except that some
of the cpuset_*() hooks would return more quickly.  This tiny cpuset
option would provide the same kernel hooks as are now provided by
the defines and inline stubs, in the "#else" to "#endif" half of the
"#ifdef CONFIG_CPUSETS" code lines in linux/cpuset.h.

User space would see the same API, except that some valid operations
on full cpusets, such as a nested mkdir, would fail on tiny cpusets.

How this extends to cgroups I don't know; for now I suspect that most
cgroup module development is motivated by the needs of larger systems,
not smaller systems.  However, cpusets is now a module client of
cgroups, and it is cgroups that now provides cpusets with its interface
to the vfs infrastructure.  It would seem unfortunate if this relation
was not continued with tiny cpusets.  Perhaps someone can imagine a tiny
cgroups?  This might be the most difficult part of this proposal.

Looking at some IA64 sn2 config builds I have laying about, I see the
following text sizes for a couple of versions, showing the growth of
the cpuset/cgroup apparatus over time:

	25933	2.6.18-rc3-mm1/kernel/cpuset.o (Aug 2006)
vs.
	37823	2.6.25-rc2-mm1/kernel/cgroup.o (Feb 2008)
	19558	2.6.25-rc2-mm1/kernel/cpuset.o

So the total has grown from 25933 to 57381 text bytes (note that
this is IA64 arch; most arch's will have proportionately smaller
text sizes.)

Unfortunately, ideas without code are usually met with the sound of
silence, as well they should be.  Furthermore, I can promise that I
have no time to design or develop this myself; my good employer is
quite focused on the other end of things - the big honkin NUMA and
cluster systems.


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214

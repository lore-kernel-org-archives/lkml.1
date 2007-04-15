Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbXDORkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbXDORkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 13:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXDORkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 13:40:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:35854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXDORki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 13:40:38 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [AppArmor 31/41] Fix __d_path() for lazy unmounts and make it unambiguous; exclude unreachable mount points from /proc/mounts
Date: Sun, 15 Apr 2007 19:40:21 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <20070412090846.670863000@suse.de> <20070412105825.15f4df39@the-village.bc.nu>
In-Reply-To: <20070412105825.15f4df39@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200704151940.22528.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 11:58, Alan Cox wrote:
> > Third, sys_getcwd() shouldn't return disconnected paths.  The patch checks 
for
> > that, and makes it fail with -ENOENT in that case
> 
> That is a fairly significant and sudden change to the existing
> kernel/user interface.

Well, this is not meant for 2.6.21. I hope it is possible to change it in 
early 2.6.22; otherwise if we can't fix mistakes from the past we are pretty 
doomed.

The problem with unreachable paths is that they are meaningless to the 
process -- the unreachable path does not really work as a path anymore, it 
could at best serve some informational value -- at worst it could lead to 
hard to track down misbehavior. ENOENT is a documented error code for 
``directory has been unlinked''. The man page does not mention unreachable 
paths, but the documentation can easily be changed.

What's an unreachable path to one process may be a reachable path for another, 
or may not be reachable at all (such as the rootfs).

> > Fourth, this now allows us to tell unreachable mount points from reachable
> > ones when generating the /proc/mounts and /proc/$pid/mountstats files. 
> > Unreachable mount points are not interesting to processes (they can't get
> > there, anyway), so we hide unreachable mounts.  In particular, ordinary
> 
> This is untrue. The process can get there (via fd passing with another
> task)

Process can access file descriptors which are unreachable via path name just 
fine indeed, but those fds still don't have a valid path in the context of 
that process.

Mount points in /proc/mounts as well as paths returned by getcwd() are 
relative to the chroot of the querying process, and listing a mount point 
that is unreachable by that process just doesn't help anybody -- that 
particular process cannot do anything with them anyway.

> and the process can be producing output for the human operators, who most
> definitely need to know and see this stuff.

We are only talking about mount points unreachable by a particular process; 
this does not mean that the mount point isn't reachable by other processes. 
Human operators can choose the context from which they are looking 
at /proc/mounts. If they are looking form the "real" root, the will see all 
mounts that any process can reach (in that namespace).

The rootfs is an example of a mount point that is not reachable by any process 
(after the initrd init process): listing it in /proc/mounts is totally 
pointless, for example -- the rootfs has no meaning to any of those 
processes. (From the point of view of the initrd init process the rootfs is 
reachable of course, and so it also shows up in /proc/mounts.) 

Another context in which the current /proc/mounts doesn't make sense is chroot 
environments: right now if you have proc mounted on /proc as usual as well as 
in a chroot, from the point of view of the "real" root, /proc/mounts will 
contain something like this (omitting all other mounts):

	proc /proc proc rw 0 0
	proc /chroot/proc proc rw 0 0

>From the point of view of the chroot, we get:

	proc /proc proc rw 0 0
	proc /proc proc rw 0 0

So there is no way to tell what's really mounted where (and how) from within 
the chroot. That's really quite broken.

Now it would be possible to use some other syntax to disambiguate unreachable 
mounts in /proc/mounts, like letting such paths start with "//", or removing 
leading slashes in those cases. At least removing leading slashes is quite 
likely to break applications though, and such a hack wouldn't really help 
anybody.

Whatever syntax we could come up with, those paths would be meaningless in the 
given context. They may be meaningful in other context -- exactly if the 
paths are reachable.

> I don't think this is fit to apply in current form. The hiding of mounts
> and mountstats is the wrong approach. The changes to getcwd behaviour
> bother me too as we are changing user space behaviour without warning.

Which kind of warning do you have in mind?

Thanks,
Andreas

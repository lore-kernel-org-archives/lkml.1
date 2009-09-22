Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZIVVGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZIVVGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZIVVGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZIVVGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:06:41 -0400
Subject: Re: fanotify as syscalls
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Jamie Lokier <jamie@shareable.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
In-Reply-To: <200909212204.51077.agruen@suse.de>
References: <20090912094110.GB24709@ioremap.net>
	 <200909190000.43556.agruen@suse.de>
	 <1253329471.2630.30.camel@dhcp231-106.rdu.redhat.com>
	 <200909212204.51077.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Sep 2009 17:06:16 -0400
Message-Id: <1253653576.2747.27.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 22:04 +0200, Andreas Gruenbacher wrote:
> On Saturday, 19 September 2009 5:04:31 Eric Paris wrote:
> > Let me start by saying I am agreeing I should pursue subtree
> > notification.  It's what I think everyone really wants.  It's a great
> > idea, and I think you might have a simple way to get close.  Clearly
> > these are avenues I'm willing and hoping to pursue.  Also I say it
> > again, I believe the interface as proposed (except maybe some of my
> > exclusion stuff) is flexible enough to implement any of these ideas.
> > Does anyone disagree?
> 
> It does seem flexible enough. However, the current interface assumes "global" 
> listeners (the mask argument of fanotify_init):
> 
>   int fanotify_init(int flags, int f_flags, __u64 mask,
> 		    unsigned int priority);
> 
> Once subtree support is added, this parameter becomes obsolete. That's pretty 
> broken for a syscall yet to be introduced.

Absolutely not obsolete.  Subtree notification cannot do fscking all
notification.  

> > BUT to solve one of the main problems fanotify is intending to solve it
> > needs a way to be the 'fscking all notifier.'  It needs to be the whole
> > damn system.
> 
> Think of a system after boot, with a single global namespace. Whatever you 
> access by filename is reachable from the namespace root. At this point, 
> nothing more global exists. A listener can watch the mount points of 
> interest, and everything's fine.

this is true, if there is only one namespace subtree notification works
the same as global notification.

> What's a bit more tricky is to ensure that this listener will continue to 
> receive all events from whatever else is mounted anywhere, irrespective of 
> namespaces. I think we can get there.

Lets say I want the subtree under / to get every event on the system.  A
process comes along and clones the namespace.  Then lets say that
process mounts something inside his new namespace.  There is absolutely
no path between my / and that new mount.  How can subtree checking
possibly find and indicate it wants notification about this mount?  I
don't see how subtree checking could do it.  There can be completely
disjoint trees with no overlap.

mount -t tmpfs none /to_umount
clone namespace
mount -t tmpfs none /to_umount/private
pivot_root /tmp_umount/private
Something else umounts /to_umount

That process is in an completely detached namespace?  right?

Heck, there could be operations on files that aren't in ANY namespace.

a = open(/path/to/dir/);
umount -l /path/to/
openat(a, "filename");

I don't see how subtree notification can possibly solve the global
notification problem.

I've been thinking that checking CAP_SYS_RAWIO as well as CAP_SYS_ADMIN
might be reasonable when trying to use a global listener.  If you can
CAP_SYS_RAWIO I sorta feel like you can break out of a namespace anyway,
right?

-Eric


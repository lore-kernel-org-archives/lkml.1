Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZL3VLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZL3VLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZL3VLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:11:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbZL3VLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:11:30 -0500
Date: Wed, 30 Dec 2009 13:10:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Borislav Petkov <petkovbb@googlemail.com>, David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
 (was: Re: Linux 2.6.33-rc2 - Merry Christmas ...)
In-Reply-To: <20091228092712.AA8C.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain> <20091226094504.GA6214@liondog.tnic> <20091228092712.AA8C.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Dec 2009, KOSAKI Motohiro wrote:
> >        [<ffffffff810694c0>] __lock_acquire+0x1373/0x16fd
> >        [<ffffffff8106993c>] lock_acquire+0xf2/0x116
> >        [<ffffffff810bb2b5>] might_fault+0x95/0xb8			<- mmap_sem
> >        [<ffffffff810e87d6>] filldir+0x75/0xd0				<- sysfs_mutex
> >        [<ffffffff8112be2a>] sysfs_readdir+0x10f/0x149
> 
> This output seems to suggest need to fix drm.

Actually, this painful dependency may technically be a bug in drm, but at 
the same time, it's really filldir() that makes it _very_ hard for certain 
locking scenarios because it has that callback to the VFS layer that takes 
the mmap_sem, and sysfs itself wants the sysfs_mutex in paths where it is 
not at all unreasonable to hold the mmap_sem.

We've seen it several times (yes, mostly with drm, but it's been seen with 
others too), and it's very annoying. It can be fixed by having very 
careful readdir implementations, but I really would blame sysfs in 
particular for having a very annoying lock reversal issue when used 
reasonably.

So the optimal situation would be for sysfs to not have that annoying lock 
dependency, and it would really have to be sysfs_readdir() that drops the 
sysfs_mutex around the filldir call (and that obviously implies having to 
re-validate and be really careful).

Added Eric and Greg to the cc, in case the sysfs people want to solve it.

The other alternative would be to fix this on a VFS layer by changing how 
'readdir/filldir' interacts, and instead make it fill in a kernel buffer - 
avoiding the mmap_sem issue entirely. And than later (in readdir) that 
kernel buffer could be copied to user space without holding any other 
locks.

I like the VFS approach because I think we could possibly use that as a 
first approach to eventually try to think about caching readdir() results 
at a VFS level - readdir() is currently the _only_ main filesystem 
callback that always calls into the low-level filesystem, and always takes 
a lot of locks. I'm adding Al to the Cc for that - he knows about this 
issue from me previously thinking aloud along these lines.

And yes, one option would be to just fix drm - by avoiding calling any 
sysfs functions while holding the mmap_lock (either in the mmap callback 
or the page fault paths). However, as mentioned, I really do think that 
the blame can be laid on sysfs for trying to be a nice generic interface, 
but having a damn inconvenient locking model.

			Linus

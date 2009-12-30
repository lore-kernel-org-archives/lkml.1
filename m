Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZL3WDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZL3WDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZL3WDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:03:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbZL3WDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:03:32 -0500
Date: Wed, 30 Dec 2009 14:03:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
 (was: Re: Linux 2.6.33-rc2 - Merry Christmas ...)
In-Reply-To: <m11victac1.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain> <20091226094504.GA6214@liondog.tnic> <20091228092712.AA8C.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain> <m11victac1.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Dec 2009, Eric W. Biederman wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > We've seen it several times (yes, mostly with drm, but it's been seen with 
> > others too), and it's very annoying. It can be fixed by having very 
> > careful readdir implementations, but I really would blame sysfs in 
> > particular for having a very annoying lock reversal issue when used 
> > reasonably.
> 
> Maybe.  The mnmap_sem has some interesting issues all of it's own.
> What reasonable thing is the drm doing that is causing problems?

The details are in the original thread on lkml, but it boils down to 
basically (the below may not be the exact sequence, but it's close)

 - drm_mmap (called with mmap_sem) takes 'dev->struct_mutex' to protect 
   it's own device data (very reasonable)

 - drm_release takes 'dev->struct_mutex' again to protect its own data, 
   and calls "mtrr_del_page()" which ends up taking cpu_hotplug.lock.

   Again, that doesn't sound "wrong" in any way.

 - hibernate ends up with the sequence: _cpu_down (cpu_hotplug.lock) ->  ..
   kref_put .. -> sysfs_addrm_start (sysfs_mutex)

   Again, nothing suspicious or "bad", and this part of the dependency 
   chain has nothing to do with the DRM code itself.

 - sysfs_readdir() (and this is the big problem) holds sysfs_mutex in its
   readdir implementation over the call to filldir. And filldir copies the 
   data to user space, so now you have sysfs_mutex -> mmap_sem.

See? None of the chains look bad. Except sysfs_readdir() obviously has 
that sysfs_mutex -> mmap_sem thing, which is _very_ annoying, because now 
you end up with a chain like

   mmap_sem -> dev->struct_mutex -> cpu_hotplug.lock -> sysfs_mutex -> mmap_sem

and I think you'll agree that of all the lock chains, the place to break 
the association is at sysfs_mutex. And the obvious place to break it would 
be that last "sysfs_mutex -> mmap_sem" stage.

> > Added Eric and Greg to the cc, in case the sysfs people want to solve it.
> 
> There are scalability reasons for dropping the sysfs_mutex in sysfs_readdir
> and I have some tenative patches for that.  I will take a look after I
> come back from the holidays, in a couple of days.  I don't understand
> the issue as described.

Ok, hopefully the above chain explains it to you, and also makes it clear 
that it's rather hard to break anywhere else, and it's not somebody else 
doing anything "obviously bogus".

Btw, the scalability issues with readdir() in general is why I'd be open 
to try to change the rules for filldir(), and always make it a kernel 
space copy. I suspect a number of users would like being able to use 
spinlocks over filldir, but it's currently impossible. 

However, we have a lot of filldir implementations (knfsd and several 
different system call interfaces), and while some of them already use 
kernel buffers (eg knfsd) others would need to allocate temporary storage 
and then do a double copy. And I suspect even things like knfsd do things 
like sleep and take locks, so it's possible that actually getting to the 
point where filldir could be spinlock-safe would be infeasible.

			Linus

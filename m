Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbZLaIkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbZLaIkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 03:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZLaIki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 03:40:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50691 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZLaIkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 03:40:37 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected (was: Re: Linux 2.6.33-rc2 - Merry Christmas ...)
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
In-Reply-To: <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain> (Linus Torvalds's message of "Wed\, 30 Dec 2009 14\:03\:25 -0800 \(PST\)")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Date: Thu, 31 Dec 2009 00:40:33 -0800
Message-ID: <m1eimbtu2m.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 30 Dec 2009, Eric W. Biederman wrote:
>
>> Linus Torvalds <torvalds@linux-foundation.org> writes:
>> 
>> > We've seen it several times (yes, mostly with drm, but it's been seen with 
>> > others too), and it's very annoying. It can be fixed by having very 
>> > careful readdir implementations, but I really would blame sysfs in 
>> > particular for having a very annoying lock reversal issue when used 
>> > reasonably.
>> 
>> Maybe.  The mnmap_sem has some interesting issues all of it's own.
>> What reasonable thing is the drm doing that is causing problems?
>
> The details are in the original thread on lkml, but it boils down to 
> basically (the below may not be the exact sequence, but it's close)

Thanks.

>  - drm_mmap (called with mmap_sem) takes 'dev->struct_mutex' to protect 
>    it's own device data (very reasonable)
>
>  - drm_release takes 'dev->struct_mutex' again to protect its own data, 
>    and calls "mtrr_del_page()" which ends up taking cpu_hotplug.lock.
>
>    Again, that doesn't sound "wrong" in any way.
>
>  - hibernate ends up with the sequence: _cpu_down (cpu_hotplug.lock) ->  ..
>    kref_put .. -> sysfs_addrm_start (sysfs_mutex)
>
>    Again, nothing suspicious or "bad", and this part of the dependency 
>    chain has nothing to do with the DRM code itself.

kobject_del with a lock held scares me.

There is a possible deadlock (that lockdep is ignorant of) if you hold
a lock over sysfs_deactivate() and if any sysfs file takes that lock.

I won't argue with a claim of inconvenient locking semantics here, and
this is different to the problem you are seeing (except that fixing this
problem would happen to fix the filldir issue).

>  - sysfs_readdir() (and this is the big problem) holds sysfs_mutex in its
>    readdir implementation over the call to filldir. And filldir copies the 
>    data to user space, so now you have sysfs_mutex -> mmap_sem.
>
> See? None of the chains look bad. Except sysfs_readdir() obviously has 
> that sysfs_mutex -> mmap_sem thing, which is _very_ annoying, because now 
> you end up with a chain like
>
>    mmap_sem -> dev->struct_mutex -> cpu_hotplug.lock -> sysfs_mutex -> mmap_sem
>
> and I think you'll agree that of all the lock chains, the place to break 
> the association is at sysfs_mutex. And the obvious place to break it would 
> be that last "sysfs_mutex -> mmap_sem" stage.

I agree that fixing sysfs_readdir to not hold the sysfs_mutex over filldir
is useful to reduce the lock hold time if nothing else.

The cheap fix here is mostly a matter of grabbing a reference to the
sysfs_dirent and then revalidating that the reference is still useful
after we reacquire the sysfs_mutex.  If not we already have the code for
restarting from just an offset.  We just don't want to use it too much as
that will give us O(n^2) times for sysfs readdir.

I will see if I can dig up or regenerate my patch in the next couple of days.

>> > Added Eric and Greg to the cc, in case the sysfs people want to solve it.
>> 
>> There are scalability reasons for dropping the sysfs_mutex in sysfs_readdir
>> and I have some tenative patches for that.  I will take a look after I
>> come back from the holidays, in a couple of days.  I don't understand
>> the issue as described.
>
> Ok, hopefully the above chain explains it to you, and also makes it clear 
> that it's rather hard to break anywhere else, and it's not somebody else 
> doing anything "obviously bogus".

We very definitely have an ABBA deadlock with sysfs_deactivate and the
cpu_hotplug.lock.  arch/x86/kernel/microcode_core.c:reload_store() is the
code for a sysfs file that when written to calls get_online_cpus().

Regardless of what we do with sysfs_readdir we need to see if we can
fix cpu_down(), to remove this nasty deadlock.

Eric

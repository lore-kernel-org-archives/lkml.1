Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086Ab0AAPQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0AAPQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883Ab0AAPQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:16:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41771 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0AAPQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:16:52 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Tejun Heo <tj@kernel.org>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected (was: Re: Linux 2.6.33-rc2 - Merry Christmas ...)
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 01 Jan 2010 07:16:46 -0800
In-Reply-To: <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain> (Linus Torvalds's message of "Thu\, 31 Dec 2009 11\:04\:48 -0800 \(PST\)")
Message-ID: <m11vi9c0td.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 31 Dec 2009, Eric W. Biederman wrote:
>> >
>> >  - hibernate ends up with the sequence: _cpu_down (cpu_hotplug.lock) ->  ..
>> >    kref_put .. -> sysfs_addrm_start (sysfs_mutex)
>> >
>> >    Again, nothing suspicious or "bad", and this part of the dependency 
>> >    chain has nothing to do with the DRM code itself.
>> 
>> kobject_del with a lock held scares me.
>
> I would not object at _all_ if sysfs fixed the locking here instead of in 
> filldir.

I just sent you my sysfs filldir scalability patch, so we can take that
red-herring off the plate.

The problem as I see it is that kobject_del is convenient.
kobject_del waits until all of the sysfs show and store methods for
that kobject have stopped executing.  Which imposes the rule that
kobject_del can not be called with any locks held that are taken in a
sysfs show or store method.  This is all invisible to lockdep as the
wait is done with a completion and not a lock.

Which unfortunately means fixing filldir only removes some noise from
the picture, and completely hides the problem from lockdep.


....

Looking at the case I am familiar with in the networking layer I think
I have stumbled on a way to sort out this locking problem.

Today the network layer effectively does:
rtnl_lock();
device_del(dev);
rtnl_unlock();
kobject_put(dev);


sysfs_deactivate happens in the device_del(), but if we were to move
sysfs_deactivate into the final kobject_put then in theory we can
continue to block and be friendly but not need to be called with
locations where locks are held.

The core idea is to allow unlisting devices from sysfs under a lock
while still waiting for all users to complete after it is safe to
drop the lock.

Does that work for the cpu hotplug case?  Doing everything from
notifiers makes me suspect it will fail.


....


Either way we will need some lockdep warnings for sysfs_deactivate
so that the problem does not continue to hide and silently foul
things up.  So I will see if I can cook something.

Eric

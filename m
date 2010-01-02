Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392Ab0ABC52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0ABC52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 21:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333Ab0ABC52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 21:57:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:57821 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab0ABC51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 21:57:27 -0500
Message-ID: <4B3EB687.7000005@kernel.org>
Date: Sat, 02 Jan 2010 11:59:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>	<20091226094504.GA6214@liondog.tnic>	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>	<m11victac1.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>	<m1fx6rtu31.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain> <m11vi9c0td.fsf@fess.ebiederm.org>
In-Reply-To: <m11vi9c0td.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On 01/02/2010 12:16 AM, Eric W. Biederman wrote:
>>> kobject_del with a lock held scares me.
>>
>> I would not object at _all_ if sysfs fixed the locking here instead of in 
>> filldir.
> 
> I just sent you my sysfs filldir scalability patch, so we can take that
> red-herring off the plate.
> 
> The problem as I see it is that kobject_del is convenient.
> kobject_del waits until all of the sysfs show and store methods for
> that kobject have stopped executing.  Which imposes the rule that
> kobject_del can not be called with any locks held that are taken in a
> sysfs show or store method.  This is all invisible to lockdep as the
> wait is done with a completion and not a lock.

The synchronization against read/write ops is in sysfs_deactivate on
purpose so that drivers (most common users) don't have to worry about
sysfs ops accessing different parts of data structures once
device_del() is complete.  Implementing the exlusion at the driver
level is possible but not easy because some hardware devices are
represented with complex data structures, some of them are reused when
devices are exchanged and some sysfs ops end up accessing the
hardware.  So, it's often not possible to simply disassociate the data
structure and float it till the last reference goes away.  There needs
to be a synchronization point where the driver can tell that nothing
is accessing released data structure or hardware resource after it and
it's far easier to define it at the sysfs level.

> sysfs_deactivate happens in the device_del(), but if we were to move
> sysfs_deactivate into the final kobject_put then in theory we can
> continue to block and be friendly but not need to be called with
> locations where locks are held.

Nobody would know when that final put will actually happen.  In
progress sysfs ops might access the hardware after the hardware is
gone or replaced with another unit.

> Either way we will need some lockdep warnings for sysfs_deactivate
> so that the problem does not continue to hide and silently foul
> things up.  So I will see if I can cook something.

I don't think this is really relevant to the problem at hand but
adding lockdep annotations would definitely be beneficial, which BTW
is another reason to leave the synchronization in sysfs_deactivate as
the trade off is between deadlocks which can be detected somewhat
reliably with lockdep and scary race conditions which may involve
hardware in mysterious ways.

Thanks.

-- 
tejun

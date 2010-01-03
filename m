Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570Ab0ACCGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0ACCGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 21:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149Ab0ACCGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 21:06:35 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53902 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0ACCGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 21:06:34 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>
	<m17hs0xjmn.fsf@fess.ebiederm.org> <4B3FE586.7020109@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 02 Jan 2010 18:06:26 -0800
In-Reply-To: <4B3FE586.7020109@kernel.org> (Tejun Heo's message of "Sun\, 03 Jan 2010 09\:32\:06 +0900")
Message-ID: <m1ws00uel9.fsf@fess.ebiederm.org>
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

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On 01/03/2010 06:49 AM, Eric W. Biederman wrote:
>>>> sysfs_deactivate happens in the device_del(), but if we were to move
>>>> sysfs_deactivate into the final kobject_put then in theory we can
>>>> continue to block and be friendly but not need to be called with
>>>> locations where locks are held.
>>>
>>> Nobody would know when that final put will actually happen.  In
>>> progress sysfs ops might access the hardware after the hardware is
>>> gone or replaced with another unit.
>> 
>> Alright than that is a bad possible split of the functionality.  Which
>> is all I was suggesting splitting the functionality not doing away
>> with the wait or moving it to a point where the wait would not work.
>> It was simply my bad assumption that the final kobject_put would
>> happen before the module that controlled that kobject could be
>> removed.
>
> The module should stay around.  The severing is necessary to protect
> driver internal data structures and possibly removed or reattached (to
> a different driver) hardware.

Removed driver hardware isn't something sysfs can really guard
against, although it can help to make the window of vulnerability
smaller.  Protecting driver internal data structures if we can does
seem reasonable.

The case I was thinking of in particular is when someone does:
"rmmod driver" I think device_del protects from the code going away
today.

>> I still think it might make sense to separate kobject_del into two
>> parts.  One that we call with the locks held and one without, but that
>> does seem to be applicable to only a very small set of cases and our
>> problems appear to be much larger than that.
>
> If such separation is necessary, we can implement the split interface
> while leaving kobject_del() as is feature-wise and convert the
> offending ones to use the split interface but I think it would be
> better to simply fix the offending ones if there aren't too many and
> they're easily fixable.  Let's see how many lockdep warnings turn up.

- We have the network stack.
  I have hacked around that (when I thought it was a singleton)
  by introducing the idiom:

	if (!rtnl_trylock())
		return restart_sysscall();

  But that isn't sustainable, as there is already one new entry that
  just does rntl_lock unconditionally.

  Maybe we can move the device_del out from under the rtnl_lock, but I
  have my doubts.  Certainly the proc and sysctl bits (which have the
  same issue look more difficult.

- We almost have an issue in ext4.
  Device_del is certainly called under lock_kernel() and lock_super().

- We have what a cpu_hotplug.lock issue with
  /sys/devices/system/cpu/cpuN/microcode/reload, a variant of the problem
  that triggered this discussion and it looks very non-trivial to solve.

So I'm not certain what to say except that we have longstanding problems.

Eric

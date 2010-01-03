Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934Ab0ACE7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab0ACE7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 23:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599Ab0ACE7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 23:59:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:42130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0ACE7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 23:59:47 -0500
Message-ID: <4B4024A5.1020704@kernel.org>
Date: Sun, 03 Jan 2010 14:01:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>	<20091226094504.GA6214@liondog.tnic>	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>	<m11victac1.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>	<m1fx6rtu31.fsf@fess.ebiederm.org>	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>	<m17hs0xjmn.fsf@fess.ebiederm.org> <4B3FE586.7020109@kernel.org> <m1ws00uel9.fsf@fess.ebiederm.org>
In-Reply-To: <m1ws00uel9.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/03/2010 11:06 AM, Eric W. Biederman wrote:
> Removed driver hardware isn't something sysfs can really guard
> against, although it can help to make the window of vulnerability
> smaller.

It can't protect against removal itself per-se but it does give the
driver a boundary which it can depend on while implementing hot
unplugging.  Hardwares which support hot unplugging can cope with
surprise removal and has mechanisms to detect and handle them but
software part still is tricky and driver needs to have a boundary
after which it can declare a device gone.

> Protecting driver internal data structures if we can does
> seem reasonable.

Also the case of driver detaching (and another driver attaching).

> The case I was thinking of in particular is when someone does:
> "rmmod driver" I think device_del protects from the code going away
> today.

Nope, that's protected by reference counting via fops and/or other
stuff.

>> If such separation is necessary, we can implement the split interface
>> while leaving kobject_del() as is feature-wise and convert the
>> offending ones to use the split interface but I think it would be
>> better to simply fix the offending ones if there aren't too many and
>> they're easily fixable.  Let's see how many lockdep warnings turn up.
> 
> - We have the network stack.
>   I have hacked around that (when I thought it was a singleton)
>   by introducing the idiom:
> 
> 	if (!rtnl_trylock())
> 		return restart_sysscall();
> 
>   But that isn't sustainable, as there is already one new entry that
>   just does rntl_lock unconditionally.
> 
>   Maybe we can move the device_del out from under the rtnl_lock, but I
>   have my doubts.  Certainly the proc and sysctl bits (which have the
>   same issue look more difficult.
> 
> - We almost have an issue in ext4.
>   Device_del is certainly called under lock_kernel() and lock_super().
> 
> - We have what a cpu_hotplug.lock issue with
>   /sys/devices/system/cpu/cpuN/microcode/reload, a variant of the problem
>   that triggered this discussion and it looks very non-trivial to solve.
> 
> So I'm not certain what to say except that we have longstanding problems.

It's interesting that the above cases arn't common drivers.  AFAICS,
the problem cases would usually be cases like above where the user is
a rather complex software entity or drivers which implement some form
of self detaching via sysfs.  For the former group, I agree that
splitting deleting and draining (or simply skipping the draining part
or active reference counting both of which basically achieve the same
thing) would be an easy way out as it would be generally easy to leave
the data structures dangling till the references go away.

How about simply introducing an interface to mark sysfs nodes which
don't require active reference counting and using them on those nodes?

Thanks.

-- 
tejun

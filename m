Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZKILpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZKILpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZKILpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:45:10 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44286 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZKILpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:45:08 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
References: <m14op5jjo4.fsf@fess.ebiederm.org>
	<1257682930-31401-22-git-send-email-ebiederm@xmission.com>
	<20091108123422.GA9145@flint.arm.linux.org.uk>
	<m1pr7siqjz.fsf@fess.ebiederm.org> <m1hbt4ipni.fsf@fess.ebiederm.org>
	<20091108164855.595ec70d@infradead.org>
	<m1tyx49y44.fsf@fess.ebiederm.org>
	<20091108205725.28778016@infradead.org>
	<m1hbt45kcp.fsf@fess.ebiederm.org> <87ocnc598i.fsf@basil.nowhere.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 09 Nov 2009 03:45:06 -0800
In-Reply-To: <87ocnc598i.fsf@basil.nowhere.org> (Andi Kleen's message of "Mon\, 09 Nov 2009 10\:38\:05 +0100")
Message-ID: <m1my2vyla5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> ebiederm@xmission.com (Eric W. Biederman) writes:
>>
>> The glibc pthread code that uses sysctl has no problems if sys_sysctl
>> is gone.  It both falls back to reading /proc/sys and it just controls
>> an optimization and the code works with either result.  Been there,
>> done that.
>
> /proc/sys is much slower than sysctl though. So you made program startup
> slower.

Not much slower, but slower. I just measured it in a case that favors
sysctl and the ration is about 5:2.  Or sysctl is about 2.5x faster.
About 49usec for open/read/close on proc and 19usec for sysctl.
In my emulation it is a bit slower than that.

> Also I agree with Arjan that breaking such a common ABI is not
> really a good idea. But I think it's enough to only handle
> common sysctls that are actually used, which are very few.

Well I haven't broken anything at this point.  I am simply edging
us to the point when we are close to being able to forget about
sys_sysctl for good.

As for the rest the common number of sysctls with glibc > 2.8 is
exactly 0.  Which makes compiling out sys_sysctl support sane.
Especially since we have been throwing a warning for years if
anyone uses any of the others.

> It would be better to simply keep the commonly used binary sysctls
> as emulation around always (commonly = used by glibc and perhaps
> added by user printk feedback) That's very cheap because it's just
> a simple translation and can be done internally cheaper than going
> through the VFS with a bazillion of locks.

A micro optimization for code that does not exist.  That is a bad
trade off.

Further it is my intention to optimize /proc/sys when I get the
chance now that we don't have all of the old sysctl baggage holding
back the code.

I don't see anything that makes the date in
Documentation/feature-removal-schedule.txt of September 2010
unrealistic.

Ultimately what drives me most is that people are still accidentally
adding binary sysctls, which no one uses or tests.  For a recent
example see:

> commit 4663712cc745324a216112a72c744bb2b8f6658b
> Author: Leo Chen <leochen@broadcom.com>
> Date:   Fri Aug 7 19:56:19 2009 +0100
> 
>     ARM: 5643/1: bcmring: arch.c and header files
>     
>     add arch.c in mach-bcmring
>     add related header files in mach-bcmring
>     
>     Signed-off-by: Leo Chen <leochen@broadcom.com>
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Andi if you want to do the do the legwork and optimize sysctl_binary.c
so it does a better job, for that one sysctl older glibc's use, feel
free to write the code.

I don't care enough, and I expect to upgrade to a glibc without the
a single sysctl call before it would possibly matter to me.

Eric

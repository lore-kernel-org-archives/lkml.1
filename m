Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZKIMmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZKIMmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbZKIMmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:42:20 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54987 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZKIMmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:42:20 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/23] sysctl arm: Remove binary sysctl support
References: <1257682930-31401-22-git-send-email-ebiederm@xmission.com>
	<20091108123422.GA9145@flint.arm.linux.org.uk>
	<m1pr7siqjz.fsf@fess.ebiederm.org> <m1hbt4ipni.fsf@fess.ebiederm.org>
	<20091108164855.595ec70d@infradead.org>
	<m1tyx49y44.fsf@fess.ebiederm.org>
	<20091108205725.28778016@infradead.org>
	<m1hbt45kcp.fsf@fess.ebiederm.org> <87ocnc598i.fsf@basil.nowhere.org>
	<m1my2vyla5.fsf@fess.ebiederm.org>
	<20091109120445.GC26740@basil.fritz.box>
From: ebiederm@xmission.com (Eric W. Biederman)
In-Reply-To: <20091109120445.GC26740@basil.fritz.box> (Andi Kleen's message of "Mon\, 9 Nov 2009 13\:04\:45 +0100")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Date: Mon, 09 Nov 2009 04:42:22 -0800
Message-ID: <m1skcnvpht.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> On Mon, Nov 09, 2009 at 03:45:06AM -0800, Eric W. Biederman wrote:
>> Andi Kleen <andi@firstfloor.org> writes:
>> 
>> > ebiederm@xmission.com (Eric W. Biederman) writes:
>> >>
>> >> The glibc pthread code that uses sysctl has no problems if sys_sysctl
>> >> is gone.  It both falls back to reading /proc/sys and it just controls
>> >> an optimization and the code works with either result.  Been there,
>> >> done that.
>> >
>> > /proc/sys is much slower than sysctl though. So you made program startup
>> > slower.
>> 
>> Not much slower, but slower. I just measured it in a case that favors
>> sysctl and the ration is about 5:2.  Or sysctl is about 2.5x faster.
>> About 49usec for open/read/close on proc and 19usec for sysctl.
>> In my emulation it is a bit slower than that.
>
> That's not good.

Why?

>> > Also I agree with Arjan that breaking such a common ABI is not
>> > really a good idea. But I think it's enough to only handle
>> > common sysctls that are actually used, which are very few.
>> 
>> Well I haven't broken anything at this point.  I am simply edging
>> us to the point when we are close to being able to forget about
>> sys_sysctl for good.
>
> I think all-or-nothing that you have right now is a bad trade-off
> because it breaks an established interface used by lots of code (glibc)
>
> You should have three states
>
> a) all
> b) common ones used by glibc and perhaps a few others only
> c) none
>
> I suspect most users would use (b), in fact (c) might be redundant
> if (b) is cheap enough (which it should be)

Next year I expect b == c.

If you think we need something better additional patches to sysctl_binary.c
are welcome.  Just add your custom fast path before the through the
VFS.

>> As for the rest the common number of sysctls with glibc > 2.8 is
>> exactly 0.  Which makes compiling out sys_sysctl support sane.
>> Especially since we have been throwing a warning for years if
>> anyone uses any of the others.
>
> Yes, but people ignore the warning. Perhaps should make it a WARN()
> and track it with kernelops?

When I have googled for it I have seen applications getting fixed.

Regardless if the warning was there for them to ignore they have been
warned.  With my patches the maintenance overhead in the core kernel
is low enough I don't think it matters. Unless sysctl_binary.c starts
developing security holes and the like through poor maintenance etc.
Which seems entirely possible given the history of sys_sysctl.

>> > It would be better to simply keep the commonly used binary sysctls
>> > as emulation around always (commonly = used by glibc and perhaps
>> > added by user printk feedback) That's very cheap because it's just
>> > a simple translation and can be done internally cheaper than going
>> > through the VFS with a bazillion of locks.
>> 
>> A micro optimization for code that does not exist.  That is a bad
>> trade off.
>
> Hmm? There's plenty of glibc code that uses the binary sysctl.

Where?  I grepped glibc today.  The only use in a recent glibc is
in glibc-ports for the support of arm inb/outb.  The only other
use in older glibc was checking to see if we ran on an SMP kernel.

>> Further it is my intention to optimize /proc/sys when I get the
>> chance now that we don't have all of the old sysctl baggage holding
>> back the code.
>
> The VFS will always be comparably slow I suspect; I'm not sure
> you can optimize it that much compared to a fast custom path
> (especially handling the kernel version should be really fast)


>> Ultimately what drives me most is that people are still accidentally
>> adding binary sysctls, which no one uses or tests.  For a recent
>> example see:
>
> Yes I agree new binary sysctls should just be deprecated right now.

Good.  The only way to keep new ones from showing up is to that I know
of is to move everything into an emulation layer.  I have done the heavy
lifting there and everything is emulated using the exact same code.

If you are ready to maintain and keep from diverging an implementation
of reading the /proc/sys/kernel/version aka
"#1 SMP Tue Oct 20 06:50:36 UTC 2009"
go ahead.  I expect it is no more than 20 lines of code.

Eric


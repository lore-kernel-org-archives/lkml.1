Return-Path: <linux-kernel-owner+w=401wt.eu-S965514AbXCATGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965514AbXCATGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXCATGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:06:52 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:46495 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965514AbXCATGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:06:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oz56RFi3yJiZg1hoLRdcLD1OGvVmZHnK83i+L/oeOvgtE+2JsmwVhMBdKf65EsB9YY7fue2eTf/5ZuEYypggL7rXLOBfGPZeT6B66QjFlzdCuLo6j6NRqPa7JKYFIoXEOPc8NYi8qR1WKP5Fb24qvZs17fEHcMq4oMstVjqs7Pc=
Message-ID: <8bd0f97a0703011106j7cb3664dx190686b0251cd1fa@mail.gmail.com>
Date: Thu, 1 Mar 2007 14:06:49 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: + blackfin-on-chip-rtc-controller-driver.patch added to -mm tree
Cc: akpm@linux-foundation.org, bryan.wu@analog.com, mm-commits@vger.kernel.org,
       a.zummo@towertech.it, "Paul Mundt" <lethal@linux-sh.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200703011039.32876.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703010848.l218me3e008819@shell0.pdx.osdl.net>
	 <200703011039.32876.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, David Brownell <david-b@pacbell.net> wrote:
> Bryan, it'd be nice to see a followup patch addressing those
> comments from Paul Mundt, especially about that code which
> will spin-forever-under-spinlock.  That spin should probably
> drop the lock then msleep(1) then restore it before retest...

i've been chatting with Paul on irc about it

> The set_alarm() method needs to enable the alarm irq if the
> "enabled" flag is set, and the read_alarm() method needs to
> report whether the alarm is enabled.

from reading other drivers and the documentation, i couldnt determine
whether this was the standard behavior or whether set_alarm simply set
the alarm time but you still needed to call the ioctl RTC_AIE_ON in
order to actual enable it

> It's unclear why you
> chose to report "pending" (irq issued but not yet acked) since
> that's uselessly transient state on non-polled hardwre.  (That
> flag definition came from EFI, a polled firmware RTC.)

because other drivers do ?  there is no documentation here that covers
what exactly the read_alarm function in the rtc_class_ops is supposed
to do which leaves it up to people looking at other drivers

rtc-sa1100.c for example:
static int sa1100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
{
    memcpy(&alrm->time, &rtc_alarm, sizeof(struct rtc_time));
    alrm->pending = RTSR & RTSR_AL ? 1 : 0;
    return 0;
}

if someone decides what the behavior is supposed to be here, i'll
happily implement it

> Correct handling of the "enabled" flag in read_alarm() will let
> you remove a redundant seq_printf() in your proc() callback...

i dont understand this ... rtc-sh.c and rtc-sa1100.c both do a
seq_printf() for the alarm irq

> It looks to me like you're handling the time in set_alarm()
> incorrectly.  Do the conversion and test in set_alarm, not
> AIE_ON ... since set_alarm() needs to be able to include AIE_ON
> capability.

the reason for this is so that i do not have to worry about keeping
two structures in sync ... there's the common RTC representation and
then there's the funky Blackfin representation, so by delaying the
conversion until RTC_AIE_ON, i didnt have to worry about keeping these
fields in sync

> The fields tm_{wday,yday,isdst} are never used,
> but you're testing tm_yday.  If you meant to test tm_mday in
> order to distinguish the WKALM_SET and ALM_SET cases, then you
> are mishandling a wraparound case; see how rtc-omap handles
> it.  (If it's 23:00 now, an 01:00 alarm means TOMORROW.  I
> think other RTCs may goof this case too.)

this is exactly why i'm checking tm_yday ... the rtc-dev interface
sets those fields to -1 when using the WKALM ioctls and there's no
other way to distinguish this

if the wraparound case is so common, then perhaps it should be a
helper function in the generic rtc code rather than reimplementing in
every rtc driver ...

> The use of class_device conflicts with the patch series I
> recently resubmitted, see it on rtc-linux@googlegroups.com ...
> if you submit a separate patch, then maybe your Blackfin RTC
> can be merged first.

i'll take a look
-mike

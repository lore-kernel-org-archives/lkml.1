Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbYDDJWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbYDDJWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYDDJWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:22:42 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:55230 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYDDJWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:22:41 -0400
Message-ID: <47F5F35F.2020508@free.fr>
Date: Fri, 04 Apr 2008 11:22:39 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 11-minute mode (RTC update)
References: <47F5E194.5040409@free.fr>
In-Reply-To: <47F5E194.5040409@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> I run Linux kernel 2.6.22.1-rt9 and ntpd 4.2.4p0
> 
> # adjtimex --print
>          mode: 0
>        offset: 77
>     frequency: -1309904
>      maxerror: 493576
>      esterror: 50
>        status: 1
> time_constant: 6
>     precision: 1
>     tolerance: 33554432
>          tick: 10000
>      raw time:  1207230744s 183249us = 1207230744.183249
> 
> In my setup, STA_UNSYNC (0x0040, clock unsynchronized) is 0.
> 
> Thus, ntp_synced() returns 1.
> 
> Thus the kernel should write the system time to the RTC every
> 11 minutes; but it does not.
> 
> The relevant code is in sync_cmos_clock()
> 
> http://lxr.linux.no/linux/kernel/time/ntp.c#L188
> 
> I've added several printk() to this function, and it appears
> that it is never called.
> 
> The relevant timer is defined with the following macro.
> 
> static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
> 
> which expands to
> 
> static struct timer_list sync_cmos_timer =
> {
>   .function = sync_cmos_clock,
>   .expires  = 0,
>   .data     = 0,
>   .base     = &boot_tvec_bases
> };
> 
> The problem seems to be that this timer is never armed, to bootstrap
> the process. It seems there should be a call to mod_timer() somewhere.
> 
> do_adjtimex() calls notify_cmos_timer() unconditionally.
> 
> static void notify_cmos_timer(void)
> {
>   if (no_sync_cmos_clock)
>     mod_timer(&sync_cmos_timer, jiffies + 1);
> }
> 
> What are the semantics of notify_cmos_timer?
> What is it supposed to do?
> 
> And what is 'no_sync_cmos_clock' supposed to mean?
> /* Disable the cmos update - used by virtualization and embedded */
> int no_sync_cmos_clock  __read_mostly;
> Why would we (re)arm the timer when 'no_sync_cmos_clock' is true?

For those wondering what this "11-minute mode" is, I'll quote the
man page for hwclock. ( http://linux.die.net/man/8/hwclock )

<quote>

Automatic Hardware Clock Synchronization By the Kernel

You should be aware of another way that the Hardware Clock is kept 
synchronized in some systems. The Linux kernel has a mode wherein it 
copies the System Time to the Hardware Clock every 11 minutes. This is 
a good mode to use when you are using something sophisticated like ntp 
to keep your System Time synchronized. (ntp is a way to keep your 
System Time synchronized either to a time server somewhere on the 
network or to a radio clock hooked up to your system. See RFC 1305).

This mode (we'll call it "11 minute mode") is off until something 
turns it on. The ntp daemon xntpd is one thing that turns it on. You 
can turn it off by running anything, including hwclock --hctosys, that 
sets the System Time the old fashioned way.

To see if it is on or off, use the command adjtimex --print and look 
at the value of "status". If the "64" bit of this number (expressed in 
binary) equal to 0, 11 minute mode is on. Otherwise, it is off.

If your system runs with 11 minute mode on, don't use hwclock --adjust 
or hwclock --hctosys. You'll just make a mess. It is acceptable to use 
a hwclock --hctosys at startup time to get a reasonable System Time 
until your system is able to set the System Time from the external 
source and start 11 minute mode.

</quote>

Apparently, drivers using one or more timer_lists typically arm the 
timer in their open or init function. My problem is: I don't think 
there is an init function for the NTP sub-system.

Regards.

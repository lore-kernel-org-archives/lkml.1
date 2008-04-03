Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYDCOqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYDCOqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbYDCOqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:46:36 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:53612 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298AbYDCOqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:46:35 -0400
Message-ID: <47F4EDC9.1040401@free.fr>
Date: Thu, 03 Apr 2008 16:46:33 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Linux 11-minute mode (RTC update)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Message also posted to comp.protocols.time.ntp)

Hello,

I run Linux kernel 2.6.22.1-rt9 and ntpd 4.2.4p0

# adjtimex --print
          mode: 0
        offset: 77
     frequency: -1309904
      maxerror: 493576
      esterror: 50
        status: 1
time_constant: 6
     precision: 1
     tolerance: 33554432
          tick: 10000
      raw time:  1207230744s 183249us = 1207230744.183249

In my setup, STA_UNSYNC (0x0040, clock unsynchronized) is 0.

Thus, ntp_synced() returns 1.

Thus the kernel should write the system time to the RTC every
11 minutes; but it does not.

The relevant code is in sync_cmos_clock()

http://lxr.linux.no/linux/kernel/time/ntp.c#L188

I've added several printk() to this function, and it appears
that it is never called.

The relevant timer is defined with the following macro.

static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);

which expands to

static struct timer_list sync_cmos_timer =
{
   .function = sync_cmos_clock,
   .expires  = 0,
   .data     = 0,
   .base     = &boot_tvec_bases
};

The problem seems to be that this timer is never armed, to bootstrap
the process. It seems there should be a call to mod_timer() somewhere.

do_adjtimex() calls notify_cmos_timer() unconditionally.

static void notify_cmos_timer(void)
{
   if (no_sync_cmos_clock)
     mod_timer(&sync_cmos_timer, jiffies + 1);
}

What are the semantics of notify_cmos_timer?
What is it supposed to do?

And what is 'no_sync_cmos_clock' supposed to mean?
/* Disable the cmos update - used by virtualization and embedded */
int no_sync_cmos_clock  __read_mostly;
Why would we (re)arm the timer when 'no_sync_cmos_clock' is true?

I'd be grateful for anyone sharing their knowledge.

Regards.


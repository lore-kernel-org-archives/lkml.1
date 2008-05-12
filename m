Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbYELMV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbYELMV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbYELMVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:21:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:40628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbYELMVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:21:50 -0400
Date: Mon, 12 May 2008 14:21:46 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080512142146.2a32793c@kopernikus.site>
In-Reply-To: <20080507134223.GB4278@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
	<20080428092513.495378af.akpm@linux-foundation.org>
	<20080429175419.6c8a0ebf@strauss.suse.de>
	<20080430133824.GC18711@boogie.lpds.sztaki.hu>
	<20080430165131.7426d5d3@strauss.suse.de>
	<20080507114343.GB5583@boogie.lpds.sztaki.hu>
	<20080507144520.17e9902a@strauss.suse.de>
	<20080507134223.GB4278@boogie.lpds.sztaki.hu>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Gabor Gombas <gombasg@sztaki.hu> [2008-05-07 15:42]:
>
> On Wed, May 07, 2008 at 02:45:20PM +0200, Bernhard Walle wrote:
> 
> > You can log it to a file or output it over serial console. Or make the
> > window sticky. ;)
> 
> Well, the machine hung and I was on a different virtual desktop. The
> output of the script together with netconsole output is below. Right now
> I don't have another machine that could be used for serial console.

Well, can you try if that really not happens without
CONFIG_HPET_EMULATE_RTC? The question is if that 64 interrupts per second really
cause a machine hang ...

However, the other question is why you get that RTC interrupts at all.
I compared the old RTC implementation (drivers/char/rtc.c) with the new
RTC interface (rtc-cmos.c) and the old implementation disables
interrupts automatically when the device is closed in userspace while
the new doesn't. I think the old one makes more sense, and so I think
the following patch should be applied. Gabor, can you also test that
patch ... it should fix your problem.

For debugging purposes it makes sense to apply the debug patch also (the
printk() in the interrupt handler). It should not conflict.


	Bernhard



From: Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Disable RTC interrupts when closing the device

This patch disables RTC for rtc_cmos interrupts when the /dev/rtcX is closed.
Previously, the userspace program explicitely had to call ioctl(RTC_..._OFF).

This is the same behaviour as the old drivers/char/rtc.c driver. Especially
when using the HPET emulation which uses a timer frequency of 64 Hz by default
it makes sense to disable this interrupts.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/rtc/rtc-cmos.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -302,6 +302,23 @@ static int cmos_irq_set_state(struct dev
 	return 0;
 }
 
+static void
+cmos_rtc_release(struct device *dev)
+{
+	unsigned char tmp;
+
+	spin_lock_irq(&rtc_lock);
+	if (!hpet_mask_rtc_irq_bit(RTC_PIE | RTC_AIE | RTC_UIE)) {
+		tmp = CMOS_READ(RTC_CONTROL);
+		tmp &= ~RTC_PIE;
+		tmp &= ~RTC_AIE;
+		tmp &= ~RTC_UIE;
+		CMOS_WRITE(tmp, RTC_CONTROL);
+		CMOS_READ(RTC_INTR_FLAGS);
+	}
+	spin_unlock_irq(&rtc_lock);
+}
+
 #if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_RTC_INTF_DEV_MODULE)
 
 static int
@@ -409,6 +426,7 @@ static int cmos_procfs(struct device *de
 
 static const struct rtc_class_ops cmos_rtc_ops = {
 	.ioctl		= cmos_rtc_ioctl,
+	.release        = cmos_rtc_release,
 	.read_time	= cmos_read_time,
 	.set_time	= cmos_set_time,
 	.read_alarm	= cmos_read_alarm,








Return-Path: <linux-kernel-owner+w=401wt.eu-S1766765AbXEBWie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766765AbXEBWie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766800AbXEBWid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:38:33 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45886 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766765AbXEBWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:38:32 -0400
Message-ID: <46391253.30201@vmware.com>
Date: Wed, 02 May 2007 15:36:03 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Marcos Pinto <markybob@gmail.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Mysterious RTC hangs on x86_64 - fixed, sort of
Content-Type: multipart/mixed;
 boundary="------------030500080802000200020100"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030500080802000200020100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

With this patch, /sbin/hwclock no longer hangs my AMD64 machine when run 
after reaching multiuser.  What I don't understand is why.  I have the 
RTC based sound sequencer timer as a module, but not loaded, and the 
error message I added to indicate broken rtc control does not fire.

So why is it that if I stop taking the rtc_task_lock and issuing the 
callbacks which should never be held or exist that my system no longer 
hard freezes?

Zach

--------------030500080802000200020100
Content-Type: text/x-patch;
 name="x86_64-rtc-mystery.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86_64-rtc-mystery.patch"

--- /tmp/a      2007-05-03 15:36:07.451256181 -0700
+++ drivers/char/rtc.c  2007-05-03 15:27:49.000000000 -0700
@@ -265,10 +265,10 @@
        spin_unlock (&rtc_lock);
 
        /* Now do the rest of the actions */
-       spin_lock(&rtc_task_lock);
-       if (rtc_callback)
-               rtc_callback->func(rtc_callback->private_data);
-       spin_unlock(&rtc_task_lock);
+/*     spin_lock(&rtc_task_lock); */
+//     if (rtc_callback)
+//             rtc_callback->func(rtc_callback->private_data);
+/*     spin_unlock(&rtc_task_lock); */
        wake_up_interruptible(&rtc_wait);       
 
        kill_fasync (&rtc_async_queue, SIGIO, POLL_IN);
@@ -811,6 +811,7 @@
 
 int rtc_register(rtc_task_t *task)
 {
+       printk(KERN_ERR "rtc_register is busted\n");
 #ifndef RTC_IRQ
        return -EIO;
 #else

--------------030500080802000200020100
Content-Type: text/plain;
 name="rtc.config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rtc.config"

CONFIG_HPET_EMULATE_RTC=y
CONFIG_RTC=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y
# RTC interfaces
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y

--------------030500080802000200020100--

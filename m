Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYC1Fq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYC1Fq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 01:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYC1Fqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 01:46:50 -0400
Received: from rtr.ca ([76.10.145.34]:1528 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYC1Fqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 01:46:49 -0400
Message-ID: <47EC8646.3050405@rtr.ca>
Date: Fri, 28 Mar 2008 01:46:46 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org
Subject: Re: 2.6.25-rc7: Ugh.
References: <20080327160700.GB828@suse.de>	<Pine.LNX.4.64.0803280126550.5541@jikos.suse.cz>	<47EC50A3.5070304@rtr.ca> <20080327.201202.163153963.davem@davemloft.net>
In-Reply-To: <20080327.201202.163153963.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Mark Lord <lkml@rtr.ca>
> Date: Thu, 27 Mar 2008 21:57:55 -0400
> 
>> I don't have the XX days necessary for git-bisect right now.
> 
> I wish people would say stuff like this.
..

I just did, thanks.

In this case, a bisect would be a complete waste of time,
because whatever is wrong seems to be a timing-related race
condition of some kind.

Merely rebuilding the kernel with slightly different debug flags
affects things, so trying to bisect it would be a super waste of
time in all probability.

When I rebuilt with all debug stuff on, the kernel was worse than
before, and just gave the "black screen of nothing" on resume,
with a hung system.

At least before the system didn't hang.

Now I've just booted with a differently configured kernel,
with only about half of the debug flags turned on.
This one resumes from suspend, and *with* working USB too.

Ugh. Gotta love it when the bug is so subtle that turning on
the debug flags makes it (1) get worse, and/or (2) get cured.

Here's the abbreviated diff between broken (no USB on resume, no hang),
and working (good USB, no hang) .config files.

--- dot_config.nousb	2008-03-27 22:43:50.000000000 -0400
+++ dot_config.works	2008-03-28 01:29:22.000000000 -0400
-CONFIG_LOG_BUF_SHIFT=16
+CONFIG_LOG_BUF_SHIFT=17
-# CONFIG_KALLSYMS_ALL is not set
+CONFIG_KALLSYMS_ALL=y
-# CONFIG_MAC80211_DEBUGFS is not set
-# CONFIG_RTC is not set
-CONFIG_GEN_RTC=y
-CONFIG_GEN_RTC_X=y
+CONFIG_RTC=y
+CONFIG_SND_RTCTIMER=m
+CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
-CONFIG_RTC_LIB=y
-CONFIG_RTC_CLASS=y
-
-#
-# Conflicting RTC option has been selected, check GEN_RTC and RTC
-#
-CONFIG_RTC_HCTOSYS=y
-CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
-# CONFIG_RTC_DEBUG is not set
-
-#
-# RTC interfaces
-#
-CONFIG_RTC_INTF_SYSFS=y
-CONFIG_RTC_INTF_PROC=y
-CONFIG_RTC_INTF_DEV=y
-# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
-CONFIG_RTC_DRV_TEST=m
-
-#
-# I2C RTC drivers
-#
-CONFIG_RTC_DRV_DS1307=m
-CONFIG_RTC_DRV_DS1374=m
-CONFIG_RTC_DRV_DS1672=m
-CONFIG_RTC_DRV_MAX6900=m
-CONFIG_RTC_DRV_RS5C372=m
-CONFIG_RTC_DRV_ISL1208=m
-CONFIG_RTC_DRV_X1205=m
-CONFIG_RTC_DRV_PCF8563=m
-CONFIG_RTC_DRV_PCF8583=m
-# CONFIG_RTC_DRV_M41T80 is not set
-# CONFIG_RTC_DRV_S35390A is not set
-
-#
-# SPI RTC drivers
-#
-
-#
-# Platform RTC drivers
-#
-CONFIG_RTC_DRV_CMOS=y
-CONFIG_RTC_DRV_DS1511=m
-CONFIG_RTC_DRV_DS1553=m
-CONFIG_RTC_DRV_DS1742=m
-# CONFIG_RTC_DRV_STK17TA8 is not set
-CONFIG_RTC_DRV_M48T86=m
-# CONFIG_RTC_DRV_M48T59 is not set
-CONFIG_RTC_DRV_V3020=m
-
-#
-# on-CPU RTC drivers
-#
+# CONFIG_RTC_CLASS is not set
-# CONFIG_JBD_DEBUG is not set
-CONFIG_DLM=m
-# CONFIG_DLM_DEBUG is not set
+# CONFIG_DLM is not set
-CONFIG_DEBUG_FS=y
+# CONFIG_DEBUG_FS is not set
-CONFIG_TIMER_STATS=y
-# CONFIG_DEBUG_SLAB is not set
+# CONFIG_TIMER_STATS is not set
+CONFIG_DEBUG_SLAB=y
+CONFIG_DEBUG_SLAB_LEAK=y
-# CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_MUTEXES is not set
-# CONFIG_DEBUG_LOCK_ALLOC is not set
-# CONFIG_PROVE_LOCKING is not set
+CONFIG_DEBUG_SPINLOCK=y
+CONFIG_DEBUG_MUTEXES=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_LOCKDEP=y
 # CONFIG_LOCK_STAT is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
-# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
-# CONFIG_DEBUG_KOBJECT is not set
-# CONFIG_DEBUG_HIGHMEM is not set
+CONFIG_DEBUG_LOCKDEP=y
+CONFIG_TRACE_IRQFLAGS=y
+CONFIG_DEBUG_SPINLOCK_SLEEP=y
+CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
+CONFIG_STACKTRACE=y
+CONFIG_DEBUG_KOBJECT=y
+CONFIG_DEBUG_HIGHMEM=y
-# CONFIG_DEBUG_INFO is not set
-# CONFIG_DEBUG_VM is not set
-# CONFIG_DEBUG_LIST is not set
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_VM=y
+CONFIG_DEBUG_LIST=y
-# CONFIG_FRAME_POINTER is not set
+CONFIG_FRAME_POINTER=y
-# CONFIG_DEBUG_STACKOVERFLOW is not set
-# CONFIG_DEBUG_STACK_USAGE is not set
+CONFIG_DEBUG_STACKOVERFLOW=y
+CONFIG_DEBUG_STACK_USAGE=y
-CONFIG_4KSTACKS=y
+# CONFIG_4KSTACKS is not set
-# CONFIG_DEBUG_BOOT_PARAMS is not set

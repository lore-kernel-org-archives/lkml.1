Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbXDITDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbXDITDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 15:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964960AbXDITDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 15:03:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:11576 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964959AbXDITDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 15:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jw/g0jgKCMEou9SYZHmr5PXza+IQdloI+O8y+Md2vEPq+uWIkEGWxKYp779k34ou7/4m+d9z0GiAhQUCku8Fx1KundEZXlm4ICxCs7vmWZLDKreM8Z6GcvgjL6i2Tg4IxCdRrQ5QQKO5pDqhMT/+XcVMCnlQRi7udv+wRXsnVVk=
Message-ID: <64bb37e0704091203m7cb4adc9g1bf6bf179603cf4a@mail.gmail.com>
Date: Mon, 9 Apr 2007 21:03:15 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc6-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070408143559.f5014629.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/

drivers/ieee1394/ieee1394_transactions.c fails for me if CONFIG_SMP=n

gcc complains:
  CC      drivers/ieee1394/ieee1394_transactions.o
drivers/ieee1394/ieee1394_transactions.c: In function 'hpsb_get_tlabel':
drivers/ieee1394/ieee1394_transactions.c:183: error:
'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/ieee1394/ieee1394_transactions.c:183: error: (Each undeclared
identifier is reported only once
drivers/ieee1394/ieee1394_transactions.c:183: error: for each function
it appears in.)
drivers/ieee1394/ieee1394_transactions.c:183: warning: implicit
declaration of function 'signal_pending'
drivers/ieee1394/ieee1394_transactions.c:183: warning: implicit
declaration of function 'schedule'
drivers/ieee1394/ieee1394_transactions.c: In function 'hpsb_free_tlabel':
drivers/ieee1394/ieee1394_transactions.c:213: error:
'TASK_INTERRUPTIBLE' undeclared (first use in this function)
make[2]: *** [drivers/ieee1394/ieee1394_transactions.o] Error 1
make[1]: *** [drivers/ieee1394] Error 2
make: *** [drivers] Error 2


I fixed this by adding #include <linux/sched.h> before #include <linux/wait.h>
But that is probably not the correct fix, but gives me a working kernel.

Diff between a working .config and a failing one:
(created by switching SMP off with menuconfig)
 --- config.works        2007-04-09 20:54:30.182374075 +0200
+++ .config     2007-04-09 20:54:47.317863059 +0200
@@ -3,3 +3,3 @@
 # Linux kernel version: 2.6.21-rc6-mm1
-# Mon Apr  9 16:01:11 2007
+# Mon Apr  9 20:54:47 2007
 #
@@ -36,3 +36,3 @@
 CONFIG_EXPERIMENTAL=y
-CONFIG_LOCK_KERNEL=y
+CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
@@ -57,3 +57,2 @@
 CONFIG_IKCONFIG_PROC=y
-CONFIG_CPUSETS=y
 # CONFIG_SYSFS_DEPRECATED is not set
@@ -104,3 +103,2 @@
 CONFIG_KMOD=y
-CONFIG_STOP_MACHINE=y

@@ -151,5 +149,3 @@
 CONFIG_MTRR=y
-CONFIG_SMP=y
-# CONFIG_SCHED_SMT is not set
-CONFIG_SCHED_MC=y
+# CONFIG_SMP is not set
 CONFIG_PREEMPT_NONE=y
@@ -157,21 +153,12 @@
 # CONFIG_PREEMPT is not set
-CONFIG_PREEMPT_BKL=y
-CONFIG_NUMA=y
-# CONFIG_K8_NUMA is not set
-CONFIG_NODES_SHIFT=6
-CONFIG_X86_64_ACPI_NUMA=y
-# CONFIG_NUMA_EMU is not set
-CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
-CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
 CONFIG_ARCH_SPARSEMEM_ENABLE=y
+CONFIG_ARCH_FLATMEM_ENABLE=y
 CONFIG_SELECT_MEMORY_MODEL=y
-# CONFIG_FLATMEM_MANUAL is not set
-CONFIG_DISCONTIGMEM_MANUAL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
 # CONFIG_SPARSEMEM_MANUAL is not set
-CONFIG_DISCONTIGMEM=y
+CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
-CONFIG_NEED_MULTIPLE_NODES=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
-CONFIG_MIGRATION=y
 CONFIG_RESOURCES_64BIT=y
@@ -180,6 +167,2 @@
 # CONFIG_DEBUG_READAHEAD is not set
-CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
-CONFIG_OUT_OF_LINE_PFN_TO_PAGE=y
-CONFIG_NR_CPUS=4
-CONFIG_HOTPLUG_CPU=y
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
@@ -209,3 +192,2 @@
 CONFIG_ISA_DMA_API=y
-CONFIG_GENERIC_PENDING_IRQ=y

@@ -220,3 +202,2 @@
 CONFIG_PM_STD_PARTITION=""
-CONFIG_SUSPEND_SMP=y

@@ -236,5 +217,3 @@
 CONFIG_ACPI_PROCESSOR=y
-CONFIG_ACPI_HOTPLUG_CPU=y
 CONFIG_ACPI_THERMAL=y
-CONFIG_ACPI_NUMA=y
 # CONFIG_ACPI_ASUS is not set

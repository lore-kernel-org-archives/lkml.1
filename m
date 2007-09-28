Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbXI1Tx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbXI1Tx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXI1TxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:53:23 -0400
Received: from rtr.ca ([76.10.145.34]:3586 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbXI1TxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:53:22 -0400
Message-ID: <46FD5BAF.8040304@rtr.ca>
Date: Fri, 28 Sep 2007 15:53:19 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, simon.derr@bull.net,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] (repost) Fix SMP poweroff hangs
References: <46FC20B7.4000606@rtr.ca> <200709281455.29069.rjw@sisk.pl>	 <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl>	 <46FD05B8.2040302@rtr.ca>  <46FD0724.5060009@rtr.ca> <1190991316.18681.38.camel@chaos>
In-Reply-To: <1190991316.18681.38.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> ..
>> @@ -879,6 +880,7 @@
>>  	if (pm_power_off_prepare)
>>  		pm_power_off_prepare();
>>  	sysdev_shutdown();
>> +	disable_nonboot_cpus();
> 
> Before sysdev_shutdown(), please.
> 
> sysdev_shutdown() may touch things that belong to CPU0.

Thanks.  Here is the revised patch.

* * *

We need to disable all CPUs other than the boot CPU (usually 0)
before attempting to power-off modern SMP machines.
This fixes the hang-on-poweroff issue on my MythTV SMP box,
and also on Thomas Gleixner's new toybox.

Signed-off-by: Mark Lord <mlord@pobox.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---

--- linux/kernel/sys.c.orig	2007-09-13 09:49:11.000000000 -0400
+++ linux/kernel/sys.c	2007-09-28 15:48:54.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/seccomp.h>
+#include <linux/cpu.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -878,6 +879,7 @@
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
+	disable_nonboot_cpus();
 	sysdev_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();

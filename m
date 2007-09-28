Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbXI1Nwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbXI1Nwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbXI1Nwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:52:38 -0400
Received: from rtr.ca ([76.10.145.34]:2608 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbXI1Nwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:52:37 -0400
Message-ID: <46FD0724.5060009@rtr.ca>
Date: Fri, 28 Sep 2007 09:52:36 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       simon.derr@bull.net
Subject: [PATCH] disable non-boot CPUs before poweroff
References: <46FC20B7.4000606@rtr.ca> <200709281455.29069.rjw@sisk.pl> <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl> <46FD05B8.2040302@rtr.ca>
In-Reply-To: <46FD05B8.2040302@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We need to disable all CPUs other than the boot CPU (usually 0)
before attempting to power-off modern SMP machines.
This seems to fix the hang-on-poweroff issue
that one of my SMP boxes exhibits.  More testing required.

Signed-off-by: Mark Lord <mlord@pobox.com>
---

--- linux/kernel/sys.c.orig	2007-09-13 09:49:11.000000000 -0400
+++ linux/kernel/sys.c	2007-09-28 09:48:54.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/seccomp.h>
+#include <linux/cpu.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -879,6 +880,7 @@
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
 	sysdev_shutdown();
+	disable_nonboot_cpus();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
 }

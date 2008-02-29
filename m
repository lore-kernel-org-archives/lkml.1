Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYB2Jm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYB2Jm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 04:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYB2JmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 04:42:19 -0500
Received: from mga06.intel.com ([134.134.136.21]:8334 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbYB2JmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 04:42:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,425,1199692800"; 
   d="scan'208";a="260178395"
Message-ID: <4848.172.16.116.56.1204278137.squirrel@linux.intel.com>
Date: Fri, 29 Feb 2008 01:42:17 -0800 (PST)
Subject: [PATCH 2.6.25-rc3] processor_idle: fixed CPU 'active state' stably 
     remain C0 by cat /proc
From: youquan_song@linux.intel.com
To: linux-kernel@vger.kernel.org
Cc: youquan.song@intel.com
User-Agent: SquirrelMail/1.4.8-4.0.1.el4.centos
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cpuidle module is enabled by CONFIG_CPU_IDEL=y,user can check CPU idle
information by both /proc and /sys. The two interface keep consistent
except 'active state'. enabling cpuidle will not record CPU active  state
any more, so if we run 'cat /proc/acpi/processor/CPU*/power', we will get
the 'active state' stably remain C0. This is different from user
experience and the case that cpuidle disable by CONFIG_CPU_IDLE=n.

This patch will fix the bug by record the specail C state when CPU is
going to enter to C state. we run 'cat /proc/acpi/processor/CPU*/power'
and we will watch the CPU 'active state' change keeping the same with the
cpu real work.

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 processor_idle.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -urNa linux-2.6.25-rc3-orginal/drivers/acpi/processor_idle.c
linux-2.6.25-rc3/drivers/acpi/processor_idle.c
--- linux-2.6.25-rc3-orginal/drivers/acpi/processor_idle.c	2008-02-29
07:58:51.000000000 -0500
+++ linux-2.6.25-rc3/drivers/acpi/processor_idle.c	2008-02-29
11:56:39.000000000 -0500
@@ -1425,6 +1425,8 @@
 		return 0;

 	local_irq_disable();
+	/* Record the active C state */
+	pr->power.state = cx;

 	/* Do not access any ACPI IO ports in suspend path */
 	if (acpi_idle_suspend) {
@@ -1468,6 +1470,8 @@
 		return(acpi_idle_enter_c1(dev, state));

 	local_irq_disable();
+	/* Record the active C state */
+	pr->power.state = cx;
 	current_thread_info()->status &= ~TS_POLLING;
 	/*
 	 * TS_POLLING-cleared state must be visible before we test
@@ -1558,6 +1562,8 @@
 	}

 	local_irq_disable();
+	/* Record the active C state */
+	pr->power.state = cx;
 	current_thread_info()->status &= ~TS_POLLING;
 	/*
 	 * TS_POLLING-cleared state must be visible before we test

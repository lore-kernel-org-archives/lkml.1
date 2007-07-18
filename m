Return-Path: <linux-kernel-owner+w=401wt.eu-S1762397AbXGRVxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762397AbXGRVxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXGRVxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:53:13 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:14035 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbXGRVxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:53:12 -0400
X-IronPort-AV: i="4.16,552,1175486400"; 
   d="scan'208"; a="45883195:sNHT39404610"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: early_printk accessing __log_buf
Date: Wed, 18 Jul 2007 17:56:43 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181756.44074.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 18 Jul 2007 21:53:08.0902 (UTC) FILETIME=[0752DC60:01C7C986]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quick question:

I am currently setting up an early_printk for the Blackfin - & I'm populating
an early fault interrupt handler at the same time. This allows things like
catching interrupts, or faults before the kernel has had a chance to
enable it's standard interrupt/fault handlers which happen midway 
through the boot process.

I would like to be able to print out the standard __log_buf from my early
fault handler - so everyone can see where things are when they died. In
most situations - printk has dumped some info to the log_buf, and it is
normally handy to see figure out what is going on.

However - __log_buf & associated pointers are declared as static in
kernel/printk.c - so they can't be accessed by external files.

I would normally use do_syslog([23],...) to read from the buffer - 
but these crashes happens before the kernel is fully initialized,
so spin_lock_irq, cond_resched, or wait_event_interruptible
will cause problems...

Although there are other solutions - I would prefer to just don't declare them
as static when EARLY_PRINTK is defined. This way if something bad happens - 
everyone can dump out the standard buffers to assist in debugging...

===================================================================
--- linux-2.6.x/kernel/printk.c (revision 3400)
+++ linux-2.6.x/kernel/printk.c (working copy)
@@ -117,7 +117,12 @@

 #ifdef CONFIG_PRINTK

+#ifdef CONFIG_EARLY_PRINTK
+char __log_buf[__LOG_BUF_LEN];
+#else
 static char __log_buf[__LOG_BUF_LEN];
+#endif
+
 static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned long logged_chars; /* Number of chars produced since last read+clear operation */

Thoughts?

-Robin

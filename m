Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZJUR3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZJUR3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 13:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZJUR3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 13:29:15 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:25837 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbZJUR3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 13:29:14 -0400
Date: Wed, 21 Oct 2009 10:28:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: discuss@LessWatts.org, lkml <linux-kernel@vger.kernel.org>
Cc: Corey Minyard <minyard@acm.org>, openipmi-developer@lists.sourceforge.net,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] ipmi: use round_jiffies on timers to reduce timer
 overhead/wakeups
Message-Id: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4ADF44DA.00A2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use a round_jiffies() variant to reduce overhead of timer
wakeups.  This causes the ipmi timers to occur at the same
time as other timers (per CPU).

Typical powertop for /ipmi/ (2.6.31, before patch):
  11.4% (247.4)            kipmi0 : __mod_timer (process_timeout) 
   0.6% ( 13.1)       <interrupt> : ipmi_si 
   0.5% ( 10.0)     <kernel core> : __mod_timer (ipmi_timeout) 

powertop for /ipmi/, 2.6.31, after patch:
  10.8% (247.6)            kipmi0 : __mod_timer (process_timeout) 
   0.3% (  6.9)       <interrupt> : ipmi_si 
   0.0% (  1.0)     <kernel core> : __mod_timer (ipmi_timeout)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Corey Minyard <minyard@acm.org>
Cc:	openipmi-developer@lists.sourceforge.net
---
 drivers/char/ipmi/ipmi_msghandler.c |    7 +++++--
 drivers/char/ipmi/ipmi_si_intf.c    |    3 ++-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- lnx-2632-rc5.orig/drivers/char/ipmi/ipmi_msghandler.c
+++ lnx-2632-rc5/drivers/char/ipmi/ipmi_msghandler.c
@@ -39,6 +39,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/timer.h>
 #include <linux/ipmi.h>
 #include <linux/ipmi_smi.h>
 #include <linux/notifier.h>
@@ -4057,7 +4058,8 @@ static void ipmi_timeout(unsigned long d
 
 	ipmi_timeout_handler(IPMI_TIMEOUT_TIME);
 
-	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
+	mod_timer(&ipmi_timer,
+		round_jiffies_up(jiffies + IPMI_TIMEOUT_JIFFIES));
 }
 
 
@@ -4424,7 +4426,8 @@ static int ipmi_init_msghandler(void)
 #endif /* CONFIG_PROC_FS */
 
 	setup_timer(&ipmi_timer, ipmi_timeout, 0);
-	mod_timer(&ipmi_timer, jiffies + IPMI_TIMEOUT_JIFFIES);
+	mod_timer(&ipmi_timer,
+		round_jiffies_up(jiffies + IPMI_TIMEOUT_JIFFIES));
 
 	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
 
--- lnx-2632-rc5.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ lnx-2632-rc5/drivers/char/ipmi/ipmi_si_intf.c
@@ -1068,7 +1068,8 @@ static int smi_start_processing(void    
 	/* Set up the timer that drives the interface. */
 	setup_timer(&new_smi->si_timer, smi_timeout, (long)new_smi);
 	new_smi->last_timeout_jiffies = jiffies;
-	mod_timer(&new_smi->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
+	mod_timer(&new_smi->si_timer,
+		round_jiffies_up(jiffies + SI_TIMEOUT_JIFFIES));
 
 	/*
 	 * Check if the user forcefully enabled the daemon.

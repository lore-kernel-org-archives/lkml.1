Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZLUBVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZLUBVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbZLUBVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:21:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37732 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbZLUBUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:20:34 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091221220.243954235@firstfloor.org>
In-Reply-To: <20091221220.243954235@firstfloor.org>
To: samuel@sortiz.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, ebiederm@xmission.com
Subject: [PATCH] [11/11] SYSCTL: Convert IRDA text sysctl to RCU 
Message-Id: <20091221012032.B73BAB158A@basil.firstfloor.org>
Date: Mon, 21 Dec 2009 02:20:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This avoids races with lockless sysctl

Cc: samuel@sortiz.org

---
 net/irda/irlmp.c    |    3 +--
 net/irda/irsysctl.c |    9 ++++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6.33-rc1-ak/net/irda/irlmp.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/net/irda/irlmp.c
+++ linux-2.6.33-rc1-ak/net/irda/irlmp.c
@@ -56,7 +56,7 @@ int  sysctl_discovery         = 0;
 int  sysctl_discovery_timeout = 3; /* 3 seconds by default */
 int  sysctl_discovery_slots   = 6; /* 6 slots by default */
 int  sysctl_lap_keepalive_time = LM_IDLE_TIMEOUT * 1000 / HZ;
-char sysctl_devname[65];
+char *sysctl_devname = "Linux";
 
 const char *irlmp_reasons[] = {
 	"ERROR, NOT USED",
@@ -101,7 +101,6 @@ int __init irlmp_init(void)
 	spin_lock_init(&irlmp->cachelog->hb_spinlock);
 
 	irlmp->last_lsap_sel = 0x0f; /* Reserved 0x00-0x0f */
-	strcpy(sysctl_devname, "Linux");
 
 	init_timer(&irlmp->discovery_timer);
 
Index: linux-2.6.33-rc1-ak/net/irda/irsysctl.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/net/irda/irsysctl.c
+++ linux-2.6.33-rc1-ak/net/irda/irsysctl.c
@@ -27,6 +27,7 @@
 #include <linux/ctype.h>
 #include <linux/sysctl.h>
 #include <linux/init.h>
+#include <linux/rcupdate.h>
 
 #include <net/irda/irda.h>		/* irda_debug */
 #include <net/irda/irlmp.h>
@@ -38,7 +39,7 @@ extern int  sysctl_discovery_slots;
 extern int  sysctl_discovery_timeout;
 extern int  sysctl_slot_timeout;
 extern int  sysctl_fast_poll_increase;
-extern char sysctl_devname[];
+extern char *sysctl_devname;
 extern int  sysctl_max_baud_rate;
 extern int  sysctl_min_tx_turn_time;
 extern int  sysctl_max_tx_data_size;
@@ -78,13 +79,15 @@ static int do_devname(ctl_table *table,
 {
 	int ret;
 
-	ret = proc_dostring(table, write, buffer, lenp, ppos);
+	ret = proc_rcu_string(table, write, buffer, lenp, ppos);
 	if (ret == 0 && write) {
 		struct ias_value *val;
 
+		rcu_read_lock();
 		val = irias_new_string_value(sysctl_devname);
 		if (val)
 			irias_object_change_attribute("Device", "DeviceName", val);
+		rcu_read_unlock();
 	}
 	return ret;
 }
@@ -121,7 +124,7 @@ static ctl_table irda_table[] = {
 	},
 	{
 		.procname	= "devname",
-		.data		= sysctl_devname,
+		.data		= &sysctl_devname,
 		.maxlen		= 65,
 		.mode		= 0644,
 		.proc_handler	= do_devname,

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbZLUBUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbZLUBUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZLUBUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:20:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37717 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbZLUBUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:20:31 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091221220.243954235@firstfloor.org>
In-Reply-To: <20091221220.243954235@firstfloor.org>
To: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       ebiederm@xmission.com
Subject: [PATCH] [9/11] SYSCTL: Add a mutex to the page_alloc zone order sysctl
Message-Id: <20091221012030.B1940B158A@basil.firstfloor.org>
Date: Mon, 21 Dec 2009 02:20:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The zone list code clearly cannot tolerate concurrent writers (I couldn't find
any locks for that), so simply add a global mutex. No need for RCU in this case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/page_alloc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6.33-rc1-ak/mm/page_alloc.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/mm/page_alloc.c
+++ linux-2.6.33-rc1-ak/mm/page_alloc.c
@@ -2401,13 +2401,14 @@ int numa_zonelist_order_handler(ctl_tabl
 {
 	char saved_string[NUMA_ZONELIST_ORDER_LEN];
 	int ret;
+	static DEFINE_MUTEX(zl_order_mutex);
 
+	mutex_lock(&zl_order_mutex);
 	if (write)
-		strncpy(saved_string, (char*)table->data,
-			NUMA_ZONELIST_ORDER_LEN);
+		strcpy(saved_string, (char*)table->data);
 	ret = proc_dostring(table, write, buffer, length, ppos);
 	if (ret)
-		return ret;
+		goto out;
 	if (write) {
 		int oldval = user_zonelist_order;
 		if (__parse_numa_zonelist_order((char*)table->data)) {
@@ -2420,7 +2421,9 @@ int numa_zonelist_order_handler(ctl_tabl
 		} else if (oldval != user_zonelist_order)
 			build_all_zonelists();
 	}
-	return 0;
+out:
+	mutex_unlock(&zl_order_mutex);
+	return ret;
 }
 
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZLKPi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZLKPi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbZLKPhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:37:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:57510 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758930AbZLKPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:36:57 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 9/9] kgdb: Always process the whole breakpoint list on activate or deactivate
Date: Fri, 11 Dec 2009 09:36:17 -0600
Message-Id: <1260545777-8089-10-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1260545777-8089-9-git-send-email-jason.wessel@windriver.com>
References: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-3-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-4-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-5-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-6-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-7-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-8-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-9-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 Dec 2009 15:36:36.0019 (UTC) FILETIME=[B9314030:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes 2 edge cases in using kgdb in conjunction with gdb.

1) kgdb_deactivate_sw_breakpoints() should process the entire array of
   breakpoints.  The failure to do so results in breakpoints that you
   cannot remove, because a break point can only be removed if its
   state flag is set to BP_SET.

   The easy way to duplicate this problem is to plant a break point in
   a kernel module and then unload the kernel module.

2) kgdb_activate_sw_breakpoints() should process the entire array of
   breakpoints.  The failure to do so results in missed breakpoints
   when a breakpoint cannot be activated.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 8584eac..2eb517e 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -625,7 +625,8 @@ static void kgdb_flush_swbreak_addr(unsigned long addr)
 static int kgdb_activate_sw_breakpoints(void)
 {
 	unsigned long addr;
-	int error = 0;
+	int error;
+	int ret = 0;
 	int i;
 
 	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
@@ -635,13 +636,16 @@ static int kgdb_activate_sw_breakpoints(void)
 		addr = kgdb_break[i].bpt_addr;
 		error = kgdb_arch_set_breakpoint(addr,
 				kgdb_break[i].saved_instr);
-		if (error)
-			return error;
+		if (error) {
+			ret = error;
+			printk(KERN_INFO "KGDB: BP install failed: %lx", addr);
+			continue;
+		}
 
 		kgdb_flush_swbreak_addr(addr);
 		kgdb_break[i].state = BP_ACTIVE;
 	}
-	return 0;
+	return ret;
 }
 
 static int kgdb_set_sw_break(unsigned long addr)
@@ -688,7 +692,8 @@ static int kgdb_set_sw_break(unsigned long addr)
 static int kgdb_deactivate_sw_breakpoints(void)
 {
 	unsigned long addr;
-	int error = 0;
+	int error;
+	int ret = 0;
 	int i;
 
 	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
@@ -697,13 +702,15 @@ static int kgdb_deactivate_sw_breakpoints(void)
 		addr = kgdb_break[i].bpt_addr;
 		error = kgdb_arch_remove_breakpoint(addr,
 					kgdb_break[i].saved_instr);
-		if (error)
-			return error;
+		if (error) {
+			printk(KERN_INFO "KGDB: BP remove failed: %lx\n", addr);
+			ret = error;
+		}
 
 		kgdb_flush_swbreak_addr(addr);
 		kgdb_break[i].state = BP_SET;
 	}
-	return 0;
+	return ret;
 }
 
 static int kgdb_remove_sw_break(unsigned long addr)
-- 
1.6.4.rc1


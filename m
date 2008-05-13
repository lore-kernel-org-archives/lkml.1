Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYEMAmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYEMAmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 20:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbYEMAmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 20:42:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33462
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756538AbYEMAmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 20:42:01 -0400
Date: Mon, 12 May 2008 17:41:55 -0700 (PDT)
Message-Id: <20080512.174155.180474500.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org, paulus@samba.org, mikpe@it.uu.se
Subject: [PATCH 2/2]: lmb: Make lmb debugging more useful.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Having to muck with the build and set DEBUG just to
get lmb_dump_all() to print things isn't very useful.

So use pr_info() and use an early boot param
"lmb=debug" so we can simply ask users to reboot
with this option when we need some debugging from
them.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 lib/lmb.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/lib/lmb.c b/lib/lmb.c
index 93445dc..867f7b5 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -19,31 +19,42 @@
 
 struct lmb lmb;
 
+static int lmb_debug;
+
+static int __init early_lmb(char *p)
+{
+	if (p && strstr(p, "debug"))
+		lmb_debug = 1;
+	return 0;
+}
+early_param("lmb", early_lmb);
+
 void lmb_dump_all(void)
 {
-#ifdef DEBUG
 	unsigned long i;
 
-	pr_debug("lmb_dump_all:\n");
-	pr_debug("    memory.cnt		  = 0x%lx\n", lmb.memory.cnt);
-	pr_debug("    memory.size		  = 0x%llx\n",
+	if (!lmb_debug)
+		return;
+
+	pr_info("lmb_dump_all:\n");
+	pr_info("    memory.cnt		  = 0x%lx\n", lmb.memory.cnt);
+	pr_info("    memory.size		  = 0x%llx\n",
 	    (unsigned long long)lmb.memory.size);
 	for (i=0; i < lmb.memory.cnt ;i++) {
-		pr_debug("    memory.region[0x%x].base       = 0x%llx\n",
+		pr_info("    memory.region[0x%lx].base       = 0x%llx\n",
 		    i, (unsigned long long)lmb.memory.region[i].base);
-		pr_debug("		      .size     = 0x%llx\n",
+		pr_info("		      .size     = 0x%llx\n",
 		    (unsigned long long)lmb.memory.region[i].size);
 	}
 
-	pr_debug("    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
-	pr_debug("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
+	pr_info("    reserved.cnt	  = 0x%lx\n", lmb.reserved.cnt);
+	pr_info("    reserved.size	  = 0x%lx\n", lmb.reserved.size);
 	for (i=0; i < lmb.reserved.cnt ;i++) {
-		pr_debug("    reserved.region[0x%x].base       = 0x%llx\n",
+		pr_info("    reserved.region[0x%lx].base       = 0x%llx\n",
 		    i, (unsigned long long)lmb.reserved.region[i].base);
-		pr_debug("		      .size     = 0x%llx\n",
+		pr_info("		      .size     = 0x%llx\n",
 		    (unsigned long long)lmb.reserved.region[i].size);
 	}
-#endif /* DEBUG */
 }
 
 static unsigned long lmb_addrs_overlap(u64 base1, u64 size1, u64 base2,
-- 
1.5.5.1.57.g5909c


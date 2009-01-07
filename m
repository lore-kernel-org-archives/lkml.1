Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbZAGTXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbZAGTXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760780AbZAGTWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:22:31 -0500
Received: from mga05.intel.com ([192.55.52.89]:34602 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755226AbZAGTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:22:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,339,1228118400"; 
   d="scan'208";a="655323908"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: netdev@vger.kernel.org
Cc: wimax@linuxwimax.org, greg@kroah.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: [PATCH 1/4] wimax: fix '#ifndef CONFIG_BUG' layout to avoid warning
Date: Wed,  7 Jan 2009 11:22:19 -0800
Message-Id: <7e92a3e498e02567876f901eba29c59c294a417b.1231355768.git.inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1231355768.git.inaky@linux.intel.com>
References: <cover.1231355768.git.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by Randy Dunlap:

> Also, this warning needs to be fixed:
>
> linux-next-20090106/net/wimax/id-table.c:133: warning: ISO C90
> forbids mixed declarations and code

Move the return on #defined(CONFIG_BUG) below the variable
declarations so it doesn't violate ISO C90.

On wimax_id_table_release() we want to do a debug check if CONFIG_BUG
is enabled. However, we also want the debug code to be always compiled
to ensure there is no bitrot. It will be optimized out by the compiler
when CONFIG_BUG is disabled.

Added a note to the function header stating this.

Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
---
 net/wimax/id-table.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/wimax/id-table.c b/net/wimax/id-table.c
index d3b8855..5e685f7 100644
--- a/net/wimax/id-table.c
+++ b/net/wimax/id-table.c
@@ -123,15 +123,17 @@ void wimax_id_table_rm(struct wimax_dev *wimax_dev)
 /*
  * Release the gennetlink family id / mapping table
  *
- * On debug, verify that the table is empty upon removal.
+ * On debug, verify that the table is empty upon removal. We want the
+ * code always compiled, to ensure it doesn't bit rot. It will be
+ * compiled out if CONFIG_BUG is disabled.
  */
 void wimax_id_table_release(void)
 {
+	struct wimax_dev *wimax_dev;
+
 #ifndef CONFIG_BUG
 	return;
 #endif
-	struct wimax_dev *wimax_dev;
-
 	spin_lock(&wimax_id_table_lock);
 	list_for_each_entry(wimax_dev, &wimax_id_table, id_table_node) {
 		printk(KERN_ERR "BUG: %s wimax_dev %p ifindex %d not cleared\n",
-- 
1.5.6.5


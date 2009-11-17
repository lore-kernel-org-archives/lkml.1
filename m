Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbZKQHTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbZKQHTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZKQHTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:19:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57311 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZKQHT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:19:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] nandsim: Don't use PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-mtd@lists.infradead.org
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Message-Id: <20091117161843.3DE0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 16:19:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
memory, anyone must not prevent it. Otherwise the system cause
mysterious hang-up and/or OOM Killer invokation.

Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/mtd/nand/nandsim.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index cd0711b..97a8bbb 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -1322,34 +1322,18 @@ static int get_pages(struct nandsim *ns, struct file *file, size_t count, loff_t
 	return 0;
 }
 
-static int set_memalloc(void)
-{
-	if (current->flags & PF_MEMALLOC)
-		return 0;
-	current->flags |= PF_MEMALLOC;
-	return 1;
-}
-
-static void clear_memalloc(int memalloc)
-{
-	if (memalloc)
-		current->flags &= ~PF_MEMALLOC;
-}
-
 static ssize_t read_file(struct nandsim *ns, struct file *file, void *buf, size_t count, loff_t *pos)
 {
 	mm_segment_t old_fs;
 	ssize_t tx;
-	int err, memalloc;
+	int err;
 
 	err = get_pages(ns, file, count, *pos);
 	if (err)
 		return err;
 	old_fs = get_fs();
 	set_fs(get_ds());
-	memalloc = set_memalloc();
 	tx = vfs_read(file, (char __user *)buf, count, pos);
-	clear_memalloc(memalloc);
 	set_fs(old_fs);
 	put_pages(ns);
 	return tx;
@@ -1359,16 +1343,14 @@ static ssize_t write_file(struct nandsim *ns, struct file *file, void *buf, size
 {
 	mm_segment_t old_fs;
 	ssize_t tx;
-	int err, memalloc;
+	int err;
 
 	err = get_pages(ns, file, count, *pos);
 	if (err)
 		return err;
 	old_fs = get_fs();
 	set_fs(get_ds());
-	memalloc = set_memalloc();
 	tx = vfs_write(file, (char __user *)buf, count, pos);
-	clear_memalloc(memalloc);
 	set_fs(old_fs);
 	put_pages(ns);
 	return tx;
-- 
1.6.2.5




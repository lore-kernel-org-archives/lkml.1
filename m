Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZLDUtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZLDUtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 15:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbZLDUtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 15:49:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbZLDUta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 15:49:30 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH 15/15] ima: limit imbalance msg
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: viro@zeniv.linux.org.uk, jmorris@namei.org, npiggin@suse.de,
       eparis@redhat.com, zohar@us.ibm.com, jack@suse.cz,
       jmalicki@metacarta.com, dsmith@redhat.com, serue@us.ibm.com, hch@lst.de,
       john@johnmccutchan.com, rlove@rlove.org, ebiederm@xmission.com,
       heiko.carstens@de.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp,
       mszeredi@suse.cz, jens.axboe@oracle.com, akpm@linux-foundation.org,
       matthew@wil.cx, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       davem@davemloft.net, arnd@arndb.de, eric.dumazet@gmail.com
Date: Fri, 04 Dec 2009 15:48:40 -0500
Message-ID: <20091204204840.18286.81154.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
References: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mimi Zohar <zohar@us.ibm.com>

Limit the number of imbalance messages to once per filesystem type instead of
once per system boot.  (it's actually slightly racy and could give you a
couple per fs, but this isn't a real issue)

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---

 security/integrity/ima/ima_main.c |   62 ++++++++++++++++++++++++++++++++-----
 1 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index c721ddc..14d109b 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -35,6 +35,55 @@ static int __init hash_setup(char *str)
 }
 __setup("ima_hash=", hash_setup);
 
+struct ima_imbalance {
+	struct hlist_node node;
+	unsigned long fsmagic;
+};
+
+/*
+ * ima_limit_imbalance - emit one imbalance message per filesystem type
+ *
+ * Maintain list of filesystem types that do not measure files properly.
+ * Return false if unknown, true if known.
+ */
+static bool ima_limit_imbalance(struct file *file)
+{
+	static DEFINE_SPINLOCK(ima_imbalance_lock);
+	static HLIST_HEAD(ima_imbalance_list);
+
+	struct super_block *sb = file->f_dentry->d_sb;
+	struct ima_imbalance *entry;
+	struct hlist_node *node;
+	bool found = false;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(entry, node, &ima_imbalance_list, node) {
+		if (entry->fsmagic == sb->s_magic) {
+			found = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	if (found)
+		goto out;
+
+	entry = kmalloc(sizeof(*entry), GFP_NOFS);
+	if (!entry)
+		goto out;
+	entry->fsmagic = sb->s_magic;
+	spin_lock(&ima_imbalance_lock);
+	/*
+	 * we could have raced and something else might have added this fs
+	 * to the list, but we don't really care
+	 */
+	hlist_add_head_rcu(&entry->node, &ima_imbalance_list);
+	spin_unlock(&ima_imbalance_lock);
+	printk(KERN_INFO "IMA: unmeasured files on fsmagic: %lX\n",
+	       entry->fsmagic);
+out:
+	return found;
+}
+
 /*
  * Update the counts given a file
  */
@@ -72,15 +121,10 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct file *file)
 		}
 	}
 
-	if ((iint->opencount < 0) ||
-	    (iint->readcount < 0) ||
-	    (iint->writecount < 0)) {
-		static int dumped;
-
-		if (dumped)
-			return;
-		dumped = 1;
-
+	if (((iint->opencount < 0) ||
+	     (iint->readcount < 0) ||
+	     (iint->writecount < 0)) &&
+	    !ima_limit_imbalance(file)) {
 		printk(KERN_INFO "%s: open/free imbalance (r:%ld w:%ld o:%ld)\n",
 		       __FUNCTION__, iint->readcount, iint->writecount,
 		       iint->opencount);


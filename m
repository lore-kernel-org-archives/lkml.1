Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbXERJR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbXERJR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbXERJRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:17:52 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:27773 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbXERJRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:17:52 -0400
Message-ID: <464D7005.6030504@sw.ru>
Date: Fri, 18 May 2007 13:21:09 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com, chas@cmf.nrl.navy.mil, axboe@kernel.dk,
       herbert@gondor.apana.org.au, dmitry.torokhov@gmail.com, kkeil@suse.de,
       David Miller <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
       viro@zeniv.linux.org.uk, devel@openvz.org
Subject: [PATCH 1/15] The helper functions itselves
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Many places in kernel use seq_file API to iterate over a regular
list_head. The code for such iteration is identical in all the
places, so it's worth introducing a common helpers.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 0ac22af..49194a4 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -447,3 +447,37 @@ int seq_puts(struct seq_file *m, const c
 	return -1;
 }
 EXPORT_SYMBOL(seq_puts);
+
+struct list_head *seq_list_start(struct list_head *head, loff_t pos)
+{
+	struct list_head *lh;
+
+	list_for_each(lh, head)
+		if (pos-- == 0)
+			return lh;
+
+	return NULL;
+}
+
+EXPORT_SYMBOL(seq_list_start);
+
+struct list_head *seq_list_start_head(struct list_head *head, loff_t pos)
+{
+	if (!pos)
+		return head;
+
+	return seq_list_start(head, pos - 1);
+}
+
+EXPORT_SYMBOL(seq_list_start_head);
+
+struct list_head *seq_list_next(void *v, struct list_head *head, loff_t *ppos)
+{
+	struct list_head *lh;
+
+	lh = ((struct list_head *)v)->next;
+	++*ppos;
+	return lh == head ? NULL : lh;
+}
+
+EXPORT_SYMBOL(seq_list_next);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 3e3cccb..83783ab 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -50,5 +50,16 @@ int seq_release_private(struct inode *, 
 
 #define SEQ_START_TOKEN ((void *)1)
 
+/*
+ * Helpers for iteration over list_head-s in seq_files
+ */
+
+extern struct list_head *seq_list_start(struct list_head *head,
+		loff_t pos);
+extern struct list_head *seq_list_start_head(struct list_head *head,
+		loff_t pos);
+extern struct list_head *seq_list_next(void *v, struct list_head *head,
+		loff_t *ppos);
+
 #endif
 #endif


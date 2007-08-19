Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbXHSH4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbXHSH4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 03:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXHSHzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 03:55:53 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50448 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751149AbXHSHzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 03:55:51 -0400
Message-ID: <387510148.18695@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070819075547.674060890@mail.ustc.edu.cn>
References: <20070819075410.411207640@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 19 Aug 2007 15:54:13 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: John Berthels <jjberthels@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] maps: introduce generic_maps_open()
Content-Disposition: inline; filename=maps-generic-open.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce generic_maps_open(). It is an extended version of do_maps_open().
The new function supports batch_size and custom sized seqfile/private buffers.
This function will be reused by pmaps.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/proc/task_mmu.c |   51 ++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 15 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
+++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
@@ -176,24 +176,45 @@ static void m_stop(struct seq_file *m, v
 		put_task_struct(priv->task);
 }
 
+static int generic_maps_open(struct inode *inode, struct file *file,
+			struct seq_operations *ops, unsigned long batch_size,
+			int bufsize, int privsize)
+{
+	struct seq_file *m;
+	struct proc_maps_private *priv = NULL;
+	char *buf = NULL;
+	int ret = -ENOMEM;
+
+	priv = kzalloc(privsize, GFP_KERNEL);
+	if (!priv)
+		goto out;
+
+	buf = kmalloc(bufsize, GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	ret = seq_open(file, ops);
+	if (ret)
+		goto out;
+
+	m = file->private_data;
+	m->private = priv;
+	m->buf = buf;
+	m->size = bufsize;
+	priv->pid = proc_pid(inode);
+	priv->batch_size = batch_size;
+	return 0;
+out:
+	kfree(priv);
+	kfree(buf);
+	return ret;
+}
+
 static int do_maps_open(struct inode *inode, struct file *file,
 			struct seq_operations *ops)
 {
-	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->pid = proc_pid(inode);
-		priv->batch_size = ~0;
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+	return generic_maps_open(inode, file, ops, ~0, 2 * PAGE_SIZE,
+				 sizeof(struct proc_maps_private));
 }
 
 static int show_map(struct seq_file *m, void *v)

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbXHPWJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbXHPWJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbXHPWIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:08:55 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44031 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753395AbXHPWIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:08:53 -0400
Message-ID: <387302129.27270@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070816220849.313377588@mail.ustc.edu.cn>
References: <20070816220516.782145952@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 17 Aug 2007 06:05:19 +0800
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
@@ -178,24 +178,45 @@ static void m_stop(struct seq_file *m, v
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

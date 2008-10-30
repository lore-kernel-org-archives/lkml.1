Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYJ3H0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYJ3H0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYJ3H03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:26:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56323 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbYJ3H02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:26:28 -0400
Message-ID: <490960F4.6050904@cn.fujitsu.com>
Date: Thu, 30 Oct 2008 15:23:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: switch sched_features to seqfile
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So handling of sched_features read is simplified.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |   52 ++++++++++++++++------------------------------------
 1 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7dd6c86..5419df9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -703,45 +703,18 @@ static __read_mostly char *sched_feat_names[] = {
 
 #undef SCHED_FEAT
 
-static int sched_feat_open(struct inode *inode, struct file *filp)
+static int sched_feat_show(struct seq_file *m, void *v)
 {
-	filp->private_data = inode->i_private;
-	return 0;
-}
-
-static ssize_t
-sched_feat_read(struct file *filp, char __user *ubuf,
-		size_t cnt, loff_t *ppos)
-{
-	char *buf;
-	int r = 0;
-	int len = 0;
 	int i;
 
 	for (i = 0; sched_feat_names[i]; i++) {
-		len += strlen(sched_feat_names[i]);
-		len += 4;
+		if (!(sysctl_sched_features & (1UL << i)))
+			seq_puts(m, "NO_");
+		seq_printf(m, "%s ", sched_feat_names[i]);
 	}
+	seq_puts(m, "\n");
 
-	buf = kmalloc(len + 2, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	for (i = 0; sched_feat_names[i]; i++) {
-		if (sysctl_sched_features & (1UL << i))
-			r += sprintf(buf + r, "%s ", sched_feat_names[i]);
-		else
-			r += sprintf(buf + r, "NO_%s ", sched_feat_names[i]);
-	}
-
-	r += sprintf(buf + r, "\n");
-	WARN_ON(r >= len + 2);
-
-	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-
-	kfree(buf);
-
-	return r;
+	return 0;
 }
 
 static ssize_t
@@ -786,10 +759,17 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int sched_feat_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, sched_feat_show, NULL);
+}
+
 static struct file_operations sched_feat_fops = {
-	.open	= sched_feat_open,
-	.read	= sched_feat_read,
-	.write	= sched_feat_write,
+	.open		= sched_feat_open,
+	.write		= sched_feat_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 };
 
 static __init int sched_init_debug(void)
-- 
1.5.4.rc3


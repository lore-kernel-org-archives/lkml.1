Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZJHGFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZJHGFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZJHGFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34545 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbZJHGFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:15 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 05/13] Blackfin: cplbinfo: drop d_path() hacks
Date: Thu,  8 Oct 2009 02:04:21 -0400
Message-Id: <1254981869-21586-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cplbinfo was using d_path() to figure out which cpu/cplb was being
parsed.  As Al pointed out, this isn't exactly reliable as it assumes the
static VFS path to be unchanged, and it's just poor form.  So use the
proc_create_data() to properly (and internally) pass the exact cpu/cplb
requested to the parser function.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/cplbinfo.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/blackfin/kernel/cplbinfo.c b/arch/blackfin/kernel/cplbinfo.c
index 26d1819..0bdaa51 100644
--- a/arch/blackfin/kernel/cplbinfo.c
+++ b/arch/blackfin/kernel/cplbinfo.c
@@ -112,24 +112,21 @@ static const struct seq_operations cplbinfo_sops = {
 	.show  = cplbinfo_show,
 };
 
+#define CPLBINFO_DCPLB_FLAG 0x80000000
+
 static int cplbinfo_open(struct inode *inode, struct file *file)
 {
-	char buf[256], *path, *p;
+	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
+	char cplb_type;
 	unsigned int cpu;
-	char *s_cpu, *s_cplb;
 	int ret;
 	struct seq_file *m;
 	struct cplbinfo_data *cdata;
 
-	path = d_path(&file->f_path, buf, sizeof(buf));
-	if (IS_ERR(path))
-		return PTR_ERR(path);
-	s_cpu = strstr(path, "/cpu");
-	s_cplb = strrchr(path, '/');
-	if (!s_cpu || !s_cplb)
-		return -EINVAL;
+	cpu = (unsigned int)pde->data;
+	cplb_type = cpu & CPLBINFO_DCPLB_FLAG ? 'D' : 'I';
+	cpu &= ~CPLBINFO_DCPLB_FLAG;
 
-	cpu = simple_strtoul(s_cpu + 4, &p, 10);
 	if (!cpu_online(cpu))
 		return -ENODEV;
 
@@ -140,7 +137,7 @@ static int cplbinfo_open(struct inode *inode, struct file *file)
 	cdata = m->private;
 
 	cdata->pos = 0;
-	cdata->cplb_type = toupper(s_cplb[1]);
+	cdata->cplb_type = cplb_type;
 	cplbinfo_seq_init(cdata, cpu);
 
 	return 0;
@@ -169,8 +166,10 @@ static int __init cplbinfo_init(void)
 		if (!cpu_dir)
 			return -ENOMEM;
 
-		proc_create("icplb", S_IRUGO, cpu_dir, &cplbinfo_fops);
-		proc_create("dcplb", S_IRUGO, cpu_dir, &cplbinfo_fops);
+		proc_create_data("icplb", S_IRUGO, cpu_dir, &cplbinfo_fops,
+			(void *)cpu);
+		proc_create_data("dcplb", S_IRUGO, cpu_dir, &cplbinfo_fops,
+			(void *)(cpu | CPLBINFO_DCPLB_FLAG));
 	}
 
 	return 0;
-- 
1.6.5.rc2


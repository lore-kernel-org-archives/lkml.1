Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbZIWE76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbZIWE76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 00:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZIWE75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 00:59:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40310 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZIWE75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 00:59:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] Blackfin: cplbinfo: drop d_path() hacks
Date: Wed, 23 Sep 2009 00:59:59 -0400
Message-Id: <1253681999-25119-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <20090921143857.GE14381@ZenIV.linux.org.uk>
References: <20090921143857.GE14381@ZenIV.linux.org.uk>
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
just a heads up -- here's what i ended up going with.  thanks for the tips.

 arch/blackfin/kernel/cplbinfo.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/blackfin/kernel/cplbinfo.c b/arch/blackfin/kernel/cplbinfo.c
index 64d7830..7e5731c 100644
--- a/arch/blackfin/kernel/cplbinfo.c
+++ b/arch/blackfin/kernel/cplbinfo.c
@@ -111,24 +111,21 @@ static const struct seq_operations cplbinfo_sops = {
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
 
@@ -139,7 +136,7 @@ static int cplbinfo_open(struct inode *inode, struct file *file)
 	cdata = m->private;
 
 	cdata->pos = 0;
-	cdata->cplb_type = toupper(s_cplb[1]);
+	cdata->cplb_type = cplb_type;
 	cplbinfo_seq_init(cdata, cpu);
 
 	return 0;
@@ -168,8 +165,10 @@ static int __init cplbinfo_init(void)
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
1.6.5.rc1


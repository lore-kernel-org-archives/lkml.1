Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZHOQQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZHOQQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZHOQQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:16:06 -0400
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:35260 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751283AbZHOQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:16:06 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Aug 2009 12:16:05 EDT
Date: Sun, 16 Aug 2009 00:54:41 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: linux-nfs@vger.kernel.org, neilb@suse.de
Cc: mandel59@gmail.com, yamahata@valinux.co.jp, yoshfuji@linux-ipv6.org
Message-Id: <20090816005441.2c923280.yoshfuji@linux-ipv6.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [PATCH] knfsd: Replace lock_kernel with a mutex in nfsd pool stats.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryusei Yamaguchi <mandel59@gmail.com>
Subject: [PATCH] knfsd: Replace lock_kernel with a mutex in nfsd pool stats.

lock_kernel() in knfsd was replaced with a mutex. The later
commit 03cf6c9f49a8fea953d38648d016e3f46e814991 ("knfsd:
add file to export stats about nfsd pools") did not follow
that change. This patch fixes the issue.

Signed-off-by: Ryusei Yamaguchi <mandel59@gmail.com>
Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

---
 fs/nfsd/nfsctl.c      |    3 ++-
 fs/nfsd/nfssvc.c      |   23 +++++++++++++++++++++--
 net/sunrpc/svc_xprt.c |   11 -----------
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 6d08475..6b1b917 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -173,12 +173,13 @@ static const struct file_operations exports_operations = {
 };
 
 extern int nfsd_pool_stats_open(struct inode *inode, struct file *file);
+extern int nfsd_pool_stats_release(struct inode *inode, struct file *file);
 
 static struct file_operations pool_stats_operations = {
 	.open		= nfsd_pool_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= nfsd_pool_stats_release,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 492c79b..32e64fc 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -34,6 +34,7 @@
 #include <linux/nfsd/syscall.h>
 #include <linux/lockd/bind.h>
 #include <linux/nfsacl.h>
+#include <linux/seq_file.h>
 
 #define NFSDDBG_FACILITY	NFSDDBG_SVC
 
@@ -605,7 +606,25 @@ nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 
 int nfsd_pool_stats_open(struct inode *inode, struct file *file)
 {
-	if (nfsd_serv == NULL)
+	int ret;
+	mutex_lock(&nfsd_mutex);
+	if (nfsd_serv == NULL) {
+		mutex_unlock(&nfsd_mutex);
 		return -ENODEV;
-	return svc_pool_stats_open(nfsd_serv, file);
+	}
+	/* bump up the psudo refcount while traversing */
+	svc_get(nfsd_serv);
+	ret = svc_pool_stats_open(nfsd_serv, file);
+	mutex_unlock(&nfsd_mutex);
+	return ret;
+}
+
+int nfsd_pool_stats_release(struct inode *inode, struct file *file)
+{
+	int ret = seq_release(inode, file);
+	mutex_lock(&nfsd_mutex);
+	/* this function really, really should have been called svc_put() */
+	svc_destroy(nfsd_serv);
+	mutex_unlock(&nfsd_mutex);
+	return ret;
 }
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 27d4433..dcd2d1e 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1166,11 +1166,6 @@ static void *svc_pool_stats_start(struct seq_file *m, loff_t *pos)
 
 	dprintk("svc_pool_stats_start, *pidx=%u\n", pidx);
 
-	lock_kernel();
-	/* bump up the pseudo refcount while traversing */
-	svc_get(serv);
-	unlock_kernel();
-
 	if (!pidx)
 		return SEQ_START_TOKEN;
 	return (pidx > serv->sv_nrpools ? NULL : &serv->sv_pools[pidx-1]);
@@ -1198,12 +1193,6 @@ static void *svc_pool_stats_next(struct seq_file *m, void *p, loff_t *pos)
 
 static void svc_pool_stats_stop(struct seq_file *m, void *p)
 {
-	struct svc_serv *serv = m->private;
-
-	lock_kernel();
-	/* this function really, really should have been called svc_put() */
-	svc_destroy(serv);
-	unlock_kernel();
 }
 
 static int svc_pool_stats_show(struct seq_file *m, void *p)
-- 
1.4.4.4


--yoshfuji

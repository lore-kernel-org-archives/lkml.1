Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0BHUNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:13:09 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:36936 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0BHUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:12:59 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 02/41] CAPI: Sanitize capifs API
Date: Mon,  8 Feb 2010 21:12:06 +0100
Message-Id: <11a13230ef2929bbd143afebe5e7f2b567b07fe6.1265659933.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1/86V2+ntpwpk8qYayffMYr8elWx47T/qi+yjlw
	bB3J4/iLRLt5k09AbzFHfrilHru06jeydJ0tN9ID11CH6nObeF
	1xV/D1cak=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of looking up the dentry of an NCCI node again in
capifs_free_ncci pass the pointer via the capifs user.

This patch also reduces the #ifdef mess in capi.c a bit as far as capifs
was causing it.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capi.c   |   14 +++++-------
 drivers/isdn/capi/capifs.c |   50 +++++++++++++++++++++++++------------------
 drivers/isdn/capi/capifs.h |   21 ++++++++++++++++-
 3 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 79f9364..dc5ac52 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -42,9 +42,8 @@
 #include <linux/moduleparam.h>
 #include <linux/isdn/capiutil.h>
 #include <linux/isdn/capicmd.h>
-#if defined(CONFIG_ISDN_CAPI_CAPIFS) || defined(CONFIG_ISDN_CAPI_CAPIFS_MODULE)
+
 #include "capifs.h"
-#endif
 
 static char *revision = "$Revision: 1.1.2.7 $";
 
@@ -96,6 +95,7 @@ struct capiminor {
 	struct list_head list;
 	struct capincci  *nccip;
 	unsigned int      minor;
+	struct dentry *capifs_dentry;
 
 	struct capi20_appl *ap;
 	u32		 ncci;
@@ -328,9 +328,9 @@ static struct capincci *capincci_alloc(struct capidev *cdev, u32 ncci)
 #ifdef _DEBUG_REFCOUNT
 		printk(KERN_DEBUG "set mp->nccip\n");
 #endif
-#if defined(CONFIG_ISDN_CAPI_CAPIFS) || defined(CONFIG_ISDN_CAPI_CAPIFS_MODULE)
-		capifs_new_ncci(mp->minor, MKDEV(capi_ttymajor, mp->minor));
-#endif
+		mp->capifs_dentry =
+			capifs_new_ncci(mp->minor,
+					MKDEV(capi_ttymajor, mp->minor));
 	}
 #endif /* CONFIG_ISDN_CAPI_MIDDLEWARE */
 	for (pp=&cdev->nccis; *pp; pp = &(*pp)->next)
@@ -353,9 +353,7 @@ static void capincci_free(struct capidev *cdev, u32 ncci)
 			*pp = (*pp)->next;
 #ifdef CONFIG_ISDN_CAPI_MIDDLEWARE
 			if ((mp = np->minorp) != NULL) {
-#if defined(CONFIG_ISDN_CAPI_CAPIFS) || defined(CONFIG_ISDN_CAPI_CAPIFS_MODULE)
-				capifs_free_ncci(mp->minor);
-#endif
+				capifs_free_ncci(mp->capifs_dentry);
 				if (mp->tty) {
 					mp->nccip = NULL;
 #ifdef _DEBUG_REFCOUNT
diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index dc68fcb..91aafad 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -141,31 +141,32 @@ static struct file_system_type capifs_fs_type = {
 	.kill_sb	= kill_anon_super,
 };
 
-static struct dentry *get_node(int num)
-{
-	char s[10];
-	struct dentry *root = capifs_root;
-	mutex_lock(&root->d_inode->i_mutex);
-	return lookup_one_len(s, root, sprintf(s, "%d", num));
-}
-
-void capifs_new_ncci(unsigned int number, dev_t device)
+struct dentry *capifs_new_ncci(unsigned int number, dev_t device)
 {
 	struct dentry *dentry;
 	struct inode *inode;
+	char name[10];
+	int namelen;
 
-	dentry = get_node(number);
-	if (IS_ERR(dentry))
+	mutex_lock(&capifs_root->d_inode->i_mutex);
+
+	namelen = sprintf(name, "%d", number);
+	dentry = lookup_one_len(name, capifs_root, namelen);
+	if (IS_ERR(dentry)) {
+		dentry = NULL;
 		goto unlock_out;
+	}
 
 	if (dentry->d_inode) {
 		dput(dentry);
+		dentry = NULL;
 		goto unlock_out;
 	}
 
 	inode = new_inode(capifs_mnt->mnt_sb);
 	if (!inode) {
 		dput(dentry);
+		dentry = NULL;
 		goto unlock_out;
 	}
 
@@ -177,24 +178,31 @@ void capifs_new_ncci(unsigned int number, dev_t device)
 	init_special_inode(inode, S_IFCHR|config.mode, device);
 
 	d_instantiate(dentry, inode);
+	dget(dentry);
 
 unlock_out:
 	mutex_unlock(&capifs_root->d_inode->i_mutex);
+
+	return dentry;
 }
 
-void capifs_free_ncci(unsigned int number)
+void capifs_free_ncci(struct dentry *dentry)
 {
-	struct dentry *dentry = get_node(number);
-
-	if (!IS_ERR(dentry)) {
-		struct inode *inode = dentry->d_inode;
-		if (inode) {
-			inode->i_nlink--;
-			d_delete(dentry);
-			dput(dentry);
-		}
+	struct inode *inode;
+
+	if (!dentry)
+		return;
+
+	mutex_lock(&capifs_root->d_inode->i_mutex);
+
+	inode = dentry->d_inode;
+	if (inode) {
+		drop_nlink(inode);
+		d_delete(dentry);
 		dput(dentry);
 	}
+	dput(dentry);
+
 	mutex_unlock(&capifs_root->d_inode->i_mutex);
 }
 
diff --git a/drivers/isdn/capi/capifs.h b/drivers/isdn/capi/capifs.h
index d0bd4c3..e193d11 100644
--- a/drivers/isdn/capi/capifs.h
+++ b/drivers/isdn/capi/capifs.h
@@ -7,5 +7,22 @@
  *
  */
 
-void capifs_new_ncci(unsigned int num, dev_t device);
-void capifs_free_ncci(unsigned int num);
+#include <linux/dcache.h>
+
+#if defined(CONFIG_ISDN_CAPI_CAPIFS) || defined(CONFIG_ISDN_CAPI_CAPIFS_MODULE)
+
+struct dentry *capifs_new_ncci(unsigned int num, dev_t device);
+void capifs_free_ncci(struct dentry *dentry);
+
+#else
+
+static inline struct dentry *capifs_new_ncci(unsigned int num, dev_t device)
+{
+	return NULL;
+}
+
+static inline void capifs_free_ncci(struct dentry *dentry)
+{
+}
+
+#endif
-- 
1.6.0.2


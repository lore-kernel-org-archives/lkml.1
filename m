Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYE2Lf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYE2Lf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYE2Lda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:33:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56709 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbYE2LdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:33:24 -0400
Message-Id: <20080529113315.284080903@szeredi.hu>
References: <20080529113245.450308367@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 29 May 2008 13:32:51 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [patch 6/8] Factor out sysctl pathname code
Content-Disposition: inline; filename=sysctl-pathname.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the selinux sysctl pathname computation code into a standalone
function.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>
Reviewed-by: James Morris <jmorris@namei.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 include/linux/sysctl.h   |    2 ++
 kernel/sysctl.c          |   27 +++++++++++++++++++++++++++
 security/selinux/hooks.c |   35 +++++------------------------------
 3 files changed, 34 insertions(+), 30 deletions(-)

Index: linux-2.6/include/linux/sysctl.h
===================================================================
--- linux-2.6.orig/include/linux/sysctl.h	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/include/linux/sysctl.h	2008-05-29 12:46:25.000000000 +0200
@@ -980,6 +980,8 @@ extern int proc_doulongvec_minmax(struct
 extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
 				      struct file *, void __user *, size_t *, loff_t *);
 
+extern char *sysctl_pathname(ctl_table *, char *, int);
+
 extern int do_sysctl (int __user *name, int nlen,
 		      void __user *oldval, size_t __user *oldlenp,
 		      void __user *newval, size_t newlen);
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/kernel/sysctl.c	2008-05-29 12:46:25.000000000 +0200
@@ -1432,6 +1432,33 @@ void register_sysctl_root(struct ctl_tab
 	spin_unlock(&sysctl_lock);
 }
 
+char *sysctl_pathname(ctl_table *table, char *buffer, int buflen)
+{
+	if (buflen < 1)
+		return NULL;
+	buffer += --buflen;
+	*buffer = '\0';
+
+	while (table) {
+		int namelen = strlen(table->procname);
+
+		if (buflen < namelen + 1)
+			return NULL;
+		buflen -= namelen + 1;
+		buffer -= namelen;
+		memcpy(buffer, table->procname, namelen);
+		*--buffer = '/';
+		table = table->parent;
+	}
+	if (buflen < 4)
+		return NULL;
+	buffer -= 4;
+	memcpy(buffer, "/sys", 4);
+
+	return buffer;
+}
+EXPORT_SYMBOL(sysctl_pathname);
+
 #ifdef CONFIG_SYSCTL_SYSCALL
 /* Perform the actual read/write of a sysctl table entry. */
 static int do_sysctl_strategy(struct ctl_table_root *root,
Index: linux-2.6/security/selinux/hooks.c
===================================================================
--- linux-2.6.orig/security/selinux/hooks.c	2008-05-29 12:46:20.000000000 +0200
+++ linux-2.6/security/selinux/hooks.c	2008-05-29 12:46:25.000000000 +0200
@@ -1736,40 +1736,15 @@ static int selinux_capable(struct task_s
 
 static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
 {
-	int buflen, rc;
-	char *buffer, *path, *end;
+	char *buffer, *path;
+	int rc = -ENOMEM;
 
-	rc = -ENOMEM;
 	buffer = (char *)__get_free_page(GFP_KERNEL);
 	if (!buffer)
 		goto out;
-
-	buflen = PAGE_SIZE;
-	end = buffer+buflen;
-	*--end = '\0';
-	buflen--;
-	path = end-1;
-	*path = '/';
-	while (table) {
-		const char *name = table->procname;
-		size_t namelen = strlen(name);
-		buflen -= namelen + 1;
-		if (buflen < 0)
-			goto out_free;
-		end -= namelen;
-		memcpy(end, name, namelen);
-		*--end = '/';
-		path = end;
-		table = table->parent;
-	}
-	buflen -= 4;
-	if (buflen < 0)
-		goto out_free;
-	end -= 4;
-	memcpy(end, "/sys", 4);
-	path = end;
-	rc = security_genfs_sid("proc", path, tclass, sid);
-out_free:
+	path = sysctl_pathname(table, buffer, PAGE_SIZE);
+	if (path)
+		rc = security_genfs_sid("proc", path, tclass, sid);
 	free_page((unsigned long)buffer);
 out:
 	return rc;

--

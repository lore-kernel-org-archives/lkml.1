Return-Path: <linux-kernel-owner+w=401wt.eu-S1761755AbXFZXWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755AbXFZXWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760170AbXFZXMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:12:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:43034 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760175AbXFZXMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:12:18 -0400
Message-Id: <20070626231132.703797254@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:30 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 34/44] Factor out sysctl pathname code
Content-Disposition: inline; filename=sysctl-pathname.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the selinux sysctl pathname computation code into a standalone
function.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 include/linux/sysctl.h   |    2 ++
 kernel/sysctl.c          |   27 +++++++++++++++++++++++++++
 security/selinux/hooks.c |   35 +++++------------------------------
 3 files changed, 34 insertions(+), 30 deletions(-)

--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -963,6 +963,8 @@ extern int proc_doulongvec_minmax(ctl_ta
 extern int proc_doulongvec_ms_jiffies_minmax(ctl_table *table, int,
 				      struct file *, void __user *, size_t *, loff_t *);
 
+extern char *sysctl_pathname(ctl_table *, char *, int);
+
 extern int do_sysctl (int __user *name, int nlen,
 		      void __user *oldval, size_t __user *oldlenp,
 		      void __user *newval, size_t newlen);
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1110,6 +1110,33 @@ struct ctl_table_header *sysctl_head_nex
 	return NULL;
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
 int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
 	       void __user *newval, size_t newlen)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1427,40 +1427,15 @@ static int selinux_capable(struct task_s
 
 static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
 {
-	int buflen, rc;
-	char *buffer, *path, *end;
+	char *buffer, *path;
+	int rc = -ENOMEM;
 
-	rc = -ENOMEM;
 	buffer = (char*)__get_free_page(GFP_KERNEL);
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

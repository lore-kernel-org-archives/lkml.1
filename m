Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbZHGSyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbZHGSyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZHGSyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:54:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39011 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbZHGSyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:54:04 -0400
Subject: [PATCH] security: define round_hint_to_min in !CONFIG_SECURITY
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org
Content-Type: text/plain
Date: Fri, 07 Aug 2009 14:53:57 -0400
Message-Id: <1249671237.2694.11.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the header files to define round_hint_to_min() and to define
mmap_min_addr_handler() in the !CONFIG_SECURITY case.

Built and tested with !CONFIG_SECURITY

Signed-off-by: Eric Paris <eparis@redhat.com>

---

diff --git a/include/linux/security.h b/include/linux/security.h
index 7b43115..57ead99 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -121,6 +121,21 @@ struct request_sock;
 #define LSM_UNSAFE_PTRACE	2
 #define LSM_UNSAFE_PTRACE_CAP	4
 
+/*
+ * If a hint addr is less than mmap_min_addr change hint to be as
+ * low as possible but still greater than mmap_min_addr
+ */
+static inline unsigned long round_hint_to_min(unsigned long hint)
+{
+	hint &= PAGE_MASK;
+	if (((void *)hint != NULL) &&
+	    (hint < mmap_min_addr))
+		return PAGE_ALIGN(mmap_min_addr);
+	return hint;
+}
+extern int mmap_min_addr_handler(struct ctl_table *table, int write, struct file *filp,
+				 void __user *buffer, size_t *lenp, loff_t *ppos);
+
 #ifdef CONFIG_SECURITY
 
 struct security_mnt_opts {
@@ -149,21 +164,6 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
 	opts->num_mnt_opts = 0;
 }
 
-/*
- * If a hint addr is less than mmap_min_addr change hint to be as
- * low as possible but still greater than mmap_min_addr
- */
-static inline unsigned long round_hint_to_min(unsigned long hint)
-{
-	hint &= PAGE_MASK;
-	if (((void *)hint != NULL) &&
-	    (hint < mmap_min_addr))
-		return PAGE_ALIGN(mmap_min_addr);
-	return hint;
-}
-
-extern int mmap_min_addr_handler(struct ctl_table *table, int write, struct file *filp,
-				 void __user *buffer, size_t *lenp, loff_t *ppos);
 /**
  * struct security_operations - main security structure
  *



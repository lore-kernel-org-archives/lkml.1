Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZIMCzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZIMCzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 22:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZIMCzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 22:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbZIMCzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 22:55:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/3] Creds: creds->security can be NULL is selinux is disabled
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Cc: sds@tycho.nsa.gov, jmorris@namei.org, mingo@elte.hu, dhowells@redhat.com
Date: Sat, 12 Sep 2009 22:54:10 -0400
Message-ID: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__validate_process_creds should check if selinux is actually enabled before
running tests on the selinux portion of the credentials struct.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/cred.h       |   13 ++++++++-----
 include/linux/selinux.h    |    9 +++++++++
 security/selinux/exports.c |    6 ++++++
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 24520a5..fb37160 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -15,6 +15,7 @@
 #include <linux/capability.h>
 #include <linux/init.h>
 #include <linux/key.h>
+#include <linux/selinux.h>
 #include <asm/atomic.h>
 
 struct user_struct;
@@ -182,11 +183,13 @@ static inline bool creds_are_invalid(const struct cred *cred)
 	if (atomic_read(&cred->usage) < atomic_read(&cred->subscribers))
 		return true;
 #ifdef CONFIG_SECURITY_SELINUX
-	if ((unsigned long) cred->security < PAGE_SIZE)
-		return true;
-	if ((*(u32*)cred->security & 0xffffff00) ==
-	    (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8))
-		return true;
+	if (selinux_is_enabled()) {
+		if ((unsigned long) cred->security < PAGE_SIZE)
+			return true;
+		if ((*(u32 *)cred->security & 0xffffff00) ==
+		    (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8))
+			return true;
+	}
 #endif
 	return false;
 }
diff --git a/include/linux/selinux.h b/include/linux/selinux.h
index 20f965d..223d06a 100644
--- a/include/linux/selinux.h
+++ b/include/linux/selinux.h
@@ -61,6 +61,11 @@ void selinux_secmark_refcount_inc(void);
  *     existing SECMARK targets has been removed/flushed.
  */
 void selinux_secmark_refcount_dec(void);
+
+/**
+ * selinux_is_enabled - is SELinux enabled?
+ */
+bool selinux_is_enabled(void);
 #else
 
 static inline int selinux_string_to_sid(const char *str, u32 *sid)
@@ -84,6 +89,10 @@ static inline void selinux_secmark_refcount_dec(void)
 	return;
 }
 
+static bool selinux_is_enabled(void)
+{
+	return false;
+}
 #endif	/* CONFIG_SECURITY_SELINUX */
 
 #endif /* _LINUX_SELINUX_H */
diff --git a/security/selinux/exports.c b/security/selinux/exports.c
index c73aeaa..c0a454a 100644
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -63,3 +63,9 @@ void selinux_secmark_refcount_dec(void)
 	atomic_dec(&selinux_secmark_refcount);
 }
 EXPORT_SYMBOL_GPL(selinux_secmark_refcount_dec);
+
+bool selinux_is_enabled(void)
+{
+	return selinux_enabled;
+}
+EXPORT_SYMBOL_GPL(selinux_is_enabled);


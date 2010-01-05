Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709Ab0AEWQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0AEWQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601Ab0AEWQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:16:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:53652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab0AEWQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:16:14 -0500
Date: Tue, 5 Jan 2010 22:15:43 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, heiko.carstens@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
References: <20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: copy_from_user() should not return -EFAULT
Message-ID: <tip-409d02ef6d74f5e91f5ea4c587b2ee1375f106fc@git.kernel.org>
Git-Commit-ID: 409d02ef6d74f5e91f5ea4c587b2ee1375f106fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  409d02ef6d74f5e91f5ea4c587b2ee1375f106fc
Gitweb:     http://git.kernel.org/tip/409d02ef6d74f5e91f5ea4c587b2ee1375f106fc
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Tue, 5 Jan 2010 14:19:11 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 5 Jan 2010 13:45:06 -0800

x86: copy_from_user() should not return -EFAULT

Callers of copy_from_user() expect it to return the number of bytes
it could not copy. In no case it is supposed to return -EFAULT.

In case of a detected buffer overflow just return the requested
length. In addition one could think of a memset that would clear
the size of the target object.

[ hpa: code is not in .32 so not needed for -stable ]

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uaccess_32.h |    5 ++---
 arch/x86/include/asm/uaccess_64.h |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 0c9825e..088d09f 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -205,14 +205,13 @@ static inline unsigned long __must_check copy_from_user(void *to,
 					  unsigned long n)
 {
 	int sz = __compiletime_object_size(to);
-	int ret = -EFAULT;
 
 	if (likely(sz == -1 || sz >= n))
-		ret = _copy_from_user(to, from, n);
+		n = _copy_from_user(to, from, n);
 	else
 		copy_from_user_overflow();
 
-	return ret;
+	return n;
 }
 
 long __must_check strncpy_from_user(char *dst, const char __user *src,
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 46324c6..535e421 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -30,16 +30,15 @@ static inline unsigned long __must_check copy_from_user(void *to,
 					  unsigned long n)
 {
 	int sz = __compiletime_object_size(to);
-	int ret = -EFAULT;
 
 	might_fault();
 	if (likely(sz == -1 || sz >= n))
-		ret = _copy_from_user(to, from, n);
+		n = _copy_from_user(to, from, n);
 #ifdef CONFIG_DEBUG_VM
 	else
 		WARN(1, "Buffer overflow detected!\n");
 #endif
-	return ret;
+	return n;
 }
 
 static __always_inline __must_check

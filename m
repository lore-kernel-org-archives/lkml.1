Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZJAKAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZJAKAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZJAKAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:00:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:55883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116AbZJAKA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:00:26 -0400
Date: Thu, 1 Oct 2009 09:59:26 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org, arjan@linux.intel.com,
       davem@davemloft.net, arjan@infradead.org, jbeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       torvalds@linux-foundation.org, davem@davemloft.net, arjan@infradead.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090930130523.348ae6c4@infradead.org>
References: <20090930130523.348ae6c4@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Turn the copy_from_user check into an (optional) compile time warning
Message-ID: <tip-4a3127693001c61a21d1ce680db6340623f52e93@git.kernel.org>
Git-Commit-ID: 4a3127693001c61a21d1ce680db6340623f52e93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 09:59:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a3127693001c61a21d1ce680db6340623f52e93
Gitweb:     http://git.kernel.org/tip/4a3127693001c61a21d1ce680db6340623f52e93
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Wed, 30 Sep 2009 13:05:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Oct 2009 11:31:04 +0200

x86: Turn the copy_from_user check into an (optional) compile time warning

A previous patch added the buffer size check to copy_from_user().

One of the things learned from analyzing the result of the previous
patch is that in general, gcc is really good at proving that the
code contains sufficient security checks to not need to do a
runtime check. But that for those cases where gcc could not prove
this, there was a relatively high percentage of real security
issues.

This patch turns the case of "gcc cannot prove" into a compile time
warning, as long as a sufficiently new gcc is in use that supports
this. The objective is that these warnings will trigger developers
checking new cases out before a security hole enters a linux kernel
release.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <20090930130523.348ae6c4@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uaccess_32.h |   12 +++++++++---
 arch/x86/lib/usercopy_32.c        |    6 ++++++
 include/linux/compiler-gcc4.h     |    3 +++
 include/linux/compiler.h          |    4 ++++
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 582d6ae..952f9e7 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -191,6 +191,13 @@ unsigned long __must_check _copy_from_user(void *to,
 					  const void __user *from,
 					  unsigned long n);
 
+
+extern void copy_from_user_overflow(void)
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	__compiletime_warning("copy_from_user() buffer size is not provably correct")
+#endif
+;
+
 static inline unsigned long __must_check copy_from_user(void *to,
 					  const void __user *from,
 					  unsigned long n)
@@ -200,10 +207,9 @@ static inline unsigned long __must_check copy_from_user(void *to,
 
 	if (likely(sz == -1 || sz >= n))
 		ret = _copy_from_user(to, from, n);
-#ifdef CONFIG_DEBUG_VM
 	else
-		WARN(1, "Buffer overflow detected!\n");
-#endif
+		copy_from_user_overflow();
+
 	return ret;
 }
 
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 8498684..e218d5d 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -883,3 +883,9 @@ _copy_from_user(void *to, const void __user *from, unsigned long n)
 	return n;
 }
 EXPORT_SYMBOL(_copy_from_user);
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index a3aef5d..f1709c1 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -39,3 +39,6 @@
 #endif
 
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#if __GNUC_MINOR__ >= 4
+#define __compiletime_warning(message) __attribute__((warning(message)))
+#endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 8e54108..9503563 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -270,6 +270,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #ifndef __compiletime_object_size
 # define __compiletime_object_size(obj) -1
 #endif
+#ifndef __compiletime_warning
+# define __compiletime_warning(message)
+#endif
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),

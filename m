Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab0BZFNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:13:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:51458 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab0BZFNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:13:00 -0500
Date: Fri, 26 Feb 2010 05:12:36 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267005265-27958-2-git-send-email-luca@luca-barbieri.com>
References: <1267005265-27958-2-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] x86: Add support for lock prefix in alternatives
Message-ID: <tip-b3ac891b67bd4b1fc728d1c784cad1212dea433d@git.kernel.org>
Git-Commit-ID: b3ac891b67bd4b1fc728d1c784cad1212dea433d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 05:12:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3ac891b67bd4b1fc728d1c784cad1212dea433d
Gitweb:     http://git.kernel.org/tip/b3ac891b67bd4b1fc728d1c784cad1212dea433d
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Wed, 24 Feb 2010 10:54:22 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 25 Feb 2010 20:46:23 -0800

x86: Add support for lock prefix in alternatives

The current lock prefix UP/SMP alternative code doesn't allow
LOCK_PREFIX to be used in alternatives code.

This patch solves the problem by adding a new LOCK_PREFIX_ALTERNATIVE_PATCH
macro that only records the lock prefix location but does not emit
the prefix.

The user of this macro can then start any alternative sequence with
"lock" and have it UP/SMP patched.

To make this work, the UP/SMP alternative code is changed to do the
lock/DS prefix switching only if the byte actually contains a lock or
DS prefix.

Thus, if an alternative without the "lock" is selected, it will now do
nothing instead of clobbering the code.

Changes in v2:
- Naming change
- Change label to not conflict with alternatives

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267005265-27958-2-git-send-email-luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/alternative.h |    8 +++++---
 arch/x86/kernel/alternative.c      |    6 ++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 3b5b828..55fee12 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -28,12 +28,14 @@
  */
 
 #ifdef CONFIG_SMP
-#define LOCK_PREFIX \
+#define LOCK_PREFIX_HERE \
 		".section .smp_locks,\"a\"\n"	\
 		_ASM_ALIGN "\n"			\
-		_ASM_PTR "661f\n" /* address */	\
+		_ASM_PTR "671f\n" /* address */	\
 		".previous\n"			\
-		"661:\n\tlock; "
+		"671:"
+
+#define LOCK_PREFIX LOCK_PREFIX_HERE "\n\tlock; "
 
 #else /* ! CONFIG_SMP */
 #define LOCK_PREFIX ""
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2589ea4..80b222e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -244,7 +244,8 @@ static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 		if (*ptr > text_end)
 			continue;
 		/* turn DS segment override prefix into lock prefix */
-		text_poke(*ptr, ((unsigned char []){0xf0}), 1);
+		if (**ptr == 0x3e)
+			text_poke(*ptr, ((unsigned char []){0xf0}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
@@ -263,7 +264,8 @@ static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end
 		if (*ptr > text_end)
 			continue;
 		/* turn lock prefix into DS segment override prefix */
-		text_poke(*ptr, ((unsigned char []){0x3E}), 1);
+		if (**ptr == 0xf0)
+			text_poke(*ptr, ((unsigned char []){0x3E}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }

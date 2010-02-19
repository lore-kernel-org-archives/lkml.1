Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0BSRdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:33:40 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:41923 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab0BSRdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:33:38 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Feb 2010 12:33:37 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=tNQfItnhzIpZsIxdfGlEp8nIYhqH4A9XSFMqyz8Ksmyf3FW8dq1lWM2lYPi/baDVlO
         rq6XrJ3qZYex1XCd12doPouA5YXANBN5RoobxzL84a+0Z2iNGk9uyEfyEcyt3EWHhXgD
         FAd3l83/9xMAqYuO5TB7DfUfAW4nqOcvj+yR4=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 2/5] x86: add support for lock prefix in alternatives (v2)
Date: Fri, 19 Feb 2010 18:26:41 +0100
Message-Id: <1266600404-16402-3-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
- Naming change
- Change label to not conflict with alternatives

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

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/include/asm/alternative.h |    8 +++++---
 arch/x86/kernel/alternative.c      |    6 ++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 77f78e2..2ed9784 100644
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
index 77eba91..57a672c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -258,7 +258,8 @@ static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 		if (*ptr > text_end)
 			continue;
 		/* turn DS segment override prefix into lock prefix */
-		text_poke(*ptr, ((unsigned char []){0xf0}), 1);
+		if (**ptr == 0x3e)
+			text_poke(*ptr, ((unsigned char []){0xf0}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
@@ -277,7 +278,8 @@ static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end
 		if (*ptr > text_end)
 			continue;
 		/* turn lock prefix into DS segment override prefix */
-		text_poke(*ptr, ((unsigned char []){0x3E}), 1);
+		if (**ptr == 0xf0)
+			text_poke(*ptr, ((unsigned char []){0x3E}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
-- 
1.6.6.1.476.g01ddb


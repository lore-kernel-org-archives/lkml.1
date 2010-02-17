Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0BQLpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:45:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:29272 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab0BQLm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:42:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=RReumUXii6T9LxdZegjjWy8Cc2/pYHoj0PFDSyaL5areUa+hx3CzY0bnni0mP+R8O5
         whORRzaZo8WZJFD52Wlx0W44YXIspGJpfyQaXOKzuCbaapvNtiNSf6IM8zKYcbrN3dDk
         p+lvI3OGhAcDqfaVLkJ5TASpH1QbSc2nEfyXs=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 03/10] x86: add support for lock prefix in alternatives
Date: Wed, 17 Feb 2010 12:42:35 +0100
Message-Id: <1266406962-17463-4-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/x86/include/asm/alternative.h |    6 ++++--
 arch/x86/kernel/alternative.c      |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 42d41ac..b31af51 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -28,12 +28,14 @@
  */
 
 #ifdef CONFIG_SMP
-#define LOCK_PREFIX \
+#define LOCK_PREFIX_ALTERNATIVE_PATCH \
 		".section .smp_locks,\"a\"\n"	\
 		_ASM_ALIGN "\n"			\
 		_ASM_PTR "661f\n" /* address */	\
 		".previous\n"			\
-		"661:\n\tlock; "
+		"661:"
+
+#define LOCK_PREFIX LOCK_PREFIX_ALTERNATIVE_PATCH "\n\tlock; "
 
 #else /* ! CONFIG_SMP */
 #define LOCK_PREFIX ""
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7464c7e..b4ff6cb 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -264,7 +264,8 @@ static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 		if (*ptr > text_end)
 			continue;
 		/* turn DS segment override prefix into lock prefix */
-		text_poke(*ptr, ((unsigned char []){0xf0}), 1);
+		if (**ptr == 0x3e)
+			text_poke(*ptr, ((unsigned char []){0xf0}), 1);
 	};
 	mutex_unlock(&text_mutex);
 }
@@ -283,7 +284,8 @@ static void alternatives_smp_unlock(u8 **start, u8 **end, u8 *text, u8 *text_end
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab0BEOhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:37:54 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:49631 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab0BEOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:37:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XxFb8vln8YQJwIrJMYr65xYyKA4TPKhWAV0kXn30RXdiCad51rfMZ8yhwBGtpyc/4g
         fgJH0fYnIKqjIbsJZyca7r0Qv3CPiC2B0iArLCHv0/nB/h0uYI7ZRbRf9AwoUtDRhIdr
         xrjyKrwaIZYEwjDj6eDlGs3zgDiw4Ffj9bH68=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] x86: Simplify flush_write_buffers()
Date: Fri,  5 Feb 2010 09:37:08 -0500
Message-Id: <1265380629-3212-7-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always make it an inline instead of using a macro for the no-op case.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/io_32.h |   10 ++--------
 arch/x86/include/asm/io_64.h |    8 +++++++-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/io_32.h b/arch/x86/include/asm/io_32.h
index 685e332..e8177f3 100644
--- a/arch/x86/include/asm/io_32.h
+++ b/arch/x86/include/asm/io_32.h
@@ -84,18 +84,12 @@ memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
  *	2. Accidentally out of order processors (PPro errata #51)
  */
 
-#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
-
 static inline void flush_write_buffers(void)
 {
+#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
 	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
-}
-
-#else
-
-#define flush_write_buffers() do { } while (0)
-
 #endif
+}
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/include/asm/io_64.h b/arch/x86/include/asm/io_64.h
index 1305525..6964a1c 100644
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -83,7 +83,13 @@ memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
  *	1. Out of order aware processors
  *	2. Accidentally out of order processors (PPro errata #51)
  */
-#define flush_write_buffers() do { } while (0)
+
+static inline void flush_write_buffers(void)
+{
+#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
+	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
+#endif
+}
 
 #endif /* __KERNEL__ */
 
-- 
1.6.6


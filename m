Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0CIRTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:19:32 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43931 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab0CIRT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:19:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=uws2FXVvp60uh7KSEz2R5A8Q8PLpEBI38zyYfcrAYMP/nFb5otPiFBhN3XFPfwxUE5
         S+2fQ8gWZ1ePN9JBq2wJ8yU2HArwUqw+tg4ec5nFMPm8GuFBoL2s+3g6fxkOaJaxw+Yf
         K4NPDVIzS14AUh4r60Ln2VUK4W+hvSRHpnPUM=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Greg KH <gregkh@suse.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 1/3] Loongson-2F: Flush the branch target history such as BTB and RAS
Date: Wed, 10 Mar 2010 01:12:31 +0800
Message-Id: <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1268153722.git.wuzhangjin@gmail.com>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1268153722.git.wuzhangjin@gmail.com>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

As the Chapter 15: "Errata: Issue of Out-of-order in loongson"[1] shows, to
workaround the Issue of Loongson-2F，We need to do:

"When switching from user model to kernel model, you should flush the branch
target history such as BTB and RAS."

This patch did clear BTB(branch target buffer), forbid RAS(row address strobe)
via Loongson-2F's 64bit diagnostic register.

[1] Chinese Version: http://www.loongson.cn/uploadfile/file/200808211
[2] English Version of Chapter 15:
http://groups.google.com.hk/group/loongson-dev/msg/e0d2e220958f10a6?dmode=source

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/include/asm/stackframe.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/stackframe.h b/arch/mips/include/asm/stackframe.h
index 3b6da33..b84cfda 100644
--- a/arch/mips/include/asm/stackframe.h
+++ b/arch/mips/include/asm/stackframe.h
@@ -121,6 +121,25 @@
 		.endm
 #else
 		.macro	get_saved_sp	/* Uniprocessor variation */
+#ifdef CONFIG_CPU_LOONGSON2F
+		/*
+		 * Clear BTB(branch target buffer), forbid RAS(row address
+		 * strobe) to workaround the Out-of-oder Issue in Loongson2F
+		 * via it's diagnostic register.
+		 */
+		move k0, ra
+		jal	1f
+		nop
+1:		jal	1f
+		nop
+1:		jal	1f
+		nop
+1:		jal	1f
+		nop
+1:		move	ra, k0
+		li	k0, 3
+		mtc0	k0, $22
+#endif /* CONFIG_CPU_LOONGSON2F */
 #if defined(CONFIG_32BIT) || defined(KBUILD_64BIT_SYM32)
 		lui	k1, %hi(kernelsp)
 #else
-- 
1.7.0.1


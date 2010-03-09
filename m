Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0CIRTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:19:45 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43931 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab0CIRTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:19:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LZKJXvmYl3FiyJQRohIaxVfgAXVqnoYZJ1Cvf/Gn37ztET6qiu1BTeAovX4N2ImM6t
         nM7/HCgL4JAJFscHkeaUQJMbpNZ+xv9NSS9IZAB59CqZLhw0q1IuCfRe9cWHQQl2pWQm
         vv2O6aWM2F/ywWlbrsqLpSqfiFOa8/4kgmqn0=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Greg KH <gregkh@suse.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 3/3] Loongson-2F: Fixup of problems introduced by -mfix-loongson2f-jump of binutils 2.20.1
Date: Wed, 10 Mar 2010 01:12:33 +0800
Message-Id: <1f3b69fc1a72f55f736c13307c2e7e03b07eb2d1.1268153722.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1268153722.git.wuzhangjin@gmail.com>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1268153722.git.wuzhangjin@gmail.com>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

The -mfix-loongson2f-jump option provided by the binutils 2.20.1 have fixed the
Out-of-order Issue of Loongson-2F described in Chapter 15 of "Loongson2F User
Manual"[1,2], but introduced some problems.

The option changes all of the jumping target to "addr & 0xcfffffff" through the
at($1) register, but for the REBOOT address of loongson-2F: 0xbfc00000, this is
totally wrong, so, this patch try to avoid the problem via telling the
assembler not to use at($1) register.

[1] Loongson2F User Manual(Chinese Version)
http://www.loongson.cn/uploadfile/file/200808211
[2] English Version of Chapter 15:
http://groups.google.com.hk/group/loongson-dev/msg/e0d2e220958f10a6?dmode=source

Reported-and-tested-by: Liu Shiwei <liushiwei@gmail.com>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/loongson/common/reset.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/mips/loongson/common/reset.c b/arch/mips/loongson/common/reset.c
index 4bd9c18..d5f1a50 100644
--- a/arch/mips/loongson/common/reset.c
+++ b/arch/mips/loongson/common/reset.c
@@ -21,8 +21,18 @@ static void loongson_restart(char *command)
 	/* do preparation for reboot */
 	mach_prepare_reboot();
 
-	/* reboot via jumping to boot base address */
+	/* reboot via jumping to boot base address
+	 *
+	 * ".set noat" and ".set at" are used to ensure the address not broken
+	 * by the -mfix-loongson2f-jump option provided by binutils 2.20.1 and
+	 * higher which try to change the jumping address to "addr &
+	 * 0xcfffffff" via the at($1) register, this is totally wrong for
+	 * 0xbfc00000(LOONGSON_BOOT_BASE).
+	 */
+
+	__asm__ __volatile__(".set noat\n");
 	((void (*)(void))ioremap_nocache(LOONGSON_BOOT_BASE, 4)) ();
+	__asm__ __volatile__(".set at\n");
 }
 
 static void loongson_poweroff(void)
-- 
1.7.0.1


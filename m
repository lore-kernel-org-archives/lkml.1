Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbZFEIY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbZFEIY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZFEIHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37509 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbZFEIGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 57/62] Blackfin: push access_ok() L1 attribute down
Date: Fri,  5 Jun 2009 04:05:06 -0400
Message-Id: <1244189111-19639-58-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for the L1 attribute to be on the prototype of the
access_ok() function as all consumers of the function do not care where it
lives -- they'll always use pcrel calls to get to it.  This prevents
pointless recompiles of most of the system when this config option changes.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/uaccess.h |    4 ----
 arch/blackfin/kernel/process.c      |    3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/include/asm/uaccess.h b/arch/blackfin/include/asm/uaccess.h
index 01f42b0..8894e9f 100644
--- a/arch/blackfin/include/asm/uaccess.h
+++ b/arch/blackfin/include/asm/uaccess.h
@@ -59,12 +59,8 @@ static inline int is_in_rom(unsigned long addr)
 #ifndef CONFIG_ACCESS_CHECK
 static inline int _access_ok(unsigned long addr, unsigned long size) { return 1; }
 #else
-#ifdef CONFIG_ACCESS_OK_L1
-extern int _access_ok(unsigned long addr, unsigned long size)__attribute__((l1_text));
-#else
 extern int _access_ok(unsigned long addr, unsigned long size);
 #endif
-#endif
 
 /*
  * The exception table consists of pairs of addresses: the first is the
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index e040e03..30d0843 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -322,6 +322,9 @@ void finish_atomic_sections (struct pt_regs *regs)
 }
 
 #if defined(CONFIG_ACCESS_CHECK)
+#ifdef CONFIG_ACCESS_OK_L1
+__attribute__((l1_text))
+#endif
 /* Return 1 if access to memory range is OK, 0 otherwise */
 int _access_ok(unsigned long addr, unsigned long size)
 {
-- 
1.6.3.1


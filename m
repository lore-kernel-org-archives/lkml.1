Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYHRHGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYHRHGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYHRHGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:06:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43090 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYHRHGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:06:05 -0400
From: "Andi Kleen" <andi@firstfloor.org>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Paul Jackson <pj@sgi.com>, mingo@elte.hu, hpa@zytor.com
Subject: [PATCH] Fix new warnings in real mode code
Date: Mon, 18 Aug 2008 09:06:01 +0200
Message-Id: <1219043161-19712-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This recent patch

commit c3965bd15118742d72b4bc1a290d37b3f081eb98
Author: Paul Jackson <pj@sgi.com>
Date:   Wed May 14 08:15:34 2008 -0700

    x86 boot: proper use of ARRAY_SIZE instead of repeated E820MAX constant

caused these new warnings during a normal build:

In file included from linux-2.6/arch/x86/boot/memory.c:17:
linux-2.6/include/linux/log2.h: In function '__ilog2_u32':
linux-2.6/include/linux/log2.h:34: warning: implicit declaration of function 'fls'
linux-2.6/include/linux/log2.h: In function '__ilog2_u64':
linux-2.6/include/linux/log2.h:42: warning: implicit declaration of function 'fls64'
linux-2.6/include/linux/log2.h: In function '__roundup_pow_of_two ':
linux-2.6/include/linux/log2.h:63: warning: implicit declaration of function 'fls_long'

I tried to fix them in log2.h, but it's difficult because the real mode
environment is completely different from a normal kernel environment. Instead
define an own ARRAY_SIZE macro in boot.h, similar to the other private
macros there.

Cc: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu
Cc: hpa@zytor.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/boot/boot.h   |    2 ++
 arch/x86/boot/memory.c |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 616b804..cc0ef13 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -30,6 +30,8 @@
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
+
 extern struct setup_header hdr;
 extern struct boot_params boot_params;
 
diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index 53165c9..8c3c25f 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -13,7 +13,6 @@
  */
 
 #include "boot.h"
-#include <linux/kernel.h>
 
 #define SMAP	0x534d4150	/* ASCII "SMAP" */
 
-- 
1.5.6


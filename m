Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYHLVYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYHLVYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYHLVYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:24:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:46149 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYHLVYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hQ2hVSSZFWeI9URH2mtGZcCxPv8XcuPB0GXFeyERDv3NTSLY6/vlZmPz8lHSCYBSjw
         SBLAvBkF3FdNqaYYNd8AsCWAZLMNwdTUbo0kgOjZjVkYDw34eBTf1OdKrXFsy+f72vFW
         iWOL6shuTQnHRwTQBAcGlLajVa67qxyNB58kk=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: fix 2 section mismatch warnings - find_and_reserve_crashkernel
Date: Tue, 12 Aug 2008 23:23:05 +0200
Message-Id: <1218576186-31442-3-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0xcd1f): Section mismatch in reference from the function find_and_reserve_crashkernel() to the function .init.text:find_e820_area()
The function find_and_reserve_crashkernel() references
the function __init find_e820_area().
This is often because find_and_reserve_crashkernel lacks a __init
annotation or the annotation of find_e820_area is wrong.

WARNING: vmlinux.o(.text+0xcd38): Section mismatch in reference from the function find_and_reserve_crashkernel() to the function .init.text:reserve_bootmem_generic()
The function find_and_reserve_crashkernel() references
the function __init reserve_bootmem_generic().
This is often because find_and_reserve_crashkernel lacks a __init
annotation or the annotation of reserve_bootmem_generic is wrong.

find_and_reserve_crashkernel is called from __init function (reserve_crashkernel)
and calls 2 __init functions (find_e820_area, reserve_bootmem_generic),
so mark it __init

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 68b48e3..a4656ad 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -445,7 +445,7 @@ static void __init reserve_early_setup_data(void)
  * @size: Size of the crashkernel memory to reserve.
  * Returns the base address on success, and -1ULL on failure.
  */
-unsigned long long find_and_reserve_crashkernel(unsigned long long size)
+unsigned long long __init find_and_reserve_crashkernel(unsigned long long size)
 {
 	const unsigned long long alignment = 16<<20; 	/* 16M */
 	unsigned long long start = 0LL;
-- 
1.5.4.5


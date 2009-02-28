Return-Path: <linux-kernel-owner+w=401wt.eu-S1763286AbZB1Bzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763286AbZB1Bzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762939AbZB1Bvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:51:32 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:45542
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762945AbZB1Bv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:51:27 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86: leave _brk_end defined
Date: Fri, 27 Feb 2009 17:51:22 -0800
Message-Id: <1235785882-17580-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235785882-17580-1-git-send-email-jeremy@goop.org>
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

highmap_end_pfn refers to _brk_end, so leave it as normal data with a
meaningful value.  Make extend_brk() check for a NULL _brk_start to
look for uses after the brk memory has been reserved and locked down.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/setup.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1d4fe19..11c4198 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -116,7 +116,7 @@ unsigned int boot_cpu_id __read_mostly;
 
 extern char __brk_base[];
 __initdata unsigned long _brk_start = (unsigned long)__brk_base;
-__initdata unsigned long _brk_end = (unsigned long)&__brk_base;
+unsigned long _brk_end = (unsigned long)&__brk_base;
 
 #ifdef CONFIG_X86_64
 int default_cpu_present_to_apicid(int mps_cpu)
@@ -337,6 +337,7 @@ void * __init extend_brk(size_t size, size_t align)
 	size_t mask = align - 1;
 	void *ret;
 
+	BUG_ON(_brk_start == 0);
 	BUG_ON(align & mask);
 
 	_brk_end = (_brk_end + mask) & ~mask;
@@ -352,7 +353,7 @@ static void __init reserve_brk(void)
 	if (_brk_end > _brk_start)
 		reserve_early(__pa(_brk_start), __pa(_brk_end), "BRK");
 
-	_brk_end = _brk_start = 0xdeadb00c + POISON_POINTER_DELTA;
+	_brk_start = 0;
 }
 
 static void __init reserve_initrd(void)
-- 
1.6.0.6


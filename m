Return-Path: <linux-kernel-owner+w=401wt.eu-S1761039AbYDZXjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039AbYDZXjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYDZXjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:39:46 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50408 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbYDZXjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:39:46 -0400
Date: Sun, 27 Apr 2008 00:39:36 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: vget_cycles() __always_inline
Message-ID: <Pine.LNX.4.64.0804270035200.30877@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark vget_cycles() as __always_inline, so gcc is never tempted to make
the vsyscall vread_tsc() dive into kernel text, with resulting SIGSEGV.

This was a self-inflicted wound: I've not seen that happen with unhacked
sources; but for debug reasons I'd changed my x86/Makefile to compile
no-unit-at-a-time, and that in conjunction with OPTIMIZE_INLINING=y
ended up with vget_cycles() in kernel text.  Perhaps it can happen
in other ways: safer to use __always_inline.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 include/asm-x86/tsc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.25-mm1/include/asm-x86/tsc.h	2008-04-18 12:18:34.000000000 +0100
+++ linux/include/asm-x86/tsc.h	2008-04-24 19:12:32.000000000 +0100
@@ -32,7 +32,7 @@ static inline cycles_t get_cycles(void)
 	return ret;
 }
 
-static inline cycles_t vget_cycles(void)
+static __always_inline cycles_t vget_cycles(void)
 {
 	/*
 	 * We only do VDSOs on TSC capable CPUs, so this shouldnt

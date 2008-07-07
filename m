Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYGGGbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYGGGbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYGGG3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:29:03 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56828 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbYGGG3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:29:01 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080707828.405203787@firstfloor.org>
In-Reply-To: <20080707828.405203787@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/9] MCE: Remove oops_begin() use in 64bit machine check
Message-Id: <20080707062840.B4C991B4315@basil.firstfloor.org>
Date: Mon,  7 Jul 2008 08:28:40 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 06:21:16.0953 (UTC) FILETIME=[A9D9C090:01C8DFF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First 32bit doesn't have oops_begin, so it's a barrier of using
this code on 32bit.

On closer examination it turns out oops_begin is not 
a good idea in a machine check panic anyways. All oops_begin
does it so check for recursive/parallel oopses and implement the
"wait on oops" heuristic. But there's actually no good reason
to lock machine checks against oopses or prevent them
from recursion. Also "wait on oops" does not really make
sense for a machine check too.

So just remove it.

Replace it with a manual bust_spinlocks/console_verbose.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -133,7 +133,8 @@ static void mce_panic(char *msg, struct 
 {
 	int i;
 
-	oops_begin();
+	bust_spinlocks(1);
+	console_verbose();
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		u64 tsc = mcelog.entry[i].tsc;
 

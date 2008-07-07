Return-Path: <linux-kernel-owner+w=401wt.eu-S1759616AbYGGXM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616AbYGGXM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbYGGXLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:11:14 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2565 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081AbYGGXLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:11:13 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080708110.487722491@firstfloor.org>
In-Reply-To: <20080708110.487722491@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/10] MCE: Remove oops_begin() use in 64bit machine check
Message-Id: <20080707231010.A4A811B4315@basil.firstfloor.org>
Date: Tue,  8 Jul 2008 01:10:10 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 23:02:46.0698 (UTC) FILETIME=[922130A0:01C8E085]
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
 

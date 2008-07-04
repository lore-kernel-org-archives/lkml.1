Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYGDVXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYGDVXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYGDVVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:21:35 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:52819 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYGDVVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:21:33 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200807041120.678642023@firstfloor.org>
In-Reply-To: <200807041120.678642023@firstfloor.org>
To: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/9] MCE: Remove oops_begin() use in 64bit machine check
Message-Id: <20080704212032.CF6421B431F@basil.firstfloor.org>
Date: Fri,  4 Jul 2008 23:20:32 +0200 (CEST)
X-OriginalArrivalTime: 04 Jul 2008 21:13:10.0267 (UTC) FILETIME=[C30834B0:01C8DE1A]
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
 

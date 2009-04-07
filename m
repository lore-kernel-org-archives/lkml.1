Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbZDGPMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbZDGPMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbZDGPHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48852 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758631AbZDGPHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:53 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [10/28] x86: MCE: Remove oops_begin() use in 64bit machine check
Message-Id: <20090407150751.841D91D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On closer examination it turns out oops_begin is not 
a good idea in a machine check panic. All oops_begin
does it so check for recursive/parallel oopses and implement the
"wait on oops" heuristic. But there's actually no good reason
to lock machine checks against oopses or prevent them
from recursion. Also "wait on oops" does not really make
sense for a machine check either.

So just remove it.

Replace it with a manual bust_spinlocks/console_verbose.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:13.000000000 +0200
@@ -151,7 +151,8 @@
 {
 	int i;
 
-	oops_begin();
+	bust_spinlocks(1);
+	console_verbose();
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		unsigned long tsc = mcelog.entry[i].tsc;
 

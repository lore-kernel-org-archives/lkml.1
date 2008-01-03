Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbYACAwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbYACAwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbYACAuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:09 -0500
Received: from mx1.suse.de ([195.135.220.2]:51770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbYACAuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:05 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [9/20] x86: Don't use oops_begin in 64bit mce code
Message-Id: <20080103005004.A171C14D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is not really useful to lock machine checks against oopses. And
machine checks normally don't nest, so they don't need their 
own locking. Just call bust_spinlock/console_verbose directly.

Signed-off-by: Andi Kleen <ak@suse.de>

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
+	console_verbose();
+	bust_spinlocks(1);
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		unsigned long tsc = mcelog.entry[i].tsc;
 

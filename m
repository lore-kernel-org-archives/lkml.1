Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbZEZXU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbZEZXU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbZEZXSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53164 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224AbZEZXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:31 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/17] x86: MCE: Remove oops_begin() use in 64bit machine check
Date: Wed, 27 May 2009 01:18:07 +0200
Message-Id: <e2d81decded3202e410a569f8c224986f2e83668.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
 <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
 <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

First 32bit doesn't have oops_begin, so it's a barrier of using
this code on 32bit.

On closer examination it turns out oops_begin is not
a good idea in a machine check panic anyways. All oops_begin
does it so check for recursive/parallel oopses and implement the
"wait on oops" heuristic. But there's actually no good reason
to lock machine checks against oopses or prevent them
from recursion. Also "wait on oops" does not really make
sense for a machine check too.

Replace it with a manual bust_spinlocks/console_verbose.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 60acee3..b9463b3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -178,7 +178,8 @@ static void mce_panic(char *msg, struct mce *backup, u64 start)
 {
 	int i;
 
-	oops_begin();
+	bust_spinlocks(1);
+	console_verbose();
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		u64 tsc = mcelog.entry[i].tsc;
 
-- 
1.6.0.2


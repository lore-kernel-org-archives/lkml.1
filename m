Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451Ab0AQSbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab0AQSbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214Ab0AQSbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:31:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:34337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab0AQSbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:31:47 -0500
Date: Sun, 17 Jan 2010 18:30:32 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, luca@luca-barbieri.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, luca@luca-barbieri.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1263634770-14578-1-git-send-email-luca@luca-barbieri.com>
References: <1263634770-14578-1-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] hw-breakpoints, perf: Fix broken mmiotrace due to dr6 by reference change
Message-ID: <tip-0bb7a95f5455cd87e6a69e5818bc1f509a98d187@git.kernel.org>
Git-Commit-ID: 0bb7a95f5455cd87e6a69e5818bc1f509a98d187
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 17 Jan 2010 18:30:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bb7a95f5455cd87e6a69e5818bc1f509a98d187
Gitweb:     http://git.kernel.org/tip/0bb7a95f5455cd87e6a69e5818bc1f509a98d187
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Sat, 16 Jan 2010 10:39:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 17 Jan 2010 08:01:44 +0100

hw-breakpoints, perf: Fix broken mmiotrace due to dr6 by reference change

Commit 62edab9056a6cf0c9207339c8892c923a5217e45 (from June 2009
but merged in 2.6.33) changes notify_die to pass dr6 by
reference.

However, it forgets to fix the check for DR_STEP in kmmio.c,
breaking mmiotrace. It also passes a wrong value to the post
handler.

This simple fix makes mmiotrace work again.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1263634770-14578-1-git-send-email-luca@luca-barbieri.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/kmmio.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index c0f6198..536fb68 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -538,14 +538,15 @@ static int
 kmmio_die_notifier(struct notifier_block *nb, unsigned long val, void *args)
 {
 	struct die_args *arg = args;
+	unsigned long* dr6_p = (unsigned long *)ERR_PTR(arg->err);
 
-	if (val == DIE_DEBUG && (arg->err & DR_STEP))
-		if (post_kmmio_handler(arg->err, arg->regs) == 1) {
+	if (val == DIE_DEBUG && (*dr6_p & DR_STEP))
+		if (post_kmmio_handler(*dr6_p, arg->regs) == 1) {
 			/*
 			 * Reset the BS bit in dr6 (pointed by args->err) to
 			 * denote completion of processing
 			 */
-			(*(unsigned long *)ERR_PTR(arg->err)) &= ~DR_STEP;
+			*dr6_p &= ~DR_STEP;
 			return NOTIFY_STOP;
 		}
 

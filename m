Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbZBRMFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbZBRMFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZBRMF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:05:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:50710 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbZBRMF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:05:27 -0500
From: Tejun Heo <tj@kernel.org>
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] module: fix out-of-range memory access
Date: Wed, 18 Feb 2009 21:04:28 +0900
Message-Id: <1234958676-27618-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234958676-27618-1-git-send-email-tj@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Feb 2009 12:04:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: subtle memory access bug fix

percpu_modalloc() may access pcpu_size[-1].  The access won't change
the value by itself but it still is read/write access and dangerous.
Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/module.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index ba22484..d54a63e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -426,12 +426,14 @@ static void *percpu_modalloc(unsigned long size, unsigned long align,
 			continue;
 
 		/* Transfer extra to previous block. */
-		if (pcpu_size[i-1] < 0)
-			pcpu_size[i-1] -= extra;
-		else
-			pcpu_size[i-1] += extra;
-		pcpu_size[i] -= extra;
-		ptr += extra;
+		if (extra) {
+			if (pcpu_size[i-1] < 0)
+				pcpu_size[i-1] -= extra;
+			else
+				pcpu_size[i-1] += extra;
+			pcpu_size[i] -= extra;
+			ptr += extra;
+		}
 
 		/* Split block if warranted */
 		if (pcpu_size[i] - size > sizeof(unsigned long))
-- 
1.6.0.2


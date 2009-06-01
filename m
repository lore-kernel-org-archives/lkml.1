Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbZFAGf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbZFAGf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 02:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZFAGfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 02:35:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:33048 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZFAGfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 02:35:15 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] x86: ensure percpu remap doesn't consume too much vmalloc space
Date: Mon,  1 Jun 2009 15:34:51 +0900
Message-Id: <1243838091-28591-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243838091-28591-1-git-send-email-tj@kernel.org>
References: <1243838091-28591-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 06:34:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On extreme configuration (e.g. 32bit 32-way NUMA machine), remap
percpu first chunk allocator can consume too much of vmalloc space.
Make it fall back to 4k allocator if the consumption goes over 20%.

[ Impact: add sanity check for remap percpu first chunk allocator ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 29be178..1f28574 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -169,9 +169,21 @@ static ssize_t __init setup_pcpu_remap(size_t static_size, bool chosen)
 		return -EINVAL;
 	}
 
-	/* on non-NUMA, embedding is better */
-	if (!chosen && !pcpu_need_numa())
-		return -EINVAL;
+	if (!chosen) {
+		size_t vm_size = VMALLOC_END - VMALLOC_START;
+		size_t tot_size = num_possible_cpus() * PMD_SIZE;
+
+		/* on non-NUMA, embedding is better */
+		if (!pcpu_need_numa())
+			return -EINVAL;
+
+		/* don't consume more than 20% of vmalloc area */
+		if (tot_size > vm_size / 5) {
+			pr_info("PERCPU: too large chunk size %zuMB for "
+				"large page remap\n", tot_size >> 20);
+			return -EINVAL;
+		}
+	}
 
 	/*
 	 * Currently supports only single page.  Supporting multiple
-- 
1.6.0.2


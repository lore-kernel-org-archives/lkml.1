Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZBHO7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZBHO7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZBHO6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:58:48 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:41045 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZBHO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:58:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=huV2Ox1g3yghZ2kvVHGZVNnkomIdUgDvYZuKfPKo74fBV7iNjlGfD0v8BfpwhDh9lR
         neNq+VMpb17GpDqU7cEIDbGnJXPVqdeA0yRjQQxgQNHzrXDiDeuVmiPo8mWY8Wwqr5Cs
         A0w31KZ5CYcKd1mx8+E68/0TOBLHzJxq99Gno=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: Fix abuse of per_cpu_offset
Date: Sun,  8 Feb 2009 09:58:40 -0500
Message-Id: <1234105120-19731-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234105120-19731-1-git-send-email-brgerst@gmail.com>
References: <1234105120-19731-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bug fix

Don't use per_cpu_offset() to determine if it valid to access a
per-cpu variable for a given cpu number.  It is not a valid assumption
on x86-64 anymore.  Use cpu_possible() instead.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/mm/numa_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 08d140f..deb1c1a 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -702,7 +702,7 @@ void __cpuinit numa_set_node(int cpu, int node)
 	}
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
-	if (cpu >= nr_cpu_ids || !per_cpu_offset(cpu)) {
+	if (cpu >= nr_cpu_ids || !cpu_possible(cpu)) {
 		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
 		dump_stack();
 		return;
@@ -790,7 +790,7 @@ int early_cpu_to_node(int cpu)
 	if (early_per_cpu_ptr(x86_cpu_to_node_map))
 		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
 
-	if (!per_cpu_offset(cpu)) {
+	if (!cpu_possible(cpu)) {
 		printk(KERN_WARNING
 			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
 		dump_stack();
-- 
1.6.1


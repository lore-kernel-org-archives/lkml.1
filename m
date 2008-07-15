Return-Path: <linux-kernel-owner+w=401wt.eu-S1762712AbYGOVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762712AbYGOVPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbYGOVOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:34 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33425 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755402AbYGOVOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:30 -0400
Message-Id: <20080715211430.306421000@polaris-admin.engr.sgi.com>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 14:14:35 -0700
From: Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] cpumask: Optimize cpumask_of_cpu in lib/smp_processor_id.c
Content-Disposition: inline; filename=optimize-cpu_mask_of_cpu-in-lib_smp_processor_id_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Optimize various places where a pointer to the cpumask_of_cpu value
    will result in reducing stack pressure.

Based on linux-2.6.tip/master at the following commit:

    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
    Merge: 9a635fa... 724dce0...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 15 14:55:17 2008 +0200

Signed-off-by: Mike Travis <travis@sgi.com>
---
 lib/smp_processor_id.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.tip.orig/lib/smp_processor_id.c
+++ linux-2.6.tip/lib/smp_processor_id.c
@@ -11,7 +11,7 @@ notrace unsigned int debug_smp_processor
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
-	cpumask_t this_mask;
+	cpumask_of_cpu_ptr_declare(this_mask);
 
 	if (likely(preempt_count))
 		goto out;
@@ -23,9 +23,9 @@ notrace unsigned int debug_smp_processor
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	this_mask = cpumask_of_cpu(this_cpu);
+	cpumask_of_cpu_ptr_next(this_mask, cpu);
 
-	if (cpus_equal(current->cpus_allowed, this_mask))
+	if (cpus_equal(current->cpus_allowed, *this_mask))
 		goto out;
 
 	/*

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYAPRL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYAPRL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbYAPRJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:09:12 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34345 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755886AbYAPRJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:09:04 -0500
Message-Id: <20080116170902.723863000@sgi.com>
References: <20080116170902.006151000@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Jan 2008 09:09:07 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Eric Dumazet <dada1@cosmosbay.com>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] x86: Change NR_CPUS arrays in smpboot_64 V3
Content-Disposition: inline; filename=NR_CPUS-arrays-in-smpboot_64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the following static arrays sized by NR_CPUS to
per_cpu data variables:

	task_struct *idle_thread_array[NR_CPUS];

This is only done if CONFIG_HOTPLUG_CPU is defined
as otherwise, the array is removed after initialization
anyways.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---
V1->V2:
    - (none)
---
 arch/x86/kernel/smpboot_64.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -111,10 +111,20 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
  * a new thread. Also avoids complicated thread destroy functionality
  * for idle threads.
  */
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
+ * removed after init for !CONFIG_HOTPLUG_CPU.
+ */
+static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
+#define get_idle_for_cpu(x)     (per_cpu(idle_thread_array, x))
+#define set_idle_for_cpu(x,p)   (per_cpu(idle_thread_array, x) = (p))
+#else
 struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
-
 #define get_idle_for_cpu(x)     (idle_thread_array[(x)])
 #define set_idle_for_cpu(x,p)   (idle_thread_array[(x)] = (p))
+#endif
+
 
 /*
  * Currently trivial. Write the real->protected mode

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYAOCSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYAOCSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYAOCRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:17:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36880 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753641AbYAOCRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:17:37 -0500
Message-Id: <20080115021736.731703000@sgi.com>
References: <20080115021735.779102000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Jan 2008 18:17:40 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] x86: Change NR_CPUS arrays in smpboot_64 V2
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

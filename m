Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYAMSgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYAMSgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYAMSfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:35:00 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49205 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753341AbYAMSe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:34:56 -0500
Message-Id: <20080113183454.680306000@sgi.com>
References: <20080113183453.973425000@sgi.com>
User-Agent: quilt/0.46-1
Date: Sun, 13 Jan 2008 10:34:58 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/10] x86: Change NR_CPUS arrays in smpboot_64
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

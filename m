Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbZBTWr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbZBTWr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 17:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZBTWrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 17:47:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZBTWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 17:47:19 -0500
Date: Fri, 20 Feb 2009 14:46:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       eric@lammerts.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH][retry 2] Conform L3 Cache Index Disable to Linux
 standards From:  Eric Lammerts <eric@lammerts.org>
Message-Id: <20090220144619.82a5f076.akpm@linux-foundation.org>
In-Reply-To: <200902201550.47415.mark.langsdorf@amd.com>
References: <200902201550.47415.mark.langsdorf@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 15:50:47 -0600
Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> Add ABI Documentation entry and fix some /sys directory formating
> issues with the L3 Cache Index Disable feature for future AMD
> processors. __Add a check to disable it for family 0x10 models
> that do not support it yet.

This change clashes with (what I assume to be) Rusty changes in
linux-next's arch/x86/kernel/cpu/intel_cacheinfo.c:

--- /tmp/1	2009-02-20 14:41:06.000000000 -0800
+++ /tmp/2	2009-02-20 14:40:52.000000000 -0800
@@ -24,7 +24,8 @@
 
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
 {
-	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
+	int node = cpu_to_node(cpumask_first(mask));
 	struct pci_dev *dev = NULL;
 	ssize_t ret = 0;
 	int i;
@@ -58,7 +59,8 @@
 store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 		    size_t count)
 {
-	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	const struct cpumask *mask = to_cpumask(this_leaf->shared_cpu_map);
+	int node = cpu_to_node(cpumask_first(mask));
 	struct pci_dev *dev = NULL;
 	unsigned int ret, index, val;
 

I think those chagnes will need to be carried forward into the new
code.

I made that change when applying this patch locally.  If Ingo applies
this to his tree, Stephen gets to do the same fix for linux-next
integration.


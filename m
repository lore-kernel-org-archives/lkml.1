Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbXK1AJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbXK1AJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbXK1AJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:09:43 -0500
Received: from relay1.sgi.com ([192.48.171.29]:56950 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754659AbXK1AJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:09:43 -0500
Date: Tue, 27 Nov 2007 16:09:41 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: andi@firstfloor.org, travis@sgi.com, ak@suse.de, pageexec@freemail.hu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: Prevent dereferencing non-allocated per_cpu
 variables
In-Reply-To: <20071127154213.11970e63.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711271608120.7293@schroedinger.engr.sgi.com>
References: <20071127215052.090968000@sgi.com> <20071127215054.660250000@sgi.com>
 <20071127221628.GG24223@one.firstfloor.org> <20071127151241.038c146d.akpm@linux-foundation.org>
 <20071127152122.1d5fbce3.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0711271522050.6713@schroedinger.engr.sgi.com>
 <20071127154213.11970e63.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Andrew Morton wrote:

> I don't recall anyone ever demonstrating that prefetch is useful in-kernel.

vmstat: remove prefetch

Remove the prefetch logic in order to avoid touching impossible per cpu 
areas.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmstat.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2007-11-27 16:04:15.345713812 -0800
+++ linux-2.6/mm/vmstat.c	2007-11-27 16:07:00.552713192 -0800
@@ -21,21 +21,14 @@ EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
 static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
 {
-	int cpu = 0;
+	int cpu;
 	int i;
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	cpu = first_cpu(*cpumask);
-	while (cpu < NR_CPUS) {
+	for_each_cpu_mask(cpu, *cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
-		cpu = next_cpu(cpu, *cpumask);
-
-		if (cpu < NR_CPUS)
-			prefetch(&per_cpu(vm_event_states, cpu));
-
-
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
 			ret[i] += this->event[i];
 	}

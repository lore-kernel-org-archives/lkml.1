Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbXJIQRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbXJIQRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXJIQR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:17:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:51808 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbXJIQR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:17:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=R3k+NfYbRMKLEsaMurOBvYVP6qNd8/13YxT9Nf+53eng8AjuPS8C2wc5ad9+FnjZp3SH3xtikoim45BJq0sJb5fNJq3ZmowTOqCYkJaIgLwbDJR2pxxszSm0JMymq2YAiSFiy2t4syND6xg59q+cbBa5AmacGEOmDKO1SEMpyb4=
Date: Wed, 10 Oct 2007 01:13:28 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] slub: fix cpu hotplug offline/online path
Message-ID: <20071009161328.GA6470@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
	Andrew Morton <akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the problem introduced by:
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch

I got slub BUG report when I tried to do cpu hotplug/unplug
$ while true; do
	echo 0 > /sys/devices/system/cpu/cpu1/online
	echo 1 > /sys/devices/system/cpu/cpu1/online
done

This is because init_alloc_cpu_cpu() is called every time when the CPU is
going to be onlined but init_alloc_cpu_cpu() is not intented to be called
twice or more for same CPU. Then it breaks kmem_cache_cpu_free list for
the CPU.

This patch removes init_alloc_cpu_cpu() from cpu hotplug notifier. But
call it for each possible CPUs not only online CPUs at initialization time.

Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 mm/slub.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: 2.6-mm/mm/slub.c
===================================================================
--- 2.6-mm.orig/mm/slub.c
+++ 2.6-mm/mm/slub.c
@@ -2029,7 +2029,7 @@ static int alloc_kmem_cache_cpus(struct 
 /*
  * Initialize the per cpu array.
  */
-static void init_alloc_cpu_cpu(int cpu)
+static void __init init_alloc_cpu_cpu(int cpu)
 {
 	int i;
 
@@ -2041,7 +2041,7 @@ static void __init init_alloc_cpu(void)
 {
 	int cpu;
 
-	for_each_online_cpu(cpu)
+	for_each_possible_cpu(cpu)
 		init_alloc_cpu_cpu(cpu);
   }
 
@@ -2973,7 +2973,6 @@ static int __cpuinit slab_cpuup_callback
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		init_alloc_cpu_cpu(cpu);
 		down_read(&slub_lock);
 		list_for_each_entry(s, &slab_caches, list)
 			s->cpu_slab[cpu] = alloc_kmem_cache_cpu(s, cpu,

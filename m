Return-Path: <linux-kernel-owner+w=401wt.eu-S1761530AbXEaS5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530AbXEaS5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760613AbXEaS5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:57:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47337 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757212AbXEaS5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:57:25 -0400
Date: Thu, 31 May 2007 11:57:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: 2.6.22-rc3-mm1
In-Reply-To: <20070531115319.967f9ff7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705311157001.21496@schroedinger.engr.sgi.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
 <465F0B83.2050100@googlemail.com> <20070531113155.1c6d7185.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705311136200.11008@schroedinger.engr.sgi.com>
 <20070531115319.967f9ff7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Andrew Morton wrote:

> we're not disbling local irqs on the cpu hotplug path.
> 
> Could do local_irq_disable() in slab_cpuup_callback(), I guess.

Ahh I see.


SLUB: Fix locking for hotplug callbacks.

Hotplug callbacks seem to be performed with interrupts enabled. Slub requires
interrupts to be disabled for flushing caches.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-05-31 11:49:48.000000000 -0700
+++ slub/mm/slub.c	2007-05-31 11:54:09.000000000 -0700
@@ -2663,6 +2663,19 @@ static void for_all_slabs(void (*func)(s
 }
 
 /*
+ * Version of __flush_cpu_slab for the case that interrupts
+ * are enabled.
+ */
+static void cpu_slab_flush(struct kmem_cache *s, int cpu)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__flush_cpu_slab(s, cpu);
+	local_irq_restore(flags);
+}
+
+/*
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
  */
@@ -2676,7 +2689,7 @@ static int __cpuinit slab_cpuup_callback
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		for_all_slabs(__flush_cpu_slab, cpu);
+		for_all_slabs(cpu_slab_flush, cpu);
 		break;
 	default:
 		break;
 

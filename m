Return-Path: <linux-kernel-owner+w=401wt.eu-S1763384AbXGNT5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763384AbXGNT5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 15:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbXGNT4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 15:56:52 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:48408 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762687AbXGNT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 15:56:51 -0400
Date: Sat, 14 Jul 2007 15:56:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, hch@infradead.org
Subject: [PATCH] Kprobes - no kprobes_mutex needed around arch_remove_kprobe calls
Message-ID: <20070714195649.GO6975@Krystal>
References: <20070714012133.612727310@polymtl.ca> <20070714012414.130353244@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012414.130353244@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:54:21 up 7 days,  9:59,  2 users,  load average: 0.15, 0.21, 0.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobes - no kprobes_mutex needed around arch_remove_kprobe calls.

Since we have the new insn pages mutex, there is no need to protect
arch_remove_kprobe() with the kprobes_mutex anymore. We don't edit the
kernel text there neither, so don't take the text edit lock.

This patch applies after
text-edit-lock-kprobes-architecture-independent.patch

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: hch@infradead.org
CC: prasanna@in.ibm.com
CC: ananth@in.ibm.com
CC: anil.s.keshavamurthy@intel.com
CC: davem@davemloft.net
---
 kernel/kprobes.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6-lttng/kernel/kprobes.c
===================================================================
--- linux-2.6-lttng.orig/kernel/kprobes.c	2007-07-14 15:44:57.000000000 -0400
+++ linux-2.6-lttng/kernel/kprobes.c	2007-07-14 15:45:49.000000000 -0400
@@ -663,11 +663,7 @@ valid_p:
 			list_del_rcu(&p->list);
 			kfree(old_p);
 		}
-		mutex_lock(&kprobe_mutex);
-		kernel_text_lock();
 		arch_remove_kprobe(p);
-		kernel_text_unlock();
-		mutex_unlock(&kprobe_mutex);
 	} else {
 		mutex_lock(&kprobe_mutex);
 		if (p->break_handler)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

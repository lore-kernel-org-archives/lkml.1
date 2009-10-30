Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZJ3NxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZJ3NxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbZJ3NxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:53:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42041 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247AbZJ3NxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:53:11 -0400
Date: Fri, 30 Oct 2009 19:23:10 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       fweisbec@gmail.com
Subject: [PATCH] kprobes: Sanitize struct kretprobe_instance allocations
Message-ID: <20091030135310.GA22230@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

For as long as kretprobes have existed, we've allocated NR_CPUS
instances of kretprobe_instance structures. With the default value of
CONFIG_NR_CPUS increasing on certain architectures, we are potentially
wasting kernel memory.

See http://sourceware.org/bugzilla/show_bug.cgi?id=10839#c3 for more
details.

Use a saner num_possible_cpus() instead of NR_CPUS for allocation.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.32-rc5/kernel/kprobes.c
===================================================================
--- linux-2.6.32-rc5.orig/kernel/kprobes.c
+++ linux-2.6.32-rc5/kernel/kprobes.c
@@ -1014,9 +1014,9 @@ int __kprobes register_kretprobe(struct 
 	/* Pre-allocate memory for max kretprobe instances */
 	if (rp->maxactive <= 0) {
 #ifdef CONFIG_PREEMPT
-		rp->maxactive = max(10, 2 * NR_CPUS);
+		rp->maxactive = max(10, 2 * num_possible_cpus());
 #else
-		rp->maxactive = NR_CPUS;
+		rp->maxactive = num_possible_cpus();
 #endif
 	}
 	spin_lock_init(&rp->lock);

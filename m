Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZKPJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZKPJbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 04:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZKPJbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 04:31:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZKPJbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 04:31:16 -0500
Subject: [PATCH] sched: sched_rt_periodic_timer vs cpu hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20091116090506.GA6077@osiris.boeblingen.de.ibm.com>
References: <20091111101801.GA19103@osiris.boeblingen.de.ibm.com>
	 <1257935428.23203.82.camel@twins>
	 <20091116090506.GA6077@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 10:31:13 +0100
Message-ID: <1258363873.26714.83.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: sched_rt_periodic_timer vs cpu hotplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Nov 16 10:28:09 CET 2009

Heiko reported a case where a timer interrupt managed to reference a
root_domain structure that was already freed by a concurrent
hot-un-plug operation.

Solve this like the regular sched_domain stuff is also synchronized,
by adding a synchronize_sched() stmt to the free path, this ensures
that a root_domain stays present for any atomic section that could
have observed it.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com> 
---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7921,6 +7921,8 @@ sd_parent_degenerate(struct sched_domain
 
 static void free_rootdomain(struct root_domain *rd)
 {
+	synchronize_sched();
+
 	cpupri_cleanup(&rd->cpupri);
 
 	free_cpumask_var(rd->rto_mask);



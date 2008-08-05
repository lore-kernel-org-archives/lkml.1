Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbYHEIq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbYHEIq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbYHEIqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:46:20 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:40932 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbYHEIqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:46:19 -0400
Subject: Re: [RFC][PATCH 1/7] lockdep: Fix combinatorial explosion in lock
	subgraph traversal.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20080805.013445.30774221.davem@davemloft.net>
References: <20080804130317.994042639@chello.nl>
	 <20080804131011.749503624@chello.nl>
	 <20080805.013445.30774221.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 10:46:13 +0200
Message-Id: <1217925973.3589.108.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 01:34 -0700, David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon, 04 Aug 2008 15:03:18 +0200
> 
> > When we traverse the graph, either forwards or backwards, we
> > are interested in whether a certain property exists somewhere
> > in a node reachable in the graph.
>  ...
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Peter, when Ingo added this to his tree he needed to add a build
> fix of some sort.  Did you include that here?
> 
> I think the problem was that if CONFIG_PROVE_LOCKING is not
> set, we need to add nop inline versions of lockdep_count_*_deps()
> in kernel/lockdep_internals.h
> 
> See:
> 
> http://marc.info/?l=linux-kernel&m=121758260130275&w=2

Probably missed that, thanks for reminding me.

Andrew, please pick up:

---
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 1 Aug 2008 11:23:50 +0200
Subject: [PATCH] lockdep: build fix

fix:

 kernel/built-in.o: In function `lockdep_stats_show':
 lockdep_proc.c:(.text+0x3cb2f): undefined reference to `lockdep_count_forward_deps'
 kernel/built-in.o: In function `l_show':
 lockdep_proc.c:(.text+0x3d02b): undefined reference to `lockdep_count_forward_deps'
 lockdep_proc.c:(.text+0x3d047): undefined reference to `lockdep_count_backward_deps'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep_internals.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 68d44ec..f5c6a14 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -53,8 +53,21 @@ extern unsigned int nr_process_chains;
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_recursion_depth;
 
+#ifdef CONFIG_PROVE_LOCKING
 extern unsigned long lockdep_count_forward_deps(struct lock_class *);
 extern unsigned long lockdep_count_backward_deps(struct lock_class *);
+#else
+static inline unsigned long
+lockdep_count_forward_deps(struct lock_class *class)
+{
+	return 0;
+}
+static inline unsigned long
+lockdep_count_backward_deps(struct lock_class *class)
+{
+	return 0;
+}
+#endif
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*



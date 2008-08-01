Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYHAJWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYHAJWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYHAJWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:22:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbYHAJWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:22:30 -0400
Date: Fri, 1 Aug 2008 11:22:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
Message-ID: <20080801092219.GA15691@elte.hu>
References: <20080728.161318.38361710.davem@davemloft.net> <20080728235133.GA7956@elte.hu> <20080728.174415.154327359.davem@davemloft.net> <20080729.214503.126934382.davem@davemloft.net> <20080731163943.GF26393@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731163943.GF26393@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > lockdep: Fix combinatorial explosion in lock subgraph traversal.
> 
> applied to tip/core/locking - thanks David. I guess we need to test 
> this a bit, the patch is far from simple :-)

small build fallout fix below.

	Ingo

---------------->
>From 8887b1c04671c66dcde3d4104913ba9587e1e40c Mon Sep 17 00:00:00 2001
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

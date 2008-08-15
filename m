Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbYHOQdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbYHOQdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYHOQdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:33:08 -0400
Received: from mail.vyatta.com ([216.93.170.194]:37052 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbYHOQdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:33:07 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.579
Date: Fri, 15 Aug 2008 09:33:05 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "John Kacur" <jkacur@gmail.com>, Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: [PATCH] lockdep: fix build if CONFIG_PROVE_LOCKING not defined
Message-ID: <20080815093305.6975ec7e@extreme>
In-Reply-To: <520f0cf10808150857u5803d86cj205e671f640c81c4@mail.gmail.com>
References: <520f0cf10808150857u5803d86cj205e671f640c81c4@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PROVE_LOCKING not defined, then no dependency information
is available.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/kernel/lockdep_proc.c	2008-08-15 09:21:46.000000000 -0700
+++ b/kernel/lockdep_proc.c	2008-08-15 09:29:59.000000000 -0700
@@ -82,7 +82,6 @@ static void print_name(struct seq_file *
 
 static int l_show(struct seq_file *m, void *v)
 {
-	unsigned long nr_forward_deps, nr_backward_deps;
 	struct lock_class *class = v;
 	struct lock_list *entry;
 	char c1, c2, c3, c4;
@@ -96,11 +95,10 @@ static int l_show(struct seq_file *m, vo
 #ifdef CONFIG_DEBUG_LOCKDEP
 	seq_printf(m, " OPS:%8ld", class->ops);
 #endif
-	nr_forward_deps = lockdep_count_forward_deps(class);
-	seq_printf(m, " FD:%5ld", nr_forward_deps);
-
-	nr_backward_deps = lockdep_count_backward_deps(class);
-	seq_printf(m, " BD:%5ld", nr_backward_deps);
+#ifdef CONFIG_PROVE_LOCKING
+	seq_printf(m, " FD:%5ld", lockdep_count_forward_deps(class));
+	seq_printf(m, " BD:%5ld", lockdep_count_backward_deps(class));
+#endif
 
 	get_usage_chars(class, &c1, &c2, &c3, &c4);
 	seq_printf(m, " %c%c%c%c", c1, c2, c3, c4);
@@ -325,7 +323,9 @@ static int lockdep_stats_show(struct seq
 		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
 			nr_hardirq_read_unsafe++;
 
+#ifdef CONFIG_PROVE_LOCKING
 		sum_forward_deps += lockdep_count_forward_deps(class);
+#endif
 	}
 #ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(&nr_unused_locks) != nr_unused);

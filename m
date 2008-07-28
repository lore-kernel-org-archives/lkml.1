Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYG1XN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYG1XN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYG1XNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:13:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49489
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYG1XNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:13:18 -0400
Date: Mon, 28 Jul 2008 16:13:18 -0700 (PDT)
Message-Id: <20080728.161318.38361710.davem@davemloft.net>
To: mingo@elte.hu
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: combinatorial explosion in lockdep
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080728.153702.103032029.davem@davemloft.net>
References: <20080728.153702.103032029.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 28 Jul 2008 15:37:02 -0700 (PDT)

> I'm still digging on what exactly makes this happen, but I wanted to
> get the information out as soon as I had something useful like this.

As a simple hack, I tried mitigating these effects using a
generation-count based "visited" scheme to bypass traversing
lock_class chains we've already walked down.

It seems to work.

But I wonder if the real problem is that there is some unintended
loop in the chains, or something like that.

Anyways, just some more info...

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2486eb4..1bfdc30 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -89,6 +89,7 @@ struct lock_class {
 
 	struct lockdep_subclass_key	*key;
 	unsigned int			subclass;
+	unsigned int			dep_gen_id;
 
 	/*
 	 * IRQ/softirq usage tracking bits:
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index d38a643..59218a0 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -959,6 +959,18 @@ static int noinline print_infinite_recursion_bug(void)
 	return 0;
 }
 
+static unsigned int dependency_gen_id;
+
+static bool dependency_visit(struct lock_class *source, unsigned int depth)
+{
+	if (!depth)
+		dependency_gen_id++;
+	if (source->dep_gen_id == dependency_gen_id)
+		return true;
+	source->dep_gen_id = dependency_gen_id;
+	return false;
+}
+
 /*
  * Prove that the dependency graph starting at <entry> can not
  * lead to <target>. Print an error and return 0 if it does.
@@ -968,6 +980,9 @@ check_noncircular(struct lock_class *source, unsigned int depth)
 {
 	struct lock_list *entry;
 
+	if (dependency_visit(source, depth))
+		return 1;
+
 	debug_atomic_inc(&nr_cyclic_check_recursions);
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
@@ -1011,6 +1026,9 @@ find_usage_forwards(struct lock_class *source, unsigned int depth)
 	struct lock_list *entry;
 	int ret;
 
+	if (dependency_visit(source, depth))
+		return 1;
+
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
 	if (depth >= RECURSION_LIMIT)
@@ -1050,6 +1068,9 @@ find_usage_backwards(struct lock_class *source, unsigned int depth)
 	struct lock_list *entry;
 	int ret;
 
+	if (dependency_visit(source, depth))
+		return 1;
+
 	if (!__raw_spin_is_locked(&lockdep_lock))
 		return DEBUG_LOCKS_WARN_ON(1);
 

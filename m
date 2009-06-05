Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZFERgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZFERgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZFERgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:36:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbZFERgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:36:10 -0400
Date: Fri, 5 Jun 2009 10:34:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
In-Reply-To: <200906052311.57762.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.01.0906051026030.6847@localhost.localdomain>
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Jun 2009, Rusty Russell wrote:
> 
> OK, here's what I've got in my tree.  Ingo, I think this should go in the
> current -rc to avoid nasty bugs.

Why is the fix not to simply clear it in alloc?

> BTW, the original alloc_cpumask_var did zero; that was dropped after arguments
> over efficiency and fitting with other interfaces, but I clearly had the old
> semantics in my head for a while.

How could this ever be a efficiency issue? If you allocate cpumasks so 
often that it's an efficiency problem, it would seem that you have bigger 
issues than the memset. You'll have to initialize them some other way 
anyway, so it's not like you can ever really avoid the dirty cachelines.

IOW, why isn't the fix just to clean up the horrible mess that is 
alloc_cpumask_var_node() once and for all. Why not something like this? 
The end result looks a lot simpler.

Or you could just add in that __GFP_ZERO there, and remove the memset. I 
don't care. But the current code just looks messy and crazy, and that 
FIXME is bogus. The end of the allocation needs to be cleared regardless.

		Linus
---
 lib/cpumask.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index 1f71b97..272b5e5 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -101,21 +101,16 @@ bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node)
 #endif
 		*mask = NULL;
 	}
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
 	if (!*mask) {
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
 		printk(KERN_ERR "=> alloc_cpumask_var: failed!\n");
 		dump_stack();
-	}
 #endif
-	/* FIXME: Bandaid to save us from old primitives which go to NR_CPUS. */
-	if (*mask) {
-		unsigned char *ptr = (unsigned char *)cpumask_bits(*mask);
-		unsigned int tail;
-		tail = BITS_TO_LONGS(NR_CPUS - nr_cpumask_bits) * sizeof(long);
-		memset(ptr + cpumask_size() - tail, 0, tail);
+		return 0;
 	}
 
-	return *mask != NULL;
+	memset(cpumask_bits(*mask), 0, cpumask_size());
+	return 1;
 }
 EXPORT_SYMBOL(alloc_cpumask_var_node);
 

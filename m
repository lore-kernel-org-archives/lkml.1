Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbYFFL6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbYFFL6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYFFL6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:58:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41573 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbYFFL6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:58:22 -0400
Date: Fri, 6 Jun 2008 13:57:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606115759.GA29321@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au> <20080605195604.41623687.akpm@linux-foundation.org> <20080606071707.GB9708@elte.hu> <20080606002957.6329a0ec.akpm@linux-foundation.org> <20080606024811.70db9ab2.akpm@linux-foundation.org> <20080606035413.37f340ef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606035413.37f340ef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Good
> 
> 	a9ad585c8a18f7ba754b85f5786976609b9d7d29
> 	Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
> 	Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:07:47
> 	Parent: 543e21916497be5a4005fd5820264ce1de9bd56d (x86: restore pda nodenumber field)
> 	Child:  78d49c6d890aee9cf8aea371011c9d7b0121b822 (x86: remove static boot_cpu_pda array v2)
> 	Branch: 
> 	Follows: v2.6.26-rc2
> 	Precedes: next-20080526
> 
> 	    x86: remove the static 256k node_to_cpumask_map
> 
> crash, as described earlier.

thanks for tracking it down! This was the origin of the commit:

 # tip/x86/numa: a9ad585: x86: remove the static 256k node_to_cpumask_map

which has been in -tip since May 12 and in linux-next for two weeks 
AFAICS, which is beyond the point of being something freshly wrong.

So i suspect something more subtle here. What compiler version are you 
using? This crash is not something that has been found in testing before 
- i use rather new compilers, gcc 4.2.2 most of the time. Previous 
compilers miscompile the kernel seriously so it's not usable for our 
regression testing grid.

until more is found out i've put the revert into tip/x86/numa for now. 
Note, you'll also need the commit below for 32-bit NUMA.

	Ingo

---------------->
commit f418f2b4a9b6ef4035cc8c9a166873a2b275e4ef
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jun 6 13:54:52 2008 +0200

    x86: fix revert side-effects
    
    fix 32-bit NUMA.

diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index c0e6ff7..abd3aa8 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -57,6 +57,18 @@ static inline int cpu_to_node(int cpu)
 }
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
+/* Returns a pointer to the cpumask of CPUs on Node 'node'. */
+static inline cpumask_t *_node_to_cpumask_ptr(int node)
+{
+	return &node_to_cpumask_map[node];
+}
+
+/* Returns a bitmask of CPUs on Node 'node'. */
+static inline cpumask_t node_to_cpumask(int node)
+{
+	return node_to_cpumask_map[node];
+}
+
 #else /* CONFIG_X86_64 */
 
 /* Mappings between node number and cpus on that node. */

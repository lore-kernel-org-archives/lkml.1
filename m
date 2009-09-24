Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbZIXISq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbZIXISq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZIXISp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:18:45 -0400
Received: from ozlabs.org ([203.10.76.45]:56123 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZIXISn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:18:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference at (null), last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/local_cpus
Date: Thu, 24 Sep 2009 17:48:44 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       Tejun Heo <tj@kernel.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20090915132105.2fdd1d45@jbarnes-g45> <20090918075952.GA29026@elte.hu> <alpine.LFD.2.01.0909180755530.4950@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909180755530.4950@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909241748.45629.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Sep 2009 01:08:02 am Linus Torvalds wrote:
> [ Side note: looking closer, I think our headers are buggy, and I _know_ 
>   they are confusing. The above inline declaration of cpumask_of_node() 
>   seems to be then later overridden in <asm-generic/topology.h> by a 
>   #define! 
> 
>   And if I read that right, that will also override the debugging 
>   versions that we declared if CONFIG_DEBUG_PER_CPU_MAPS is on. Ingo? 
>   Rusty? Am I missing something?

What a tangle.

The CONFIG_DEBUG_PER_CPU_MAPS only overrides cpumask_of_node in the NUMA case
(otherwise, it leaves it alone).

And asm-generic/topology.h only defines cpumask_of_node in the !NUMA case.

But there's still redundancy.  Ingo...

Subject: x86: remove redundant non-NUMA topology functions

arch/x86/include/asm/topology.h declares inline fns cpu_to_node
and cpumask_of_node for !NUMA, even though they are then declared as macros
by asm-generic/topology.h, which is #included just below.

The macros (which are the same) end up being used; these functions are
just confusing.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/topology.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -165,21 +165,11 @@ static inline int numa_node_id(void)
 	return 0;
 }
 
-static inline int cpu_to_node(int cpu)
-{
-	return 0;
-}
-
 static inline int early_cpu_to_node(int cpu)
 {
 	return 0;
 }
 
-static inline const struct cpumask *cpumask_of_node(int node)
-{
-	return cpu_online_mask;
-}
-
 static inline void setup_node_to_cpumask_map(void) { }
 
 #endif

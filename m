Return-Path: <linux-kernel-owner+w=401wt.eu-S934338AbYEHXCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338AbYEHXCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763246AbYEHXCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:02:41 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51531 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758785AbYEHXCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:02:39 -0400
Message-Id: <20080508230238.468043000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 08 May 2008 16:02:38 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       bunk@kernel.org
Cc: linux-sh@vger.kernel.org, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] mm: define default cpu_to_node
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is offered to resolve this problem:

| Adrian Bunk wrote:
|| Commit aa6b54461cc5c0019b9d792adf3176b444c10763
|| (asm-generic: add node_to_cpumask_ptr macro)
|| causes the following build error with migor_defconfig:
||
|| <--  snip  -->
||
|| ...
||   CC      arch/sh/kernel/asm-offsets.s
|| In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:8,
||                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/asm-offsets.c:13:
|| /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h: In function 'alloc_pages_node':
|| /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h:190: 
|| error: implicit declaration of function 'cpu_to_node'
|| make[2]: *** [arch/sh/kernel/asm-offsets.s] Error 1
||


Ahh, this is what caused the error.  In include/asm-generic/topology.h
cpu_to_node is only defined now if NUMA is turned off.

#ifndef CONFIG_NUMA

/* Other architectures wishing to use this simple topology API should fill
   in the below functions as appropriate in their own <asm/topology.h> file. */
#ifndef cpu_to_node
#define cpu_to_node(cpu)        ((void)(cpu),0)
#endif
...

So before my change arch 'sh' used the default define whether NUMA was
set or not.

An alternative would be to change all the arch's that define cpu_to_node
as an inline to:

#define cpu_to_node(cpu)	_cpu_to_node(cpu)
static inline int _cpu_to_node(int cpu)
{
	...
}

Then asm-generic/topology.h could define cpu_to_node if it's not already
defined.

Andrew or Ingo - do you have any preferences?

Thanks,
Mike

Signed-off-by: Mike Travis <travis@sgi.com>

# alpha
Cc: Richard Henderson <rth@twiddle.net>

# powerpc
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>

# sh
Cc: Adrian Bunk <bunk@kernel.org>
Cc: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org

# sparc
Cc: David S. Miller <davem@davemloft.net>
Cc: William L. Irwin <wli@holomorphy.com>

# x86
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---

-- 

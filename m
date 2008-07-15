Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbYGOVQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbYGOVQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYGOVOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:40233 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755138AbYGOVOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:31 -0400
Message-Id: <20080715211429.454823000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 14:14:29 -0700
From: Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] cpumask: Replace/optimize cpumask_of_cpu & cpumask_t operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From Rusty Russell <rusty@rustcorp.com.au>:
>  
>    Hi Christoph/Mike,
>    
>      Looked at cpumask_of_cpu as introduced in 
>    9f0e8d0400d925c3acd5f4e01dbeb736e4011882 (x86: convert cpumask_of_cpu
>    macro to allocated array), and I don't think it's safe:
>    
>      #define cpumask_of_cpu(cpu)					\
>      (*({								\
>    	typeof(_unused_cpumask_arg_) m;					\
>    	if (sizeof(m) == sizeof(unsigned long)) {			\
>    		m.bits[0] = 1UL<<(cpu);					\
>    	} else {							\
>    		cpus_clear(m);						\
>    		cpu_set((cpu), m);					\
>    	}								\
>    	&m;								\
>      }))
>    
>    Referring to &m once out of scope is invalid, and I can't find any
>    evidence that it's legal here.  In particular, the change 
>    b53e921ba1cff8453dc9a87a84052fa12d5b30bd (generic: reduce stack pressure
>    in sched_affinity) which passes &m to other functions seems highly risky.

  * Patch 1 replaces the dangerous lvalue version of cpumask_of_cpu
    with new cpumask_of_cpu_ptr macros.  These are patterned after the
    node_to_cpumask_ptr macros.

  * Patches 2..6 optimizes various places where a pointer to the cpumask_of_cpu
    value will result in reducing stack pressure.

  * Patch 7 provides a generic set of CPUMASK_ALLOC macros patterned after
    the SCHED_CPUMASK_ALLOC macros.  This is used where multiple cpumask_t
    variables are declared on the stack to reduce the amount of stack space
    required.

  * Patch 8 uses the CPUMASK_ALLOC macros in the centrino_target() function.

Based on linux-2.6.tip/master at the following commit:

    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
    Merge: 9a635fa... 724dce0...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 15 14:55:17 2008 +0200


Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: Greg Banks <gnb@sgi.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Jackson <pj@sgi.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Dean Nelson <dcn@sgi.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---

-- 

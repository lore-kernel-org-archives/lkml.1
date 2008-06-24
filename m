Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYFXII3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYFXII3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbYFXIIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:08:10 -0400
Received: from mga07.intel.com ([143.182.124.22]:38195 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756882AbYFXIIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:08:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,695,1204531200"; 
   d="scan'208";a="1771351"
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer
	dereference
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <200806241136.52430.rusty@rustcorp.com.au>
References: <20080622125633.GA8166@damson.getinternet.no>
	 <200806231326.11328.rusty@rustcorp.com.au> <485FD644.80208@sgi.com>
	 <200806241136.52430.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Jun 2008 16:06:23 +0800
Message-Id: <1214294783.25608.75.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-24 at 11:36 +1000, Rusty Russell wrote:
> On Tuesday 24 June 2008 02:58:44 Mike Travis wrote:
> > Rusty Russell wrote:
> > > On Monday 23 June 2008 02:29:07 Vegard Nossum wrote:
> > >> And the (cpu < nr_cpu_ids) fails because the CPU has just been
> > >> offlined (or failed to initialize, but it's the same thing), while
> > >> NR_CPUS is the value that was compiled in as CONFIG_NR_CPUS (so the
> > >> former check will always be true).
> > >>
> > >> I don't think it is valid to ask for a per_cpu() variable on a CPU
> > >> which does not exist, though
> > >
> > > Yes it is.  As long as cpu_possible(cpu), per_cpu(cpu) is valid.
> > >
> > > The number check should be removed: checking cpu_possible() is
> > > sufficient.
> > >
> > > Hope that helps,
> > > Rusty.
> >
> > I don't see a check for index being out of range in cpu_possible().
> 
> You're right.  It assumes cpu is < NR_CPUS.  Hmm, I have no idea what's going 
> on.  nr_cpu_ids (ignore that it's a horrible name for a bad idea) should be 
> fine to test against.
> 
> Vegard's analysis is flawed: just because cpu is offline, it still must be < 
> nr_cpu_ids, which is based on possible cpus.  Unless something crazy is 
> happening, but a quick grep doesn't reveal anyone manipulating nr_cpu_ids.
> 
> If changing this fixes the bug, something else is badly wrong...
> Rusty.

In function _cpu_up, the panic happens when calling __raw_notifier_call_chain
at the second time. Kernel doesn't panic when calling it at the first time. If
just say because ﻿of nr_cpu_ids, that's not right.

By checking source codes, I find function do_boot_cpu is the culprit.
Consider below call chain:
 _cpu_up=>__cpu_up=>smp_ops.cpu_up=>native_cpu_up=>do_boot_cpu.

So ﻿do_boot_cpu is called in the end. In ﻿do_boot_cpu, if boot_error==true,
cpu_clear(cpu, cpu_possible_map) is executed. So later on, when ﻿_cpu_up
calls ﻿__raw_notifier_call_chain at the second time to report CPU_UP_CANCELED,
because this cpu is already cleared from ﻿cpu_possible_map, get_cpu_sysdev returns
NULL.

Many resources are related to ﻿cpu_possible_map, so it's better not to change it.

Below patch against 2.6.26-rc7 fixes it by removing the bit clearing in ﻿cpu_possible_map.

Vegard, would you like to help test it?

﻿﻿﻿Signed-off-by: Zhang Yanmin ﻿<yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6.26-rc7/arch/x86/kernel/smpboot.c linux-2.6.26-rc7_cpuhotplug/arch/x86/kernel/smpboot.c
--- linux-2.6.26-rc7/arch/x86/kernel/smpboot.c	2008-06-24 09:03:54.000000000 +0800
+++ linux-2.6.26-rc7_cpuhotplug/arch/x86/kernel/smpboot.c	2008-06-24 09:04:45.000000000 +0800
@@ -996,7 +996,6 @@ do_rest:
 #endif
 		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
-		cpu_clear(cpu, cpu_possible_map);
 		cpu_clear(cpu, cpu_present_map);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}





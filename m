Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYF0DRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYF0DRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 23:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYF0DRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 23:17:45 -0400
Received: from ozlabs.org ([203.10.76.45]:54025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbYF0DRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 23:17:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: ego@in.ibm.com
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Date: Fri, 27 Jun 2008 13:16:42 +1000
User-Agent: KMail/1.9.9
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Mike Travis <travis@sgi.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20080622125633.GA8166@damson.getinternet.no> <200806242314.51656.rusty@rustcorp.com.au> <20080626125820.GA30144@in.ibm.com>
In-Reply-To: <20080626125820.GA30144@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806271316.42771.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008 22:58:20 Gautham R Shenoy wrote:
> On Tue, Jun 24, 2008 at 11:14:51PM +1000, Rusty Russell wrote:
> > On Tuesday 24 June 2008 18:06:23 Zhang, Yanmin wrote:
> > > On Tue, 2008-06-24 at 11:36 +1000, Rusty Russell wrote:
> > > > On Tuesday 24 June 2008 02:58:44 Mike Travis wrote:
> > > > > Rusty Russell wrote:
> > > > > > On Monday 23 June 2008 02:29:07 Vegard Nossum wrote:
> > > > > >> And the (cpu < nr_cpu_ids) fails because the CPU has just been
> > > > > >> offlined (or failed to initialize, but it's the same thing),
> > > > > >> while NR_CPUS is the value that was compiled in as
> > > > > >> CONFIG_NR_CPUS (so the former check will always be true).
> > > > > >>
> > > > > >> I don't think it is valid to ask for a per_cpu() variable on a
> > > > > >> CPU which does not exist, though
> > > > > >
> > > > > > Yes it is.  As long as cpu_possible(cpu), per_cpu(cpu) is valid.
> > > > > >
> > > > > > The number check should be removed: checking cpu_possible() is
> > > > > > sufficient.
> > > > > >
> > > > > > Hope that helps,
> > > > > > Rusty.
> > > > >
> > > > > I don't see a check for index being out of range in cpu_possible().
> > > >
> > > > You're right.  It assumes cpu is < NR_CPUS.  Hmm, I have no idea
> > > > what's going on.  nr_cpu_ids (ignore that it's a horrible name for a
> > > > bad idea) should be fine to test against.
> > > >
> > > > Vegard's analysis is flawed: just because cpu is offline, it still
> > > > must be < nr_cpu_ids, which is based on possible cpus.  Unless
> > > > something crazy is happening, but a quick grep doesn't reveal anyone
> > > > manipulating nr_cpu_ids.
> > > >
> > > > If changing this fixes the bug, something else is badly wrong...
> > > > Rusty.
> > >
> > > In function _cpu_up, the panic happens when calling
> > > __raw_notifier_call_chain at the second time. Kernel doesn't panic when
> > > calling it at the first time. If just say because ﻿of nr_cpu_ids,
> > > that's not right.
> > >
> > > By checking source codes, I find function do_boot_cpu is the culprit.
> > > Consider below call chain:
> > >  _cpu_up=>__cpu_up=>smp_ops.cpu_up=>native_cpu_up=>do_boot_cpu.
> > >
> > > So ﻿do_boot_cpu is called in the end. In ﻿do_boot_cpu, if
> > > boot_error==true, cpu_clear(cpu, cpu_possible_map) is executed. So
> > > later on, when ﻿_cpu_up calls ﻿__raw_notifier_call_chain at the second
> > > time to report
> > > CPU_UP_CANCELED, because this cpu is already cleared from
> > > ﻿cpu_possible_map, get_cpu_sysdev returns NULL.
> > >
> > > Many resources are related to ﻿cpu_possible_map, so it's better not to
> > > change it.
> > >
> > > Below patch against 2.6.26-rc7 fixes it by removing the bit clearing in
> > > ﻿cpu_possible_map.
> > >
> > > Vegard, would you like to help test it?
> > >
> > > ﻿﻿﻿Signed-off-by: Zhang Yanmin ﻿<yanmin_zhang@linux.intel.com>
> > >
> > > ---
> > >
> > > diff -Nraup linux-2.6.26-rc7/arch/x86/kernel/smpboot.c
> > > linux-2.6.26-rc7_cpuhotplug/arch/x86/kernel/smpboot.c ---
> > > linux-2.6.26-rc7/arch/x86/kernel/smpboot.c	2008-06-24
> > > 09:03:54.000000000 +0800 +++
> > > linux-2.6.26-rc7_cpuhotplug/arch/x86/kernel/smpboot.c	2008-06-24
> > > 09:04:45.000000000 +0800 @@ -996,7 +996,6 @@ do_rest:
> > >  #endif
> > >  		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
> > >  		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
> > > -		cpu_clear(cpu, cpu_possible_map);
> > >  		cpu_clear(cpu, cpu_present_map);
>
> Nice catch.
>
> While we're at it, is the clearing of cpu from the cpu_present_map
> necessary if cpu_up failed for 'cpu' ?

It's never necessary, but there there are not many places which cpu_present is 
examined.  It just prevents it from being hot added again, AFAICT.

Rusty.

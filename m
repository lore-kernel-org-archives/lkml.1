Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYFZCRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYFZCRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYFZCRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:17:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbYFZCRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:17:06 -0400
Date: Wed, 25 Jun 2008 19:15:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer
 dereference
Message-Id: <20080625191535.e6e60432.akpm@linux-foundation.org>
In-Reply-To: <1214441979.25608.86.camel@ymzhang>
References: <20080622125633.GA8166@damson.getinternet.no>
	<200806231326.11328.rusty@rustcorp.com.au>
	<485FD644.80208@sgi.com>
	<200806241136.52430.rusty@rustcorp.com.au>
	<1214294783.25608.75.camel@ymzhang>
	<1214441979.25608.86.camel@ymzhang>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 08:59:39 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> 
> On Tue, 2008-06-24 at 16:06 +0800, Zhang, Yanmin wrote:
> > On Tue, 2008-06-24 at 11:36 +1000, Rusty Russell wrote:
> > > On Tuesday 24 June 2008 02:58:44 Mike Travis wrote:
> > > > Rusty Russell wrote:
> > > > > On Monday 23 June 2008 02:29:07 Vegard Nossum wrote:
> > > > >> And the (cpu < nr_cpu_ids) fails because the CPU has just been
> > > > >> offlined (or failed to initialize, but it's the same thing), while
> > > > >> NR_CPUS is the value that was compiled in as CONFIG_NR_CPUS (so the
> > > > >> former check will always be true).
> > > > >>
> > > > >> I don't think it is valid to ask for a per_cpu() variable on a CPU
> > > > >> which does not exist, though
> > > > >
> > > > > Yes it is.  As long as cpu_possible(cpu), per_cpu(cpu) is valid.
> > > > >
> > > > > The number check should be removed: checking cpu_possible() is
> > > > > sufficient.
> > > > >
> > > > > Hope that helps,
> > > > > Rusty.
> > > >
> > > > I don't see a check for index being out of range in cpu_possible().
> > > 
> > > You're right.  It assumes cpu is < NR_CPUS.  Hmm, I have no idea what's going 
> > > on.  nr_cpu_ids (ignore that it's a horrible name for a bad idea) should be 
> > > fine to test against.
> > > 
> > > Vegard's analysis is flawed: just because cpu is offline, it still must be < 
> > > nr_cpu_ids, which is based on possible cpus.  Unless something crazy is 
> > > happening, but a quick grep doesn't reveal anyone manipulating nr_cpu_ids.
> > > 
> > > If changing this fixes the bug, something else is badly wrong...
> > > Rusty.
> > 
> > In function _cpu_up, the panic happens when calling __raw_notifier_call_chain
> > at the second time. Kernel doesn't panic when calling it at the first time. If
> > just say because ___of nr_cpu_ids, that's not right.
> > 
> > By checking source codes, I find function do_boot_cpu is the culprit.
> > Consider below call chain:
> >  _cpu_up=>__cpu_up=>smp_ops.cpu_up=>native_cpu_up=>do_boot_cpu.
> > 
> > So ___do_boot_cpu is called in the end. In ___do_boot_cpu, if boot_error==true,
> > cpu_clear(cpu, cpu_possible_map) is executed. So later on, when ____cpu_up
> > calls _____raw_notifier_call_chain at the second time to report CPU_UP_CANCELED,
> > because this cpu is already cleared from ___cpu_possible_map, get_cpu_sysdev returns
> > NULL.
> > 
> > Many resources are related to ___cpu_possible_map, so it's better not to change it.
> > 
> > Below patch against 2.6.26-rc7 fixes it by removing the bit clearing in ___cpu_possible_map.
> > 
> > Vegard, would you like to help test it?
> > 
> > _________Signed-off-by: Zhang Yanmin ___<yanmin_zhang@linux.intel.com>
> > 
> > ---
> > 
> > diff -Nraup linux-2.6.26-rc7/arch/x86/kernel/smpboot.c linux-2.6.26-rc7_cpuhotplug/arch/x86/kernel/smpboot.c
> > --- linux-2.6.26-rc7/arch/x86/kernel/smpboot.c	2008-06-24 09:03:54.000000000 +0800
> > +++ linux-2.6.26-rc7_cpuhotplug/arch/x86/kernel/smpboot.c	2008-06-24 09:04:45.000000000 +0800
> > @@ -996,7 +996,6 @@ do_rest:
> >  #endif
> >  		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
> >  		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
> > -		cpu_clear(cpu, cpu_possible_map);
> >  		cpu_clear(cpu, cpu_present_map);
> >  		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
> >  	}
> > 
> Andrew,
> 
> Would you like to pick up this patch? ___Rusty Russell <rusty@rustcorp.com.au> acked it.
> 

Could.  But arch/x86/kernel/smpboot.c is an x86-tree file.  I'd expect
the x86 maintainers would like a usable changelog and a Tested-by: (if
indeed Vegard tested it).


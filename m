Return-Path: <linux-kernel-owner+w=401wt.eu-S964800AbXBNXFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbXBNXFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXBNXFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:05:40 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:58353 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800AbXBNXFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:05:38 -0500
Date: Wed, 14 Feb 2007 15:03:46 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: William Cohen <wcohen@redhat.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [perfmon] 2.6.20 new perfmon code base + libpfm + pfmon
Message-ID: <20070214230346.GC12109@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070213184839.GC10031@frankl.hpl.hp.com> <45D23042.1020802@redhat.com> <45D3415B.7080104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D3415B.7080104@redhat.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Wed, Feb 14, 2007 at 12:05:31PM -0500, William Cohen wrote:

> >The oprofile patch should be made against the oprofile cvs rather than 
> >the 0.9.2 tarball. There are some files that the patch touches that are 
> >created by the autogen.sh.
> >
> >The oprofile patch doesn't build if things are configured without the 
> >"--enable-perfmon2".
> >
> >gcc -W -Wall -fno-common -Wdeclaration-after-statement 
> >-fno-omit-frame-pointer -g -O2   -o oprofiled  init.o oprofiled.o 
> >opd_stats.o opd_sfile.o opd_kernel.o opd_trans.o opd_cookie.o 
> >opd_events.o opd_mangling.o opd_perfmon.o opd_perfmon_22.o 
> >opd_perfmon_compat.o opd_anon.o liblegacy/liblegacy.a ../libabi/libabi.a 
> >../libdb/libodb.a ../libop/libop.a ../libutil/libutil.a -lpopt -liberty 
> >-ldl
> >opd_perfmon.o: In function `perfmon_init':
> >/home/wcohen/research/profiling/oprofile/oprofile-0.9.2-perfmon2/daemon/opd_perfmon.c:384: 
> >undefined reference to `do_perfmon_init'
> >collect2: ld returned 1 exit status
> >
> >-Will
> 
> Hi Stephane,
> 
> I tweaked the oprofile patch a bit so that it applies to the oprofile cvs 
> repository and builds with and without being configured with 
> --enable-perfmon2. The patch is attached.
> 
> Things that will need to be done to the patch:
> 
> -handle case where perfmon pmd/pmc registers are unavailable
> 	Is the method being used going to work for systemwide perfmon?
> 		create a thread local context then collect unavail regs.

As of now, there is enforced mutual exclusions between per-thread and system-wide.
The unavailable support is used to make the application aware that the whole PMU may
not be available, for whatever reason. For instance, today this is used when the NMI
watchdog is active. The unavailable mask will report that one counter is not available.

This will be generalized once we add a finer grain PMU register allocator underneath
perfmon (to be used by perfmon and NMI for instance). The way I envision this is that
you create the context, query what is available, assign event -> counters, load
context onto thread or CPU. That call could fail if some of the registers used became
unavailable in which case, you need to go through the procedure again.

> 	What happens if another thread using a register that is marked
> 		available in the current thread?
> -handle naming differences between oprofile events and perfmon2

This is handled in the code already today. Because I did not want to change
the event description table nor the higher level event -> counter logic of OProfile,
the mapping from Oprofile counter -> Perfmon PMC/PMD is done AFTER. With such setup,
it is hard to deal with unavailable registers detection once in perfmon code. I think
querying the unavailable register needs to happen BEFORE event-> counter assignment.
But that means that we need to provide a converter from Perfmon PMD -> OProfile
counters which is something i have not yet done.

Thanks for the patch.

-- 
-Stephane

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbZFQOPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbZFQOPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZFQOPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:15:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:52058 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZFQOPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:15:34 -0400
Cc: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <34BD6A89-A05E-40CC-A495-017BFB08B796@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
In-Reply-To: <19000.55631.802122.696927@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 5/6] perf_counter: powerpc: Add processor back-end for MPC7450 family
Date: Wed, 17 Jun 2009 09:14:58 -0500
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com> <19000.55631.802122.696927@cargo.ozlabs.ibm.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 17, 2009, at 6:53 AM, Paul Mackerras wrote:

> This adds support for the performance monitor hardware on the
> MPC7450 family of processors (7450, 7451, 7455, 7447/7457, 7447A,
> 7448), used in the later Apple G4 powermacs/powerbooks and other
> machines.  These machines have 6 hardware counters with a unique
> set of events which can be counted on each counter, with some
> events being available on multiple counters.
>
> Raw event codes for these processors are (PMC << 8) + PMCSEL.
> If PMC is non-zero then the event is that selected by the given
> PMCSEL value for that PMC (hardware counter).  If PMC is zero
> then the event selected is one of the low-numbered ones that are
> common to several PMCs.  In this case PMCSEL must be <= 22 and
> the event is what that PMCSEL value would select on PMC1 (but
> it may be placed any other PMC that has the same event for that
> PMCSEL value).
>
> For events that count cycles or occurrences that exceed a threshold,
> the threshold requested can be specified in the 0x3f000 bits of the
> raw event codes.  If the event uses the threshold multiplier bit
> and that bit should be set, that is indicated with the 0x40000 bit
> of the raw event code.
>
> This fills in some of the generic cache events.  Unfortunately there
> are quite a few blank spaces in the table, partly because these
> processors tend to count cache hits rather than cache accesses.
>
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> arch/powerpc/kernel/Makefile           |    2 +
> arch/powerpc/kernel/mpc7450-pmu.c      |  417 +++++++++++++++++++++++ 
> +++++++++
> arch/powerpc/platforms/Kconfig.cputype |    1 +
> 3 files changed, 420 insertions(+), 0 deletions(-)
> create mode 100644 arch/powerpc/kernel/mpc7450-pmu.c
>
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/ 
> Makefile
> index c5f93f0..a9f8829 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -98,6 +98,7 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
> obj-$(CONFIG_PPC_PERF_CTRS)	+= perf_counter.o
> obj64-$(CONFIG_PPC_PERF_CTRS)	+= power4-pmu.o ppc970-pmu.o power5- 
> pmu.o \
> 				   power5+-pmu.o power6-pmu.o power7-pmu.o

This should be something like:

obj64-$(CONFIG_PPC_PERF_CTRS)-$(PPC_BOOK3S_64)

> +obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o

obj32-$(CONFIG_PPC_PERF_CTRS)-$(PPC_BOOK3S_32)

Or use new Kconfig types as I suggested on patch 1/6


> obj-$(CONFIG_8XX_MINIMAL_FPEMU) += softemu8xx.o
>
> @@ -106,6 +107,7 @@ obj-y				+= iomap.o
> endif
>
> obj-$(CONFIG_PPC64)		+= $(obj64-y)
> +obj-$(CONFIG_PPC32)		+= $(obj32-y)
>
> ifneq ($(CONFIG_XMON)$(CONFIG_KEXEC),)
> obj-y				+= ppc_save_regs.o
> diff --git a/arch/powerpc/kernel/mpc7450-pmu.c b/arch/pow

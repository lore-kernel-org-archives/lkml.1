Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYK2KDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYK2KDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYK2KDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:03:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYK2KDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:03:08 -0500
Date: Sat, 29 Nov 2008 11:02:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: sparseirq enabling v4
Message-ID: <20081129100253.GD26691@elte.hu>
References: <492A1877.4090304@kernel.org> <20081124144007.GA30725@elte.hu> <492B77C5.2050502@kernel.org> <20081126074826.GI26036@elte.hu> <492D02A4.4030206@kernel.org> <20081126081724.GK26036@elte.hu> <492E0540.9010009@kernel.org> <20081128163456.GB10487@elte.hu> <4930EB7F.1080307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4930EB7F.1080307@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> impact: new feature sparseirq

> ---
>  arch/x86/Kconfig                   |   10 
>  arch/x86/include/asm/io_apic.h     |    2 
>  arch/x86/include/asm/irq_vectors.h |   11 
>  arch/x86/kernel/io_apic.c          |  625 ++++++++++++++++++++++---------------
>  arch/x86/kernel/irq.c              |    3 
>  arch/x86/kernel/irq_32.c           |    2 
>  arch/x86/kernel/irq_64.c           |    2 
>  arch/x86/kernel/irqinit_32.c       |    3 
>  arch/x86/kernel/irqinit_64.c       |    3 
>  arch/x86/kernel/setup.c            |    2 
>  drivers/char/random.c              |   22 -
>  drivers/pci/intr_remapping.c       |   76 ++++
>  drivers/pci/msi.c                  |   55 ++-
>  drivers/xen/events.c               |   12 
>  fs/proc/stat.c                     |   17 -
>  include/linux/interrupt.h          |    2 
>  include/linux/irq.h                |   54 +++
>  include/linux/irqnr.h              |   14 
>  include/linux/kernel_stat.h        |   14 
>  include/linux/msi.h                |    3 
>  include/linux/random.h             |   51 +++
>  init/main.c                        |   11 
>  kernel/irq/autoprobe.c             |   15 
>  kernel/irq/chip.c                  |    3 
>  kernel/irq/handle.c                |  187 ++++++++++-
>  kernel/irq/proc.c                  |    6 
>  kernel/irq/spurious.c              |    5 
>  27 files changed, 891 insertions(+), 319 deletions(-)

very nice!

All the structural feedback i gave seems to be addressed properly, and 
the patch has shrunk and consolidated nicely. I think we can start 
splitting it up and applying it to tip/irq/sparseirq. We might notice a 
few more details when that happens, on a per patch basis.

I started this by applying the whole patch and creating a good commit log 
entry for it. Could you please use the commit log and create a split-up 
series from it? Each main bullet point starting with " - " should go into 
a separate patch - see the commit log below.

I've pushed it out into tip/irq/sparseirq, but not yet into tip/master. 
Will rebase irq/sparseirq with the split-up series of 8-9 patches once 
you send it.

Thanks,

	Ingo


---------------->
>From 29c35c370d0ae5484c8d9e8aa2475ea6633623fc Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Fri, 28 Nov 2008 23:13:03 -0800
Subject: [PATCH] irq: sparse irq_desc[] support

Impact: new CONFIG_SPARSE_IRQ feature, which makes irq_desc[] a sparse array

To support kernels with very large NR_CPUS and NR_IRQS settings,
we need to reduce the size of irq_desc[]. On x86, when NR_CPUS is
set to 4096, the irq_desc[] array will waste megabytes of RAM,
which is not acceptable overhead to generic distro kernels.

In v2.6.28 we already introduced a generic API to make access to
the irq_desc[] array more abstract - and to allow a different
data structure to underly it. This patch finishes that process.

Core kernel changes:

 - fix missing sparseirq API changes in various bits of core kernel code
   (missing for_irq_desc primitives, missing checks for !desc, etc.)

 - introduce a new data type in the IRQ code: irq_desc_ptrs[] and its
   handling in the core IRQ code

 - detach the IRQ statistics counters from kernel_stat and
   attach it to irq_desc->kstat_irqs[] dynamically allocated
   array of pointers. (this can use percpu_alloc() in the
   future, once percpu_alloc() becomes generic enough)

 - detach the NR_IRQS array in random.c.

 - interrupt remapping: when moving an IRQ on NUMA, reallocate the irq
   descriptor so that we get proper NUMA-local memory for the descriptor,
   for the irq_cfg entry and for the kstat_irqs array.

Architectures can enable this by setting the CONFIG_SPARSE_IRQ
config switch. The x86 architecture is extended/fixed to deal
with such an irq_desc[] model:

 - io_apic irq_cfg[NR_IRQS] array is re-attached to desc->irq_chip

 - MSI virtual IRQ numbering is sanitized to go from the max upper
   end of the physical IRQ range up towards NR_IRQS - instead of
   coming down from the end of NR_IRQS.

 - re-tunes our max NR_IRQS calculations

Architectures that do not specify CONFIG_SPARSE_IRQ, do not need
to change anything - this is a transparent feature that is not
supposed to break any existing code.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

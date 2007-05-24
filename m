Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbXEXJgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbXEXJgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXEXJgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:36:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:40304 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbXEXJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:36:07 -0400
Date: Thu, 24 May 2007 11:34:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
Message-ID: <20070524093441.GP5722@kernel.dk>
References: <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com> <20070515175025.GE23798@kernel.dk> <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com> <20070517062742.GW23798@kernel.dk> <1179414911.23725.7.camel@dyn9047017100.beaverton.ibm.com> <20070518073525.GD23798@kernel.dk> <1179510664.29302.16.camel@dyn9047017100.beaverton.ibm.com> <20070521061445.GD14746@kernel.dk> <20070521063554.GF14746@kernel.dk> <1179872108.29302.55.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179872108.29302.55.camel@dyn9047017100.beaverton.ibm.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22 2007, Badari Pulavarty wrote:
> > If iommu=off works, can you try a normal boot but with this applied on
> > top of the sglist patches? That should fix gart mapping.
> > 
> > diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
> > index 2e22a3a..b16384f 100644
> > --- a/arch/x86_64/kernel/pci-gart.c
> > +++ b/arch/x86_64/kernel/pci-gart.c
> 
> Yes. With this patch + kzalloc() for ide probe took care of all my
> problems on x86-64.
> 
> But my ppc64 box is still sick :(

:-(

> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=32 NUMA pSeries
> Modules linked in: qla2xxx scsi_transport_fc
> NIP: c0000000000414a0 LR: c00000000004162c CTR: 0000000000000001
> REGS: c0000000047bb130 TRAP: 0300   Not tainted  (2.6.22-rc1)
> MSR: 8000000000001032 <ME,IR,DR>  CR: 28000022  XER: 00000008
> DAR: 0000000000000000, DSISR: 0000000040000000
> TASK = c0000000047a6aa0[0] 'swapper' THREAD: c0000000047b8000 CPU: 7
> GPR00: 0000000000000080 c0000000047bb3b0 c000000000692358 c0000000047a6aa0
> GPR04: 0000000000000000 0000000000000070 0000000000000000 c0000000005ac0b8
> GPR08: 000000000000e4b4 0000000000000001 0000000000000000 0000000000000280
> GPR12: 0000000000000020 c0000000005a3e80 0000000000000000 0000000007a8dd70
> GPR16: 0000000000000000 0000000000000000 0000000000000000 c0000000047b8000
> GPR20: 000000003b9aca00 c0000000047a6c50 0000000000000001 0000000000000000
> GPR24: d000000000909048 0001dee6d30c0d30 c000000003b7dd80 c0000000047a6aa0
> GPR28: 00000001079027ca c0000000047a6aa0 c0000000005b7cb0 c000000000472c9c
> NIP [c0000000000414a0] .dequeue_task+0x0/0x9c
> LR [c00000000004162c] .deactivate_task+0x40/0x60
> Call Trace:
> [c0000000047bb3b0] [c00000000004bccc] .printk+0x38/0x48 (unreliable)
> [c0000000047bb440] [c000000000471704] .schedule+0x1fc/0x8dc
> [c0000000047bb540] [c000000000472c9c] .schedule_timeout+0xa8/0xe8
> [c0000000047bb610] [c000000000057260] .msleep+0x20/0x38
> [c0000000047bb690] [c00000000003f5ec] .eeh_dn_check_failure+0x114/0x268
> [c0000000047bb740] [c00000000003fc64] .eeh_check_failure+0xec/0x114
> [c0000000047bb7c0] [d00000000086190c] .qla2300_fw_dump+0x1130/0x1c00 [qla2xxx]
> [c0000000047bb8a0] [d000000000858d50] .qla2300_intr_handler+0x1e8/0x60c [qla2xxx]
> [c0000000047bb950] [c000000000078368] .handle_IRQ_event+0x70/0xe4
> [c0000000047bb9f0] [c00000000007a7e0] .handle_fasteoi_irq+0x11c/0x1d0
> [c0000000047bba90] [c00000000000c178] .do_IRQ+0x90/0xec
> [c0000000047bbb10] [c000000000004790] hardware_interrupt_entry+0x18/0x1c

Not good. The qla changes are non-trivial (that hardware has a really
funky sg setup), so I may have botched a part of it. I'll review the
qla changes and get back to you.

-- 
Jens Axboe


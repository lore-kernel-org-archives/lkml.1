Return-Path: <linux-kernel-owner+w=401wt.eu-S1763509AbYBZR0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763509AbYBZR0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763204AbYBZR0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:26:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:56379 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763205AbYBZR0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:26:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BkPCtqY92mjs+RApO+juYuovexk8SGq/pZDftRiQaCSVVRU60Fv4+QoziB/HrPIH8mCVxfPxssO7/Gmn3z5Epm6ItY43T2ROaLtQ+Y/TzvX31MMnCtkzb6/S/NR65+15wrrftkNPCGt5tD1PPoC9hFQPt0PU+vCv+Ylr4wEEoQI=
Message-ID: <6101e8c40802260926p122c18f0k2615933e6abe911@mail.gmail.com>
Date: Tue, 26 Feb 2008 18:26:05 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: Linux 2.6.22.19
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20080226010559.GE26912@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080226010549.GD26912@suse.de> <20080226010559.GE26912@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank for your work in this serie or tree.

On 2/26/08, Greg KH <gregkh@suse.de> wrote:
> diff --git a/Makefile b/Makefile
> index 99c5e87..27acaf4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 22
> -EXTRAVERSION = .18
> +EXTRAVERSION = .19
>  NAME = Holy Dancing Manatees, Batman!
>
>  # *DOCUMENTATION*
> diff --git a/arch/i386/kernel/entry.S b/arch/i386/kernel/entry.S
> index 3c3c220..b7be5cf 100644
> --- a/arch/i386/kernel/entry.S
> +++ b/arch/i386/kernel/entry.S
> @@ -409,8 +409,6 @@ restore_nocheck_notrace:
>  1:	INTERRUPT_RETURN
>  .section .fixup,"ax"
>  iret_exc:
> -	TRACE_IRQS_ON
> -	ENABLE_INTERRUPTS(CLBR_NONE)
>  	pushl $0			# no error code
>  	pushl $do_iret_error
>  	jmp error_code
> diff --git a/arch/i386/kernel/ptrace.c b/arch/i386/kernel/ptrace.c
> index 0c0ceec..120a63b 100644
> --- a/arch/i386/kernel/ptrace.c
> +++ b/arch/i386/kernel/ptrace.c
> @@ -164,14 +164,22 @@ static unsigned long convert_eip_to_linear(struct
> task_struct *child, struct pt_
>  		u32 *desc;
>  		unsigned long base;
>
> -		down(&child->mm->context.sem);
> -		desc = child->mm->context.ldt + (seg & ~7);
> -		base = (desc[0] >> 16) | ((desc[1] & 0xff) << 16) | (desc[1] &
> 0xff000000);
> +		seg &= ~7UL;
>
> -		/* 16-bit code segment? */
> -		if (!((desc[1] >> 22) & 1))
> -			addr &= 0xffff;
> -		addr += base;
> +		down(&child->mm->context.sem);
> +		if (unlikely((seg >> 3) >= child->mm->context.size))
> +			addr = -1L; /* bogus selector, access would fault */
> +		else {
> +			desc = child->mm->context.ldt + seg;
> +			base = ((desc[0] >> 16) |
> +				((desc[1] & 0xff) << 16) |
> +				(desc[1] & 0xff000000));
> +
> +			/* 16-bit code segment? */
> +			if (!((desc[1] >> 22) & 1))
> +				addr &= 0xffff;
> +			addr += base;
> +		}
>  		up(&child->mm->context.sem);
>  	}
>  	return addr;
> diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
> index 90da057..4995b92 100644
> --- a/arch/i386/kernel/traps.c
> +++ b/arch/i386/kernel/traps.c
> @@ -517,10 +517,12 @@ fastcall void do_##name(struct pt_regs * regs, long
> error_code) \
>  	do_trap(trapnr, signr, str, 0, regs, error_code, NULL); \
>  }
>
> -#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr) \
> +#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr, irq) \
>  fastcall void do_##name(struct pt_regs * regs, long error_code) \
>  { \
>  	siginfo_t info; \
> +	if (irq) \
> +		local_irq_enable(); \
>  	info.si_signo = signr; \
>  	info.si_errno = 0; \
>  	info.si_code = sicode; \
> @@ -560,13 +562,13 @@ DO_VM86_ERROR( 3, SIGTRAP, "int3", int3)
>  #endif
>  DO_VM86_ERROR( 4, SIGSEGV, "overflow", overflow)
>  DO_VM86_ERROR( 5, SIGSEGV, "bounds", bounds)
> -DO_ERROR_INFO( 6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN,
> regs->eip)
> +DO_ERROR_INFO( 6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN,
> regs->eip, 0)
>  DO_ERROR( 9, SIGFPE,  "coprocessor segment overrun",
> coprocessor_segment_overrun)
>  DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
>  DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
>  DO_ERROR(12, SIGBUS,  "stack segment", stack_segment)
> -DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN,
> 0)
> -DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0)
> +DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN,
> 0, 0)
> +DO_ERROR_INFO(32, SIGSEGV, "iret exception", iret_error, ILL_BADSTK, 0, 1)
>
>  fastcall void __kprobes do_general_protection(struct pt_regs * regs,
>  					      long error_code)
> diff --git a/arch/x86_64/kernel/ptrace.c b/arch/x86_64/kernel/ptrace.c
> index 8d89d8c..7fc0e73 100644
> --- a/arch/x86_64/kernel/ptrace.c
> +++ b/arch/x86_64/kernel/ptrace.c
> @@ -102,16 +102,25 @@ unsigned long convert_rip_to_linear(struct task_struct
> *child, struct pt_regs *r
>  		u32 *desc;
>  		unsigned long base;
>
> -		down(&child->mm->context.sem);
> -		desc = child->mm->context.ldt + (seg & ~7);
> -		base = (desc[0] >> 16) | ((desc[1] & 0xff) << 16) | (desc[1] &
> 0xff000000);
> +		seg &= ~7UL;
>
> -		/* 16-bit code segment? */
> -		if (!((desc[1] >> 22) & 1))
> -			addr &= 0xffff;
> -		addr += base;
> +		down(&child->mm->context.sem);
> +		if (unlikely((seg >> 3) >= child->mm->context.size))
> +			addr = -1L; /* bogus selector, access would fault */
> +		else {
> +			desc = child->mm->context.ldt + seg;
> +			base = ((desc[0] >> 16) |
> +				((desc[1] & 0xff) << 16) |
> +				(desc[1] & 0xff000000));
> +
> +			/* 16-bit code segment? */
> +			if (!((desc[1] >> 22) & 1))
> +				addr &= 0xffff;
> +			addr += base;
> +		}
>  		up(&child->mm->context.sem);
>  	}
> +
>  	return addr;
>  }
>
> diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
> index 6dc0b01..681b76a 100644
> --- a/drivers/ata/sata_promise.c
> +++ b/drivers/ata/sata_promise.c
> @@ -51,6 +51,7 @@
>  enum {
>  	PDC_MAX_PORTS		= 4,
>  	PDC_MMIO_BAR		= 3,
> +	PDC_MAX_PRD		= LIBATA_MAX_PRD - 1, /* -1 for ASIC PRD bug workaround */
>
>  	/* register offsets */
>  	PDC_FEATURE		= 0x04, /* Feature/Error reg (per port) */
> @@ -157,7 +158,7 @@ static struct scsi_host_template pdc_ata_sht = {
>  	.queuecommand		= ata_scsi_queuecmd,
>  	.can_queue		= ATA_DEF_QUEUE,
>  	.this_id		= ATA_SHT_THIS_ID,
> -	.sg_tablesize		= LIBATA_MAX_PRD,
> +	.sg_tablesize		= PDC_MAX_PRD,
>  	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
>  	.emulated		= ATA_SHT_EMULATED,
>  	.use_clustering		= ATA_SHT_USE_CLUSTERING,
> @@ -330,8 +331,8 @@ static const struct pci_device_id pdc_ata_pci_tbl[] = {
>
>  	{ PCI_VDEVICE(PROMISE, 0x3318), board_20319 },
>  	{ PCI_VDEVICE(PROMISE, 0x3319), board_20319 },
> -	{ PCI_VDEVICE(PROMISE, 0x3515), board_20319 },
> -	{ PCI_VDEVICE(PROMISE, 0x3519), board_20319 },
> +	{ PCI_VDEVICE(PROMISE, 0x3515), board_40518 },
> +	{ PCI_VDEVICE(PROMISE, 0x3519), board_40518 },
>  	{ PCI_VDEVICE(PROMISE, 0x3d17), board_40518 },
>  	{ PCI_VDEVICE(PROMISE, 0x3d18), board_40518 },
>
> @@ -531,6 +532,84 @@ static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
>  	memcpy(buf+31, cdb, cdb_len);
>  }
>
> +/**
> + *	pdc_fill_sg - Fill PCI IDE PRD table
> + *	@qc: Metadata associated with taskfile to be transferred
> + *
> + *	Fill PCI IDE PRD (scatter-gather) table with segments
> + *	associated with the current disk command.
> + *	Make sure hardware does not choke on it.
> + *
> + *	LOCKING:
> + *	spin_lock_irqsave(host lock)
> + *
> + */
> +static void pdc_fill_sg(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct scatterlist *sg;
> +	unsigned int idx;
> +	const u32 SG_COUNT_ASIC_BUG = 41*4;
> +
> +	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
> +		return;
> +
> +	WARN_ON(qc->__sg == NULL);
> +	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
> +
> +	idx = 0;
> +	ata_for_each_sg(sg, qc) {
> +		u32 addr, offset;
> +		u32 sg_len, len;
> +
> +		/* determine if physical DMA addr spans 64K boundary.
> +		 * Note h/w doesn't support 64-bit, so we unconditionally
> +		 * truncate dma_addr_t to u32.
> +		 */
> +		addr = (u32) sg_dma_address(sg);
> +		sg_len = sg_dma_len(sg);
> +
> +		while (sg_len) {
> +			offset = addr & 0xffff;
> +			len = sg_len;
> +			if ((offset + sg_len) > 0x10000)
> +				len = 0x10000 - offset;
> +
> +			ap->prd[idx].addr = cpu_to_le32(addr);
> +			ap->prd[idx].flags_len = cpu_to_le32(len & 0xffff);
> +			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
> +
> +			idx++;
> +			sg_len -= len;
> +			addr += len;
> +		}
> +	}
> +
> +	if (idx) {
> +		u32 len = le32_to_cpu(ap->prd[idx - 1].flags_len);
> +
> +		if (len > SG_COUNT_ASIC_BUG) {
> +			u32 addr;
> +
> +			VPRINTK("Splitting last PRD.\n");
> +
> +			addr = le32_to_cpu(ap->prd[idx - 1].addr);
> +			ap->prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
> +			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx - 1, addr, SG_COUNT_ASIC_BUG);
> +
> +			addr = addr + len - SG_COUNT_ASIC_BUG;
> +			len = SG_COUNT_ASIC_BUG;
> +			ap->prd[idx].addr = cpu_to_le32(addr);
> +			ap->prd[idx].flags_len = cpu_to_le32(len);
> +			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
> +
> +			idx++;
> +		}
> +
> +		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
> +	}
> +}
> +
>  static void pdc_qc_prep(struct ata_queued_cmd *qc)
>  {
>  	struct pdc_port_priv *pp = qc->ap->private_data;
> @@ -540,7 +619,7 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
>
>  	switch (qc->tf.protocol) {
>  	case ATA_PROT_DMA:
> -		ata_qc_prep(qc);
> +		pdc_fill_sg(qc);
>  		/* fall through */
>
>  	case ATA_PROT_NODATA:
> @@ -556,11 +635,11 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
>  		break;
>
>  	case ATA_PROT_ATAPI:
> -		ata_qc_prep(qc);
> +		pdc_fill_sg(qc);
>  		break;
>
>  	case ATA_PROT_ATAPI_DMA:
> -		ata_qc_prep(qc);
> +		pdc_fill_sg(qc);
>  		/*FALLTHROUGH*/
>  	case ATA_PROT_ATAPI_NODATA:
>  		pdc_atapi_pkt(qc);
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 5acc6c4..132f76b 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3225,12 +3225,15 @@ static int alloc_cciss_hba(void)
>  	for (i = 0; i < MAX_CTLR; i++) {
>  		if (!hba[i]) {
>  			ctlr_info_t *p;
> +
>  			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
>  			if (!p)
>  				goto Enomem;
>  			p->gendisk[0] = alloc_disk(1 << NWD_SHIFT);
> -			if (!p->gendisk[0])
> +			if (!p->gendisk[0]) {
> +				kfree(p);
>  				goto Enomem;
> +			}
>  			hba[i] = p;
>  			return i;
>  		}
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index a124060..d06b652 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -20,7 +20,9 @@
>  #define PCI_DEVICE_ID_INTEL_82965G_IG       0x29A2
>  #define PCI_DEVICE_ID_INTEL_82965GM_HB      0x2A00
>  #define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
> +#define PCI_DEVICE_ID_INTEL_82965GME_HB     0x2A10
>  #define PCI_DEVICE_ID_INTEL_82965GME_IG     0x2A12
> +#define PCI_DEVICE_ID_INTEL_82945GME_HB     0x27AC
>  #define PCI_DEVICE_ID_INTEL_82945GME_IG     0x27AE
>  #define PCI_DEVICE_ID_INTEL_G33_HB          0x29C0
>  #define PCI_DEVICE_ID_INTEL_G33_IG          0x29C2
> @@ -33,7 +35,8 @@
>                   agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB
> || \
>                   agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965Q_HB
> || \
>                   agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB
> || \
> -                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB)
> +                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB
> || \
> +                 agp_bridge->dev->device ==
> PCI_DEVICE_ID_INTEL_82965GME_HB)
>
>  #define IS_G33 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G33_HB || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
> @@ -527,6 +530,7 @@ static void intel_i830_init_gtt_entries(void)
>  			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
>  			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
>  			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
> +			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB ||
>  			    IS_I965 || IS_G33)
>  				gtt_entries = MB(48) - KB(size);
>  			else
> @@ -538,6 +542,7 @@ static void intel_i830_init_gtt_entries(void)
>  			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
>  			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
>  			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
> +			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GME_HB ||
>  			    IS_I965 || IS_G33)
>  				gtt_entries = MB(64) - KB(size);
>  			else
> @@ -1848,9 +1853,9 @@ static const struct intel_driver_description {
>  		NULL, &intel_915_driver },
>  	{ PCI_DEVICE_ID_INTEL_82945G_HB, PCI_DEVICE_ID_INTEL_82945G_IG, 0, "945G",
>  		NULL, &intel_915_driver },
> -	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, 1,
> "945GM",
> +	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, 0,
> "945GM",
>  		NULL, &intel_915_driver },
> -	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, 0,
> "945GME",
> +	{ PCI_DEVICE_ID_INTEL_82945GME_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, 0,
> "945GME",
>  		NULL, &intel_915_driver },
>  	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, 0,
> "946GZ",
>  		NULL, &intel_i965_driver },
> @@ -1860,9 +1865,9 @@ static const struct intel_driver_description {
>  		NULL, &intel_i965_driver },
>  	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, 0, "965G",
>  		NULL, &intel_i965_driver },
> -	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 1,
> "965GM",
> +	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 0,
> "965GM",
>  		NULL, &intel_i965_driver },
> -	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0,
> "965GME/GLE",
> +	{ PCI_DEVICE_ID_INTEL_82965GME_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0,
> "965GME/GLE",
>  		NULL, &intel_i965_driver },
>  	{ PCI_DEVICE_ID_INTEL_7505_0, 0, 0, "E7505", &intel_7505_driver, NULL },
>  	{ PCI_DEVICE_ID_INTEL_7205_0, 0, 0, "E7205", &intel_7505_driver, NULL },
> @@ -2051,11 +2056,13 @@ static struct pci_device_id agp_intel_pci_table[] =
> {
>  	ID(PCI_DEVICE_ID_INTEL_82915GM_HB),
>  	ID(PCI_DEVICE_ID_INTEL_82945G_HB),
>  	ID(PCI_DEVICE_ID_INTEL_82945GM_HB),
> +	ID(PCI_DEVICE_ID_INTEL_82945GME_HB),
>  	ID(PCI_DEVICE_ID_INTEL_82946GZ_HB),
>  	ID(PCI_DEVICE_ID_INTEL_82965G_1_HB),
>  	ID(PCI_DEVICE_ID_INTEL_82965Q_HB),
>  	ID(PCI_DEVICE_ID_INTEL_82965G_HB),
>  	ID(PCI_DEVICE_ID_INTEL_82965GM_HB),
> +	ID(PCI_DEVICE_ID_INTEL_82965GME_HB),
>  	ID(PCI_DEVICE_ID_INTEL_G33_HB),
>  	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
>  	ID(PCI_DEVICE_ID_INTEL_Q33_HB),
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
> b/drivers/char/ipmi/ipmi_si_intf.c
> index 78e1b96..eb894f8 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -2214,7 +2214,8 @@ static int ipmi_pci_resume(struct pci_dev *pdev)
>
>  static struct pci_device_id ipmi_pci_devices[] = {
>  	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
> -	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) }
> +	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) },
> +	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, ipmi_pci_devices);
>
> diff --git a/drivers/media/video/usbvision/usbvision-cards.c
> b/drivers/media/video/usbvision/usbvision-cards.c
> index 51ab265..31db1ed 100644
> --- a/drivers/media/video/usbvision/usbvision-cards.c
> +++ b/drivers/media/video/usbvision/usbvision-cards.c
> @@ -1081,6 +1081,7 @@ struct usb_device_id usbvision_table [] = {
>  	{ USB_DEVICE(0x2304, 0x0301), .driver_info=PINNA_LINX_VD_IN_CAB_PAL },
>  	{ USB_DEVICE(0x2304, 0x0419), .driver_info=PINNA_PCTV_BUNGEE_PAL_FM },
>  	{ USB_DEVICE(0x2400, 0x4200), .driver_info=HPG_WINTV },
> +	{ },    /* terminate list */
>  };
>
>  MODULE_DEVICE_TABLE (usb, usbvision_table);
> diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
> index ab2ca63..6d2d64f 100644
> --- a/drivers/misc/sony-laptop.c
> +++ b/drivers/misc/sony-laptop.c
> @@ -2056,8 +2056,6 @@ static int sony_pic_remove(struct acpi_device *device,
> int type)
>  	struct sony_pic_ioport *io, *tmp_io;
>  	struct sony_pic_irq *irq, *tmp_irq;
>
> -	sonypi_compat_exit();
> -
>  	if (sony_pic_disable(device)) {
>  		printk(KERN_ERR DRV_PFX "Couldn't disable device.\n");
>  		return -ENXIO;
> @@ -2067,6 +2065,8 @@ static int sony_pic_remove(struct acpi_device *device,
> int type)
>  	release_region(spic_dev.cur_ioport->io.minimum,
>  			spic_dev.cur_ioport->io.address_length);
>
> +	sonypi_compat_exit();
> +
>  	sony_laptop_remove_input();
>
>  	/* pf attrs */
> @@ -2132,6 +2132,9 @@ static int sony_pic_add(struct acpi_device *device)
>  		goto err_free_resources;
>  	}
>
> +	if (sonypi_compat_init())
> +		goto err_remove_input;
> +
>  	/* request io port */
>  	list_for_each_entry(io, &spic_dev.ioports, list) {
>  		if (request_region(io->io.minimum, io->io.address_length,
> @@ -2146,7 +2149,7 @@ static int sony_pic_add(struct acpi_device *device)
>  	if (!spic_dev.cur_ioport) {
>  		printk(KERN_ERR DRV_PFX "Failed to request_region.\n");
>  		result = -ENODEV;
> -		goto err_remove_input;
> +		goto err_remove_compat;
>  	}
>
>  	/* request IRQ */
> @@ -2186,9 +2189,6 @@ static int sony_pic_add(struct acpi_device *device)
>  	if (result)
>  		goto err_remove_pf;
>
> -	if (sonypi_compat_init())
> -		goto err_remove_pf;
> -
>  	return 0;
>
>  err_remove_pf:
> @@ -2204,6 +2204,9 @@ err_release_region:
>  	release_region(spic_dev.cur_ioport->io.minimum,
>  			spic_dev.cur_ioport->io.address_length);
>
> +err_remove_compat:
> +	sonypi_compat_exit();
> +
>  err_remove_input:
>  	sony_laptop_remove_input();
>
> diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
> index cff969d..6f32a35 100644
> --- a/drivers/mtd/nand/cafe_nand.c
> +++ b/drivers/mtd/nand/cafe_nand.c
> @@ -816,7 +816,8 @@ static void __devexit cafe_nand_remove(struct pci_dev
> *pdev)
>  }
>
>  static struct pci_device_id cafe_nand_tbl[] = {
> -	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8,
> 0xFFFF0 }
> +	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8,
> 0xFFFF0 },
> +	{ 0, }
>  };
>
>  MODULE_DEVICE_TABLE(pci, cafe_nand_tbl);
> diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
> index b670b97..431269e 100644
> --- a/drivers/net/via-velocity.c
> +++ b/drivers/net/via-velocity.c
> @@ -1075,6 +1075,9 @@ static int velocity_init_rd_ring(struct velocity_info
> *vptr)
>  	int ret = -ENOMEM;
>  	unsigned int rsize = sizeof(struct velocity_rd_info) *
>  					vptr->options.numrx;
> +	int mtu = vptr->dev->mtu;
> +
> +	vptr->rx_buf_sz = (mtu <= ETH_DATA_LEN) ? PKT_BUF_SZ : mtu + 32;
>
>  	vptr->rd_info = kmalloc(rsize, GFP_KERNEL);
>  	if(vptr->rd_info == NULL)
> @@ -1733,8 +1736,6 @@ static int velocity_open(struct net_device *dev)
>  	struct velocity_info *vptr = netdev_priv(dev);
>  	int ret;
>
> -	vptr->rx_buf_sz = (dev->mtu <= 1504 ? PKT_BUF_SZ : dev->mtu + 32);
> -
>  	ret = velocity_init_rings(vptr);
>  	if (ret < 0)
>  		goto out;
> @@ -1798,6 +1799,11 @@ static int velocity_change_mtu(struct net_device
> *dev, int new_mtu)
>  		return -EINVAL;
>  	}
>
> +	if (!netif_running(dev)) {
> +		dev->mtu = new_mtu;
> +		return 0;
> +	}
> +
>  	if (new_mtu != oldmtu) {
>  		spin_lock_irqsave(&vptr->lock, flags);
>
> @@ -1808,12 +1814,6 @@ static int velocity_change_mtu(struct net_device
> *dev, int new_mtu)
>  		velocity_free_rd_ring(vptr);
>
>  		dev->mtu = new_mtu;
> -		if (new_mtu > 8192)
> -			vptr->rx_buf_sz = 9 * 1024;
> -		else if (new_mtu > 4096)
> -			vptr->rx_buf_sz = 8192;
> -		else
> -			vptr->rx_buf_sz = 4 * 1024;
>
>  		ret = velocity_init_rd_ring(vptr);
>  		if (ret < 0)
> diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
> index 027f686..02a09d5 100644
> --- a/drivers/pci/hotplug/fakephp.c
> +++ b/drivers/pci/hotplug/fakephp.c
> @@ -39,6 +39,7 @@
>  #include <linux/init.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> +#include <linux/workqueue.h>
>  #include "../pci.h"
>
>  #if !defined(MODULE)
> @@ -63,10 +64,16 @@ struct dummy_slot {
>  	struct list_head node;
>  	struct hotplug_slot *slot;
>  	struct pci_dev *dev;
> +	struct work_struct remove_work;
> +	unsigned long removed;
>  };
>
>  static int debug;
>  static LIST_HEAD(slot_list);
> +static struct workqueue_struct *dummyphp_wq;
> +
> +static void pci_rescan_worker(struct work_struct *work);
> +static DECLARE_WORK(pci_rescan_work, pci_rescan_worker);
>
>  static int enable_slot (struct hotplug_slot *slot);
>  static int disable_slot (struct hotplug_slot *slot);
> @@ -109,7 +116,7 @@ static int add_slot(struct pci_dev *dev)
>  	slot->name = &dev->dev.bus_id[0];
>  	dbg("slot->name = %s\n", slot->name);
>
> -	dslot = kmalloc(sizeof(struct dummy_slot), GFP_KERNEL);
> +	dslot = kzalloc(sizeof(struct dummy_slot), GFP_KERNEL);
>  	if (!dslot)
>  		goto error_info;
>
> @@ -164,6 +171,14 @@ static void remove_slot(struct dummy_slot *dslot)
>  		err("Problem unregistering a slot %s\n", dslot->slot->name);
>  }
>
> +/* called from the single-threaded workqueue handler to remove a slot */
> +static void remove_slot_worker(struct work_struct *work)
> +{
> +	struct dummy_slot *dslot =
> +		container_of(work, struct dummy_slot, remove_work);
> +	remove_slot(dslot);
> +}
> +
>  /**
>   * Rescan slot.
>   * Tries hard not to re-enable already existing devices
> @@ -267,11 +282,17 @@ static inline void pci_rescan(void) {
>  	pci_rescan_buses(&pci_root_buses);
>  }
>
> +/* called from the single-threaded workqueue handler to rescan all pci
> buses */
> +static void pci_rescan_worker(struct work_struct *work)
> +{
> +	pci_rescan();
> +}
>
>  static int enable_slot(struct hotplug_slot *hotplug_slot)
>  {
>  	/* mis-use enable_slot for rescanning of the pci bus */
> -	pci_rescan();
> +	cancel_work_sync(&pci_rescan_work);
> +	queue_work(dummyphp_wq, &pci_rescan_work);
>  	return -ENODEV;
>  }
>
> @@ -306,6 +327,10 @@ static int disable_slot(struct hotplug_slot *slot)
>  		err("Can't remove PCI devices with other PCI devices behind it yet.\n");
>  		return -ENODEV;
>  	}
> +	if (test_and_set_bit(0, &dslot->removed)) {
> +		dbg("Slot already scheduled for removal\n");
> +		return -ENODEV;
> +	}
>  	/* search for subfunctions and disable them first */
>  	if (!(dslot->dev->devfn & 7)) {
>  		for (func = 1; func < 8; func++) {
> @@ -328,8 +353,9 @@ static int disable_slot(struct hotplug_slot *slot)
>  	/* remove the device from the pci core */
>  	pci_remove_bus_device(dslot->dev);
>
> -	/* blow away this sysfs entry and other parts. */
> -	remove_slot(dslot);
> +	/* queue work item to blow away this sysfs entry and other parts. */
> +	INIT_WORK(&dslot->remove_work, remove_slot_worker);
> +	queue_work(dummyphp_wq, &dslot->remove_work);
>
>  	return 0;
>  }
> @@ -340,6 +366,7 @@ static void cleanup_slots (void)
>  	struct list_head *next;
>  	struct dummy_slot *dslot;
>
> +	destroy_workqueue(dummyphp_wq);
>  	list_for_each_safe (tmp, next, &slot_list) {
>  		dslot = list_entry (tmp, struct dummy_slot, node);
>  		remove_slot(dslot);
> @@ -351,6 +378,10 @@ static int __init dummyphp_init(void)
>  {
>  	info(DRIVER_DESC "\n");
>
> +	dummyphp_wq = create_singlethread_workqueue(MY_NAME);
> +	if (!dummyphp_wq)
> +		return -ENOMEM;
> +
>  	return pci_scan_buses();
>  }
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3d8c9cb..d2531dd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -895,6 +895,7 @@ static void sd_rw_intr(struct scsi_cmnd * SCpnt)
>   	unsigned int xfer_size = SCpnt->request_bufflen;
>   	unsigned int good_bytes = result ? 0 : xfer_size;
>   	u64 start_lba = SCpnt->request->sector;
> +	u64 end_lba = SCpnt->request->sector + (xfer_size / 512);
>   	u64 bad_lba;
>  	struct scsi_sense_hdr sshdr;
>  	int sense_valid = 0;
> @@ -933,26 +934,23 @@ static void sd_rw_intr(struct scsi_cmnd * SCpnt)
>  			goto out;
>  		if (xfer_size <= SCpnt->device->sector_size)
>  			goto out;
> -		switch (SCpnt->device->sector_size) {
> -		case 256:
> +		if (SCpnt->device->sector_size < 512) {
> +			/* only legitimate sector_size here is 256 */
>  			start_lba <<= 1;
> -			break;
> -		case 512:
> -			break;
> -		case 1024:
> -			start_lba >>= 1;
> -			break;
> -		case 2048:
> -			start_lba >>= 2;
> -			break;
> -		case 4096:
> -			start_lba >>= 3;
> -			break;
> -		default:
> -			/* Print something here with limiting frequency. */
> -			goto out;
> -			break;
> +			end_lba <<= 1;
> +		} else {
> +			/* be careful ... don't want any overflows */
> +			u64 factor = SCpnt->device->sector_size / 512;
> +			do_div(start_lba, factor);
> +			do_div(end_lba, factor);
>  		}
> +
> +		if (bad_lba < start_lba  || bad_lba >= end_lba)
> +			/* the bad lba was reported incorrectly, we have
> +			 * no idea where the error is
> +			 */
> +			goto out;
> +
>  		/* This computation should always be done in terms of
>  		 * the resolution of the device's medium.
>  		 */
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index 881fa49..b6fd8a7 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -433,9 +433,6 @@ static int nfs_create_rpc_client(struct nfs_client *clp,
> int proto,
>   */
>  static void nfs_destroy_server(struct nfs_server *server)
>  {
> -	if (!IS_ERR(server->client_acl))
> -		rpc_shutdown_client(server->client_acl);
> -
>  	if (!(server->flags & NFS_MOUNT_NONLM))
>  		lockd_down();	/* release rpc.lockd */
>  }
> @@ -614,16 +611,6 @@ static int nfs_init_server(struct nfs_server *server,
> const struct nfs_mount_dat
>  	server->namelen  = data->namlen;
>  	/* Create a client RPC handle for the NFSv3 ACL management interface */
>  	nfs_init_server_aclclient(server);
> -	if (clp->cl_nfsversion == 3) {
> -		if (server->namelen == 0 || server->namelen > NFS3_MAXNAMLEN)
> -			server->namelen = NFS3_MAXNAMLEN;
> -		if (!(data->flags & NFS_MOUNT_NORDIRPLUS))
> -			server->caps |= NFS_CAP_READDIRPLUS;
> -	} else {
> -		if (server->namelen == 0 || server->namelen > NFS2_MAXNAMLEN)
> -			server->namelen = NFS2_MAXNAMLEN;
> -	}
> -
>  	dprintk("<-- nfs_init_server() = 0 [new %p]\n", clp);
>  	return 0;
>
> @@ -781,6 +768,9 @@ void nfs_free_server(struct nfs_server *server)
>
>  	if (server->destroy != NULL)
>  		server->destroy(server);
> +
> +	if (!IS_ERR(server->client_acl))
> +		rpc_shutdown_client(server->client_acl);
>  	if (!IS_ERR(server->client))
>  		rpc_shutdown_client(server->client);
>
> @@ -820,6 +810,16 @@ struct nfs_server *nfs_create_server(const struct
> nfs_mount_data *data,
>  	error = nfs_probe_fsinfo(server, mntfh, &fattr);
>  	if (error < 0)
>  		goto error;
> +	if (server->nfs_client->rpc_ops->version == 3) {
> +		if (server->namelen == 0 || server->namelen > NFS3_MAXNAMLEN)
> +			server->namelen = NFS3_MAXNAMLEN;
> +		if (!(data->flags & NFS_MOUNT_NORDIRPLUS))
> +			server->caps |= NFS_CAP_READDIRPLUS;
> +	} else {
> +		if (server->namelen == 0 || server->namelen > NFS2_MAXNAMLEN)
> +			server->namelen = NFS2_MAXNAMLEN;
> +	}
> +
>  	if (!(fattr.valid & NFS_ATTR_FATTR)) {
>  		error = server->nfs_client->rpc_ops->getattr(server, mntfh, &fattr);
>  		if (error < 0) {
> @@ -1010,6 +1010,9 @@ struct nfs_server *nfs4_create_server(const struct
> nfs4_mount_data *data,
>  	if (error < 0)
>  		goto error;
>
> +	if (server->namelen == 0 || server->namelen > NFS4_MAXNAMLEN)
> +		server->namelen = NFS4_MAXNAMLEN;
> +
>  	BUG_ON(!server->nfs_client);
>  	BUG_ON(!server->nfs_client->rpc_ops);
>  	BUG_ON(!server->nfs_client->rpc_ops->file_inode_ops);
> @@ -1082,6 +1085,9 @@ struct nfs_server *nfs4_create_referral_server(struct
> nfs_clone_mount *data,
>  	if (error < 0)
>  		goto error;
>
> +	if (server->namelen == 0 || server->namelen > NFS4_MAXNAMLEN)
> +		server->namelen = NFS4_MAXNAMLEN;
> +
>  	dprintk("Referral FSID: %llx:%llx\n",
>  		(unsigned long long) server->fsid.major,
>  		(unsigned long long) server->fsid.minor);
> @@ -1141,6 +1147,9 @@ struct nfs_server *nfs_clone_server(struct nfs_server
> *source,
>  	if (error < 0)
>  		goto out_free_server;
>
> +	if (server->namelen == 0 || server->namelen > NFS4_MAXNAMLEN)
> +		server->namelen = NFS4_MAXNAMLEN;
> +
>  	dprintk("Cloned FSID: %llx:%llx\n",
>  		(unsigned long long) server->fsid.major,
>  		(unsigned long long) server->fsid.minor);
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index c27258b..db1d6b9 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -897,14 +897,13 @@ int nfs_is_exclusive_create(struct inode *dir, struct
> nameidata *nd)
>  	return (nd->intent.open.flags & O_EXCL) != 0;
>  }
>
> -static inline int nfs_reval_fsid(struct vfsmount *mnt, struct inode *dir,
> -				 struct nfs_fh *fh, struct nfs_fattr *fattr)
> +static inline int nfs_reval_fsid(struct inode *dir, const struct nfs_fattr
> *fattr)
>  {
>  	struct nfs_server *server = NFS_SERVER(dir);
>
>  	if (!nfs_fsid_equal(&server->fsid, &fattr->fsid))
> -		/* Revalidate fsid on root dir */
> -		return __nfs_revalidate_inode(server, mnt->mnt_root->d_inode);
> +		/* Revalidate fsid using the parent directory */
> +		return __nfs_revalidate_inode(server, dir);
>  	return 0;
>  }
>
> @@ -946,7 +945,7 @@ static struct dentry *nfs_lookup(struct inode *dir,
> struct dentry * dentry, stru
>  		res = ERR_PTR(error);
>  		goto out_unlock;
>  	}
> -	error = nfs_reval_fsid(nd->mnt, dir, &fhandle, &fattr);
> +	error = nfs_reval_fsid(dir, &fattr);
>  	if (error < 0) {
>  		res = ERR_PTR(error);
>  		goto out_unlock;
> @@ -1163,6 +1162,8 @@ static struct dentry
> *nfs_readdir_lookup(nfs_readdir_descriptor_t *desc)
>  	}
>  	if (!desc->plus || !(entry->fattr->valid & NFS_ATTR_FATTR))
>  		return NULL;
> +	if (name.len > NFS_SERVER(dir)->namelen)
> +		return NULL;
>  	/* Note: caller is already holding the dir->i_mutex! */
>  	dentry = d_alloc(parent, &name);
>  	if (dentry == NULL)
> diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
> index d1cbf0a..522e5ad 100644
> --- a/fs/nfs/getroot.c
> +++ b/fs/nfs/getroot.c
> @@ -175,6 +175,9 @@ next_component:
>  		path++;
>  	name.len = path - (const char *) name.name;
>
> +	if (name.len > NFS4_MAXNAMLEN)
> +		return -ENAMETOOLONG;
> +
>  eat_dot_dir:
>  	while (*path == '/')
>  		path++;
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index bd9f5a8..2219b6c 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -961,8 +961,8 @@ static int nfs_update_inode(struct inode *inode, struct
> nfs_fattr *fattr)
>  		goto out_changed;
>
>  	server = NFS_SERVER(inode);
> -	/* Update the fsid if and only if this is the root directory */
> -	if (inode == inode->i_sb->s_root->d_inode
> +	/* Update the fsid? */
> +	if (S_ISDIR(inode->i_mode)
>  			&& !nfs_fsid_equal(&server->fsid, &fattr->fsid))
>  		server->fsid = fattr->fsid;
>
> diff --git a/fs/nfs/write.c b/fs/nfs/write.c
> index af344a1..380a7ae 100644
> --- a/fs/nfs/write.c
> +++ b/fs/nfs/write.c
> @@ -710,6 +710,17 @@ int nfs_flush_incompatible(struct file *file, struct
> page *page)
>  }
>
>  /*
> + * If the page cache is marked as unsafe or invalid, then we can't rely on
> + * the PageUptodate() flag. In this case, we will need to turn off
> + * write optimisations that depend on the page contents being correct.
> + */
> +static int nfs_write_pageuptodate(struct page *page, struct inode *inode)
> +{
> +	return PageUptodate(page) &&
> +		!(NFS_I(inode)->cache_validity &
> (NFS_INO_REVAL_PAGECACHE|NFS_INO_INVALID_DATA));
> +}
> +
> +/*
>   * Update and possibly write a cached page of an NFS file.
>   *
>   * XXX: Keep an eye on generic_file_read to make sure it doesn't do bad
> @@ -730,10 +741,13 @@ int nfs_updatepage(struct file *file, struct page
> *page,
>  		(long long)(page_offset(page) +offset));
>
>  	/* If we're not using byte range locks, and we know the page
> -	 * is entirely in cache, it may be more efficient to avoid
> -	 * fragmenting write requests.
> +	 * is up to date, it may be more efficient to extend the write
> +	 * to cover the entire page in order to avoid fragmentation
> +	 * inefficiencies.
>  	 */
> -	if (PageUptodate(page) && inode->i_flock == NULL && !(file->f_mode &
> O_SYNC)) {
> +	if (nfs_write_pageuptodate(page, inode) &&
> +			inode->i_flock == NULL &&
> +			!(file->f_mode & O_SYNC)) {
>  		count = max(count + offset, nfs_page_length(page));
>  		offset = 0;
>  	}
> diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
> index b617428..0e5fa11 100644
> --- a/fs/nfsd/nfs2acl.c
> +++ b/fs/nfsd/nfs2acl.c
> @@ -41,7 +41,7 @@ static __be32 nfsacld_proc_getacl(struct svc_rqst * rqstp,
>
>  	fh = fh_copy(&resp->fh, &argp->fh);
>  	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
> -		RETURN_STATUS(nfserr_inval);
> +		RETURN_STATUS(nfserr);
>
>  	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
>  		RETURN_STATUS(nfserr_inval);
> diff --git a/fs/nfsd/nfs3acl.c b/fs/nfsd/nfs3acl.c
> index 3e3f2de..b647f2f 100644
> --- a/fs/nfsd/nfs3acl.c
> +++ b/fs/nfsd/nfs3acl.c
> @@ -37,7 +37,7 @@ static __be32 nfsd3_proc_getacl(struct svc_rqst * rqstp,
>
>  	fh = fh_copy(&resp->fh, &argp->fh);
>  	if ((nfserr = fh_verify(rqstp, &resp->fh, 0, MAY_NOP)))
> -		RETURN_STATUS(nfserr_inval);
> +		RETURN_STATUS(nfserr);
>
>  	if (argp->mask & ~(NFS_ACL|NFS_ACLCNT|NFS_DFACL|NFS_DFACLCNT))
>  		RETURN_STATUS(nfserr_inval);
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index 15809df..0898aec 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -1453,7 +1453,8 @@ nfsd4_encode_fattr(struct svc_fh *fhp, struct
> svc_export *exp,
>  	err = vfs_getattr(exp->ex_mnt, dentry, &stat);
>  	if (err)
>  		goto out_nfserr;
> -	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL)) ||
> +	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL |
> +			FATTR4_WORD0_MAXNAME)) ||
>  	    (bmval1 & (FATTR4_WORD1_SPACE_AVAIL | FATTR4_WORD1_SPACE_FREE |
>  		       FATTR4_WORD1_SPACE_TOTAL))) {
>  		err = vfs_statfs(dentry, &statfs);
> @@ -1699,7 +1700,7 @@ out_acl:
>  	if (bmval0 & FATTR4_WORD0_MAXNAME) {
>  		if ((buflen -= 4) < 0)
>  			goto out_resource;
> -		WRITE32(~(u32) 0);
> +		WRITE32(statfs.f_namelen);
>  	}
>  	if (bmval0 & FATTR4_WORD0_MAXREAD) {
>  		if ((buflen -= 8) < 0)
> diff --git a/include/linux/quicklist.h b/include/linux/quicklist.h
> index 9371c61..39b6671 100644
> --- a/include/linux/quicklist.h
> +++ b/include/linux/quicklist.h
> @@ -56,14 +56,6 @@ static inline void __quicklist_free(int nr, void
> (*dtor)(void *), void *p,
>  	struct page *page)
>  {
>  	struct quicklist *q;
> -	int nid = page_to_nid(page);
> -
> -	if (unlikely(nid != numa_node_id())) {
> -		if (dtor)
> -			dtor(p);
> -		__free_page(page);
> -		return;
> -	}
>
>  	q = &get_cpu_var(quicklist)[nr];
>  	*(void **)p = q->page;
> diff --git a/mm/memory.c b/mm/memory.c
> index f64cbf9..538f054 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -983,6 +983,8 @@ int get_user_pages(struct task_struct *tsk, struct
> mm_struct *mm,
>  	int i;
>  	unsigned int vm_flags;
>
> +	if (len <= 0)
> +		return 0;
>  	/*
>  	 * Require read or write permissions.
>  	 * If 'force' is set, we only require the "MAY" flags.
> diff --git a/mm/quicklist.c b/mm/quicklist.c
> index ae8189c..3f703f7 100644
> --- a/mm/quicklist.c
> +++ b/mm/quicklist.c
> @@ -26,9 +26,17 @@ DEFINE_PER_CPU(struct quicklist,
> quicklist)[CONFIG_NR_QUICK];
>  static unsigned long max_pages(unsigned long min_pages)
>  {
>  	unsigned long node_free_pages, max;
> +	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
> +
> +	node_free_pages =
> +#ifdef CONFIG_ZONE_DMA
> +		zone_page_state(&zones[ZONE_DMA], NR_FREE_PAGES) +
> +#endif
> +#ifdef CONFIG_ZONE_DMA32
> +		zone_page_state(&zones[ZONE_DMA32], NR_FREE_PAGES) +
> +#endif
> +		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
>
> -	node_free_pages = node_page_state(numa_node_id(),
> -			NR_FREE_PAGES);
>  	max = node_free_pages / FRACTION_OF_NODE_MEM;
>  	return max(max, min_pages);
>  }
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> b/net/netfilter/nf_conntrack_proto_tcp.c
> index 2721ff4..baff1f4 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -143,7 +143,7 @@ enum tcp_bit_set {
>   * CLOSE_WAIT:	ACK seen (after FIN)
>   * LAST_ACK:	FIN seen (after FIN)
>   * TIME_WAIT:	last ACK seen
> - * CLOSE:	closed connection
> + * CLOSE:	closed connection (RST)
>   *
>   * LISTEN state is not used.
>   *
> @@ -842,8 +842,21 @@ static int tcp_packet(struct nf_conn *conntrack,
>  	case TCP_CONNTRACK_SYN_SENT:
>  		if (old_state < TCP_CONNTRACK_TIME_WAIT)
>  			break;
> -		if ((conntrack->proto.tcp.seen[!dir].flags &
> -			IP_CT_TCP_FLAG_CLOSE_INIT)
> +		/* RFC 1122: "When a connection is closed actively,
> +		 * it MUST linger in TIME-WAIT state for a time 2xMSL
> +		 * (Maximum Segment Lifetime). However, it MAY accept
> +		 * a new SYN from the remote TCP to reopen the connection
> +		 * directly from TIME-WAIT state, if..."
> +		 * We ignore the conditions because we are in the
> +		 * TIME-WAIT state anyway.
> +		 *
> +		 * Handle aborted connections: we and the server
> +		 * think there is an existing connection but the client
> +		 * aborts it and starts a new one.
> +		 */
> +		if (((conntrack->proto.tcp.seen[dir].flags
> +		      | conntrack->proto.tcp.seen[!dir].flags)
> +		     & IP_CT_TCP_FLAG_CLOSE_INIT)
>  		    || (conntrack->proto.tcp.last_dir == dir
>  		        && conntrack->proto.tcp.last_index == TCP_RST_SET)) {
>  			/* Attempt to reopen a closed/aborted connection.
> @@ -858,16 +871,23 @@ static int tcp_packet(struct nf_conn *conntrack,
>  	case TCP_CONNTRACK_IGNORE:
>  		/* Ignored packets:
>  		 *
> +		 * Our connection entry may be out of sync, so ignore
> +		 * packets which may signal the real connection between
> +		 * the client and the server.
> +		 *
>  		 * a) SYN in ORIGINAL
>  		 * b) SYN/ACK in REPLY
>  		 * c) ACK in reply direction after initial SYN in original.
> +		 *
> +		 * If the ignored packet is invalid, the receiver will send
> +		 * a RST we'll catch below.
>  		 */
>  		if (index == TCP_SYNACK_SET
>  		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
>  		    && conntrack->proto.tcp.last_dir != dir
>  		    && ntohl(th->ack_seq) ==
>  			     conntrack->proto.tcp.last_end) {
> -			/* This SYN/ACK acknowledges a SYN that we earlier
> +			/* b) This SYN/ACK acknowledges a SYN that we earlier
>  			 * ignored as invalid. This means that the client and
>  			 * the server are both in sync, while the firewall is
>  			 * not. We kill this session and block the SYN/ACK so
> @@ -892,7 +912,7 @@ static int tcp_packet(struct nf_conn *conntrack,
>  		write_unlock_bh(&tcp_lock);
>  		if (LOG_INVALID(IPPROTO_TCP))
>  			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
> -				  "nf_ct_tcp: invalid packed ignored ");
> +				  "nf_ct_tcp: invalid packet ignored ");
>  		return NF_ACCEPT;
>  	case TCP_CONNTRACK_MAX:
>  		/* Invalid packet */
> @@ -948,8 +968,7 @@ static int tcp_packet(struct nf_conn *conntrack,
>
>  	conntrack->proto.tcp.state = new_state;
>  	if (old_state != new_state
> -	    && (new_state == TCP_CONNTRACK_FIN_WAIT
> -		|| new_state == TCP_CONNTRACK_CLOSE))
> +	    && new_state == TCP_CONNTRACK_FIN_WAIT)
>  		conntrack->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
>  	timeout = conntrack->proto.tcp.retrans >= nf_ct_tcp_max_retrans
>  		  && *tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver

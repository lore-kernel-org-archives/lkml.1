Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYLCGeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYLCGeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 01:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYLCGeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 01:34:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263AbYLCGeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 01:34:08 -0500
Date: Tue, 2 Dec 2008 22:33:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: bluesmoke-devel <bluesmoke-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@google.com>
Subject: Re: [PATCH RESEND] driver for i5400 MCH
Message-Id: <20081202223347.bf6506f1.akpm@linux-foundation.org>
In-Reply-To: <20081201194623.3ce28246@pedra.chehab.org>
References: <20081201194623.3ce28246@pedra.chehab.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008 19:46:23 -0200 Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> EDAC driver for i5400 MCH (Seaburg)
> 
> This driver adds support for i5400 MCH chipset.

checkpatch has fun with this one.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Both you and Ben Woodard are listed under MODULE_AUTHOR.  Should this
patch have Ben's Signed-off-by:?  And/or his From:?

>
> ...
>
> +/* Device 16,
> + * Function 0: System Address
> + * Function 1: Memory Branch Map, Control, Errors Register
> + * Function 2: FSB Error Registers
> + *
> + * All 3 functions of Device 16 (0,1,2) share the SAME DID
> + */
> +#ifndef PCI_DEVICE_ID_INTEL_5400_ERR

This ifndef is unneeded: PCI_DEVICE_ID_INTEL_5400_ERR _is_ defined.

What's more, it is actually bad, because if pci_ids.h were to #define
PCI_DEVICE_ID_INTEL_5400_ERR to something other than 0x4030, the ifndef
would prevent the compiler from informing us of this potential problem.

> +#define PCI_DEVICE_ID_INTEL_5400_ERR  0x4030	/* Device 16 (0,1,2) */
> +#define PCI_DEVICE_ID_INTEL_5400_FBD0 0x4035	/* Device 21 (0,1) */
> +#define PCI_DEVICE_ID_INTEL_5400_FBD1 0x4036	/* Device 21 (0,1) */
> +#endif
> +
>
> ...
>
> +/*
> + * Names to translate bit error into something useful
> + */
> +char *error_name[] = {

error_name is a global symbol.

> +	[0]  = "Memory Write error on non-redundant retry",
> +	[1]  = "Memory or FB-DIMM configuration CRC read error",
> +	/* Reserved */
> +	[3]  = "Uncorrectable Data ECC on Replay",
> +	[4]  = "Aliased Uncorrectable Non-Mirrored Demand Data ECC",
> +	/* Unsupported on i5400 */
> +	[6]  = "Aliased Uncorrectable Resilver- or Spare-Copy Data ECC",
> +	[7]  = "Aliased Uncorrectable Patrol Data ECC",
> +	[8]  = "Non-Aliased Uncorrectable Non-Mirrored Demand Data ECC",
> +	/* Unsupported */
> +	[10] = "Non-Aliased Uncorrectable Resilver- or Spare-Copy Data ECC",
> +	[11] = "Non-Aliased Uncorrectable Patrol Data ECC",
> +	[12] = "Memory Write error on first attempt",
> +	[13] = "FB-DIMM Configuration Write error on first attempt",
> +	[14] = "Memory or FB-DIMM configuration CRC read error",
> +	[15] = "Channel Failed-Over Occurred",
> +	[16] = "Correctable Non-Mirrored Demand Data ECC",
> +	/* Unsupported */
> +	[18] = "Correctable Resilver- or Spare-Copy Data ECC",
> +	[19] = "Correctable Patrol Data ECC",
> +	[20] = "FB-DIMM Northbound parity error on FB-DIMM Sync Status",
> +	[21] = "SPD protocol Error",
> +	[22] = "Non-Redundant Fast Reset Timeout",
> +	[23] = "Refresh error",
> +	[24] = "Memory Write error on redundant retry",
> +	[25] = "Redundant Fast Reset Timeout",
> +	[26] = "Correctable Counter Threshold Exceeded",
> +	[27] = "DIMM-Spare Copy Completed",
> +	[28] = "DIMM-Isolation Completed",
> +};
> +
>
> ...
>
> +/* masks for non-fatal error register */
> +#define TO_NF_MASK(a)		(((a) & EMASK_M29) | ((a) >> 3))
> +#define FROM_NF_FERR(a)		(((a) & EMASK_M29) | (((a) << 3) & ((1 << 30)-1)))

These macros will misbehave if passed an expression with side-effects. 
Not really a problem as they're only used for constructing constants. 
I guess if one was being paranoid, one could #undef them again as soon
as possible.

> +#define FERR_NF_MASK		TO_NF_MASK(ERROR_NF_MASK)
> +#define FERR_NF_CORRECTABLE	TO_NF_MASK(ERROR_NF_CORRECTABLE)
> +#define FERR_NF_DIMM_SPARE	TO_NF_MASK(ERROR_NF_DIMM_SPARE)
> +#define FERR_NF_SPD_PROTOCOL	TO_NF_MASK(ERROR_NF_SPD_PROTOCOL)
> +#define FERR_NF_NORTH_CRC	TO_NF_MASK(ERROR_NF_NORTH_CRC)
> +#define FERR_NF_RECOVERABLE	TO_NF_MASK(ERROR_NF_RECOVERABLE)
> +#define FERR_NF_UNCORRECTABLE	TO_NF_MASK(ERROR_NF_UNCORRECTABLE)
> +
>
> ...
>
> +#ifdef CONFIG_EDAC_DEBUG
> +/* MTR NUMROW */
> +static char *numrow_toString[] = {
> +	"8,192 - 13 rows",
> +	"16,384 - 14 rows",
> +	"32,768 - 15 rows",
> +	"65,536 - 16 rows"
> +};
> +
> +/* MTR NUMCOL */
> +static char *numcol_toString[] = {
> +	"1,024 - 10 columns",
> +	"2,048 - 11 columns",
> +	"4,096 - 12 columns",
> +	"reserved"
> +};

These could possibly be made const.  We don't modify them at runtime...

> +#endif
> +
>
> ...
>
> +static void i5400_proccess_non_recoverable_info(struct mem_ctl_info *mci,
> +				    struct i5400_error_info *info,
> +				    unsigned long allErrors)
> +{
> +	char msg[EDAC_MC_LABEL_LEN + 1 + 90 + 80];

202 bytes.  Tolerable, I guess.

Heaven knows why and how this dimension was chosen, and under which
circumstances it will overflow :(

It looks like such a hack that perhaps you should give up and use
kasprintf()+kfree()?

> +	int branch;
> +	int channel;
> +	int bank;
> +	int buf_id;
> +	int rank;
> +	int rdwr;
> +	int ras, cas;
> +	int errnum;
> +	char *type = NULL;
> +
> +	if (!allErrors)
> +		return;		/* if no error, return now */
> +
> +	if (allErrors &  ERROR_FAT_MASK)
> +		type = "FATAL";
> +	else if (allErrors & FERR_NF_UNCORRECTABLE)
> +		type = "NON-FATAL uncorrected";
> +	else
> +		type = "NON-FATAL recoverable";
> +
> +	/* ONLY ONE of the possible error bits will be set, as per the docs */
> +
> +	branch = extract_fbdchan_indx(info->ferr_fat_fbd);
> +	channel = branch;
> +
> +	/* Use the NON-Recoverable macros to extract data */
> +	bank = nrec_bank(info);
> +	rank = nrec_rank(info);
> +	buf_id = nrec_buf_id(info);
> +	rdwr = nrec_rdwr(info);
> +	ras = nrec_ras(info);
> +	cas = nrec_cas(info);
> +
> +	debugf0("\t\tCSROW= %d  Channels= %d,%d  (Branch= %d "
> +		"DRAM Bank= %d Buffer ID = %d rdwr= %s ras= %d cas= %d)\n",
> +		rank, channel, channel + 1, branch >> 1, bank,
> +		buf_id, rdwr_str(rdwr), ras, cas);
> +
> +	/* Only 1 bit will be on */
> +	errnum = find_first_bit(&allErrors, ARRAY_SIZE(error_name));
> +
> +	/* Form out message */
> +	snprintf(msg, sizeof(msg),
> +		 "%s (Branch=%d DRAM-Bank=%d Buffer ID = %d RDWR=%s RAS=%d CAS=%d "
> +		 "%s Err=0x%lx (%s))",
> +		 type, branch >> 1, bank, buf_id, rdwr_str(rdwr), ras, cas, type,
> +		 allErrors, error_name[errnum]);
> +
> +	/* Call the helper to output message */
> +	edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
> +}
> +
> +/*
> + * i5400_process_fatal_error_info(struct mem_ctl_info *mci,
> + * 				struct i5400_error_info *info,
> + * 				int handle_errors);
> + *
> + *	handle the Intel NON-FATAL errors, if any
> + */
> +static void i5400_process_nonfatal_error_info(struct mem_ctl_info *mci,
> +					struct i5400_error_info *info)
> +{
> +	char msg[EDAC_MC_LABEL_LEN + 1 + 90 + 80];

dittoes.

> +	unsigned long allErrors;
> +	int branch;
> +	int channel;
> +	int bank;
> +	int rank;
> +	int rdwr;
> +	int ras, cas;
> +	int errnum;
> +
> +	/* mask off the Error bits that are possible */
> +	allErrors = FROM_NF_FERR(info->ferr_nf_fbd & FERR_NF_MASK);
> +	if (!allErrors)
> +		return;		/* if no error, return now */
> +
> +	/* ONLY ONE of the possible error bits will be set, as per the docs */
> +
> +	if (allErrors & (ERROR_NF_UNCORRECTABLE | ERROR_NF_RECOVERABLE)) {
> +		i5400_proccess_non_recoverable_info(mci, info, allErrors);
> +		return;
> +	}
> +
> +	/* Correctable errors */
> +	if (allErrors & ERROR_NF_CORRECTABLE) {
> +		debugf0("\tCorrected bits= 0x%lx\n", allErrors);
> +
> +		branch = extract_fbdchan_indx(info->ferr_nf_fbd);
> +
> +		channel = 0;
> +		if (REC_ECC_LOCATOR_ODD(info->redmemb))
> +			channel = 1;
> +
> +		/* Convert channel to be based from zero, instead of
> +		 * from branch base of 0 */
> +		channel += branch;
> +
> +		bank = rec_bank(info);
> +		rank = rec_rank(info);
> +		rdwr = rec_rdwr(info);
> +		ras = rec_ras(info);
> +		cas = rec_cas(info);
> +
> +		/* Only 1 bit will be on */
> +		errnum = find_first_bit(&allErrors, ARRAY_SIZE(error_name));
> +
> +		debugf0("\t\tCSROW= %d Channel= %d  (Branch %d "
> +			"DRAM Bank= %d rdwr= %s ras= %d cas= %d)\n",
> +			rank, channel, branch >> 1, bank,
> +			rdwr_str(rdwr), ras, cas);
> +
> +		/* Form out message */
> +		snprintf(msg, sizeof(msg),
> +			 "Corrected error (Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
> +			 "CAS=%d, CE Err=0x%lx (%s))", branch >> 1, bank,
> +			 rdwr_str(rdwr), ras, cas, allErrors,
> +			error_name[errnum]);
> +
> +		/* Call the helper to output message */
> +		edac_mc_handle_fbd_ce(mci, rank, channel, msg);
> +
> +		return;
> +	}
> +
> +	/* Miscelaneous errors */
> +	errnum = find_first_bit(&allErrors, ARRAY_SIZE(error_name));
> +
> +	branch = extract_fbdchan_indx(info->ferr_nf_fbd);
> +
> +	i5400_mc_printk(mci, KERN_EMERG,
> +			"Non-Fatal misc error (Branch=%d Err=%#lx (%s))",
> +			branch >> 1, allErrors, error_name[errnum]);
> +}
> +
>
> ...
>
> +static void i5400_put_devices(struct mem_ctl_info *mci)
> +{
> +	struct i5400_pvt *pvt;
> +
> +	pvt = mci->pvt_info;
> +
> +	/* Decrement usage count for devices */
> +	if (pvt->branch_1)
> +		pci_dev_put(pvt->branch_1);
> +
> +	if (pvt->branch_0)
> +		pci_dev_put(pvt->branch_0);
> +
> +	if (pvt->fsb_error_regs)
> +		pci_dev_put(pvt->fsb_error_regs);
> +
> +	if (pvt->branchmap_werrors)
> +		pci_dev_put(pvt->branchmap_werrors);

pci_dev_put(NULL) is legal.

> +}
> +
>
> ...
>
> +static int i5400_probe1(struct pci_dev *pdev, int dev_idx)
> +{
> +	struct mem_ctl_info *mci;
> +	struct i5400_pvt *pvt;
> +	int num_channels;
> +	int num_dimms_per_channel;
> +	int num_csrows;
> +
> +	debugf0("MC: " __FILE__ ": %s(), pdev bus %u dev=0x%x fn=0x%x\n",
> +		__func__,
> +		pdev->bus->number,
> +		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
> +
> +	/* We only are looking for func 0 of the set */
> +	if (PCI_FUNC(pdev->devfn) != 0)
> +		return -ENODEV;
> +
> +	/* Ask the devices for the number of CSROWS and CHANNELS so
> +	 * that we can calculate the memory resources, etc
> +	 *
> +	 * The Chipset will report what it can handle which will be greater
> +	 * or equal to what the motherboard manufacturer will implement.
> +	 *
> +	 * As we don't have a motherboard identification routine to determine
> +	 * actual number of slots/dimms per channel, we thus utilize the
> +	 * resource as specified by the chipset. Thus, we might have
> +	 * have more DIMMs per channel than actually on the mobo, but this
> +	 * allows the driver to support upto the chipset max, without
> +	 * some fancy mobo determination.
> +	 */
> +	i5400_get_dimm_and_channel_counts(pdev, &num_dimms_per_channel,
> +					&num_channels);
> +	num_csrows = num_dimms_per_channel * 2;
> +
> +	debugf0("MC: %s(): Number of - Channels= %d  DIMMS= %d  CSROWS= %d\n",
> +		__func__, num_channels, num_dimms_per_channel, num_csrows);
> +
> +	/* allocate a new MC control structure */
> +	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
> +
> +	if (mci == NULL)
> +		return -ENOMEM;
> +
> +	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
> +
> +	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
> +
> +	pvt = mci->pvt_info;
> +	pvt->system_address = pdev;	/* Record this device in our private */
> +	pvt->maxch = num_channels;
> +	pvt->maxdimmperch = num_dimms_per_channel;
> +
> +	/* 'get' the pci devices we want to reserve for our use */
> +	if (i5400_get_devices(mci, dev_idx))
> +		goto fail0;
> +
> +	/* Time to get serious */
> +	i5400_get_mc_regs(mci);	/* retrieve the hardware registers */
> +
> +	mci->mc_idx = 0;
> +	mci->mtype_cap = MEM_FLAG_FB_DDR2;
> +	mci->edac_ctl_cap = EDAC_FLAG_NONE;
> +	mci->edac_cap = EDAC_FLAG_NONE;
> +	mci->mod_name = "i5400_edac.c";
> +	mci->mod_ver = I5400_REVISION;
> +	mci->ctl_name = i5400_devs[dev_idx].ctl_name;

This is a bit strange.  i5400_devs[] has a single entry, so what's the
point in indexing it with `dev_idx', which MUST have a value of zero
anyway?

> +	mci->dev_name = pci_name(pdev);
> +	mci->ctl_page_to_phys = NULL;
> +
> +	/* Set the function pointer to an actual operation function */
> +	mci->edac_check = i5400_check_error;
> +
> +	/* initialize the MC control structure 'csrows' table
> +	 * with the mapping and control information */
> +	if (i5400_init_csrows(mci)) {
> +		debugf0("MC: Setting mci->edac_cap to EDAC_FLAG_NONE\n"
> +			"    because i5400_init_csrows() returned nonzero "
> +			"value\n");
> +		mci->edac_cap = EDAC_FLAG_NONE;	/* no csrows found */
> +	} else {
> +		debugf1("MC: Enable error reporting now\n");
> +		i5400_enable_error_reporting(mci);
> +	}
> +
> +	/* add this new MC control structure to EDAC's list of MCs */
> +	if (edac_mc_add_mc(mci)) {
> +		debugf0("MC: " __FILE__
> +			": %s(): failed edac_mc_add_mc()\n", __func__);
> +		/* FIXME: perhaps some code should go here that disables error
> +		 * reporting if we just enabled it
> +		 */
> +		goto fail1;
> +	}
> +
> +	i5400_clear_error(mci);
> +
> +	/* allocating generic PCI control info */
> +	i5400_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
> +	if (!i5400_pci) {
> +		printk(KERN_WARNING
> +			"%s(): Unable to create PCI control\n",
> +			__func__);
> +		printk(KERN_WARNING
> +			"%s(): PCI error report via EDAC not setup\n",
> +			__func__);
> +	}
> +
> +	return 0;
> +
> +	/* Error exit unwinding stack */
> +fail1:
> +
> +	i5400_put_devices(mci);
> +
> +fail0:
> +	edac_mc_free(mci);
> +	return -ENODEV;
> +}
> +
>
> ...
>
> +static struct pci_driver i5400_driver = {
> +	.name = KBUILD_BASENAME,
> +	.probe = i5400_init_one,
> +	.remove = __devexit_p(i5400_remove_one),
> +	.id_table = i5400_pci_tbl,
> +};

Only one other driver in the tree uses KBUILD_BASENAME, and that is
drivers/edac/i5100_edac.c, from which I suspect the above was copied.

I suspect that something is being done wrongly here.

>
> ...
>


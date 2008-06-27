Return-Path: <linux-kernel-owner+w=401wt.eu-S1763436AbYF0XPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763436AbYF0XPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765707AbYF0XGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 19:06:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765598AbYF0XGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 19:06:18 -0400
Date: Fri, 27 Jun 2008 16:05:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/13] EDAC i5100 new intel chipset driver
Message-Id: <20080627160551.d66547db.akpm@linux-foundation.org>
In-Reply-To: <48652da5.s2xXeJUyQ6DrqarN%dougthompson@xmission.com>
References: <48652da5.s2xXeJUyQ6DrqarN%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 12:12:53 -0600
dougthompson@xmission.com wrote:

> From:	Arthur Jones <ajones@riverbed.com>
> 
> Applied to linux-2.6.26-rc5-mm3
> 
> Preliminary support for the Intel 5100 MCH.  CE and UE
> errors are reported along with the current DIMM label
> information and other memory parameters.
> 
> Reasons why this is preliminary:
> 
> 1)  This chip has 2 independent memory controllers which,
> for best perforance, use interleaved accesses to the DDR2
> memory.  This architecture does not map very well to the
> current edac data structures which depend on symmetric
> channel access to the interleaved data.  Without core changes,
> the best I could do for now is to map both memory controllers
> to different csrows (first all ranks of controller 0,
> then all ranks of controller 1).  Someone much more
> familiar with the edac core than I will probably need to
> come up with a more general data structure to handle the
> interleaving and de-interleaving of the two memory controllers.
> 
> 2)  I have not yet tackled the de-interleaving of the
> rank/controller address space into the physical address
> space of the CPU.  There is nothing fundamentally missing,
> it is just ending up to be a lot of code, and I'd rather
> keep it separate for now, esp since it doesn't work yet...
> 
> 3)  The code depends on a particular i5100 chip select
> to DIMM mainboard chip select mapping.  This mapping
> seems obvious to me in order to support dual and single
> ranked memory, but it is not unique and DIMM labels
> could be wrong on other mainboards.  There is no way
> to query this mapping that I know of.
> 
> 4)  The code requires that the i5100 is in 32GB mode.
> Only 4 ranks per controller, 2 ranks per DIMM are
> supported.  I do not have hardware (nor do I expect
> to have hardware anytime soon) for the 48GB (6 ranks
> per controller) mode.
> 
> 5)  The serial presence detect code should be broken
> out into a "real" i2c driver so that decode-dimms.pl
> can work.
> 
> Signed-off-by:	Arthur Jones <ajones@riverbed.com>
> Signed-off-by:	Doug Thompson <dougthompson@xmission.com>

A single space after the colon is conventional.

>
> ...
>
> +static unsigned long i5100_ctl_page_to_phys(struct mem_ctl_info *mci,
> +					    unsigned long cntlr_addr)
> +{
> +	const struct i5100_priv *priv = mci->pvt_info;
> +
> +	if (cntlr_addr < priv->tolm)
> +		return cntlr_addr;
> +
> +	return (1ULL << 32) + (cntlr_addr - priv->tolm);

Strange to use 1ULL for an unsigned long.

And it's broken on 32-bit, but that's probably inapplicable tothis
driver.

> +}
> +
> +static const char *i5100_err_msg(unsigned err)
> +{
> +	const char *merrs[] = {
> +		"unknown", /* 0 */
> +		"uncorrectable data ECC on replay", /* 1 */
> +		"unknown", /* 2 */
> +		"unknown", /* 3 */
> +		"aliased uncorrectable demand data ECC", /* 4 */
> +		"aliased uncorrectable spare-copy data ECC", /* 5 */
> +		"aliased uncorrectable patrol data ECC", /* 6 */
> +		"unknown", /* 7 */
> +		"unknown", /* 8 */
> +		"unknown", /* 9 */
> +		"non-aliased uncorrectable demand data ECC", /* 10 */
> +		"non-aliased uncorrectable spare-copy data ECC", /* 11 */
> +		"non-aliased uncorrectable patrol data ECC", /* 12 */
> +		"unknown", /* 13 */
> +		"correctable demand data ECC", /* 14 */
> +		"correctable spare-copy data ECC", /* 15 */
> +		"correctable patrol data ECC", /* 16 */
> +		"unknown", /* 17 */
> +		"SPD protocol error", /* 18 */
> +		"unknown", /* 19 */
> +		"spare copy initiated", /* 20 */
> +		"spare copy completed", /* 21 */
> +	};

The compiler will need to assemble thisarray onthe stack each time this
funtion is called.  Should be static.

> +	unsigned i;
> +
> +	for (i = 0; i < ARRAY_SIZE(merrs); i++)
> +		if (1 << i & err)
> +			return merrs[i];
> +
> +	return "none";
> +}
> +
>
> ...
>
> +static void i5100_read_log(struct mem_ctl_info *mci, int ctlr,
> +			   u32 ferr, u32 nerr)
> +{
> +	struct i5100_priv *priv = mci->pvt_info;
> +	struct pci_dev *pdev = (ctlr) ? priv->ch1mm : priv->ch0mm;
> +	u32 dw;
> +	u32 dw2;
> +	unsigned syndrome = 0;
> +	unsigned ecc_loc = 0;
> +	unsigned merr;
> +	unsigned bank;
> +	unsigned rank;
> +	unsigned cas;
> +	unsigned ras;
> +
> +	pci_read_config_dword(pdev, I5100_VALIDLOG, &dw);
> +
> +	if (I5100_VALIDLOG_REDMEMVALID(dw)) {

I WONDER WHY THAT "FUNCTION" IS IN UPPER CASE?

A lower-cased inlined C function would be nicer..

> +		pci_read_config_dword(pdev, I5100_REDMEMA, &dw2);
> +		syndrome = I5100_REDMEMA_SYNDROME(dw2);
> +		pci_read_config_dword(pdev, I5100_REDMEMB, &dw2);
> +		ecc_loc = I5100_REDMEMB_ECC_LOCATOR(dw2);
> +	}
> +
> +	if (I5100_VALIDLOG_RECMEMVALID(dw)) {
> +		const char *msg;
> +
> +		pci_read_config_dword(pdev, I5100_RECMEMA, &dw2);
> +		merr = I5100_RECMEMA_MERR(dw2);
> +		bank = I5100_RECMEMA_BANK(dw2);
> +		rank = I5100_RECMEMA_RANK(dw2);
> +
> +		pci_read_config_dword(pdev, I5100_RECMEMB, &dw2);
> +		cas = I5100_RECMEMB_CAS(dw2);
> +		ras = I5100_RECMEMB_RAS(dw2);
> +
> +		/* FIXME:  not really sure if this is what merr is...
> +		 */
> +		if (!merr)
> +			msg = i5100_err_msg(ferr);
> +		else
> +			msg = i5100_err_msg(nerr);
> +
> +		i5100_handle_ce(mci, ctlr, bank, rank, syndrome, cas, ras, msg);
> +	}
> +
> +	if (I5100_VALIDLOG_NRECMEMVALID(dw)) {
> +		const char *msg;
> +
> +		pci_read_config_dword(pdev, I5100_NRECMEMA, &dw2);
> +		merr = I5100_NRECMEMA_MERR(dw2);
> +		bank = I5100_NRECMEMA_BANK(dw2);
> +		rank = I5100_NRECMEMA_RANK(dw2);
> +
> +		pci_read_config_dword(pdev, I5100_NRECMEMB, &dw2);
> +		cas = I5100_NRECMEMB_CAS(dw2);
> +		ras = I5100_NRECMEMB_RAS(dw2);
> +
> +		/* FIXME:  not really sure if this is what merr is...
> +		 */
> +		if (!merr)
> +			msg = i5100_err_msg(ferr);
> +		else
> +			msg = i5100_err_msg(nerr);
> +
> +		i5100_handle_ue(mci, ctlr, bank, rank, syndrome, cas, ras, msg);
> +	}
> +
> +	pci_write_config_dword(pdev, I5100_VALIDLOG, dw);
> +}
> +
>
> ...
>
> +static unsigned long __devinit i5100_npages(struct mem_ctl_info *mci,
> +					    int csrow)
> +{
> +	struct i5100_priv *priv = mci->pvt_info;
> +	const unsigned ctlr_rank = i5100_csrow_to_rank(mci, csrow);
> +	const unsigned ctlr = i5100_csrow_to_cntlr(mci, csrow);
> +	unsigned addr_lines;
> +
> +	/* dimm present? */
> +	if (!priv->mtr[ctlr][ctlr_rank].present)
> +		return 0ULL;
> +
> +	addr_lines =
> +		I5100_DIMM_ADDR_LINES +
> +		priv->mtr[ctlr][ctlr_rank].numcol +
> +		priv->mtr[ctlr][ctlr_rank].numrow +
> +		priv->mtr[ctlr][ctlr_rank].numbank;
> +
> +	return (unsigned long)
> +		((unsigned long long) (1ULL << addr_lines) / PAGE_SIZE);

OK, the ULL here might make sense.

> +}
> +
>
> ...
>
> +static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
> +{
> +	int i;
> +	unsigned long total_pages = 0UL;
> +	struct i5100_priv *priv = mci->pvt_info;
> +
> +	for (i = 0; i < mci->nr_csrows; i++) {
> +		const unsigned long npages = i5100_npages(mci, i);
> +		const unsigned cntlr = i5100_csrow_to_cntlr(mci, i);
> +		const unsigned rank = i5100_csrow_to_rank(mci, i);
> +
> +		if (!npages)
> +			continue;
> +
> +		/*
> +		 * FIXME: these two are totally bogus -- I don't see how to
> +		 * map them correctly to this structure...
> +		 */

?

> +		mci->csrows[i].first_page = total_pages;
> +		mci->csrows[i].last_page = total_pages + npages - 1;
> +		mci->csrows[i].page_mask = 0UL;
> +
> +		mci->csrows[i].nr_pages = npages;
> +		mci->csrows[i].grain = 32;
> +		mci->csrows[i].csrow_idx = i;
> +		mci->csrows[i].dtype =
> +			(priv->mtr[cntlr][rank].width == 4) ? DEV_X4 : DEV_X8;
> +		mci->csrows[i].ue_count = 0;
> +		mci->csrows[i].ce_count = 0;
> +		mci->csrows[i].mtype = MEM_RDDR2;
> +		mci->csrows[i].edac_mode = EDAC_SECDED;
> +		mci->csrows[i].mci = mci;
> +		mci->csrows[i].nr_channels = 1;
> +		mci->csrows[i].channels[0].chan_idx = 0;
> +		mci->csrows[i].channels[0].ce_count = 0;
> +		mci->csrows[i].channels[0].csrow = mci->csrows + i;
> +		snprintf(mci->csrows[i].channels[0].label,
> +			 sizeof(mci->csrows[i].channels[0].label),
> +			 "DIMM%u", i5100_rank_to_slot(mci, cntlr, rank));
> +
> +		total_pages += npages;
> +	}
> +}
> +
>
> ...
>
> +static int __devinit i5100_init_one(struct pci_dev *pdev,
> +				    const struct pci_device_id *id)
> +{
> +	int rc;
> +	struct mem_ctl_info *mci;
> +	struct i5100_priv *priv;
> +	struct pci_dev *ch0mm, *ch1mm;
> +	int ret = 0;
> +	u32 dw;
> +	int ranksperch;
> +
> +	if (PCI_FUNC(pdev->devfn) != 1)
> +		return -ENODEV;
> +
> +	rc = pci_enable_device(pdev);
> +	if (rc < 0) {
> +		ret = rc;
> +		goto bail;
> +	}
> +
> +	/* figure out how many ranks, from strapped state of 48GB_Mode input */
> +	pci_read_config_dword(pdev, I5100_MS, &dw);
> +	ranksperch = !!(dw & (1 << 8)) * 2 + 4;
> +
> +	if (ranksperch != 4) {
> +		/* FIXME: get 6 ranks / controller to work - need hw... */
> +		printk(KERN_INFO "i5100_edac: unsupported configuration.\n");
> +		ret = -ENODEV;
> +		goto bail;
> +	}
> +
> +	/* device 21, func 0, Channel 0 Memory Map, Error Flag/Mask, etc... */
> +	ch0mm = pci_get_device_func(PCI_VENDOR_ID_INTEL,
> +				    PCI_DEVICE_ID_INTEL_5100_21, 0);
> +	if (!ch0mm)
> +		return -ENODEV;
> +
> +	rc = pci_enable_device(ch0mm);
> +	if (rc < 0) {
> +		ret = rc;
> +		goto bail_ch0;
> +	}
> +
> +	/* device 22, func 0, Channel 1 Memory Map, Error Flag/Mask, etc... */
> +	ch1mm = pci_get_device_func(PCI_VENDOR_ID_INTEL,
> +				    PCI_DEVICE_ID_INTEL_5100_22, 0);
> +	if (!ch1mm) {
> +		ret = -ENODEV;
> +		goto bail_ch0;
> +	}
> +
> +	rc = pci_enable_device(ch1mm);
> +	if (rc < 0) {
> +		ret = rc;
> +		goto bail_ch1;
> +	}
> +
> +	mci = edac_mc_alloc(sizeof(*priv), ranksperch * 2, 1, 0);
> +	if (!mci) {
> +		ret = -ENOMEM;
> +		goto bail_ch1;

No pci_disable_device() needed?

> +	}
> +
> +	mci->dev = &pdev->dev;
> +
> +	priv = mci->pvt_info;
> +	priv->ranksperctlr = ranksperch;
> +	priv->mc = pdev;
> +	priv->ch0mm = ch0mm;
> +	priv->ch1mm = ch1mm;
> +
> +	i5100_init_dimm_layout(pdev, mci);
> +	i5100_init_interleaving(pdev, mci);
> +
> +	mci->mtype_cap = MEM_FLAG_FB_DDR2;
> +	mci->edac_ctl_cap = EDAC_FLAG_SECDED;
> +	mci->edac_cap = EDAC_FLAG_SECDED;
> +	mci->mod_name = "i5100_edac.c";
> +	mci->mod_ver = "not versioned";
> +	mci->ctl_name = "i5100";
> +	mci->dev_name = pci_name(pdev);
> +	mci->ctl_page_to_phys = i5100_ctl_page_to_phys;
> +
> +	mci->edac_check = i5100_check_error;
> +
> +	i5100_init_csrows(mci);
> +
> +	/* this strange construction seems to be in every driver, dunno why */
> +	switch (edac_op_state) {
> +	case EDAC_OPSTATE_POLL:
> +	case EDAC_OPSTATE_NMI:
> +		break;
> +	default:
> +		edac_op_state = EDAC_OPSTATE_POLL;
> +		break;
> +	}
> +
> +	if (edac_mc_add_mc(mci)) {
> +		ret = -ENODEV;
> +		goto bail_mc;
> +	}
> +
> +	goto bail;
> +
> +bail_mc:
> +	edac_mc_free(mci);
> +
> +bail_ch1:
> +	pci_dev_put(ch1mm);
> +
> +bail_ch0:
> +	pci_dev_put(ch0mm);
> +
> +bail:
> +	return ret;
> +}
> +
>
> ...
>


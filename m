Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbZEHJk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbZEHJk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZEHJkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:40:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58702 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbZEHJkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:40:16 -0400
Date: Fri, 8 May 2009 06:39:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>,
       <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <aris@redhat.com>, edt@aei.ca, <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 15/21] amd64_edac: add F10h-and-later methods-p3
Message-ID: <20090508063900.0bf2042a@pedra.chehab.org>
In-Reply-To: <1241704183-29223-16-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
	<1241704183-29223-16-git-send-email-borislav.petkov@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 7 May 2009 15:49:37 +0200
Borislav Petkov <borislav.petkov@amd.com> escreveu:

> From: Doug Thompson <dougthompson@xmission.com>
> 
> Borislav: cleanup, remove StinkyIdentifiers, simplify logic
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>


> ---
>  drivers/edac/amd64_edac.c |  292 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 288 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 3dc04c0..a805554 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1554,6 +1554,10 @@ static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
>  			pvt->dram_ctl_select_high);
>  }
>  
> +/*
> + * determine channel based on the interleaving mode: F10h BKDG, 2.8.9 Memory
> + * Interleaving Modes.
> + */
>  static u32 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
>  				int hi_range_sel, u32 intlv_en)
>  {
> @@ -1564,6 +1568,9 @@ static u32 f10_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
>  	else if (hi_range_sel)
>  		cs = dct_sel_high;
>  	else if (dct_interleave_enabled(pvt)) {
> +		/*
> +		 * see F2x110[DctSelIntLvAddr] - channel interleave mode
> +		 */
>  		if (dct_sel_interleave_addr(pvt) == 0)
>  			cs = sys_addr >> 6 & 1;
>  		else if ((dct_sel_interleave_addr(pvt) >> 1) & 1) {
> @@ -1601,22 +1608,25 @@ static inline u32 f10_map_intlv_en_to_shift(u32 intlv_en)
>  	return 0;
>  }
>  
> -static inline u64 f10_determine_base_addr_offset(u64 sys_addr, int hi_range_sel,
> +/*
> + * See F10h BKDG, 2.8.10.2 DctSelBaseOffset Programming
> + */
> +static inline u64 f10_get_base_addr_offset(u64 sys_addr, int hi_range_sel,
>  						 u32 dct_sel_base_addr,
>  						 u64 dct_sel_base_off,
> -						 u32 hole_en, u32 hole_off,
> +						 u32 hole_valid, u32 hole_off,
>  						 u64 dram_base)
>  {
>  	u64 chan_off;
>  
>  	if (hi_range_sel) {
>  		if ((!dct_sel_base_addr & 0xFFFF0000) &&
> -		   (hole_en & 1) && (sys_addr >= 0x100000000ULL))
> +		    hole_valid && (sys_addr >= 0x100000000ULL))
>  			chan_off = hole_off << 16;
>  		else
>  			chan_off = dct_sel_base_off;
>  	} else {
> -		if ((hole_en & 1) && (sys_addr >= 0x100000000ULL))
> +		if (hole_valid && (sys_addr >= 0x100000000ULL))
>  			chan_off = hole_off << 16;
>  		else
>  			chan_off = dram_base & 0xFFFFF8000000ULL;
> @@ -1724,4 +1734,278 @@ static int f10_lookup_addr_in_dct(u32 in_addr, u32 nid, u32 cs)
>  	return cs_found;
>  }
>  
> +/*
> + * f10_match_to_this_node
> + *
> + * For a given 'DramRange' value, check if 'SystemAddr' fall within this value
> + */
> +static int f10_match_to_this_node(struct amd64_pvt *pvt, int dram_range,
> +				  u64 sys_addr, int *nid, int *chan_sel)
> +{
> +	int node_id, cs_found = -EINVAL, high_range = 0;
> +	u32 intlv_en, intlv_sel, intlv_shift, hole_off;
> +	u32 hole_valid, tmp, dct_sel_base, channel;
> +	u64 dram_base, chan_addr;
> +
> +	/* DRAM base and limit values for this DRAM instance */
> +	dram_base = pvt->dram_base[dram_range];
> +	intlv_en = pvt->dram_IntlvEn[dram_range];
> +
> +	node_id = pvt->dram_DstNode[dram_range];
> +	intlv_sel = pvt->dram_IntlvSel[dram_range];
> +
> +	debugf1("%s(dram=%d) Base=0x%llx SystemAddr= 0x%llx Limit=0x%llx\n",
> +		__func__, dram_range, dram_base, sys_addr,
> +		pvt->dram_limit[dram_range]);
> +
> +	/*
> +	 * This assumes that one node's DHAR is the same as all the other
> +	 * nodes' DHAR.
> +	 */
> +	hole_off = (pvt->dhar & 0x0000FF80);
> +	hole_valid = (pvt->dhar & 0x1);
> +
> +	debugf1("   HoleOffset=0x%x  HoleValid=0x%x IntlvSel=0x%x\n",
> +			hole_off, hole_valid, intlv_sel);
> +
> +	if (intlv_en ||
> +	    (intlv_sel != ((sys_addr >> 12) & intlv_en)))
> +		return -EINVAL;
> +
> +	dct_sel_base = dct_sel_baseaddr(pvt);
> +
> +	/*
> +	 * check whether addresses >= DctSelBaseAddr[47:27] are to be used to
> +	 * select between DCT0 and DCT1.
> +	 */
> +	if (dct_high_range_enabled(pvt) &&
> +	   !dct_ganging_enabled(pvt) &&
> +	   ((sys_addr >> 27) >= (dct_sel_base >> 11)))
> +		high_range = 1;
> +
> +	channel = f10_determine_channel(pvt, sys_addr, high_range, intlv_en);
> +
> +	chan_addr = f10_get_base_addr_offset(sys_addr, high_range, dct_sel_base,
> +					     pvt->dram_ctl_select_high << 16,
> +					     hole_valid, hole_off, dram_base);
> +
> +	intlv_shift = f10_map_intlv_en_to_shift(intlv_en);
> +
> +	/* remove Node ID (in case of memory interleaving) */
> +	tmp = chan_addr & 0xFC0;
> +
> +	chan_addr = ((chan_addr >> intlv_shift) & 0xFFFFFFFFF000ULL) | tmp;
> +
> +	/* remove channel interleave and hash */
> +	if (dct_interleave_enabled(pvt) &&
> +	   !dct_high_range_enabled(pvt) &&
> +	   !dct_ganging_enabled(pvt)) {
> +		if (dct_sel_interleave_addr(pvt) != 1)
> +			chan_addr = (chan_addr >> 1) & 0xFFFFFFFFFFFFFFC0ULL;
> +		else {
> +			tmp = chan_addr & 0xFC0;
> +			chan_addr = ((chan_addr & 0xFFFFFFFFFFFFC000ULL) >> 1)
> +					| tmp;
> +		}
> +	}
> +
> +	debugf1("   (ChannelAddrLong=0x%llx) >> 8 becomes InputAddr=0x%x\n",
> +		chan_addr, (u32)(chan_addr >> 8));
> +
> +	cs_found = f10_lookup_addr_in_dct(chan_addr >> 8, node_id, channel);
> +
> +	if (cs_found >= 0) {
> +		*nid = node_id;
> +		*chan_sel = channel;
> +	}
> +	return cs_found;
> +}
> +
> +static int f10_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
> +				       int *node, int *chan_sel)
> +{
> +	int dram_range, cs_found = -EINVAL;
> +	u64 dram_base, dram_limit;
> +
> +	for (dram_range = 0; dram_range < DRAM_REG_COUNT; dram_range++) {
> +
> +		if (!pvt->dram_rw_en[dram_range])
> +			continue;
> +
> +		dram_base = pvt->dram_base[dram_range];
> +		dram_limit = pvt->dram_limit[dram_range];
> +
> +		if ((dram_base <= sys_addr) && (sys_addr <= dram_limit)) {
> +
> +			cs_found = f10_match_to_this_node(pvt, dram_range,
> +							  sys_addr, node,
> +							  chan_sel);
> +			if (cs_found >= 0)
> +				break;
> +		}
> +	}
> +	return cs_found;
> +}
> +
> +/*
> + * f10_map_sysaddr_to_csrow
> + *
> + *	This the F10 reference code from AMD to
> + *	map a SystemAddress to NodeID, CSROW, Channel
> + *
> + *	See the Family 10h BKDG (with bug fixes in the code from AMD)
> + *
> + *	The SystemAddress is usually an error address received from the
> + *	hardware error detector.
> + */
> +static void f10_map_sysaddr_to_csrow(struct mem_ctl_info *mci,
> +				     struct amd64_error_info_regs *info,
> +				     u64 sys_addr)
> +{
> +	struct amd64_pvt *pvt = mci->pvt_info;
> +	u32 page, offset;
> +	unsigned short syndrome;
> +	int nid, csrow, chan = 0;
> +
> +	csrow = f10_translate_sysaddr_to_cs(pvt, sys_addr, &nid, &chan);
> +
> +	if (csrow >= 0) {
> +		error_address_to_page_and_offset(sys_addr, &page, &offset);
> +
> +		syndrome = EXTRACT_HIGH_SYNDROME(info->nbsl) << 8;
> +		syndrome |= EXTRACT_LOW_SYNDROME(info->nbsh);
> +
> +		/* Is CHIPKILL ON?
> +		 * If so, then we can attempt to use the 'syndrome' to isolate
> +		 * which channel the error was on
> +		 */
> +		if (pvt->nbcfg & K8_NBCFG_CHIPKILL)
> +			chan = get_channel_from_ecc_syndrome(syndrome);
> +
> +		if (chan >= 0) {
> +			edac_mc_handle_ce(mci, page, offset, syndrome,
> +					csrow, chan, EDAC_MOD_STR);
> +		} else {
> +			/* Channel is not known,
> +			 * report all channels on this CSROW as failed.
> +			 */
> +			for (chan = 0; chan < mci->csrows[csrow].nr_channels;
> +								chan++) {
> +					edac_mc_handle_ce(mci, page, offset,
> +							syndrome,
> +							csrow, chan,
> +							EDAC_MOD_STR);
> +			}
> +		}
> +
> +	} else {
> +		edac_mc_handle_ce_no_info(mci, EDAC_MOD_STR);
> +	}
> +}
> +
> +/* map_dbam_to_csrow_size
> + *
> + * Input (index) is the DBAM DIMM value (1 of 4) used as an index into a
> + * shift table (revf_quad_ddr2_shift) which starts at 128MB DIMM size.
> + *
> + * Index of 0 indicates an empty DIMM slot, as reported by Hardware on
> + * empty slots.
> + *
> + * Normalize to 128MB by subracting 27 bit shift
> + */
> +static int map_dbam_to_csrow_size(int index)
> +{
> +	int mega_bytes = 0;
> +
> +	if (index > 0 && index <= DBAM_MAX_VALUE)
> +		mega_bytes = ((128 << (revf_quad_ddr2_shift[index]-27)));
> +
> +	return mega_bytes;
> +}
> +
> +/*
> + * f10_debug_display_dimm_sizes
> + *
> + *	debug routine to display the memory sizes of a DIMM
> + *	(ganged or not) and it CSROWs as well
> + */
> +static void f10_debug_display_dimm_sizes(int ctrl,
> +					struct amd64_pvt *pvt, int ganged)
> +{
> +	int dimm;
> +	int size0;
> +	int size1;
> +	u32 dbam;
> +	u32 *dcsb;
> +
> +	debugf1("  dbam%d: 0x%8.08x  CSROW is %s\n", ctrl,
> +			ctrl ? pvt->dbam1 : pvt->dbam0,
> +			ganged ? "GANGED - dbam1 not used" : "NON-GANGED");
> +
> +	dbam = ctrl ? pvt->dbam1 : pvt->dbam0;
> +	dcsb = ctrl ? pvt->dcsb1 : pvt->dcsb0;
> +
> +	/* Dump memory sizes for DIMM and its CSROWs */
> +	for (dimm = 0; dimm < 4; dimm++) {
> +
> +		size0 = 0;
> +		if (dcsb[dimm*2] & K8_DCSB_CS_ENABLE)
> +			size0 = map_dbam_to_csrow_size(DBAM_DIMM(dimm, dbam));
> +
> +		size1 = 0;
> +		if (dcsb[dimm*2 + 1] & K8_DCSB_CS_ENABLE)
> +			size1 = map_dbam_to_csrow_size(DBAM_DIMM(dimm, dbam));
> +
> +		debugf1("     CTRL-%d DIMM-%d=%5dMB   CSROW-%d=%5dMB "
> +				"CSROW-%d=%5dMB\n",
> +				ctrl,
> +				dimm,
> +				size0 + size1,
> +				dimm * 2,
> +				size0,
> +				dimm * 2 + 1,
> +				size1);
> +	}
> +}
> +
> +/*
> + * f10_probe_valid_hardware
> + *
> + * Very early hardware probe on pci_probe thread to determine if this module can
> + * support the hardware.
> + *
> + * Return:
> + *      0 for OK
> + *      1 for error
> + */
> +static int f10_probe_valid_hardware(struct amd64_pvt *pvt)
> +{
> +	int rc = 0;
> +
> +	/*
> +	 * If we are on a DDR3 machine, we don't know yet if
> +	 * we support that properly at this time
> +	 */
> +	if ((pvt->dchr0 & F10_DCHR_Ddr3Mode) ||
> +	    (pvt->dchr1 & F10_DCHR_Ddr3Mode)) {
> +
> +		amd64_printk(KERN_WARNING,
> +			"%s() This machine is running with DDR3 memory. "
> +			"This is not currently supported. "
> +			"DCHR0=0x%x DCHR1=0x%x\n",
> +			__func__, pvt->dchr0, pvt->dchr1);
> +
> +		amd64_printk(KERN_WARNING,
> +			"   Contact '%s' module MAINTAINER to help add"
> +			" support.\n",
> +			EDAC_MOD_STR);
> +
> +		rc = 1;
> +
> +	} else {
> +		debugf0("%s() DDR2 Memory Installed\n", __func__);
> +	}
> +
> +	return rc;
> +}
>  


-- 

Cheers,
Mauro

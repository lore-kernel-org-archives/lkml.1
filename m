Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbZD2SZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbZD2SZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZD2SZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:25:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51900 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZD2SZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:25:06 -0400
Date: Wed, 29 Apr 2009 20:24:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de,
       hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
Message-ID: <20090429182450.GA9057@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-14-git-send-email-borislav.petkov@amd.com> <20090429182255.GD8321@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429182255.GD8321@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Borislav Petkov <borislav.petkov@amd.com> wrote:
> 
> > From: Doug Thompson <dougthompson@xmission.com>
> > 
> > Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  drivers/edac/amd64_edac.c |  318 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 318 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> > index fe2342c..84075c0 100644
> > --- a/drivers/edac/amd64_edac.c
> > +++ b/drivers/edac/amd64_edac.c
> > @@ -2726,4 +2726,322 @@ static int f10_lookup_addr_in_dct(u32 InputAddr, u32 NodeID, u32 ChannelSelect)
> >  	return CSFound;
> >  }
> >  
> > +/*
> > + * f10_match_to_this_node
> > + *
> > + * For a given 'DramRange' value, check if 'SystemAddr' fall within this value
> > + */
> > +static int f10_match_to_this_node(struct amd64_pvt *pvt, int DramRange,
> > +				u64 SystemAddr,
> > +				int *node_id,
> > +				int *channel_select)
> > +{
> > +	int CSFound = -1;
> > +	int NodeID;
> > +	int HiRangeSelected;
> > +	u32 IntlvEn, IntlvSel;
> > +	u32 DramEn;
> > +	u32 Ilog;
> > +	u32 HoleOffset, HoleEn;
> > +	u32 InputAddr, Temp;
> > +	u32 DctSelBaseAddr, DctSelIntLvAddr;
> > +	u32 DctSelHi;
> > +	u32 ChannelSelect;
> > +	u64 DramBaseLong, DramLimitLong;
> > +	u64 DctSelBaseOffsetLong, ChannelAddrLong;
> > +
> > +	/* DRAM Base value for this DRAM instance */
> > +	DramBaseLong = pvt->dram_base[DramRange];
> > +	DramEn = pvt->dram_rw_en[DramRange];
> > +	IntlvEn = pvt->dram_IntlvEn[DramRange];
> > +
> > +	/* DRAM Limit value for this DRAM instance */
> > +	DramLimitLong = pvt->dram_limit[DramRange];
> > +	NodeID = pvt->dram_DstNode[DramRange];
> > +	IntlvSel = pvt->dram_IntlvSel[DramRange];
> > +
> > +	debugf1("%s(dram=%d) Base=0x%llx SystemAddr= 0x%llx Limit=0x%llx\n",
> > +		__func__, DramRange, DramBaseLong, SystemAddr, DramLimitLong);
> > +
> > +	/* This assumes that one node's DHAR is the same as
> > +	 * all the other node's DHARs
> > +	 */
> > +	HoleEn = pvt->dhar;
> > +	HoleOffset = (HoleEn & 0x0000FF80);
> > +	HoleEn = (HoleEn & 0x00000003);
> > +
> > +	debugf1("   HoleOffset=0x%x  HoleEn=0x%x IntlvSel=0x%x\n",
> > +			HoleOffset, HoleEn, IntlvSel);
> > +
> > +	if ((IntlvEn == 0) || IntlvSel == ((SystemAddr >> 12) & IntlvEn)) {
> > +
> > +		Ilog = f10_map_IntlvEn_to_shift(IntlvEn);
> > +
> > +		Temp = pvt->dram_ctl_select_low;
> > +		DctSelBaseOffsetLong = pvt->dram_ctl_select_high << 16;
> > +
> > +		DctSelHi = (Temp >> 1) & 1;
> > +		DctSelIntLvAddr = dct_sel_interleave_addr(pvt);
> > +		DctSelBaseAddr = dct_sel_baseaddr(pvt);
> > +
> > +		if (dct_high_range_enabled(pvt) &&
> > +		   !dct_ganging_enabled(pvt) &&
> > +		   ((SystemAddr >> 27) >= (DctSelBaseAddr >> 11)))
> > +			HiRangeSelected = 1;
> > +		else
> > +			HiRangeSelected = 0;
> > +
> > +		ChannelSelect = f10_determine_channel(pvt, SystemAddr,
> > +						HiRangeSelected, IntlvEn);
> > +
> > +		ChannelAddrLong = f10_determine_base_addr_offset(
> > +						SystemAddr,
> > +						HiRangeSelected,
> > +						DctSelBaseAddr,
> > +						DctSelBaseOffsetLong,
> > +						HoleEn,
> > +						HoleOffset,
> > +						DramBaseLong);
> > +
> > +		/* Remove Node ID (in case of processor interleaving) */
> > +		Temp = ChannelAddrLong & 0xFC0;
> > +
> > +		ChannelAddrLong = ((ChannelAddrLong >> Ilog) &
> > +					0xFFFFFFFFF000ULL) | Temp;
> > +
> > +		/* Remove Channel interleave and hash */
> > +		if (dct_interleave_enabled(pvt) &&
> > +		   !dct_high_range_enabled(pvt) &&
> > +		   !dct_ganging_enabled(pvt)) {
> > +			if (DctSelIntLvAddr != 1)
> > +				ChannelAddrLong =
> > +					(ChannelAddrLong >> 1) &
> > +					0xFFFFFFFFFFFFFFC0ULL;
> > +			else {
> > +				Temp = ChannelAddrLong & 0xFC0;
> > +				ChannelAddrLong =
> > +					((ChannelAddrLong &
> > +					0xFFFFFFFFFFFFC000ULL)
> > +					>> 1) | Temp;
> > +			}
> > +		}
> > +
> > +		/* Form a normalize InputAddr (Move bits 36:8 down to 28:0
> > +		 * which will set it up to match the DCT Base register
> > +		 */
> > +		InputAddr = ChannelAddrLong >> 8;
> > +
> > +		debugf1("   (ChannelAddrLong=0x%llx) >> 8 becomes "
> > +			"InputAddr=0x%x\n", ChannelAddrLong, InputAddr);
> > +
> > +		/* Iterate over the DRAM DCTs looking for a
> > +		 * match for InputAddr on the selected NodeID
> > +		 */
> > +		CSFound = f10_lookup_addr_in_dct(InputAddr,
> > +						NodeID, ChannelSelect);
> > +
> > +		if (CSFound >= 0) {
> > +			*node_id = NodeID;
> > +			*channel_select = ChannelSelect;
> > +		}
> > +	}
> > +
> > +	return CSFound;
> > +}
> 
> this function is probably too large, and also it uses some weird 
> hungarian notation coding style. Please dont do that! It's 
> completely unacceptable.
> 
> this condition:
> 
> > +	if ((IntlvEn == 0) || IntlvSel == ((SystemAddr >> 12) & IntlvEn)) {
> 
> could be inverted and an early "return cs_found" could be done - 
> saving an indentitation level for most of the above code.
> 
> etc. etc.
> 
> Please look at the function in a really large xterm, from far 
> away. If the shape does not look 'good', and the structure is not 
> an obvious pattern seen a hundred times elsewhere in the kernel, 
> there's something weird going on with the function. It should be 
> split up, cleaned up, simplified. Variable names could become 
> shorter, etc. etc.

... and this general observation about variable naming and general 
structure holds for the rest of the patches as well. This really 
needs to be sorted out before a more detailed review can be done.

	Ingo

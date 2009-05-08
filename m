Return-Path: <linux-kernel-owner+w=401wt.eu-S1762354AbZEHKDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354AbZEHKDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 06:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762934AbZEHKCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 06:02:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44845 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761210AbZEHKCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 06:02:46 -0400
Date: Fri, 8 May 2009 07:01:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>,
       <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <aris@redhat.com>, edt@aei.ca, <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 05/21] amd64_edac: add MCA error types
Message-ID: <20090508070143.7206f6f4@pedra.chehab.org>
In-Reply-To: <1241704183-29223-6-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
	<1241704183-29223-6-git-send-email-borislav.petkov@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 7 May 2009 15:49:27 +0200
Borislav Petkov <borislav.petkov@amd.com> escreveu:

> From: Doug Thompson <dougthompson@xmission.com>
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
>  drivers/edac/amd64_edac_err_types.c |  163 +++++++++++++++++++++++++++++++++++
>  1 files changed, 163 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/edac/amd64_edac_err_types.c
> 
> diff --git a/drivers/edac/amd64_edac_err_types.c b/drivers/edac/amd64_edac_err_types.c
> new file mode 100644
> index 0000000..20a2bb6
> --- /dev/null
> +++ b/drivers/edac/amd64_edac_err_types.c
> @@ -0,0 +1,163 @@
> +#include "amd64_edac.h"
> +
> +/*
> + * See F2x80 for K8 and F2x[1,0]80 for Fam10 and later. The table below is only
> + * for DDR2 DRAM mapping.
> + */
> +u32 revf_quad_ddr2_shift[] = {
> +	0,	/* 0000b NULL DIMM (128mb) */
> +	28,	/* 0001b 256mb */
> +	29,	/* 0010b 512mb */
> +	29,	/* 0011b 512mb */
> +	29,	/* 0100b 512mb */
> +	30,	/* 0101b 1gb */
> +	30,	/* 0110b 1gb */
> +	31,	/* 0111b 2gb */
> +	31,	/* 1000b 2gb */
> +	32,	/* 1001b 4gb */
> +	32,	/* 1010b 4gb */
> +	33,	/* 1011b 8gb */
> +	0,	/* 1100b future */
> +	0,	/* 1101b future */
> +	0,	/* 1110b future */
> +	0	/* 1111b future */
> +};
> +
> +/* Valid scrub rates for the K8 hardware memory scrubber. We map
> + *	the scrubbing bandwidth to a valid bit pattern. The 'set'
> + *	operation finds the 'matching- or higher value'.
> + *
> + *FIXME: Produce a better mapping/linearisation.
> + */
> +
> +struct scrubrate scrubrates[] = {
> +	{ 0x01, 1600000000UL},
> +	{ 0x02, 800000000UL},
> +	{ 0x03, 400000000UL},
> +	{ 0x04, 200000000UL},
> +	{ 0x05, 100000000UL},
> +	{ 0x06, 50000000UL},
> +	{ 0x07, 25000000UL},
> +	{ 0x08, 12284069UL},
> +	{ 0x09, 6274509UL},
> +	{ 0x0A, 3121951UL},
> +	{ 0x0B, 1560975UL},
> +	{ 0x0C, 781440UL},
> +	{ 0x0D, 390720UL},
> +	{ 0x0E, 195300UL},
> +	{ 0x0F, 97650UL},
> +	{ 0x10, 48854UL},
> +	{ 0x11, 24427UL},
> +	{ 0x12, 12213UL},
> +	{ 0x13, 6101UL},
> +	{ 0x14, 3051UL},
> +	{ 0x15, 1523UL},
> +	{ 0x16, 761UL},
> +	{ 0x00, 0UL},        /* scrubbing off */
> +};
> +
> +/*
> + * string representation for the different MCA reported error types, see F3x48
> + * or MSR0000_0411.
> + */
> +const char *tt_msgs[] = {        /* transaction type */
> +	"instruction",
> +	"data",
> +	"generic",
> +	"reserved"
> +};
> +
> +const char *ll_msgs[] = {	/* cache level */
> +	"L0",
> +	"L1",
> +	"L2",
> +	"L3/generic"
> +};
> +
> +const char *rrrr_msgs[] = {
> +	"generic",
> +	"generic read",
> +	"generic write",
> +	"data read",
> +	"data write",
> +	"inst fetch",
> +	"prefetch",
> +	"evict",
> +	"snoop",
> +	"reserved RRRR= 9",
> +	"reserved RRRR= 10",
> +	"reserved RRRR= 11",
> +	"reserved RRRR= 12",
> +	"reserved RRRR= 13",
> +	"reserved RRRR= 14",
> +	"reserved RRRR= 15"
> +};
> +
> +const char *pp_msgs[] = {	/* participating processor */
> +	"local node originated (SRC)",
> +	"local node responded to request (RES)",
> +	"local node observed as 3rd party (OBS)",
> +	"generic"
> +};
> +
> +const char *to_msgs[] = {
> +	"no timeout",
> +	"timed out"
> +};
> +
> +const char *ii_msgs[] = {	/* memory or i/o */
> +	"mem access",
> +	"reserved",
> +	"i/o access",
> +	"generic"
> +};
> +
> +/* Map the 5 bits of Extended Error code toString table
> + *	enhanced to support the new F10 error codes
> + *	esp, with L3 cache errors
> + */
> +const char *ext_msgs[] = {	/* extended error */
> +	"K8 ECC error/F10 reserved",	/* 0_0000b */
> +	"CRC error",			/* 0_0001b */
> +	"sync error",			/* 0_0010b */
> +	"mst abort",			/* 0_0011b */
> +	"tgt abort",			/* 0_0100b */
> +	"GART error",			/* 0_0101b */
> +	"RMW error",			/* 0_0110b */
> +	"Wdog timer error",		/* 0_0111b */
> +	"F10-ECC/K8-Chipkill error",	/* 0_1000b */
> +	"DEV Error",			/* 0_1001b */
> +	"Link Data error",		/* 0_1010b */
> +	"Link or L3 Protocol error",	/* 0_1011b */
> +	"NB Array error",		/* 0_1100b */
> +	"DRAM Parity error",		/* 0_1101b */
> +	"Link Retry/GART Table Walk/DEV Table Walk error", /* 0_1110b */
> +	"Res 0x0ff error",		/* 0_1111b */
> +	"Res 0x100 error",		/* 1_0000b */
> +	"Res 0x101 error",		/* 1_0001b */
> +	"Res 0x102 error",		/* 1_0010b */
> +	"Res 0x103 error",		/* 1_0011b */
> +	"Res 0x104 error",		/* 1_0100b */
> +	"Res 0x105 error",		/* 1_0101b */
> +	"Res 0x106 error",		/* 1_0110b */
> +	"Res 0x107 error",		/* 1_0111b */
> +	"Res 0x108 error",		/* 1_1000b */
> +	"Res 0x109 error",		/* 1_1001b */
> +	"Res 0x10A error",		/* 1_1010b */
> +	"Res 0x10B error",		/* 1_1011b */
> +	"L3 Cache Data error",		/* 1_1100b */
> +	"L3 CacheTag error",		/* 1_1101b */
> +	"L3 Cache LRU error",		/* 1_1110b */
> +	"Res 0x1FF error"		/* 1_1111b */
> +};
> +
> +const char *htlink_msgs[] = {
> +	"none",
> +	"1",
> +	"2",
> +	"1 2",
> +	"3",
> +	"1 3",
> +	"2 3",
> +	"1 2 3"
> +};


-- 

Cheers,
Mauro

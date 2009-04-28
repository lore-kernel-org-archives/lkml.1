Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZD1SQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZD1SQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761950AbZD1SQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:16:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175AbZD1SQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:16:14 -0400
Date: Tue, 28 Apr 2009 11:13:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       borislav.petkov@amd.com
Subject: Re: [PATCH 02/21] amd64_edac: add driver structs
Message-Id: <20090428111349.d7a6a770.akpm@linux-foundation.org>
In-Reply-To: <1240931173-17477-3-git-send-email-borislav.petkov@amd.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
	<1240931173-17477-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 17:05:54 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Doug Thompson <dougthompson@xmission.com>
> 
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>
> ...
>
> +/**
> + * popcnt - count the set bits in a bit vector.
> + * @vec - bit vector
> + *
> + * This instruction is supported only on F10h and later CPUs.
> + */
> +#define popcnt(x)						\
> +({								\
> +	typeof(x) __ret;					\
> +	__asm__("popcnt %1, %0" : "=r" (__ret) : "r" (x));	\
> +	__ret;							\
> +})

We kinda already have this, in bitmap_weight().  Your popcnt() looks
more efficient.

I'm scratching my head at the types.  I'd have thought that I could do

	char foo[32];
	int n;
	...
	n = popcnt(foo);

but obviosuly not, because a) popcnt() doesn't take a length argumetn
and b) returning a char* is silly.

Some of this would be clearer if popcnt() wasn't implemented as a sucky
macro.

<googles the popcnt instruction>

hm, it seems to operate on a 64-bit operand.  You just reinvented
hweight64()?

Still, returning the same type as the input argument seems peculiar.

>
> ...
>
> +struct amd64_pvt {
> +	/* pci_device handles which we utilize */
> +	struct pci_dev *addr_f1_ctl;
> +	struct pci_dev *dram_f2_ctl;
> +	struct pci_dev *misc_f3_ctl;
> +
> +	int mc_node_id;		/* MC index of this MC node */
> +	int ext_model;		/* extended model value of this node */
> +
> +	struct low_ops	*ops;	/* pointer to per PCI Device ID func table */
> +
> +	int channel_count;	/* Count of 'channels' */
> +
> +	/* Raw registers */
> +	u32 dclr0;		/* DRAM Configuration Low DCT0 reg */
> +	u32 dclr1;		/* DRAM Configuration Low DCT1 reg */
> +	u32 dchr0;		/* DRAM Configuration High DCT0 reg */
> +	u32 dchr1;		/* DRAM Configuration High DCT1 reg */
> +	u32 nbcap;		/* North Bridge Capabilities */
> +	u32 nbcfg;		/* F10 North Bridge Configuration */
> +	u32 ext_nbcfg;		/* Extended F10 North Bridge Configuration */
> +	u32 dhar;		/* DRAM Hoist reg */
> +	u32 dbam0;		/* DRAM Base Address Mapping reg for DCT0 */
> +	u32 dbam1;		/* DRAM Base Address Mapping reg for DCT1 */
> +
> +	/* DRAM CS Base Address Registers
> +	 *   F2x[1,0][5C:40]
> +	 */
> +	u32 dcsb0[CHIPSELECT_COUNT];    /* DRAM CS Base Registers */
> +	u32 dcsb1[CHIPSELECT_COUNT];    /* DRAM CS Base Registers */
> +
> +	/* DRAM CS Mask Registers
> +	 *   F2x[1,0][6C:60]
> +	 */
> +	u32 dcsm0[CHIPSELECT_COUNT];    /* DRAM CS Mask Registers */
> +	u32 dcsm1[CHIPSELECT_COUNT];    /* DRAM CS Mask Registers */
> +
> +	/* Decoded parts of DRAM BASE and LIMIT Registers
> +	 * F1x[78,70,68,60,58,50,48,40]
> +	 */
> +	u64 dram_base[DRAM_REG_COUNT];/* DRAM Base Reg */
> +	u64 dram_limit[DRAM_REG_COUNT];/* DRAM Limit Reg */
> +	u8 dram_IntlvSel[DRAM_REG_COUNT];
> +	u8 dram_IntlvEn[DRAM_REG_COUNT];
> +	u8 dram_DstNode[DRAM_REG_COUNT];
> +	u8 dram_rw_en[DRAM_REG_COUNT];
> +
> +	/* The following fields are set at (load) run time, after Revision has
> +	 * been determined, since the dct_base and dct_mask registers vary
> +	 * by CPU Revsion
> +	 */
> +	u32 dcsb_base;		/* DCSB base bits */
> +	u32 dcsm_mask;		/* DCSM mask bits */
> +	u32 num_dcsm;		/* Number of DCSM registers */
> +	u32 dcs_mask_notused;	/* DCSM notused mask bits */
> +	u32 dcs_shift;		/* DCSB and DCSM shift value */
> +
> +	u64 top_mem;		/* top of memory below 4GB */
> +	u64 top_mem2;		/* top of memory above 4GB */
> +
> +	/* F10 registers */
> +	u32 dram_ctl_select_low;	/* DRAM Controller Select Low Reg */
> +	u32 dram_ctl_select_high;	/* DRAM Controller Select High Reg */
> +	u32 online_spare;               /* On-Line spare Reg */
> +
> +	/* sysfs storage area: Temp storage for when input
> +	 * is received from sysfs
> +	 */
> +	struct amd64_error_info_regs ctl_error_info;
> +
> +	/* Place to store error injection parameters prior to issue */
> +	struct error_injection injection;
> +
> +	/* Save old hw registers' values before we modified them */
> +	u32 nbctl_mcgctl_saved;		/* When true, following 2 are valid */
> +	u32 old_nbctl;
> +	u32 old_mcgctl;
> +
> +	/* MC Type Index value: socket F vs Family 10h */
> +	u32 mc_type_index;
> +
> +	/* misc settings */
> +	struct flags {
> +		unsigned long cf8_extcfg :1;

checkpatch correctly warns here.

> +	} flags;
> +};
> +
> +/*
> + * See F2x80 for K8 and F2x[1,0]80 for Fam10 and later. The table below is only
> + * for DDR2 DRAM mapping.
> + */
> +static u32 revf_quad_ddr2_shift[] =
> +{

static u32 revf_quad_ddr2_shift[] = {

would be more typical.

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
>
> ...
>


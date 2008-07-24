Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYGXOk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYGXOk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYGXOkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:40:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:24820 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYGXOkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:40:17 -0400
X-BigFish: VPS-17(zz1432R98dR936eT62a3L1805Mzz10d3izzz32i6bh87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4IM2L-02-13Y-01
Date: Thu, 24 Jul 2008 16:39:53 +0200
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, Jason Yeh <jason.yeh@amd.com>
Subject: Re: [PATCH 11/24] x86/oprofile: Add IBS support for AMD CPUs,
	model specific code
Message-ID: <20080724143953.GS17134@erda.amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-12-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1216753748-11261-12-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 24 Jul 2008 14:40:01.0059 (UTC) FILETIME=[2707B730:01C8ED9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.07.08 21:08:55, Robert Richter wrote:
> From: Barry Kasindorf <barry.kasindorf@amd.com>
> 
> This patchset supports the new profiling hardware available in the
> latest AMD CPUs in the oProfile driver.
> 
> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/oprofile/op_model_athlon.c |  257 +++++++++++++++++++++++++++++++++++
>  1 files changed, 257 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
> index 40ecb02..229e0b4 100644

[...]

> @@ -181,6 +345,99 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
>  	}
>  }
>  
> +static inline void apic_init_ibs_nmi_per_cpu(void *arg)
> +{
> +	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
> +}
> +
> +static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
> +{
> +	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
> +}
> +
> +/*
> + * initialize the APIC for the IBS interrupts
> + * if needed on AMD Family10h rev B0 and later
> + */
> +static void setup_ibs(void)
> +{
> +	struct pci_dev *gh_device = NULL;
> +	u32 low, high;
> +	u8 vector;
> +
> +	ibs_allowed = boot_cpu_has(X86_FEATURE_IBS);
> +
> +	if (!ibs_allowed)
> +		return;
> +
> +	/* This gets the APIC_EILVT_LVTOFF_IBS value */
> +	vector = setup_APIC_eilvt_ibs(0, 0, 1);
> +
> +	/*see if the IBS control register is already set correctly*/
> +	/*remove this when we know for sure it is done
> +	  in the kernel init*/
> +	rdmsr(MSR_AMD64_IBSCTL, low, high);
> +	if ((low & (IBS_CTL_LVT_OFFSET_VALID_BIT | vector)) !=
> +		(IBS_CTL_LVT_OFFSET_VALID_BIT | vector)) {
> +
> +		/**** Be sure to run loop until NULL is returned to
> +		decrement reference count on any pci_dev structures
> +		returned ****/
> +		while ((gh_device = pci_get_device(PCI_VENDOR_ID_AMD,
> +			PCI_DEVICE_ID_AMD_10H_NB_MISC, gh_device))
> +			!= NULL) {
> +			/* This code may change if we can find a proper
> +			* way to get at the PCI extended config space */
> +			pci_write_config_dword(
> +				gh_device, IBS_LVT_OFFSET_PCI,
> +				(vector | IBS_CTL_LVT_OFFSET_VALID_BIT));
> +		}
> +	}
> +	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1, 1);
> +}
> +
> +
> +/*
> + * unitialize the APIC for the IBS interrupts if needed on AMD Family10h
> + * rev B0 and later */
> +static void clear_ibs_nmi(void)
> +{
> +	if (ibs_allowed)
> +		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1, 1);
> +}
> +
> +static void setup_ibs_files(struct super_block *sb, struct dentry *root)
> +{
> +	char buf[12];
> +	struct dentry *dir;
> +
> +	if (!ibs_allowed)
> +		return;
> +
> +	/* setup some reasonable defaults */
> +	ibs_config.max_cnt_fetch = 250000;
> +	ibs_config.fetch_enabled = 0;
> +	ibs_config.max_cnt_op = 250000;
> +	ibs_config.op_enabled = 0;
> +	ibs_config.dispatched_ops = 1;
> +	snprintf(buf,  sizeof(buf), "ibs_fetch");
> +	dir = oprofilefs_mkdir(sb, root, buf);
> +	oprofilefs_create_ulong(sb, dir, "rand_enable",
> +				&ibs_config.rand_en);
> +	oprofilefs_create_ulong(sb, dir, "enable",
> +		&ibs_config.fetch_enabled);
> +	oprofilefs_create_ulong(sb, dir, "max_count",
> +		&ibs_config.max_cnt_fetch);
> +	snprintf(buf,  sizeof(buf), "ibs_uops");

This should be renamed to "ibs_op" to be close to the register
specification in the BKDG.

-Robert

> +	dir = oprofilefs_mkdir(sb, root, buf);
> +	oprofilefs_create_ulong(sb, dir, "enable",
> +		&ibs_config.op_enabled);
> +	oprofilefs_create_ulong(sb, dir, "max_count",
> +		&ibs_config.max_cnt_op);
> +	oprofilefs_create_ulong(sb, dir, "dispatched_ops",
> +		&ibs_config.dispatched_ops);
> +}
> +
>  static int op_amd_init(struct oprofile_operations *ops)
>  {
>  	return 0;
> -- 
> 1.5.5.4
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


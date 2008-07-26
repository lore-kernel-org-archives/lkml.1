Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYGZKEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYGZKEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 06:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYGZKEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 06:04:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYGZKEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 06:04:00 -0400
Date: Sat, 26 Jul 2008 12:03:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/24] x86/oprofile: Add IBS support for AMD CPUs,
	model specific code
Message-ID: <20080726100341.GF25890@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-12-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216753748-11261-12-git-send-email-robert.richter@amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> @@ -132,6 +214,65 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
>  		}
>  	}
>  
> +	/*If AMD and IBS is available */
> +	if (ibs_allowed && ibs_config.fetch_enabled) {
> +		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
> +		if (high & IBS_FETCH_VALID_BIT) {
> +			ibs_fetch.ibs_fetch_ctl_high = high;
> +			ibs_fetch.ibs_fetch_ctl_low = low;
> +			rdmsr(MSR_AMD64_IBSFETCHLINAD, low, high);
> +			ibs_fetch.ibs_fetch_lin_addr_high = high;
> +			ibs_fetch.ibs_fetch_lin_addr_low = low;
> +			rdmsr(MSR_AMD64_IBSFETCHPHYSAD, low, high);
> +			ibs_fetch.ibs_fetch_phys_addr_high = high;
> +			ibs_fetch.ibs_fetch_phys_addr_low = low;
> +
> +			oprofile_add_ibs_sample(regs,
> +						(unsigned int *)&ibs_fetch,
> +						IBS_FETCH_BEGIN);

please move this innermost code into a helper function. That will help 
eliminate line 80 artifacts as well.

> +	if (ibs_allowed && ibs_config.op_enabled) {
> +		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
> +		if (low & IBS_OP_VALID_BIT) {
> +			rdmsr(MSR_AMD64_IBSOPRIP, low, high);
> +			ibs_op.ibs_op_rip_low = low;
> +			ibs_op.ibs_op_rip_high = high;
> +			rdmsr(MSR_AMD64_IBSOPDATA, low, high);
> +			ibs_op.ibs_op_data1_low = low;
> +			ibs_op.ibs_op_data1_high = high;
> +			rdmsr(MSR_AMD64_IBSOPDATA2, low, high);
> +			ibs_op.ibs_op_data2_low = low;
> +			ibs_op.ibs_op_data2_high = high;
> +			rdmsr(MSR_AMD64_IBSOPDATA3, low, high);
> +			ibs_op.ibs_op_data3_low = low;
> +			ibs_op.ibs_op_data3_high = high;
> +			rdmsr(MSR_AMD64_IBSDCLINAD, low, high);
> +			ibs_op.ibs_dc_linear_low = low;
> +			ibs_op.ibs_dc_linear_high = high;
> +			rdmsr(MSR_AMD64_IBSDCPHYSAD, low, high);
> +			ibs_op.ibs_dc_phys_low = low;
> +			ibs_op.ibs_dc_phys_high = high;
> +
> +			/* reenable the IRQ */
> +			oprofile_add_ibs_sample(regs,
> +						(unsigned int *)&ibs_op,
> +						IBS_OP_BEGIN);
> +			rdmsr(MSR_AMD64_IBSOPCTL, low, high);
> +			low &= ~(IBS_OP_VALID_BIT);
> +			low |= IBS_OP_ENABLE;
> +			wrmsr(MSR_AMD64_IBSOPCTL, low, high);
> +		}
> +	}

ditto.

> +		/**** Be sure to run loop until NULL is returned to
> +		decrement reference count on any pci_dev structures
> +		returned ****/

please use standard comment style:

 /*
  * Multi-line ..........
  * ....................... comment:
  */

> +		while ((gh_device = pci_get_device(PCI_VENDOR_ID_AMD,
> +			PCI_DEVICE_ID_AMD_10H_NB_MISC, gh_device))
> +			!= NULL) {
> +			/* This code may change if we can find a proper
> +			* way to get at the PCI extended config space */

ditto.

> +			pci_write_config_dword(
> +				gh_device, IBS_LVT_OFFSET_PCI,
> +				(vector | IBS_CTL_LVT_OFFSET_VALID_BIT));

perhaps use a helper function to reduce col 80 artifacts.

> +/*
> + * unitialize the APIC for the IBS interrupts if needed on AMD Family10h
> + * rev B0 and later */

comment style.

> +static void setup_ibs_files(struct super_block *sb, struct dentry *root)
> +{
> +	char buf[12];

magic limit.

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

you could make use of a small style trick here: use a newline before 
this statement, to make blocks of code stand out in a clearer way. The 
construction of 'buf' is finished after the snprintf above, then comes 
the next step, to create the oprofilefs entries.

	Ingo

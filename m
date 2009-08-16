Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZHPRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZHPRwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbZHPRwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 13:52:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57738 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbZHPRwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 13:52:18 -0400
Date: Sun, 16 Aug 2009 19:52:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Kelly <mark@bifferos.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Florian Fainelli <florian@openwrt.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86 CPU detection for RDC
Message-ID: <20090816175204.GA28553@elte.hu>
References: <58001.1250437590@bifferos.com> <20090816155507.GA2791@elte.hu> <alpine.LNX.2.00.0908160317250.19588@cent.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0908160317250.19588@cent.localnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Kelly <mark@bifferos.com> wrote:

> +static void __cpuinit rdc_identify(struct cpuinfo_x86 *c)
> +{
> +	u16 vendor, device;
> +	u32 customer_id;
> +
> +	/* RDC CPU is SoC (system-on-chip), Northbridge is always present. */
> +	vendor = read_pci_config_16(0, 0, 0, PCI_VENDOR_ID);
> +	device = read_pci_config_16(0, 0, 0, PCI_DEVICE_ID);
> +
> +	if (vendor != PCI_VENDOR_ID_RDC || device != PCI_DEVICE_ID_RDC_R6020)
> +		return;  /* not RDC */
> +
> +	/* NB: We could go on and check other devices, e.g. r6040 NIC, but
> +	   that's probably overkill */

please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

> +	strcpy(c->x86_vendor_id, "RDC");
> +	c->x86_vendor = X86_VENDOR_RDC;
> +
> +	customer_id = read_pci_config(0, 0, 0, 0x90);
> +
> +	switch (customer_id) {
> +		/* id names are from RDC */
> +	case 0x00321000:
> +		strcpy(c->x86_model_id, "R3210/R3211");
> +		break;
> +	case 0x00321001:
> +		strcpy(c->x86_model_id, "AMITRISC20000/20010");
> +		break;
> +	case 0x00321002:
> +		strcpy(c->x86_model_id, "R3210X/Edimax");
> +		break;
> +	case 0x00321003:
> +		strcpy(c->x86_model_id, "R3210/Kcodes");
> +		break;
> +	case 0x00321004:  /* tested */
> +		strcpy(c->x86_model_id, "S3282/CodeTek");
> +		break;
> +	case 0x00321007:
> +		strcpy(c->x86_model_id, "R8610");
> +		break;
> +	default:
> +		printk(KERN_INFO "Unrecognised Customer ID (0x%x) please "
> +			"report to bifferos@yahoo.co.uk\n", customer_id);

I'd rather see them reported to linux-kernel@vger.kernel.org. Also, 
please concatenate the string on a single line (and ignore the 
checkpatch warning in this case, even if the line is over-long).

Also, please use pr_info() here. Plus, put 'RDC' into the printout 
so that people know that the RDC cpu is unknown. (it's not clear 
from this printk)

> +		/* We'll default to the R321x since that's mentioned
> +		   elsewhere in the kernel sources */
> +		strcpy(c->x86_model_id, "R321x");
> +
> +		/* blank the vendor_id, so we get a warning that this
> +		   is unsupported, your system may be unstable etc...
> +		   Is there a better way? */

(these multi-line comments too need to be fixed.)

> +		strcpy(c->x86_vendor_id, "");

hm, the default should already be an empty string (i.e. \0) - why 
does this need to be cleared again?

	Ingo

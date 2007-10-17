Return-Path: <linux-kernel-owner+w=401wt.eu-S936464AbXJQD31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936464AbXJQD31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935824AbXJQD3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:29:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54124 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936293AbXJQD3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:29:09 -0400
Date: Tue, 16 Oct 2007 21:29:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Mark Lord <lkml@rtr.ca>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 1/4] Fix PCIe hotplug for non-ACPI ExpressCard slots (version 2)
Message-ID: <20071017032907.GA16728@parisc-linux.org>
References: <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca> <47156B14.2080608@rtr.ca> <47156B40.4060006@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47156B40.4060006@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 09:54:08PM -0400, Mark Lord wrote:
> -	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
> +	/* Check if slot is occupied */
> +	t_slot->hpc_ops->get_adapter_status(t_slot, &value);
>  	if ((POWER_CTRL(ctrl->ctrlcap)) && !value) {
> -		rc = t_slot->hpc_ops->power_off_slot(t_slot); /* Power off slot if not occupied*/
> +		/* Power off slot if not occupied*/
> +		rc = t_slot->hpc_ops->power_off_slot(t_slot);

I'd argue these comments fall under "stating the bleedin' obvious", but
that's Kristen's call.

>  	case INT_PRESENCE_OFF:
>  		if (!HP_SUPR_RM(ctrl->ctrlcap))
>  			break;
> -		dbg("Surprise Removal\n");
> +		dbg("Surprise Event\n");
>  		update_slot_info(p_slot);
>  		handle_surprise_event(p_slot);
>  		break;

That doesn't seem like an obviously correct change to me.  Can you
explain?

> -	if (((cap_reg & SLOT_IMPL) == 0) || (((cap_reg & DEV_PORT_TYPE) != 0x0040)
> +	if (((cap_reg & SLOT_IMPL) == 0)
> +		|| (((cap_reg & DEV_PORT_TYPE) != 0x0040)
>  		&& ((cap_reg & DEV_PORT_TYPE) != 0x0060))) {
> -		dbg("%s : This is not a root port or the port is not connected to a slot\n", __FUNCTION__);
> +		dbg("%s : This is not a root port"
> +		" or the port is not connected to a slot\n", __FUNCTION__);
>  		goto abort_free_ctlr;

Normal style would be more like ...

	if (((cap_reg & SLOT_IMPL) == 0) ||
	    (((cap_reg & DEV_PORT_TYPE) != 0x0040) &&
	     ((cap_reg & DEV_PORT_TYPE) != 0x0060))) {
		dbg("%s : This is not a root port or the port is not "
		    "connected to a slot\n", __FUNCTION__);

> -	info("HPC vendor_id %x device_id %x ss_vid %x ss_did %x\n", pdev->vendor, pdev->device, 
> +	info("HPC vendor_id %x device_id %x ss_vid %x"
> +		" ss_did %x\n", pdev->vendor, pdev->device,
>  		pdev->subsystem_vendor, pdev->subsystem_device);

Why did you choose to break the format string?

	info("HPC vendor_id %x device_id %x ss_vid %x ss_did %x\n",
		pdev->vendor, pdev->device,
		pdev->subsystem_vendor, pdev->subsystem_device);

> -	temp_word = (temp_word & ~HP_INTR_ENABLE & ~CMD_CMPL_INTR_ENABLE) | 0x00;
> +	temp_word = (temp_word & ~HP_INTR_ENABLE & ~CMD_CMPL_INTR_ENABLE)|0x00;

Just delete the | 0x00?

> -	temp_word = (temp_word & ~intr_enable) | intr_enable; 
> +	temp_word = (temp_word & ~intr_enable) | intr_enable;

*boggle*
	temp_word |= intr_enable;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

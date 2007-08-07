Return-Path: <linux-kernel-owner+w=401wt.eu-S934427AbXHGOhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbXHGOhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXHGOhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:37:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58298 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754042AbXHGOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:37:34 -0400
Date: Tue, 7 Aug 2007 10:37:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Engraf <david.engraf@netcom.eu>
cc: Greg KH <gregkh@suse.de>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
In-Reply-To: <46B83109.8060808@netcom.eu>
Message-ID: <Pine.LNX.4.44L0.0708071029520.2770-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2007, David Engraf wrote:

> You said your Intel board has also problems with the handoff.
> Could you try the follwing patch, because the EHCI documentation
> says that the OS must set the EHCI_USBLEGSUP_OS bit and then
> wait until EHCI_USBLEGSUP_BIOS is cleared. The kernel never
> uses the EHCI_USBLEGSUP_OS flag at the moment.

Yes it does.  Maybe not by that name, but it does set the bit.

> On my system there is no change, but maybe this patch works on
> your system.
> 
> Thanks
> David Engraf
> 
> linux-2.6.22.1
> 
> diff -puN drivers/usb/host/pci-quirks_orig.c drivers/usb/host/pci-quirks.c
> 
> --- drivers/usb/host/pci-quirks_orig.c    2007-07-10 20:56:30.000000000
> +0200
> +++ drivers/usb/host/pci-quirks.c    2007-08-07 10:38:33.000000000 +0200
> @@ -268,6 +268,8 @@ static void __devinit quirk_usb_disable_
>                   * handoff..
>                   */
>                  pci_write_config_byte(pdev, offset + 3, 1);
> +
> +                pci_write_config_byte(pdev, offset, cap |
> EHCI_USBLEGSUP_OS);

This patch is definitely wrong (besides being line-wrapped).  Note that
EHCI_USBLEGSUP_OS is equal to (1 << 24) -- it makes no sense to use it
as an argument for a byte-sized write.  Also note that the two 
low-order bytes in the USBLEGSUP register are read-only; you shouldn't 
try to write them at all.

It looks like you are simply attempting to do what the previous line of 
code already does.

Alan Stern


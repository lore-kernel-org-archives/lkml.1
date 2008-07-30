Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbYG3Tlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbYG3Tlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYG3TlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:41:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55167 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753305AbYG3TlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:41:24 -0400
Date: Wed, 30 Jul 2008 15:41:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch 5/3] fastboot: sync the async execution before late_initcall
 and move level 6s (sync) first
In-Reply-To: <4890B20C.7060308@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0807301522230.2322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Simon Arlott wrote:

> > The USB stack _already_ initializes USB devices (i.e., not host
> > controllers) in a separate thread.
> 
> With fastboot:
> 162 ohci_hcd_mod_init+0x0/0xa6
> 167 pcie_portdrv_init+0x0/0x4d
> 182 saa7134_init+0x0/0x4a
> 205 ehci_hcd_init+0x0/0x8b
> 299 snd_usb_audio_init+0x0/0x3d
> 557 e1000_init_module+0x0/0x88
> 1227 amd74xx_ide_init+0x0/0x1b
> 2306 nv_init+0x0/0x1b
> 
> Without fastboot:
> 103 ehci_hcd_init+0x0/0x8b
> 113 raid5_init+0x0/0x3e
> 127 pci_iommu_init+0x0/0x17
> 148 ohci_hcd_mod_init+0x0/0xa4
> 183 saa7134_init+0x0/0x4a
> 297 snd_usb_audio_init+0x0/0x3d
> 557 e1000_init_module+0x0/0x88
> 1227 amd74xx_ide_init+0x0/0x1b
> 2303 nv_init+0x0/0x1b
> 2859 usblp_init+0x0/0x1b
> 
> Boot log attached.

The timings in the boot log agree with your "Without fastboot:" 
figures, so I assume that's the log you attached.  The only timings at 
issue here are ehci_hcd_init and ohci_hcd_mod_init.  It's not clear 
that the with-fastboot and without-fastboot values are directly 
comparable; during startup there's a lot of activity, and interrupt 
handlers can throw the timings off.

> It looks like usb device driver init requires it to immediately block and 
> wait for all devices to have completed init

Which USB device driver init are you talking about?  Your log includes 
usblp_init, usb_stor_init, usb_usual_init, hid_init (for a USB mouse), 
and snd_usb_audio_init.  Each one completed before the next one 
started; none of them blocked waiting for any devices (other than their 
own, of course) to finish initializing.

>  - so regardless of where we 
> put the usb/ directory in the initcall order, it will always wait a while 
> because the drivers will be immediately after the hcd init...

No, you're wrong.  To prove it, try patching the start of hub_events() 
in drivers/usb/core/hub.c like this:

 	 * Not the most efficient, but avoids deadlocks.
 	 */
 	while (1) {
+		ssleep(5);
 
 		/* Grab the first entry at the beginning of the list */
 		spin_lock_irq(&hub_event_lock);

Then see what happens.

> perhaps 
> if we moved the hcd init to before net/, sata/, ide/ etc. (all the things 
> that take time themselves) but left usb device drivers to the end it 
> would actually get the benefit of that separate thread.

They are already running in a separate thread.  Of course, the 
different threads will contend for CPU resources -- just putting things 
into multiple threads doesn't mean they will necessarily run 
concurrently.

> I don't have the time to rework how usb/ is linked in order to try that, 
> but moving usb/ to before net/ and sata/ while making all the usb device 
> drivers that get used be late initcalls could be used to test it.

You seem to have a completely mixed-up idea of how the USB stack works.  
All the device drivers you're worried about are initialized within the 
khubd kernel thread.

Alan Stern


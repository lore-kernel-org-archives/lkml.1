Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbZEXUt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbZEXUt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 16:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZEXUtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 16:49:17 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39236 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbZEXUtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 16:49:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18969.45764.766890.290349@pilspetsen.it.uu.se>
Date: Sun, 24 May 2009 22:49:08 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, arjan@linux.intel.com
Subject: Re: [2.6.30-rc7 regression] kernel/async.c broke pata_legacy.c
In-Reply-To: <1243192526.2889.26.camel@localhost.localdomain>
References: <18969.29245.610133.834819@pilspetsen.it.uu.se>
	<1243192526.2889.26.camel@localhost.localdomain>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley writes:
 > On Sun, 2009-05-24 at 18:13 +0200, Mikael Pettersson wrote:
 > > I tried booting 2.6.30-rc7 on my old '486, but it fails miserably
 > > during libata/pata_legacy's device scan:
 > [...]
 > > WARNING: at drivers/ata/libata-core.c:6222 ata_host_detach+0x75/0x90()
 > > Modules linked in:
 > > Pid: 1, comm: swapper Not tainted 2.6.30-rc7 #1
 > > Call Trace:
 > >  [<c01fbb05>] ? ata_host_detach+0x75/0x90
 > >  [<c01fbb05>] ? ata_host_detach+0x75/0x90
 > >  [<c01139b5>] ? warn_slowpath_common+0x45/0x80
 > >  [<c01139fa>] ? warn_slowpath_null+0xa/0x10
 > >  [<c01fbb05>] ? ata_host_detach+0x75/0x90
 > >  [<c02f40e0>] ? legacy_init+0x44e/0x87f
 > >  [<c02f3c92>] ? legacy_init+0x0/0x87f
 > >  [<c0101021>] ? _stext+0x21/0x140
 > >  [<c01890ff>] ? proc_register+0x2f/0x190
 > >  [<c018938c>] ? create_proc_entry+0x5c/0xc0
 > >  [<c0135ebe>] ? register_irq_proc+0x6e/0x90
 > >  [<c02e6484>] ? kernel_init+0x6e/0xbf
 > >  [<c02e6416>] ? kernel_init+0x0/0xbf
 > >  [<c01031d7>] ? kernel_thread_helper+0x7/0x10
 > 
 > OK, so the basic problem here is that pata_legacy attaches the host,
 > sees if it found any devices and detaches it if none were found.  With
 > async probing, it's not waiting until discovery is finished before
 > deciding it has no devices and trying the detach ... the warning is
 > because the detach is racing with the asynchronous probe.
 > 
 > One way to fix it would be to put an async_synchronize_full() before
 > looking for devices (try the patch below).  A better way might be to
 > separate libata into its own domain and only wait for that.
 > 
 > James
 > 
 > ---
 > 
 > diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
 > index f72c6c5..6932e56 100644
 > --- a/drivers/ata/pata_legacy.c
 > +++ b/drivers/ata/pata_legacy.c
 > @@ -48,6 +48,7 @@
 >   *
 >   */
 >  
 > +#include <linux/async.h>
 >  #include <linux/kernel.h>
 >  #include <linux/module.h>
 >  #include <linux/pci.h>
 > @@ -1028,6 +1029,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 >  				&legacy_sht);
 >  	if (ret)
 >  		goto fail;
 > +	async_synchronize_full();
 >  	ld->platform_dev = pdev;
 >  
 >  	/* Nothing found means we drop the port as its probably not there */
 > 

Thanks, with this applied the kernel boots w/o problems.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>

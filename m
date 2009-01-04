Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbZADTr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbZADTr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760405AbZADTrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:47:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:36376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760221AbZADTrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:47:01 -0500
Date: Sun, 4 Jan 2009 11:48:52 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090104114852.2cfee4d3@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901041118390.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
	<alpine.LFD.2.00.0901041118390.3179@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 11:27:08 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 4 Jan 2009, Linus Torvalds wrote:
> > 
> > Ok, so why does the serial port init take so long? That's a quarter
> > of a second for you, which is ridiculous.
> 
> Hmm. I also note that you don't seem to have the IDE probing
> configured in at all. It's not _that_ uncommon, afaik, and even if
> you have no devices behind it (or perhaps _especially_ if you have no
> devices behind it), the IDE probe is actually pretty expensive. Hmm?

actually pretty much all PC distros no longer ship with CONFIG_IDE,
only libata.

And afaik the box that that bootchart came from only has SATA devices
and the bios is also configured as such.. so not even libata sees IDE
devices.

> Also, I'm looking at the AHCI vs Marvell thing, and the problem seems
> to be that you do that libata port scan like this:
> 
>         for (i = 0; i < host->n_ports; i++) {
>                 struct ata_port *ap = host->ports[i];
> 
>                 async_schedule(async_port_probe, ap);
>         }
> 
> 	async_synchronize_full();
>         /* probes are done, now scan each port's disk(s) */
>         DPRINTK("host probe begin\n");
>         for (i = 0; i < host->n_ports; i++) {
>                 struct ata_port *ap = host->ports[i];
> 
>                 ata_scsi_scan_host(ap, 1);
>         }
> 
> which means that there is a full serialization between each
> controller.

yeah in the current patch that is exactly the case.
I don't know the libata code enough to know if it's safe to do
otherwise. The code was structured such that it looked VERY deliberate
to do these two things in separate steps.

 
> Wouldn't is be possible to move the "ata_scsi_scan_host(ap, 1);"
> _into_ the async_port_probe(), and just do a
> 
> 	async_synchronize_cookie(cookie);
> 
> before it? Hmm?

I would think so but someone from the libata/scsi world needs to say
so.. I didn't want to break the world entirely yet. 

 
> And then not do any async_synchronize_full() at all, until much
> later. For example, we clearly do need that full synchronization
> before we try to mount the root filesystem, but we should have that

actually we should try to mount, and if we fail, then synchronize, and
try again. 
I need that capability for something else anyway 
(and have a patch to do this in general, I just need to dust it off and
see if it's still any good)

[in case you're curious: if you boot without initrd, and have a
touchpad, right now the kernel will wait for the touchpad probing to be
done explicitly before trying to mount the rootfs; on many laptops that
I have access to that touchpad probing can easily take 7 seconds. The
patch I have gets rid of that delay by just trying, for most cases
it'll just be there anyway]

> particular synchronization regardless of any SATA issues.

yeah likewise before freeing initmem... pretty much the same reason.
I'm not worried about that too much; at some point you just have to
serialize. no big deal.




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

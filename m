Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbXEJAa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbXEJAa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbXEJAaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:30:13 -0400
Received: from lixom.net ([66.141.50.11]:32945 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148AbXEJAaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:30:12 -0400
Date: Wed, 9 May 2007 19:32:29 -0500
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: PCMCIA on ppc64, and the joys of io port ranges on mmio-only platforms
Message-ID: <20070510003229.GA15682@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've got a very simple CF interface on our eval board, sitting on
localbus with a couple of gpios for control. mem and i/o port ranges
are mapped to two mmio ranges, i.e. 0xf0000000 and 0xf1000000 in our case.

I've got a pcmcia driver for the slot to handle all the probing, etc. It ioremaps both
the mem and io ranges, and provides that with the registered device:

        cf->mem_base = ioremap(mem->start, mem->end - mem->start);
        cf->io_base = ioremap(io->start, io->end - io->start);
[...]
        /* pcmcia layer only remaps "real" memory not iospace */
        cf->socket.io_offset = (unsigned long)cf->io_base;

        /* reserve chip-select regions */
        if (!request_mem_region(mem->start, mem->end + 1 - mem->start,
[...]
        if (!request_mem_region(io->start, io->end + 1 - io->start, driver_name))
[...]
        cf->socket.dev.parent = &ofdev->dev;
        cf->socket.ops = &electra_cf_ops;
        cf->socket.resource_ops = &pccard_static_ops;
        cf->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP | SS_CAP_MEM_ALIGN;
[...]

(I'll post the full driver separately, but wanted to bring this up first).

Bottom line is that io_offset points to the ioremap()ed memory, i.e a
64-bit kernel address.

The problems show up further up the stack, in this case in the
pata_pcmcia driver, where pcmcia_request_io() is used to handle the
address allocation. That in turn calls alloc_io_space(), which takes an
ioaddr_t * as argument and does math on it.

ioaddr_t is 32-bit, causing obvious problems since io_offset is
64-bit. There's a compatible kio_addr_t available, but I'm guessing it's
already not used because of ABI requiremenets given the big warning at
the definition of ioaddr_t.

Since ppc64 never has had pcmcia before (We're the first platform with
it), changing the type under ifdef like mips/arm shouldn't be a problem,
at least it won't lead to regressions -- there's no previous user apps
to regress.


However, that's not enough in this case: Next thing that will fail is
ioport_map() in ppc-specific code, called from devm_ioport_map(). It
currently assumes to be passed the bus-local port number and adding
it to the ioremap base of the (normally only) bus with I/O ports,
i.e. ISA/LPC. Since we already use that for other devices (UARTS, etc),
we now have more than one base register.

I see two ways to solve this:

1. Create infrastructure to track the various io-port ranges, register
them and let the infrastructure take care of the ioremap, pick the right
ioport_map(), etc. I.e. create virtual io port ranges.

2. Make ioport_map() detect already mapped arguments (i.e.:
+       if (port >= IMALLOC_BASE && (port+len) < IMALLOC_END)
+               return (void __iomem *)port;

(1) would be appealing if it was the only change needed, and if that
meant that I didn't have to change ioaddr_t. It doesn't though, since
the pcmcia code still stores the ioport_map():ed value in an ioaddr_t,
so it really just adds complexity without that much benefit.

I'm tempted to go with (2) + type change but if someone has a third
option I'm all ears.


-Olof

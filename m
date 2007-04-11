Return-Path: <linux-kernel-owner+w=401wt.eu-S1030476AbXDKUVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbXDKUVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXDKUVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:21:45 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:3749 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965292AbXDKUVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:21:44 -0400
Date: Thu, 12 Apr 2007 00:21:49 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Jay Estabrook <jay.estabrook@hp.com>
Cc: rth@twiddle.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ALPHA: support graphics on non-zero PCI domains
Message-ID: <20070412002149.A23659@jurassic.park.msu.ru>
References: <20070411123048.H17547@jurassic.park.msu.ru> <20070411160520.GB12573@twiddle.net> <461D1BA3.60903@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <461D1BA3.60903@hp.com>; from jay.estabrook@hp.com on Wed, Apr 11, 2007 at 01:32:19PM -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 01:32:19PM -0400, Jay Estabrook wrote:
> Yes, it does leak, and yes, it should be kmalloced. Something like this?
> 
>         struct resource *new_vga;
> 
>         new_vga = kmalloc(sizeof(struct resource), GFP_ATOMIC);
>         if (new_vga) {
>             *new_vga = alpha_vga;
>             new_vga->start += pci_vga_hose->io_space->start;
>             new_vga->end   += pci_vga_hose->io_space->start;
>             request_resource(&ioport_resource, new_vga);
>         }

No. After closer inspection this looks like a dead code.
This request_resource() always fails because the parent resource
passed to it is incorrect - it must be pci_vga_hose->io_space,
not ioport_resource.
On the other hand, I don't see why we should request VGA IO from
VGA_MAP_MEM, which might be called multiple times. Wouldn't it be
much cleaner to do it once right after VGA discovery?
I'd suggest the appended patch on top of your original one.

Ivan.

--- orig/arch/alpha/kernel/console.c	Tue Apr 10 12:26:12 2007
+++ linux/arch/alpha/kernel/console.c	Wed Apr 11 22:09:56 2007
@@ -18,6 +18,11 @@
 #ifdef CONFIG_VGA_HOSE
 
 struct pci_controller *pci_vga_hose = NULL;
+static struct resource alpha_vga = {
+	.name	= "alpha-vga+",
+	.start	= 0x3C0,
+	.end	= 0x3DF
+};
 
 static struct pci_controller * __init 
 default_vga_hose_select(struct pci_controller *h1, struct pci_controller *h2)
@@ -48,6 +53,11 @@ locate_and_init_vga(void *(*sel_func)(vo
 	/* Did we already initialize the correct one? Is there one? */
 	if (!hose || (conswitchp == &vga_con && pci_vga_hose == hose))
 		return;
+
+	/* Create a new VGA ioport resource WRT the hose it is on. */
+	alpha_vga.start += hose->io_space->start;
+	alpha_vga.end += hose->io_space->start;
+	request_resource(hose->io_space, &alpha_vga);
 
 	/* Set the VGA hose and init the new console. */
 	pci_vga_hose = hose;
--- orig/include/asm-alpha/vga.h	Tue Apr 10 12:26:12 2007
+++ linux/include/asm-alpha/vga.h	Wed Apr 11 22:07:17 2007
@@ -52,24 +52,6 @@ extern void scr_memcpyw(u16 *d, const u1
 
 extern struct pci_controller *pci_vga_hose;
  
-static inline unsigned long
-VGA_MAP_MEM(unsigned long xaddr, unsigned int size)
-{
-	/* Create a new VGA ioport resource WRT the hose it is on. */
-	if (pci_vga_hose && pci_vga_hose->index) {
-		static struct resource alpha_vga =
-		  { .name = "alpha-vga+", .start = 0x3C0, .end = 0x3DF };
-		struct resource new_vga = alpha_vga;
-
-		new_vga.start += pci_vga_hose->io_space->start;
-		new_vga.end   += pci_vga_hose->io_space->start;
-		request_resource(&ioport_resource, &new_vga);
-	}
-
-	/*  Return the ioremap. */
-	return (unsigned long) ioremap(xaddr, size);
-}
-
 # define __is_port_vga(a)       \
 	(((a) >= 0x3b0) && ((a) < 0x3e0) && \
 	 ((a) != 0x3b3) && ((a) != 0x3d3))
@@ -88,10 +70,11 @@ VGA_MAP_MEM(unsigned long xaddr, unsigne
  } while(0)
 
 #else /* CONFIG_VGA_HOSE */
-# define VGA_MAP_MEM(x,s)	((unsigned long) ioremap(x, s))
 # define pci_vga_hose 0
 # define FIXUP_IOADDR_VGA(a)
 # define FIXUP_MEMADDR_VGA(a)
 #endif /* CONFIG_VGA_HOSE */
+
+#define VGA_MAP_MEM(x,s)	((unsigned long) ioremap(x, s))
 
 #endif

Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbXDAO4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbXDAO4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbXDAO4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:56:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43527 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933140AbXDAO4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:56:54 -0400
Date: Sun, 1 Apr 2007 17:00:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Pedram M" <pmessri@gmail.com>
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: my first janitorial
Message-ID: <20070401170043.27a581cb@the-village.bc.nu>
In-Reply-To: <9c9aa5d00703312224t1948b24bhe34199f19cbda4fb@mail.gmail.com>
References: <9c9aa5d00703310639q68fa5d19k4d8e3bfb56b1fa6@mail.gmail.com>
	<9c9aa5d00703312224t1948b24bhe34199f19cbda4fb@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 22:24:12 -0700
"Pedram M" <pmessri@gmail.com> wrote:

> How about this one? Am I doing it right now?
> If not, please try to explain more to me what I am
> doing wrong.

You need to hold a reference to the PCI device for the entire duration it
is used. I think you actually also need something like this to get the whole
thing using pci references and pci_get_* properly

Alan

--- drivers/char/cyclades.c~	2007-04-01 15:52:16.000000000 +0100
+++ drivers/char/cyclades.c	2007-04-01 15:52:16.000000000 +0100
@@ -4803,7 +4782,7 @@
                 cy_card[j].bus_index = 1;
                 cy_card[j].first_line = cy_next_channel;
                 cy_card[j].num_chips = cy_pci_nchan/4;
-		cy_card[j].pdev = pdev;
+		cy_card[j].pdev = pci_dev_get(pdev);
 	
                 /* enable interrupts in the PCI interface */
 		plx_ver = cy_readb(cy_pci_addr2 + CyPLX_VER) & 0x0f;
@@ -4901,7 +4880,7 @@
 			Ze_addr0[ZeIndex] = cy_pci_addr0;
 			Ze_addr2[ZeIndex] = cy_pci_addr2;
 			Ze_irq[ZeIndex] = cy_pci_irq;
-			Ze_pdev[ZeIndex] = pdev;
+			Ze_pdev[ZeIndex] = pci_dev_get(pdev);
 			ZeIndex++;
 		    }
 		    i--;
@@ -4986,7 +4965,7 @@
                 cy_card[j].bus_index = 1;
                 cy_card[j].first_line = cy_next_channel;
                 cy_card[j].num_chips = -1;
-		cy_card[j].pdev = pdev;
+		cy_card[j].pdev = pci_dev_get(pdev);
 
                 /* print message */
 #ifdef CONFIG_CYZ_INTR
@@ -5007,6 +4986,10 @@
                 cy_next_channel += cy_pci_nchan;
 	    }
         }
+        
+        if (pdev)
+		pci_dev_put(pdev);
+        
 
         for (; ZeIndex != 0 && i < NR_CARDS; i++) {
 	    cy_pci_phys0 = Ze_phys0[0];
@@ -5485,11 +5468,12 @@
 	    )
 		free_irq(cy_card[i].irq, &cy_card[i]);
 #ifdef CONFIG_PCI
-		if (cy_card[i].pdev)
+		if (cy_card[i].pdev) {
 			pci_release_regions(cy_card[i].pdev);
+			pci_dev_put(pdev);
+		}
 #endif
         }
     }
 } /* cy_cleanup_module */
 
 module_init(cy_init);

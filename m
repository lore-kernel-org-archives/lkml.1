Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbZEWWM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbZEWWM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 18:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZEWWMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 18:12:20 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:50764 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZEWWMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 18:12:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Po94zLFqEqGYW7JN1Oi74/6szAFZ/5IcfuFec7g9vc29kI0AS491I2kKEWPj0wHK3K
         scSAhHrBgoIZBFKRKYmXn3mcztaVprgUr+3gTLvnFsKYR9OwlffX9dBDRNZbc4m2R1OC
         niKERFJZ+WbT3a5fGftVkRnPv1IfUoJZPnCak=
MIME-Version: 1.0
In-Reply-To: <c384c5ea0905231358t4803fbc6gf54618b2839a448a@mail.gmail.com>
References: <c384c5ea0905231358t4803fbc6gf54618b2839a448a@mail.gmail.com>
Date: Sun, 24 May 2009 00:12:18 +0200
Message-ID: <c384c5ea0905231512u72894e34g17746548e640d4fe@mail.gmail.com>
Subject: Re: mpc8315e-rdb: pci_enable_msi() fails (using today's 
	galak/powerpc.git tree)
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Linux PPC <linuxppc-dev@ozlabs.org>, linuxppc-embedded@ozlabs.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, May 23, 2009 at 10:58 PM, Leon Woestenberg
<leon.woestenberg@gmail.com> wrote:
> using this tree: git://git.kernel.org/pub/scm/linux/kernel/git/galak/powerpc.git
>
> pci_enable_msi() fails on my MPC8315E-RDB board with PCIe device in

I found that the DTS for the MPC8315E-RDB is missing the msi bits. I
added these, converted from the BSP (in old non-hex format):

                ipic-msi@7c0 {
                        compatible = "fsl,ipic-msi";
                        reg = <0x7c0 0x40>;
                        msi-available-ranges = <0 0x100>;
                        interrupts = < 0x43 8
                                       0x4  8
                                       0x51 8
                                       0x52 8
                                       0x56 8
                                       0x57 8
                                       0x58 8
                                       0x59 8 >;
                        interrupt-parent = < &ipic >;
                };



Now the MSI stuff gets set-up, pci_enable_msi() does not fault. My
interrupt handler is still not called though.

Partial log below:

[  246.907366] Setting up Freescale MSI support
[  247.858192] irq: irq 67 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 67
[  249.323654] irq: irq 4 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 21
[  250.779210] irq: irq 81 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 81
[  252.244662] irq: irq 82 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 82
[  253.710192] irq: irq 86 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 86
[  255.175651] irq: irq 87 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 87
[  256.641100] irq: irq 88 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 88
[  258.106549] irq: irq 89 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 89

[  309.396138] pci_enable_msi()
[  309.399735] irq: irq 0 on host /immr@e0000000/ipic-msi@7c0 mapped
to virtual irq 24
[  309.408030] fsl_compose_msi_msg: allocated srs: 0, ibs: 0
[  309.414160] Enabled MSI interrupting.
[  309.418449] pci_read_config_byte(..., PCI_REVISION_ID, ...)
[  309.424754] Board revision: 0x01.
[  309.428690] pci_request_regions()
[  309.432654] pci_set_dma_mask()
[  309.436337] Using a 64-bit DMA mask.
[  309.455605] request_irq()
[  309.458925] Succesfully requested IRQ #24 with dev_id 0xc71c5440

debugfs shows:

virq   hwirq    chip name        host name
   17  0x00009   IPIC            /immr@e0000000/interrupt-controller@700
   22  0x00010   IPIC            /immr@e0000000/interrupt-controller@700
   23  0x0000e   IPIC            /immr@e0000000/interrupt-controller@700
   24  0x00000   FSL-MSI         /immr@e0000000/ipic-msi@7c0
   32  0x00020   IPIC            /immr@e0000000/interrupt-controller@700
   33  0x00021   IPIC            /immr@e0000000/interrupt-controller@700
   34  0x00022   IPIC            /immr@e0000000/interrupt-controller@700
   35  0x00023   IPIC            /immr@e0000000/interrupt-controller@700
   36  0x00024   IPIC            /immr@e0000000/interrupt-controller@700
   37  0x00025   IPIC            /immr@e0000000/interrupt-controller@700
   38  0x00026   IPIC            /immr@e0000000/interrupt-controller@700

Regards, Leon.

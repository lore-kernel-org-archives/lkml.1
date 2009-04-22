Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZDVLQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZDVLQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZDVLQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:16:04 -0400
Received: from khc.piap.pl ([195.187.100.11]:37268 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbZDVLQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:16:01 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Char: cyclades, plx9060 casts cleanup
References: <1240384003-25499-1-git-send-email-jirislaby@gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 22 Apr 2009 13:15:58 +0200
In-Reply-To: <1240384003-25499-1-git-send-email-jirislaby@gmail.com> (Jiri Slaby's message of "Wed\, 22 Apr 2009 09\:06\:38 +0200")
Message-ID: <m3mya9ey6p.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> Remove ugly all-over-the-code casts of ctl_addr to 9060 space.
> Add an union to the cyclades_card structure, which contains
> a pointer to both 9050 and 9060 spaces.
>
> The 9050 space layout is unknown, so let it still as a void
> __iomem pointer.

FYI: 9050 and 9060 certainly refer to PLXtech's PCI9050 and PCI9060
bridges. Those are PCI-to-local-bus bridges, 9050 being a simpler
target-only device and 9060 also featuring programmable DMA controller
(= bus master on both PCI and local bus) and local-bus-target -> PCI
bus master operation (for a CPU or FPGA on the local bus).

The 9050 register space is well known, e.g. struct plx9050 in
drivers/net/wan/pc300too.c (later). IIRC the registers can be accessed
as MMIO (region 0) or IO (region 1) on the PCI bus. There are up to 4
additional regions, used for PCI->local bus transfers (the configuration
is in a small external EEPROM).

These bridges (especially 9050 and its newer versions) are quite
popular. Perhaps we should move the definitions to some common header
files, shared by the drivers?

struct {
        u32 loc_addr_range[4];  /* 00-0Ch : Local Address Ranges */
        u32 loc_rom_range;      /* 10h : Local ROM Range */
        u32 loc_addr_base[4];   /* 14-20h : Local Address Base Addrs */
        u32 loc_rom_base;       /* 24h : Local ROM Base */
        u32 loc_bus_descr[4];   /* 28-34h : Local Bus Descriptors */
        u32 rom_bus_descr;      /* 38h : ROM Bus Descriptor */
        u32 cs_base[4];         /* 3C-48h : Chip Select Base Addrs */
        u32 intr_ctrl_stat;     /* 4Ch : Interrupt Control/Status */
        u32 init_ctrl;          /* 50h : EEPROM ctrl, Init Ctrl, etc */
}plx9050;


OTOH 9060 struct in cyclades.h is a bit simplified version, in reality

struct RUNTIME_9060 {
        __u32   loc_addr_range; /* 00h - Local Address Range */
        __u32   loc_addr_base;  /* 04h - Local Address Base */
        __u32   loc_arbitr;     /* 08h - Local Arbitration */
        __u32   endian_descr;   /* 0Ch - Big/Little Endian Descriptor */

Interestingly registers 8 and 0x0C are "reserved" in my book (v1.2,
1995, I don't think there is newer version).

        __u32   loc_rom_range;  /* 10h - Local ROM Range */
        __u32   loc_rom_base;   /* 14h - Local ROM Base */
        __u32   loc_bus_descr;  /* 18h - Local Bus descriptor */
        __u32   loc_range_mst;  /* 1Ch - Local Range for Master to PCI */
        __u32   loc_base_mst;   /* 20h - Local Base for Master PCI */
        __u32   loc_range_io;   /* 24h - Local Range for Master IO */
        __u32   pci_base_mst;   /* 28h - PCI Base for Master PCI */
        __u32   pci_conf_io;    /* 2Ch - PCI configuration for Master IO */
        __u32   filler1;        /* 30h */
        __u32   filler2;        /* 34h */
        __u32   filler3;        /* 38h */
        __u32   filler4;        /* 3Ch */
        __u32   mail_box_0;     /* 40h - Mail Box 0 */
        __u32   mail_box_1;     /* 44h - Mail Box 1 */
        __u32   mail_box_2;     /* 48h - Mail Box 2 */
        __u32   mail_box_3;     /* 4Ch - Mail Box 3 */
        __u32   filler5;        /* 50h */
        __u32   filler6;        /* 54h */
        __u32   filler7;        /* 58h */
        __u32   filler8;        /* 5Ch */

filler5-8 are actually mail_box_4 to 7 (probably not used by Cyclades'
firmware).

        __u32   pci_doorbell;   /* 60h - PCI to Local Doorbell */
        __u32   loc_doorbell;   /* 64h - Local to PCI Doorbell */
        __u32   intr_ctrl_stat; /* 68h - Interrupt Control/Status */
        __u32   init_ctrl;      /* 6Ch - EEPROM control, Init Control, etc */
};

And there are 13 additional registers at 0x100 for the DMA controller.
Probably only accessed from the local bus by Cyclades's firmware, or not
used.

Just in case someone needs the details.
-- 
Krzysztof Halasa

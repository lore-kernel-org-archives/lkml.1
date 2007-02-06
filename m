Return-Path: <linux-kernel-owner+w=401wt.eu-S965286AbXBFAdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965286AbXBFAdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965220AbXBFAdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:33:19 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:45585 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965223AbXBFAdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:33:17 -0500
Date: Tue, 6 Feb 2007 01:31:30 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?unknown-8bit?B?6Kix5oGG5ZiJ?= <edward_hsu@realtek.com.tw>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, hiwu@realtek.com.tw
Subject: Re: [PATCH 2.6.19.2] r8169: support RTL8169SC/8110SC
Message-ID: <20070206003130.GA18236@electric-eye.fr.zoreil.com>
References: <45C2F390.4070805@realtek.com.tw> <20070203003952.GA22823@electric-eye.fr.zoreil.com> <45C6A8EC.5090201@realtek.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45C6A8EC.5090201@realtek.com.tw>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

許恆嘉 <edward_hsu@realtek.com.tw> :
[...]
> >>static struct pci_device_id rtl8169_pci_tbl[] = {
> >>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8129), 0, 0, RTL_CFG_0 },
> >>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8136), 0, 0, RTL_CFG_2 },
> >>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8167), 0, 0, RTL_CFG_0 },
> >>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8168), 0, 0, RTL_CFG_2 },
> >>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8169), 0, 0, RTL_CFG_0 },
> >>- { PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x4300), 0, 0, RTL_CFG_0 },
> >>- { PCI_DEVICE(0x1259, 0xc107), 0, 0, RTL_CFG_0 },
> >>- { PCI_DEVICE(0x16ec, 0x0116), 0, 0, RTL_CFG_0 },
> >>- { PCI_VENDOR_ID_LINKSYS, 0x1032,
> >>- PCI_ANY_ID, 0x0024, 0, 0, RTL_CFG_0 },
> >>+ { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8169), },
> >>+ { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8167), },
> >>   
> >>
> >
> >The current driver is intended to handle the whole set of PCI IDs
> >which would be removed by the patch. Thoug some combination of
> >chipset and motherboard do not work as expected, the gigabit
> >chipsets have been reported to work.
> >
> >Please elaborate if there is a good reason to remove any ID.
> > 
> >
> ANS:
> I have explained my point about this in last question. This driver is 
> developed for Realtek PCI gigabit ethernet controllers. Although some 
> vendors may use Realtek solutions with their own PCI DIDs and VIDs, they 
> should customize this driver and maintained the customized driver on 
> their own.

Vendors will change the PCI ID because they like to see their name in
the nifty hardware GUI under Windows. The brave ones will mess with the
VPD (before or after they vandalize the ACPI tables, at their option).
Eventually they will copy an outdated version of your driver on their site
with the updated ID. Given the tight margin on these kind of mass-volume
product, I would not expect vendors to do more for their customers who
use Linux.

If your hardware changes significantly, it may make sense to use a new,
different driver. Otherwise, as long as the changes are minor, a single
in-kernel driver which works out of the box for most users/vendors offers
the best coverage. It should not be neglected.

So far, I have only seen minor differences between r8101-1.001.00,
r8168-8.001.00 and r8169-6.001.00. The mac init sequence is not pretty
to unify but the drivers stay mostly the same. There even is a floating
patch for MSI support which seems manageable within a single driver.

Of course it depends a lot on the kind of changes that you envision for
the driver(s).

[...]
> >>RxMaxSize = 0xDA,
> >>CPlusCmd = 0xE0,
> >>IntrMitigate = 0xE2,
> >>@@ -287,11 +291,10 @@ enum RTL8169_register_content {
> >>RxOK = 0x01,
> >>
> >>/* RxStatusDesc */
> >>- RxFOVF = (1 << 23),
> >>- RxRWT = (1 << 22),
> >>- RxRES = (1 << 21),
> >>- RxRUNT = (1 << 20),
> >>- RxCRC = (1 << 19),
> >>+ RxRES = 0x00200000,
> >>+ RxCRC = 0x00080000,
> >>+ RxRUNT = 0x00100000,
> >>+ RxRWT = 0x00400000,
> >>   
> >>
> >
> >This part removes RxFOVF. Please elaborate if there is a reason
> >to do so.
> > 
> >
> 
> ANS:
> According to the spec of RTL8110SC, bit 23 and bit 24 are reserved in 
> the 1st double word of rx status descriptor. Therefore, I delete it.

The bits are fine for the old Gigabit 8169 though, aren't they ?

[...]
> >Two points here:
> >1. the driver uniformly uses u{8/16/32} types. Please follow the current
> >  style and avoid to add uint{8/16/32}_t things.
> >2. does this new field bring something that struct net_device.dev_addr
> >  does not ?
> >
> > 
> >
> ANS:
> I reference the source code of e1000.c, which is currently existing in 
> Linux kernel. I think it uses u{8/16/32} and the new field.

The e1000 driver has an interesting history. It is strongly suggested
to ponder several drivers to figure some good practices. Please see for
instance tg3.c, b44.c, sky2.c or any recent driver in drivers/net.

-- 
Ueimor

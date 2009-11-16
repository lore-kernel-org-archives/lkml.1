Return-Path: <linux-kernel-owner+w=401wt.eu-S1751103AbZKPVVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbZKPVVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZKPVVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:21:08 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11122 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZKPVVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:21:07 -0500
Date: Mon, 16 Nov 2009 14:21:13 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/pci: remove early PCI pr_debug statements
Message-ID: <20091116212113.GF21242@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit db635adc turned -DDEBUG for x86/pci on when CONFIG_PCI_DEBUG
is set. In general, I agree with that change.

However, it exposes a bunch of very low level PCI debugging in the
early x86 path, such as:

	0 reading 2 from a: ffff
	1 reading 2 from a: ffff
	2 reading 2 from a: ffff
	3 reading 2 from a: 300
	3 reading 2 from 0: 1002
	3 reading 2 from 2: 515e

These statements add a lot of noise to the boot and aren't likely to
be necessary even when handling random upstream bug reports.

[In contrast, statements such as these:

	pci 0000:02:04.0: found [14e4:164a] class 000200 header type 00
	pci 0000:02:04.0: reg 10: [mem 0xf8000000-0xf9ffffff 64bit]
	pci 0000:02:04.0: reg 30: [mem 0x00000000-0x0001ffff pref]

are indeed useful when remote debugging users' machines]

Remove the noisy printks and save electrons everywhere.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
index aaf26ae..d1067d5 100644
--- a/arch/x86/pci/early.c
+++ b/arch/x86/pci/early.c
@@ -12,8 +12,6 @@ u32 read_pci_config(u8 bus, u8 slot, u8 func, u8 offset)
 	u32 v;
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	v = inl(0xcfc);
-	if (v != 0xffffffff)
-		pr_debug("%x reading 4 from %x: %x\n", slot, offset, v);
 	return v;
 }
 
@@ -22,7 +20,6 @@ u8 read_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset)
 	u8 v;
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	v = inb(0xcfc + (offset&3));
-	pr_debug("%x reading 1 from %x: %x\n", slot, offset, v);
 	return v;
 }
 
@@ -31,28 +28,24 @@ u16 read_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset)
 	u16 v;
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	v = inw(0xcfc + (offset&2));
-	pr_debug("%x reading 2 from %x: %x\n", slot, offset, v);
 	return v;
 }
 
 void write_pci_config(u8 bus, u8 slot, u8 func, u8 offset,
 				    u32 val)
 {
-	pr_debug("%x writing to %x: %x\n", slot, offset, val);
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	outl(val, 0xcfc);
 }
 
 void write_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset, u8 val)
 {
-	pr_debug("%x writing to %x: %x\n", slot, offset, val);
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	outb(val, 0xcfc + (offset&3));
 }
 
 void write_pci_config_16(u8 bus, u8 slot, u8 func, u8 offset, u16 val)
 {
-	pr_debug("%x writing to %x: %x\n", slot, offset, val);
 	outl(0x80000000 | (bus<<16) | (slot<<11) | (func<<8) | offset, 0xcf8);
 	outw(val, 0xcfc + (offset&2));
 }

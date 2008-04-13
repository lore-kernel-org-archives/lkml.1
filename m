Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYDMIMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYDMIMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYDMIMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:12:19 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:33436 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286AbYDMIMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:12:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Q/6kckMsjlJ9df7zN3prsBnRn2S3xVpryhXBWHl7ne+5KDu0pW3rgCgLv6ckti6mbpF/ZFlAfBeFZqAZ80ZZhclIfvfeqtEmHcr2qptkJEzrTMIKIk3yb3nlQYJQbn8rmV1AzNKDzrhGWI0dJLX4dm59sPmlJRcNdYOZrT/zf8c=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] x86_64: agp_gart size checking for buggy device
Date: Sun, 13 Apr 2008 01:11:41 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804130111.42254.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


while lookin Rafael J. Wysocki <rjw@sisk.pl> system boot log,

find some funny print out

	Node 0: aperture @ de000000 size 32 MB
	Aperture too small (32 MB)
	AGP bridge at 00:04:00
	Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
	Aperture too small (0 MB)
	Your BIOS doesn't leave a aperture memory hole
	Please enable the IOMMU option in the BIOS setup
	This costs you 64 MB of RAM
	Mapping aperture over 65536 KB of RAM @ 4000000

	...

	agpgart: Detected AGP bridge 20
	agpgart: Aperture pointing to RAM
	agpgart: Aperture from AGP @ de000000 size 4096 MB
	agpgart: Aperture too small (0 MB)
	agpgart: No usable aperture found.
	agpgart: Consider rebooting with iommu=memaper=2 to get a good aperture.


it means BIOS allocate correct gart on NB and AGP bridge but because one bug in silicon
( the agp bridge report wrong order, it wants 4G instead)
the kernel will reject that allocation, also becase the size is only 32M. and try to get another
64M for gart, and late fix_northbridge can not revert that change because it still read
wrong size from agp bridge.

So try to double check order from agp bridge, before calling aperture_valid().

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 479926d..9f86778 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -138,6 +138,7 @@ static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
 	int nbits;
 	u32 aper_low, aper_hi;
 	u64 aper;
+	u32 old_order;
 
 	printk(KERN_INFO "AGP bridge at %02x:%02x:%02x\n", num, slot, func);
 	apsizereg = read_pci_config_16(num, slot, func, cap + 0x14);
@@ -146,6 +147,9 @@ static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
 		return 0;
 	}
 
+	/* old_order could be the value from NB gart setting */
+	old_order = *order;
+
 	apsize = apsizereg & 0xfff;
 	/* Some BIOS use weird encodings not in the AGPv3 table. */
 	if (apsize & 0xff)
@@ -159,6 +163,16 @@ static __u32 __init read_agp(int num, int slot, int func, int cap, u32 *order)
 	aper_hi = read_pci_config(num, slot, func, 0x14);
 	aper = (aper_low & ~((1<<22)-1)) | ((u64)aper_hi << 32);
 
+	/*
+	 * some sick chip, APSIZE is 0, it mean it wants 4G
+	 * so let double check that order, let trust AMD NB setting
+	 */
+	if (aper + (32UL<<(20 + *order)) > 0x100000000UL) {
+		printk(KERN_INFO "Aperture size %u MB (APSIZE %x) is not right, use setting from NB\n",
+				32 << *order, apsizereg);
+		*order = old_order;
+	}
+
 	printk(KERN_INFO "Aperture from AGP @ %Lx size %u MB (APSIZE %x)\n",
 			aper, 32 << *order, apsizereg);
 
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 9d82045..288d1f5 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -312,6 +312,17 @@ static __devinit int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp,
 	pci_read_config_dword(agp, 0x10, &aper_low);
 	pci_read_config_dword(agp, 0x14, &aper_hi);
 	aper = (aper_low & ~((1<<22)-1)) | ((u64)aper_hi << 32);
+
+        /*
+         * some sick chip, APSIZE is 0, it mean it wants 4G
+         * so let double check that order, let trust AMD NB setting
+         */
+        if (aper + (32UL<<(20 + order)) > 0x100000000UL) {
+                printk(KERN_INFO "Aperture size %u MB is not right, use setting from NB\n",
+                                32 << order);
+                order = nb_order;
+        }
+
 	printk(KERN_INFO PFX "Aperture from AGP @ %Lx size %u MB\n", aper, 32 << order);
 	if (order < 0 || !aperture_valid(aper, (32*1024*1024)<<order))
 		return -1;

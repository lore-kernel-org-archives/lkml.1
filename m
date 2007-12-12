Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbXLLBLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbXLLBLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbXLLBLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:11:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763AbXLLBLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:11:44 -0500
Date: Tue, 11 Dec 2007 17:11:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Rankin <rankincj@yahoo.com>
Cc: dcbw@redhat.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
Message-Id: <20071211171106.ec6f6d38.akpm@linux-foundation.org>
In-Reply-To: <587622.50680.qm@web52902.mail.re2.yahoo.com>
References: <1193657365.19938.17.camel@localhost.localdomain>
	<587622.50680.qm@web52902.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 19:41:58 +0000 (GMT)
Chris Rankin <rankincj@yahoo.com> wrote:

> Hi,
> 
> I've recently been having trouble loading the hostap_plx 802.11b wireless networking driver, and
> this evening I managed to narrow the problem down to these lines of code by copying code from
> hostap_plx into a "test driver" until the test driver also locked the PC up:
> 
>         /* read CIS; it is in even offsets in the beginning of attr_mem */
>         for (i = 0; i < CIS_MAX_LEN; i++)
>                 cis[i] = readb(attr_mem + 2 * i);
> 
> If I comment these lines out then my test driver just complains about the garbage CIS information
> and fails gracefully. Leave these lines in and my PC freezes instantly.
> 
> These lines are part of the prism2_plx_check_cis() function, which is called when the module first
> loads. CIX_MAX_LEN is a #define for 256, and cis is a u8* pointer previously allocated as:
> 
> cis = kmalloc(CIS_MAX_LEN, GFP_KERNEL);
> 
> attr_mem is one of the function's paramters, and is defined as void __iomem *attr_mem.
> 
> As far as I can tell, the PCI I/O memory information is correct, and matches what lspci tells me:
> 
> 00:0e.0 Network controller: Netgear MA301 802.11b Wireless PCI Adapter (rev 02)
>         Subsystem: Netgear MA301 802.11b Wireless PCI Adapter
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+
> FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR-
> <PERR-
>         Interrupt: pin A routed to IRQ 5
>         Region 1: I/O ports at 1000 [size=128]
>         Region 2: Memory at e8002000 (32-bit, non-prefetchable) [size=4K]
>         Region 3: I/O ports at 1080 [size=64]
> 
> so there is apparently 4K of I/O memory at 0xe8002000.
> 
> Can anyone help me understand why my PC is locking up when it executes this code, please?
> 

I guess something like this:


--- a/drivers/net/wireless/hostap/hostap_plx.c~a
+++ a/drivers/net/wireless/hostap/hostap_plx.c
@@ -343,13 +343,14 @@ static int prism2_plx_check_cis(void __i
 	int i, pos;
 	unsigned int rmsz, rasz, manfid1, manfid2;
 	struct prism2_plx_manfid *manfid;
+	int len = min(CIS_MAX_LEN, attr_len);
 
-	cis = kmalloc(CIS_MAX_LEN, GFP_KERNEL);
+	cis = kmalloc(len, GFP_KERNEL);
 	if (cis == NULL)
 		return -ENOMEM;
 
 	/* read CIS; it is in even offsets in the beginning of attr_mem */
-	for (i = 0; i < CIS_MAX_LEN; i++)
+	for (i = 0; i < len; i++)
 		cis[i] = readb(attr_mem + 2 * i);
 	printk(KERN_DEBUG "%s: CIS: %02x %02x %02x %02x %02x %02x ...\n",
 	       dev_info, cis[0], cis[1], cis[2], cis[3], cis[4], cis[5]);
@@ -361,8 +362,8 @@ static int prism2_plx_check_cis(void __i
 	manfid1 = manfid2 = 0;
 
 	pos = 0;
-	while (pos < CIS_MAX_LEN - 1 && cis[pos] != CISTPL_END) {
-		if (pos + 2 + cis[pos + 1] > CIS_MAX_LEN)
+	while (pos < len - 1 && cis[pos] != CISTPL_END) {
+		if (pos + 2 + cis[pos + 1] > len)
 			goto cis_error;
 
 		switch (cis[pos]) {
@@ -401,7 +402,7 @@ static int prism2_plx_check_cis(void __i
 		pos += cis[pos + 1] + 2;
 	}
 
-	if (pos >= CIS_MAX_LEN || cis[pos] != CISTPL_END)
+	if (pos >= len || cis[pos] != CISTPL_END)
 		goto cis_error;
 
 	for (manfid = prism2_plx_known_manfids; manfid->manfid1 != 0; manfid++)
_

would be a bit safer, but looking at your /proc/iomem I doubt if it will
fix anything.

It might be interesting to see what value of `i' is causing it to fall
over.

Did any earlier version of the 2.6 kernel work OK?

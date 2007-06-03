Return-Path: <linux-kernel-owner+w=401wt.eu-S1751992AbXFCWNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbXFCWNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 18:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbXFCWNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 18:13:13 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:51375 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbXFCWNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 18:13:12 -0400
Message-id: <304615082222625376@wsc.cz>
Subject: [PATCH 1/1] Char: stallion, don't fail with less than max panels
From: Jiri Slaby <jirislaby@gmail.com>
To: "Ingo Korb" <ml@akana.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: stallion driver dmesg notice
In-reply-to: <46633BC8.3838.43FB8257@ml.akana.de>
Date: Mon,  4 Jun 2007 00:13:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Korb wrote:
> Stallion Multiport Serial Driver: version 5.6.0
> stallion 0000:00:0b.0: please, report this to LKML: 100b/d001/ffffff
> ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 17
> stallion: probe of 0000:00:0b.0 failed with error -16
> === Cut ===
>
> The card is a EC8/32-PCI with a single connected panel. It used to work 
> well with 2.4, mostly well with a patched 2.6.8.1, really bad 
> (unstable, lost characters) with 2.6.11(?) and doesn't work at all with 
> 2.6.21.3.

Hmm, breakage in 2.6.11 is interesting, I'll try to dig through logs, what
could happen.

> Should I test it with an EC8/64-PCI? The /32 (ab)uses an IDE controller 
> chip as PCI interface, the /64 uses a PLX PCI9050.

I don't undestand this. IDE grabs the device? This is possible and if yes,
I'll fix the IDE driver.

Could you please try the patch below?

--
stallion, don't fail with less than max panels

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit a6c3fb453e98ba32291a4fc5a7d843fb27359182
tree d28d09d3fa53b7af465c7b4cc88c295459c96276
parent 8785a2ca27122a0a46119fc57e7667bf9c916df4
author Jiri Slaby <jirislaby@gmail.com> Mon, 04 Jun 2007 00:05:16 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 04 Jun 2007 00:07:32 +0200

 drivers/char/stallion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 05f492d..9820f49 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -2172,7 +2172,7 @@ static int __devinit stl_initech(struct stlbrd *brdp)
 		}
 		status = inb(ioaddr + ECH_PNLSTATUS);
 		if ((status & ECH_PNLIDMASK) != nxtid)
-			goto err_fr;
+			break;
 		panelp = kzalloc(sizeof(struct stlpanel), GFP_KERNEL);
 		if (!panelp) {
 			printk("STALLION: failed to allocate memory "

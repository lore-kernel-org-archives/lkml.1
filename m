Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbYE3XvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbYE3XvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYE3XvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:51:08 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:54682 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbYE3XvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:51:05 -0400
Message-ID: <484093A2.8060304@keyaccess.nl>
Date: Sat, 31 May 2008 01:54:10 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Takashi Iwai <tiwai@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: [PATCH] PNP: set the pnp_card dma_mask for use by ISAPnP cards
References: <4823AAF2.7070102@keyaccess.nl> <482B38D6.5030804@keyaccess.nl> <48406E8D.8050408@keyaccess.nl> <200805301543.42208.bjorn.helgaas@hp.com> <48407B99.4080209@keyaccess.nl>
In-Reply-To: <48407B99.4080209@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------050004000406080804070800"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050004000406080804070800
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit




--------------050004000406080804070800
Content-Type: text/plain;
 name="0001-PNP-set-the-pnp_card-dma_mask-for-use-by-ISAPnP-c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-PNP-set-the-pnp_card-dma_mask-for-use-by-ISAPnP-c.patch"

>From 801c13fb3e8564221a1fb21892dbe13add3d7cea Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Fri, 30 May 2008 23:10:23 +0200
Subject: [PATCH] PNP: set the pnp_card dma_mask for use by ISAPnP cards.

dma_alloc_coherent() on x86 currently takes a passed in NULL device
pointer to mean that it should allocate an ISA compatible (24-bit)
buffer which is a bit of a hack.

The ALSA ISA drivers are the main consumers of this but have a struct
device in fact readily available.

For the PnP drivers, the specific pnp_dev->dev device pointer is not
always available at the right time so for now we want to pass the
pnp_card->dev instead which is always available. Set its dma_mask in
preparation for doing so.

This does not fix a current bug -- 2.6.26-rc1 stumbled over the NULL
hack in dma_alloc_coherent() but this has already been fixed in commit
4a367f3a9dbf2e7ffcee4702203479809236ee6e by Takashi Iwai.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/pnp/card.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/pnp/card.c b/drivers/pnp/card.c
index a762a41..b00ef10 100644
--- a/drivers/pnp/card.c
+++ b/drivers/pnp/card.c
@@ -8,6 +8,7 @@
 #include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/pnp.h>
+#include <linux/dma-mapping.h>
 #include "base.h"
 
 LIST_HEAD(pnp_cards);
@@ -167,6 +168,9 @@ struct pnp_card *pnp_alloc_card(struct pnp_protocol *protocol, int id, char *pnp
 	sprintf(card->dev.bus_id, "%02x:%02x", card->protocol->number,
 		card->number);
 
+	card->dev.coherent_dma_mask = DMA_24BIT_MASK;
+	card->dev.dma_mask = &card->dev.coherent_dma_mask;
+
 	dev_id = pnp_add_card_id(card, pnpid);
 	if (!dev_id) {
 		kfree(card);
-- 
1.5.2.2


--------------050004000406080804070800--

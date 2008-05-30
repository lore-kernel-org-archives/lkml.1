Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbYE3VNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbYE3VNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYE3VMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:12:55 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:34686 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYE3VMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:12:54 -0400
Message-ID: <48406E8D.8050408@keyaccess.nl>
Date: Fri, 30 May 2008 23:15:57 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl> <482B0807.9050404@keyaccess.nl> <482B3274.2060006@keyaccess.nl> <200805141250.57115.bjorn.helgaas@hp.com> <482B38D6.5030804@keyaccess.nl>
In-Reply-To: <482B38D6.5030804@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------030605020307000902060404"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030605020307000902060404
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 14-05-08 21:09, Rene Herman wrote:

> On 14-05-08 20:50, Bjorn Helgaas wrote:

>> I agree, it seems a bit of a hack to use a DMA mask from the card
>> instead of from the device, since the driver should be programming
>> the device to do the DMA.
>>
>> But I know very little about pnp_card in general, so don't attach too
>> much weight to my opinion.
> 
> Okay, I'll sit on this for a bit. Right now we're using a global device 
> even but this is exactly about cleaning that up so couldn't convince 
> myself. Will see what happens when I try to make it nice...

It gets uglier. ALSA ISA drivers (for cards that exist both as legacy 
and as ISAPnP at least) keep a merged legacy/isapnp model; PnP is used 
mostly for initializing global variables that the same old legacy probe 
routines then reference. This means that beyond that global resource 
init step the specific struct device is no longer available. Without 
restructuring too many things really only fixable through other hacks 
again such as a global dma_dev[] array or some such.

 From the viewpoint of PnP itself setting the dma_mask for a pnp_card (a 
pnp_dev collection) makes isolated sense so if no objections, I'll 
submit the attached after all. From the ALSA side we'd then pass the 
card dev (which we'd also do for isa_dev) and keep in mind that we might 
want to get more specific if over time structure permits it.

struct snd_pcm already has its own struct device * which would be the 
right one here but it's setting that which gets ugly...

Rene.

--------------030605020307000902060404
Content-Type: text/plain;
 name="0001-PNP-set-the-pnp_card-dma_mask-for-use-by-ISAPnP-car.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-PNP-set-the-pnp_card-dma_mask-for-use-by-ISAPnP-car.pat";
 filename*1="ch"

>From b4e8e6b833d2e8ed3a2b78912c4afff563d8ae21 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Fri, 30 May 2008 23:10:23 +0200
Subject: [PATCH] PNP: set the pnp_card dma_mask for use by ISAPnP cards.

This makes the pnp_card->dev available as a DMAable device same as
the pnp_dev->dev.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
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


--------------030605020307000902060404--

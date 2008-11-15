Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbYKOPYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbYKOPYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 10:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYKOPY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 10:24:27 -0500
Received: from cpsmtpo-eml03.KPNXCHANGE.COM ([213.75.38.152]:46470 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbYKOPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 10:24:27 -0500
From: Frans Pop <elendil@planet.nl>
To: dbrownell@users.sourceforge.net
Subject: Re: [PATCH] pcmcia: ensure correct logging in do_io_probe [v2]
Date: Sat, 15 Nov 2008 16:24:24 +0100
User-Agent: KMail/1.9.9
References: <200811071522.43618.elendil@planet.nl> <20081109212849.GA12584@isilmar.linta.de>
In-Reply-To: <20081109212849.GA12584@isilmar.linta.de>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_omuHJYkvUwD3LUR"
Message-Id: <200811151624.24904.elendil@planet.nl>
X-OriginalArrivalTime: 15 Nov 2008 15:24:25.0339 (UTC) FILETIME=[3E2814B0:01C94736]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_omuHJYkvUwD3LUR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 09 November 2008, Dominik Brodowski wrote:
> On Fri, Nov 07, 2008 at 03:22:42PM +0100, Frans Pop wrote:
> > During early probing of the parent PCI bridge I/O window no socket
> > has been allocated yet.
> > In that case print &s->cb_dev->dev instead of &s->dev as device.
>
> similar to the other patch, this won't work: &skt->cb_dev is only
> available and set if the parent device is a PCI device; therefore,
> &skt->dev is the only thing we can use.

OK.

I still feel I'm missing something in the debug logging. Shouldn't there 
be a line saying something like the following?
yenta_cardbus 0000:02:06.0: Assigned pcmcia socket 0

> An alternative approach would be to move this initialization code only
> after we've set dev_name. Could you test whether this approach works
> for you, please?

Tested on two different systems: Toshiba Satellite A40 running i386 (with 
atheros wlan card already inserted during boot) and HP 2510p running 
x86_64 (with same card inserted after boot).
Both with patch applied against current mainline git. I've not seen any 
problems and wireless worked in both cases.

There are some differences in the logs (see attachments). I only see the 
IO probes on the Toshiba, not on the HP. I'd guess that's expected.

Tested-by: Frans Pop <elendil@planet.nl>


This does leave one minor issue from my previous patch. Please consider 
applying the attached patch.

Cheers,
FJP


--Boundary-00=_omuHJYkvUwD3LUR
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="pcmcia_close-prink.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="pcmcia_close-prink.patch"

From: Frans Pop <elendil@planet.nl>

pcmcia: properly close previous dev_printk if kzalloc fails in do_io_probe

Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index 17f4ecf..da95252 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -206,6 +206,7 @@ static void do_io_probe(struct pcmcia_socket *s, unsigned int base,
     /* First, what does a floating port look like? */
     b = kzalloc(256, GFP_KERNEL);
     if (!b) {
+	    printk("\n");
 	    dev_printk(KERN_ERR, &s->dev,
 		   "do_io_probe: unable to kmalloc 256 bytes");
             return;

--Boundary-00=_omuHJYkvUwD3LUR
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="pcmcia_hp2510p.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="pcmcia_hp2510p.log"

yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30c9]
yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0cb8, PCI irq 18
yenta_cardbus 0000:02:06.0: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #06
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0x80000000 - 0x83ffffff
pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0

--Boundary-00=_omuHJYkvUwD3LUR
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="pcmcia_toshiba.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="pcmcia_toshiba.log"

yenta_cardbus 0000:01:0b.0: CardBus bridge found [1179:0001]
yenta_cardbus 0000:01:0b.0: ISA IRQ mask 0x0c38, PCI irq 18
yenta_cardbus 0000:01:0b.0: Socket status: 30000020
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge I/O window: 0xc000 - 0xcfff
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc000-0xcfff: clean.
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0xcff00000 - 0xcfffffff
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0x28000000 - 0x2bffffff
pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.

--Boundary-00=_omuHJYkvUwD3LUR--

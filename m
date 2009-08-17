Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZHQPHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZHQPHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 11:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZHQPHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 11:07:24 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:35056 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbZHQPHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 11:07:24 -0400
Message-ID: <4A89722A.1070407@s5r6.in-berlin.de>
Date: Mon, 17 Aug 2009 17:07:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ohci1396_dma=early nogo on an imac?
References: <4A88F6BF.7090104@gmail.com>
In-Reply-To: <4A88F6BF.7090104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> Seems the macbook shows the init ohci1394_dma
> activating, but using this on an imac has no affects.
> is this device supported yet or is this still in the process of being
> developed?(event though the imac is 1394 800 port).
> 
> At the moment my machine boots up 2.6.30.4 but will not bootup
> the latest git. If the early dma option is possible with the imac9,1
> I can send out a post with the error, and see if somebody might know.
> (but if this isn't possible then Ill take the 40$
> for the cable and and spend it on beer)...

init_ohci1394_dma is supposed to work on all OHCI-1394 compliant
controllers.  This includes all FireWire controllers in all iMac models
ever made.  (However, init_ohci1394_dma's initialization is a
trimmed-down version of ohci1394's, and is much much less widely tested
than the ohci1394 driver, hence there may be things which work in the
latter but not quite in the former.  If so, it should be fixed.)

But note that there is an important limitation in init_ohci1394_dma:
After it opened the DMA filters, there must be no subsequent FireWire
bus reset.  When a bus reset happens, the controller immediately filters
everything again ( = disallows remote DMA).  To compensate for that,
init_ohci1394_dma would have to have an IRQ handler which handles bus
reset IRQ events.  (And the CPU must not lock up before you need it to
handle the IRQ.)

Causes for a bus reset are:
  - Something was plugged out or into the bus.
  - One of the nodes on the bus changed its configuration (e.g.
    a disk enclosure finished spinning up its drive mechanism after
    power-on).
  - One of the nodes on the bus (the one which volunteers to be the
    so-called isochronous resource manager or bus manager) resets
    the bus to enable or optimize some bus functions.
To avoid all this, its best if you only have a single other node (as
debugger console) plugged in, have it already powered on and running the
1394 driver stack at the moment when your test PC starts
init_ohci1394_dma, you use the old ieee1394 + ohci1394 + raw1394 drivers
on the debugger console, and set ieee1394's disable_irm=1 parameter
there (disable isochronous resource manager).  The new replacement
drivers firewire-core + firewire-ohci don't have such a parameter, i.e.
always run some bus manager functions which might get in the way of
remote DMA to an init_ohci1394_dma running node.
-- 
Stefan Richter
-=====-==--= =--- =---=
http://arcgraph.de/sr/

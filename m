Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbYDSHwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbYDSHwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 03:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYDSHwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 03:52:44 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:56039 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYDSHwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 03:52:44 -0400
Date: Sat, 19 Apr 2008 09:51:36 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Brownell <david-b@pacbell.net>, Andrew Victor <linux@maxim.org.za>,
       Pavel Pisa <ppisa@pikron.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Anderson Briglia <briglia.anderson@gmail.com>,
       "Syed Mohammed, Khasim" <x0khasim@ti.com>,
       Russell King <rmk@arm.linux.org.uk>, Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] MMC multiwrite capability removal
Message-ID: <20080419095136.15a50cc9@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I've been planning to remove the MMC multiwrite capability (making it
always on), but I need some help from all you driver maintainers first.

Ages ago, I had a chat with Axboe about the current situation and it
turns out that the MMC layer is a bit over-cautious. There are plenty
of other block devices that cannot report anything more than
success/failure for the whole request. So it's silly that we're
crippling the MMC layer when upper layers have to deal with that
scenario anyway.

What I need from you is and audit of your respective driver(s) and
check that they do not overestimate the number of successfully written
blocks. Please send a short reply even if your driver needs no changes.

Long version:

The data flow of a write is something like this:

1. Data starts moving from main memory to host memory (DMA or PIO)
2. Data finishes moving from main memory to host memory
3. A sector moves to the front of the device write queue
4. The sector starts being sent over the wire
5. The sector finishes being sent over the wire
6. The card acknowledges a successful transfer
7. The card finishes busy signalling
8. The sector moves to the front of the card write queue
9. The sector gets picked up by the FTL
10. The sector is written to media

In a perfect world we would report the number of sectors that made it
to 10. Unfortunately we have limited insight into what the card is up
to.

What your host drivers should report is sectors that have passed stage
6. If your controller doesn't give you enough information to determine
that, then you must report 0 for all failed transfers.

I'll be having a closer look at stages 7 through 10, but that's a core
issue that shouldn't involve your drivers.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

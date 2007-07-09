Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXGIBdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXGIBdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 21:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXGIBdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 21:33:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:57360 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511AbXGIBdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 21:33:09 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-Reply-To: <FFA29D56-3400-4EA3-8CE8-C1EF75484510@mac.com>
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org>
	 <1183929611.3388.303.camel@localhost.localdomain>
	 <200707090006.32712.rjw@sisk.pl>
	 <1183941217.3388.324.camel@localhost.localdomain>
	 <FFA29D56-3400-4EA3-8CE8-C1EF75484510@mac.com>
Content-Type: text/plain
Date: Mon, 09 Jul 2007 11:32:44 +1000
Message-Id: <1183944764.3388.330.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> You could do this with a straight mutex except for the  
> dev_suspend_trylock/unlock bit in uninterruptable contexts, but I  
> seem to recall somebody saying that could be made to work if there  
> was a real need for it.  Alternatively you could just drive the  
> "Generic Mutex" guys up the wall by inventing your own pseudo-mutex  
> with a spinlock, a boolean value, and a waitqueue.

Most of the time, the interrupt/atomic contexts are part of what I call
the "main path" of the driver, which doesn't need most of this stuff.

Depending on what is "upstream" from the driver, you typically set a
condition stopping the flow of "interrupt" activity and wait for it to
drain in suspend. For example, a block driver would instruct the driver
to stop processing the request queue and wait for pending in flight
requests to drain, or a network driver would stop the tx queue and wait
for pending/concurrent xmit() callbacks to complete (basically sync. bh
and sync. with NAPI poll).

In both examples, helpers can be provided in the block layer or network
stack to make that easier.

In many cases, the driver may just turn off something in the chip in
"suspend" (using a low level spinlock that it already has if it has an
irq path to sync. HW access) and set some flag/state to instruct the irq
handler to not restart, then synchronize_irq().

All those techniques are fairly simple and well known. The main source
of problems are the "sideband" channels, such as sysfs accesses to
driver tunables, ioctl's, etc... for which I believe mutexes can solve
90% of them.

Ben.



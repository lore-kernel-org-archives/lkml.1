Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbZBBUeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbZBBUeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZBBUeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:34:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:52429 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbZBBUeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:34:13 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Schwab <schwab@suse.de>
In-Reply-To: <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <1233568479.18767.86.camel@pasglop>
	 <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 07:33:25 +1100
Message-Id: <1233606805.18767.97.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 09:06 -0800, Linus Torvalds wrote:
> > I don't know how x86 does but I'm sure there must be some kind ACPI
> > thingy that must be called too before you can touch a device, in case it
> > got powered off by more than just the standard D states (ie, clock
> > stopped on the bus or whole power plane switched off).
> 
> It gets called later in that case.

And won't you have a potential problem here if ACPI is doing clock
gating or turning off the whole power plane ? IE. If that happens, your
pci_restore_state() done early with interrupts off will fail as well...

Since the root of that problem seems to be related to interrupts, maybe
the right approach is to have drivers disable it on suspend (ie,
disable_irq -> disabled at PIC level) and thus it would only get
re-enabled when all the drivers on a shared line have re-enabled it...
but that would mean drivers have to know they can not synchronously wait
for an interrupt from the device to happen at resume() time ...

It's not a trivial problem...

Ben.




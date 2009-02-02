Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZBBVB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZBBVB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZBBVBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:01:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:39558 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbZBBVBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:01:18 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Schwab <schwab@suse.de>
In-Reply-To: <alpine.LFD.2.00.0902021236040.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <1233568479.18767.86.camel@pasglop>
	 <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain>
	 <1233606580.18767.93.camel@pasglop>
	 <alpine.LFD.2.00.0902021236040.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 08:00:37 +1100
Message-Id: <1233608437.18767.106.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 12:41 -0800, Linus Torvalds wrote:
> 
> On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> > 
> > I'd rather hook it up inside pci_set_power_state()...
> 
> Umm. But you already _have_ that. Look at platform_pci_set_power_state(). 
> It gets called before turning the device on (pci_raw_set_power_state(D0)) 
> and after turning the device off (pci_raw_set_power_state(D1+))
> 
> Maybe you missed it? It's how ACPI does things.

I may well have, it didn't exist when my stuff was written.

> However, the issue you see is that pci_restore_standard_config() doesn't 
> call it, because at least with ACPI, the ACPI code simply isn't ready to 
> be called with interrupts off. So it looks like you may be looking at the 
> wrong thing, hmm?

Well.. yes and no... I still don't see how it can be sane to whack config
space back before the device has been turned back on. I wouldn't be surprised
if some devices don't grok well their BARs being written while not in D0.

I suppose I can always add another hook inside pci_restore_blah for my specific
case but I can also very easily see that can of worms hitting even more badly
in tight embedded environments such as handhelds, who use things like fine clock
control a lot more extensively.

In fact, even on x86, I'm not sure it's kosher to restore the config space
before you called ACPI...

Ben.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbZBCPtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbZBCPtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZBCPs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:48:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbZBCPs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:48:57 -0500
Date: Tue, 3 Feb 2009 07:48:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <1233641226.16867.81.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902030742530.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <200902030045.19416.rjw@sisk.pl>  <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>  <200902030115.32659.rjw@sisk.pl>  <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain>
 <1233641226.16867.81.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> Now where it gets funny is that I've added code to read the BAR and
> command register content before, between, and after those calls and
> print it and .. they are sane... Until i discovered that what happens is
> that the new generic code seems to actually blast 0 all over my config
> space if I don't call pci_save_state() in suspend(). I suppose I was
> missing a "mandatory" call here... but the core should be more robust,
> ie it shouldn't erase the config space of something because a driver
> "forgot" to call pci_save_state() !

You've found a bug somewhere.

We _should_ be saving things, the legacy code does something like this:

        if (drv && drv->suspend) {
                pci_dev->state_saved = false;

                i = drv->suspend(pci_dev, state);
                suspend_report_result(drv->suspend, i);
                if (i)
                        return i;

                if (pci_dev->state_saved)
                        goto Fixup;

                if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
                        goto Fixup;
        }

        pci_save_state(pci_dev);

ie if your ->suspend function doesn't use pci_save_state() itself (which 
sets that "state_saved" flag to true), then the generic code will do it 
for you.

Also, on the resume path, we actually have

        if (pci_dev->state_saved)
                pci_restore_standard_config(pci_dev);

so I wonder how the heck you got that blast of all zeroes - because we 
clearly shouldn't be trying to restore any unsaved state!

So if you can figure out how it does all that...

		Linus

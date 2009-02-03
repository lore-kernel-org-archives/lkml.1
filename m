Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZBCQew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZBCQew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZBCQel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:34:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:53223 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbZBCQek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:34:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,373,1231142400"; 
   d="scan'208";a="486804078"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Tue, 3 Feb 2009 08:33:07 -0800
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain> <1233641226.16867.81.camel@pasglop>
In-Reply-To: <1233641226.16867.81.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902030833.08222.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 2, 2009 10:07 pm Benjamin Herrenschmidt wrote:
> On Mon, 2009-02-02 at 16:28 -0800, Linus Torvalds wrote:
> > On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> > > BTW, on the PMAC the problematic driver appears to be the radeon
> > > driver, according to Ben, and the breakage is not related to USB.
> >
> > Hmm. atyfb_base.c has the same kind of things with magic PMAC code, but
> > it doesn't follow the USB pattern - it just replaces
> > "pci_set_power_state()" _entirely_.
> >
> > It seems a very interesting suspend routine, btw. It doesn't seem to do
> > any of the pci_save_state() at all, just re-initializes from scratch.
> > Maybe it is unhappy with the PM layer deciding to try to restore state
> > since it clearly didn't..
>
> In fact, atyfb is also busted in -rc3 for different reasons though
> probably by the same patch. I just dug an old powerbook with a mach64
> and it crashes on resume with a machine check in there. (Among 2 or 3
> other problems introduced by recent kernels, such as pci_get_* now
> kmallocs with GFP_KERNEL internally which makes it WARN when I use it in
> my low level suspend/resume code to whack the memory controller, etc...
> this one is going to bite others I reckon, or IDE having some interrupt
> problems on resume).
>
> Adding a pci_save_state() to atyfb_pci_suspend() and a
> pci_set_power_state() + pci_restore_state() at the beginning of
> atyfb_pci_resume() fixes the machine check here.
>
> Now where it gets funny is that I've added code to read the BAR and
> command register content before, between, and after those calls and
> print it and .. they are sane... Until i discovered that what happens is
> that the new generic code seems to actually blast 0 all over my config
> space if I don't call pci_save_state() in suspend(). I suppose I was
> missing a "mandatory" call here... but the core should be more robust,
> ie it shouldn't erase the config space of something because a driver
> "forgot" to call pci_save_state() !

Whoa, I don't think we actually zero the contents in the suspend/resume core, 
but if the device goes into D3 the config space contents may be lost, maybe 
that's what happening here?

-- 
Jesse Barnes, Intel Open Source Technology Center

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZBCD4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZBCD4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZBCD4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:56:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:33760 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZBCD4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:56:13 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1233633061.16867.41.camel@pasglop>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <200902022239.02453.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
	 <200902022331.49131.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain>
	 <1233633061.16867.41.camel@pasglop>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 14:55:15 +1100
Message-Id: <1233633315.16867.45.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Note that I notice on various powerbook models a bunch of things like
> 
> <some pci device> : restoring config space at offset XX (was: 0xffffffff, writin 0 ...)
> 
> I'm not sure if that will do any good :-)
> 
> The reason is that some devices (here sungem, ide-pmac and the firewire OHCI) -do-
> get clock gated until either you hit some of my magic pmac_feature calls in
> the driver or the driver calls pci_enable_device() (I have a hook there).
> 
> So far, it appears to be harmless ... at least on the one machine I have here,
> but it shows that we are doing something wrong.

Another little nit here...

The new code will basically make the core bring back everything to D0 on
resume. That's a huge power surge and often not needed at all...

If we set aside the shared interrupt problem for a moment, why should
waking up from sleep suddenly D0 everything in my system including stuff
that might have self suspended due to not being used (wifi killswitched,
audio off, etc...) and is still not going to be used until I actually
decide to do so (aka the user)... 

I suppose the drivers can then turn those things back off right away but
it's still a bit fishy...

Of course, drivers that can do that sort of dynamic power management
must already be ready to cope with interrupts coming from a shared line
while asleep...

Maybe we need some flags in the drivers telling the core "I know what
I'm doing and I'm ready to take shared interrupts after suspended, but
please don't mess with my device behind my back"... but then, even
stupid driver writers will abuse the flags ... hard.

Cheers,
Ben.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbZBCAXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbZBCAXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbZBCAXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:23:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:44386 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZBCAXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:23:46 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200902030000.18049.rjw@sisk.pl>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>
	 <1233614927.18767.121.camel@pasglop>  <200902030000.18049.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 11:23:09 +1100
Message-Id: <1233620590.18767.138.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But we can't tell no one is holding the mutex in question, AFAICS.
> 
> I'm afraid we'd really need a special "no mutexes, no GFP_KERNEL allocations"
> code path for that.

No, the mutex shouldn't be held already, if it is, you're probably
already in deep trouble. IE, you probably want to enfore that anyway,
ie, it wouldn't be very sane to suspend the machine while ACPI was
already in the -middle- of interpreting something anyway.

IE, you should have something to ensure, before you turn interrupts off,
that nobody else is inside the AML interpreter. You already know there
are no other CPUs, so it's just a matter of making sure no other process
has scheduled while holding that mutex.

The easy way to do that is to do something like taking the mutex
yourself and then setting a flag so that the intepreter stops trying to
take it or release it itself, maybe just using the global system state.

Then release the mutex on resume.

All of these are issues that exist today. IE. Regardless of that
powermac problem, which is unrelated (see other posts), I think these
things need to be sorted cleanly or suspend will not be as rock solid as
it could/should be. IE. It's several order of magnitude better than it
was, I agree, but I believe we have here a few reasonably simple things
we can/should do to make it more robust.

Cheers,
Ben.



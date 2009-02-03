Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZBCBEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZBCBEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZBCBEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:04:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:38029 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbZBCBEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:04:43 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200902030022.39396.rjw@sisk.pl>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <alpine.LFD.2.00.0902021413040.3247@localhost.localdomain>
	 <1233615423.18767.129.camel@pasglop>  <200902030022.39396.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 12:03:46 +1100
Message-Id: <1233623026.18767.148.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > (*) There are reasons to think that kmalloc/gfp should both silently
> > turn into GFP_NOIO always while the suspend process is started, but
> > that's somewhat a different subject. Rafael, did we ever act on that ?
> > It's an old discussion we had but I don't know if we actually
> > implemented anything.
> 
> We have the ->prepare(), ->complete() callbacks that, among other things,
> can be used for allocating and freeing memory with GFP_KERNEL safely.

First, that's assuming drivers will be smart enough to figure that out.
They won't, believe me.

Then, as I said, this doesn't work in practice because there is no way
drivers and/or underlying subsystems will start "remembering" when they
are within a prepare/complete pair, and suddenly do allocations
differently. That's just going to break.

It's the allocator itself that -must- degrade to NOIO or ATOMIC, or
we'll just never get it right imho.

> Yes, that's possible in theory, never observed in practice from what I can
> tell.

Sure, neither did I, though I could manufacture a case. IE, you'll need
memory pressure at suspend time to start having problems with
allocations blocking on disk access. So I'm sure most of the time we
never hit it ... until we do one day and don't know why the whole system
deadlocked somewhere in suspend or resume. 

Here we have a few low hanging fruits like that we know about, that can
make the difference between suspend/resume works always vs. it works
-most- of the time, unless I happened to have been under heavy memory
pressure while playing an MP3 on the train a 3rd day of the month....

IE. We don't want that rare case to break, because you can be sure that
that once out of 1000 times where it does is going to piss me off real
bad and probably just the day I typed something for 2h in a row without
saving etc...

> Hm, atomic allocations may cause other problems to happen (ie. fail easily).

That's true, but at the end of the day, if the choice is between
deadlock and failure, pick your medicine...

Maybe we could do it differently and have the allocators basically just
give up if they are going to trigger IOs or something but at the end of
the day, we need to make it robust, not just "will work most of the
time".

Ben.



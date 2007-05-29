Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbXE2NPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbXE2NPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXE2NPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:15:08 -0400
Received: from thunk.org ([69.25.196.29]:55491 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbXE2NPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:15:06 -0400
Date: Tue, 29 May 2007 09:15:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: M Macnair <mmacnair@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
Message-ID: <20070529131501.GA9899@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	M Macnair <mmacnair@gmail.com>, linux-kernel@vger.kernel.org
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 12:53:10PM +0100, M Macnair wrote:
> I have two embedded boards (one ARM, one PowerPC), running two
> different versions of 2.6.  They have no hard drives, keyboards or
> mice.  They each have a NIC, but I understand these make no
> contribution to the entropy pool.
> 
> 	if [ -f $random_seed ]; then
> 		cat $random_seed >/dev/urandom  # should seed the pool
> 	fi
> 	dd if=/dev/urandom of=$random_seed count=1 2>/dev/null # save some
> data from urandom for next boot
>
> I have rebooted my boards many times, and after each boot I read the
> contents of $random_seed.  Whilst it does not happen every time, the
> contents of $random_seed are /often the same/.  To give you a feel:
> rebooted 11 times, got a total of 3 different outputs.

Ok, so this is telling me a couple of things.  First of all, if you're
only getting three outputs, it means that you don't have any
peripherals feeding entropy into the system from the boot sequence.
Without any hard drives, keyboards or mice, and a NIC whose device
driver hasn't been configured to feed entropy, you're definitely
hosed.

Secondly, and more importantly, your boot scripts aren't set up
correctly.  You really want to make sure that you save the some
entropy at shutdown.  i.e., run at shutdown the same sequence that was
run at the boot-time.  (You don't really need the "cat $random_seed >
/dev/urandom", but it's harmless.)  Repeating this sequence at
shutdown is useful because it saves any entropy gathered from the
current boot session and saves it to be used at the next boot session.
I've noticed a number of distro's have gotten this wrong, and I guess
I should have filed more bugs to get this fixed.  In your case, since
you don't have anything wired up to feed entropy into your pool, it
will make /dev/urandom effectively a psuedo-random number generator,
but at least you won't get repeating outputs.

Another thing which I noticed is that when Matt Mackall took over
maintainership of /dev/random, he apparently took out one of the
safeguards I had, which was that before, when entropy was extracted
from the pool the time stamp when it was extracted was mixed back into
the pool.  The theory was that an external attacker might not know
when a program might be calling /dev/random, so mixing in the time of
that entropy was extracted wouldn't hurt, and might help.  I'll submit
a patch to add that support back in, which will help you a little.

HOWEVER, the more important thing to remember is that /dev/random
isn't magic.  If you don't have any entropy sources to mix in, and you
don't do anything at the application level to mix in data that might
not be known by external attackers, you will always be vulnerable,
especially if your threat model includes government funded
intelligence agencies.  So if you are planning on using /dev/urandom
for cryptographic purposes, while some of these fixes will avoid at
least the embarassing result of repeating outputs from /dev/urandom,
it's not really going to result in high-quality unpredictable results
against a well-funded, determined adversary.  

If that is your threat model, then you really should consider adding
hardware random number generator into your product design.

Regards,

					- Ted

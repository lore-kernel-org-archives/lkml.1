Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbXHUJff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbXHUJff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbXHUJee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:34:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36576 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbXHUJeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:34:13 -0400
Date: Tue, 21 Aug 2007 15:16:58 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: NeilBrown <neilb@suse.de>, Jan Engelhardt <jengelh@computergmbh.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 002 of 6] Introduce rq_for_each_segment replacing
 rq_for_each_bio
In-Reply-To: <Pine.LNX.4.62.0708210904220.11703@pademelon.sonytel.be>
Message-ID: <alpine.LFD.0.999.0708211500100.2774@enigma.security.iitk.ac.in>
References: <20070816211551.11839.patches@notabene> <1070816112100.12182@suse.de>
 <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708210523470.2774@enigma.security.iitk.ac.in>
 <Pine.LNX.4.62.0708210904220.11703@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Aug 2007, Geert Uytterhoeven wrote:

> On Tue, 21 Aug 2007, Satyam Sharma wrote:
> > 
> > This is turning rather funny :-)
> > 
> > * Why the printk() conversion specifier must be "%llu"?
> > 
> > When reusing parts of this code (such as this debug message) for another
> > 32-bit driver (we certainly seem to care about this, as per your reply),
> > the largest size of sector_t can be "unsigned long long", thereby causing
> > truncated output, and the following warning:
> > 
> > warning: format ???lu???expects type ???ong unsigned int??? but argument 2 has
> > type ???ector_t?
> 
> You will get a warning, so you will know.

Ah. So you'd much rather prefer that code in drivers/ make assumptions:
sizeof(long) == sizeof(long long), and, sizeof(long) == sizeof(sector_t),
hmmm?


> > Therefore, let us not depend on the fact that this driver is being used
> > only for 64-bit platforms as of now (especially since this is in drivers/
> > and not in arch/) and rather make the printk() specifier as "%llu".
> > 
> > [ Sadly, I had to repeat most of my previous mail, which Jan Engelhardt
> > appears to have snipped. ]
> 
> [ and you dropped the cell mailing list from the CC list ]

I don't enjoy getting "this is a subscriber-only list" notifications,
thank you.


> > * Why we require an explicit (unsigned long long) cast?
> > 
> > Having made the above change (and say we don't have an explicit cast
> > there), that line now becomes:
> > 
> > 	printk("... %llu\n", ..., iter.bio->bi_sector);
> > 
> > Now if we build this code with CONFIG_LBD=n, sector_t becomes just an
> > "unsigned long" (whereas printk specifier is the larger "%llu") thereby
> > causing:
> > 
> > warning: format ???llu???expects type ???ong long unsigned int??? but argument
> > 2 has type ???ector_t?
> > 
> > Therefore, let us shut this up with an explicit (unsigned long long) cast,
> > as is done in most other existing code in the kernel where we want to get
> > bi_sector printed out, which would correctly convert the value to the
> > larger integer type (even negative ones, due to sign-extension) and print
> > it out.
> > 
> > > On the other hand, adding a cast may hide bugs:
> > >   - cast to unsigned long long: When sector_t is changed to an even larger
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >     type, it will be silently truncated as well.
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > IMHO, this is not a valid enough reason, given the above (BTW if/when that
> > happens, we'll have to update the printk conversion specifer as well).
> > 
> > Personally, I'd say code that assumes "sizeof(unsigned long long) ==
> > sizeof(unsigned long)", and also that assumes "sizeof(unsigned long) ==
> > sizeof(sector_t)" -- both assumptions _are_ made by the above code --
> > is not good taste, even if both may be true for PS3 platform. So unless
> > we decide "nobody except that platform would ever build this driver
> > anyway", I'd suggest to make the printk specifier as "%llu" and use an
> > explicit (unsigned long long) cast. Therefore (on top of this series):
> 
> Adding such a cast makes it impossible for the compiler to detect (and warn us)
> if something has changed.

Change as in increase in size, right? Did you even read the mail? The only
argument you had given against the cast to (unsigned long long) was what
has been underlined above, which was bogus, considering we would have to
change the "%lu" specifier in the printk() also, when that happens
(otherwise suffer silent truncation).

But looks like you /are/ deciding "nobody except PS3 platform would ever
build this driver anyway" ... so okay, the current code, will all it's
non-portable assumptions, is okay.

Cheers,

Satyam

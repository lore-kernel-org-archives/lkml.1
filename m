Return-Path: <linux-kernel-owner+w=401wt.eu-S935055AbYCDX4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935055AbYCDX4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934743AbYCDXzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:55:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934394AbYCDXzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:55:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Hartley <pdh@utter.chaos.org.uk>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read is required
Date: Wed, 5 Mar 2008 00:54:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <20080225090316.GA420@elf.ucw.cz> <20080303172410.GA13869@elf.ucw.cz> <1204673572.1020.12.camel@amd64.pyotr.org>
In-Reply-To: <1204673572.1020.12.camel@amd64.pyotr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803050054.04930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 5 of March 2008, Peter Hartley wrote:
> On Mon, 2008-03-03 at 18:24 +0100, Pavel Machek wrote:
> > Ok, I can understand the gcc side. But do we actually run on an
> > architecture where
> > 
> > long *x;
> > 
> > *x = 0;
> > 
> > racing with 
> > 
> > *x = 0x12345678;
> > 
> > can produce
> > 
> > *x == 0x12340000;
> > 
> > or something like that? I'm told RCU relies on architectures not doing
> > this, and I'd like to get this clarified.
> 
> ARM6, ARM7500 and similar do exactly this for short (and unsigned
> short), although not for int, long, or pointers:
> 
> > struct foo { short b; short c; };
> > void baa(struct foo *f, short cc) { f->c = cc; }
> 
> becomes (arm-linux-gcc -mcpu=arm6):
> 
> > baa:
> >	mov	r3, r1, lsr #8
> >	strb	r3, [r0, #3]
> >	strb	r1, [r0, #2]
> >	mov	pc, lr
> 
> note the two single-byte stores, as ARM6 didn't have the "store
> halfword" instruction.
> 
> So I think Alan Stern's
> "For all properly-aligned pointer and integral types other than long
> long..."
> should be amended to
> "For all properly-aligned pointer and integral types other than short or
> long long..."

Well, perhaps it's sufficient to document just pointers?  In fact this is what
RCU relies on.

Thanks,
Rafael

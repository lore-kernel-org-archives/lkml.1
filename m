Return-Path: <linux-kernel-owner+w=401wt.eu-S934541AbYCEARP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541AbYCEARP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763011AbYCEAQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:16:31 -0500
Received: from utter.chaos.org.uk ([193.201.201.153]:57036 "EHLO
	utter.chaos.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758652AbYCEAQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:16:29 -0500
X-Greylist: delayed 2611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 19:16:29 EST
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
	is required
From: Peter Hartley <pdh@utter.chaos.org.uk>
To: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>
In-Reply-To: <20080303172410.GA13869@elf.ucw.cz>
References: <20080225090316.GA420@elf.ucw.cz>
	 <Pine.LNX.4.44L0.0802250943410.3549-100000@iolanthe.rowland.org>
	 <20080303120842.GA28369@elf.ucw.cz> <20080303154831.22a4eb14@core>
	 <20080303172410.GA13869@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 23:32:52 +0000
Message-Id: <1204673572.1020.12.camel@amd64.pyotr.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 18:24 +0100, Pavel Machek wrote:
> Ok, I can understand the gcc side. But do we actually run on an
> architecture where
> 
> long *x;
> 
> *x = 0;
> 
> racing with 
> 
> *x = 0x12345678;
> 
> can produce
> 
> *x == 0x12340000;
> 
> or something like that? I'm told RCU relies on architectures not doing
> this, and I'd like to get this clarified.

ARM6, ARM7500 and similar do exactly this for short (and unsigned
short), although not for int, long, or pointers:

> struct foo { short b; short c; };
> void baa(struct foo *f, short cc) { f->c = cc; }

becomes (arm-linux-gcc -mcpu=arm6):

> baa:
>	mov	r3, r1, lsr #8
>	strb	r3, [r0, #3]
>	strb	r1, [r0, #2]
>	mov	pc, lr

note the two single-byte stores, as ARM6 didn't have the "store
halfword" instruction.

So I think Alan Stern's
"For all properly-aligned pointer and integral types other than long
long..."
should be amended to
"For all properly-aligned pointer and integral types other than short or
long long..."

	Peter



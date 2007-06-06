Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbXFFIvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbXFFIvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXFFIvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:51:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59069 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXFFIvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:51:14 -0400
Subject: Re: [Patch 04/18] include/linux/logfs.h
From: David Woodhouse <dwmw2@infradead.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, John Stoffel <john@stoffel.org>,
       Willy Tarreau <w@1wt.eu>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       CaT <cat@zip.com.au>, Ondrej Zajicek <santiago@crfreenet.org>,
       linux-kernel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>, Dongjun Shin <djshin90@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Arnd Bergmann <arnd@arndb.de>,
       Albert Cahalan <acahalan@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org,
       Artem Bityutskiy <dedekind@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Pavel Machek <pavel@ucw.cz>, Ulisses Furquim <ulissesf@gmail.com>,
       akpm@osdl.org, David Weinehall <tao@acc.umu.se>
In-Reply-To: <db91817d295770e459727005108b05e2@kernel.crashing.org>
References: <20070603183845.GA8952@lazybastard.org>
	 <20070603184205.GE8952@lazybastard.org> <200706032342.27252.arnd@arndb.de>
	 <20070604091245.GF14823@lazybastard.org>
	 <1180964303.25232.358.camel@pmac.infradead.org>
	 <18f622d94e9273fe6c93ef091fcec87c@kernel.crashing.org>
	 <1181058836.16089.23.camel@hades.cambridge.redhat.com>
	 <db91817d295770e459727005108b05e2@kernel.crashing.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 09:50:20 +0100
Message-Id: <1181119820.25232.434.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 20:49 +0200, Segher Boessenkool wrote:
> >>> It would be better if GCC had a 'nopadding' attribute which gave us
> >>> what we need without the _extra_ implications about alignment.
> >>
> >> That's impossible; removing the padding from a struct
> >> _will_ make accesses to its members unaligned (think
> >> about arrays of that struct).
> >
> > It _might_ make accesses to _some_ of its members unaligned.
> 
> It _will_ make accesses to _at least one_ of the members
> unaligned, in the second array element.

It _might_, but not necessarily.

Won't a simple struct { uint16_t } get padded to a size of 4 bytes on
ARM? Even if I'm misremembering that, I certainly can't guarantee that
such a thing will _never_ happen on any newly-invented ABI. If you had
'nopadding' instead of 'packed', then there's no need to emit code to
handle unaligned loads.

Likewise, with a struct which looks like this: 
   { uint32_t, uint16_t, uint16_t, uint32_t, uint32_t }
I cannot _guarantee_ that there will never be an architecture on which
we'll end up using 32 bits of space for each uint16_t. I might _guess_
that and hope, but that's precisely the kind of moronic empirical
behaviour which caused Linux to have so many problems with newer
compilers in the past. If it isn't _guaranteed_ then I shouldn't be
assuming it.

Thus, I want a way to tell the compiler not to insert _any_ padding. But
without the compiler making extra inferences about the whole thing being
found at arbitrary alignments.

And if I had something like this (which is admittedly contrived, but
hardware people _do_ do stupid things to us):
   { uint32_t, uint8_t, uint16_t, uint8_t, uint32_t, uint32_t }

With the 'packed' attribute the compiler would assume arbitrary
alignment of all the 32-bit integers. But in reality it's only necessary
for the uint16_t in the middle. A 'nopadding' attribute would deal with
that correctly.

-- 
dwmw2


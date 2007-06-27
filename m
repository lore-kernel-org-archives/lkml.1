Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbXF0RDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbXF0RDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbXF0RDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:03:40 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42027 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801AbXF0RDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:03:39 -0400
X-Sasl-enc: f5mFIu7JWJyvKbDz87J4LO5TY2Ddf2ZoW1rDe27nDq/O 1182963818
Date: Wed, 27 Jun 2007 14:03:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC #2] hwrng: Add type categories
Message-ID: <20070627170331.GB6508@khazad-dum.debian.net>
References: <200706262021.51410.mb@bu3sch.de> <20070626224517.GG11115@waste.org> <20070627024856.GB5491@khazad-dum.debian.net> <200706271505.33970.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706271505.33970.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Michael Buesch wrote:
> Well, we have that userspace ABI of one hwrng char device. I did not

Yeah.  Talk about shortsighted ABIs that deserve to die an horrible death.
The same goes for the watchdog ABI.

> And changing it in a compatible way is probably difficult.

Well, sort of.  Some sort of compromise will have to be taken.

IMHO, anything worth bothering with in userspace will react well to a
symlink in /dev/hw_random, which is userspace's problem to set.  Anyone else
is expected to fix his /dev or whatever when they upgrade kernels, and we
can always provide the old hw_random char device returning EFAULT or
somesuch, so that it becomes very obvious that something is in need of
attention (and it FAILS instead of just disappearing).

> And then we would _still_ export some kind of hint for rngd that
> the CPU rng device should be preferred over the bcm43xx device.

Yes, export all the characterisitics of the RNG, and let userspace decide
what to do.

> How would you implement that? (We're back to my TYPE_XXX definitions ;) )

I'd implement it as an IOCTL with gives back:

1. Hardware device name
2. Hardware device revision
3. expected worst-case minimum entropy per bit of output
4. current config expected minimum entropy per bit of output
5. average bit rate (worst config)
6. average bit rate (current config)

There are probably others, but they don't come to mind at the moment.  We
could add something for type of device (oscilators, radioactive decay,
whatever), I suppose.

Use some magic value (0x00 ?) for unknown.  I won't bother with the scales,
if someone is going to write this, we can decide that later.  Just remember
that there are 10 Mbit/s RNGs out there, and 100 bit/s RNGs out there, and
that entropy goes from 0/unknown to 1 and needs at least a precison of
10^-3.

You also need a way to lock the RNG configuration, and you need to detect if
you ever read a byte from it that was produced by a different
configuration, which probably means a few more IOCTLs.

> What is "vital information"? My TYPE_XXX categories? ;)

See above.

> It _can_. We can switch the RNG in sysfs. So userspace _can_ get data
> from whichever HWRNG it wants.

I don't much like sysfs over IOCTLs for this, as you will probably need to
be able to set and get things in an atomic way.  A sysfs binary attribute
would also work.  A sysfs one-value-per-attribute bunch of them is
completely useless from a security point of view.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

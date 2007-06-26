Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbXFZOGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbXFZOGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbXFZOGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:06:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36407 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877AbXFZOGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:06:37 -0400
X-Sasl-enc: 9LCejyMAbPCUPtBxXaSyYGSi4VANi6HTcthYV9lfF9eS 1182866796
Date: Tue, 26 Jun 2007 11:06:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matt Mackall <mpm@selenic.com>
Cc: Michael Buesch <mb@bu3sch.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_random: add quality categories
Message-ID: <20070626140624.GC30655@khazad-dum.debian.net>
References: <200706241555.22957.mb@bu3sch.de> <20070626031340.GQ11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626031340.GQ11166@waste.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Matt Mackall wrote:
> On Sun, Jun 24, 2007 at 03:55:22PM +0200, Michael Buesch wrote:
> > This adds quality categories for hardware random number generators.
> > + * enum hwrng_quality - Quality identifier for RNG hardware
> > + * @HWRNG_QUAL_HIGH:	High quality RNG. Higher quality than
> > + * 			what is found on the usual PC mainboards.
> > + * 			Use that for special dedicated RNG
> > + * 			extension boards.
> > + * @HWRNG_QUAL_NORMAL:	PC-onboard-RNG devices.
> > + * @HWRNG_QUAL_LOW:	Low quality RNG devices. Use this for
> > + * 			devices which gather the entropy from possibly
> > + * 			bad sources, like the network.
> > + * @HWRNG_QUAL_PSEUDO:	Pseudo RNG device. Use this for devices
> > + * 			which are not RNG devices by definition, but
> > + * 			could be used as such. For example various
> > + * 			hardware sensors, like a motion sensor.
> 
> I don't think these definitions are very useful.

Agreed. They are horrible.

> There are basically three ways of measuring RNG quality:
> 
> a) does it generate a good spectrum based on an unpredictable physical
> process like Schott noise or free-running oscillator beat patterns?

Which, AFAIK, we can quantify as the minimum expected entropy in the output.

You can get output with the minimum expected entropy quite close to 1 from
good HRNGs.  Note that the same HRNGs might be configurable to disable the
whitener and output more bits, dropping to an expected minimum entropy of
0.75 for example (say hello, VIA Padlock!).

So quality is a property of (HRNG implementation, HRNG configuration when
the data was generated).

AFAIK, what really matters on a RNG is:

	0. trust on the design and implementation
	1. quality (minimum entropy expected on output)
	2. speed (minimum and average bits-per-second expected on output)
	3. whether it is implemented on software, or not.

Anything else is just *useless*.  And which RNG you should use (if you have
more than one available), based on the four attributes above, depends on
what you want to do.

> b) can the end-user trust that the design is implemented as described?

Heh, that's a hard one :-)  But I'd say HRNGs without at least a peer review
and open design are not to be trusted at all (which doesn't mean that those
which do have a peer review and open design can be trusted...).

> c) does it output lots of bits fast?

Yeah, you can go from a few bit/s, to some kbits/s, to megabits/s, it is a
damn important thing to know.

> Anything that fails (a) belongs in the PSEUDO class. This applies to
> RNGs where the implementation is undocumented too. (There's not much
> excuse for this as it costs negligible silicon to do this right.)

I'd say RNGs where the implementation is undocumented should not even be
supported at all...  but they certainly cannot be considered anything but
pseudo-random.

> Anything that passes (b) is something that the end-user built
> themselves while wearing their tinfoil hat.

Yes. Leave the user to decide whether they trust it or not.  And if the
kernel needs to know this, default to untrusted and let the user set a trust
level through some parameter.

> Anything that claims to be significantly better than the trivial
> circuit and whitening on a typical PC is probably marketing hype. 

Sort of.  But IMHO, such claims, when not backed by some hard paper analysis
the RNG design and output by third-parties, really are a reason to
*blacklist* the RNG and not use it at all.

> Which brings us down to (c). And basically all hardware RNGs are
> plenty fast enough.

Err... not really.  Intel's 82802AB or 82802AC-builtin RNG gives only ~24 *
10^3 bit/s, which is not much depending on what you are doing, for example.
While a VIA Padlock dual-HRNG CPU can easily output 1 * 10^6 bits/s of data
in its highest quality setting.  With such a bit amplitude of speeds
available, I really doubt you can say that all HRNGs are plenty fast enough.

> So that's basically three orthogonal axes: "real", "trusted", and
> "fast". And "trusted" trumps "real", which trumps "fast".

Heh. Indeed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

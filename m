Return-Path: <linux-kernel-owner+w=401wt.eu-S1762051AbXF0Qk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762051AbXF0Qk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbXF0Qkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:40:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48039 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753984AbXF0Qkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:40:49 -0400
X-Sasl-enc: NXOeoOp963BRLRF8v38hCyPmvo6jZSAhv2eUZ4bVn0Lh 1182962448
Date: Wed, 27 Jun 2007 13:40:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hw_random: add quality categories
Message-ID: <20070627164041.GA6508@khazad-dum.debian.net>
References: <200706241555.22957.mb@bu3sch.de> <200706261620.33898.mb@bu3sch.de> <20070627020045.GA5491@khazad-dum.debian.net> <200706271458.51884.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706271458.51884.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael!

On Wed, 27 Jun 2007, Michael Buesch wrote:

> On Wednesday 27 June 2007 04:00:46 Henrique de Moraes Holschuh wrote:
> > On Tue, 26 Jun 2007, Michael Buesch wrote:
> > > On Tuesday 26 June 2007 16:06:25 Henrique de Moraes Holschuh wrote:
> > > > Which, AFAIK, we can quantify as the minimum expected entropy in the output.
> > > 
> > > The category is _not_ a measure of the entropy in the output.
> > > It is _just_ to get the chance to get a sane _default_ policy
> > > for which RNG is enabled by default, in the kernel.
> > > It's just about a default policy. _Nothing_ else.
> > 
> > Then why don't you call it "preference", or something to that effect?
> 
> Why? Because I did not get the same idea as you?
> So, please make up "preference" categories and give me some examples.

preference: 

	scalar, unsigned 32 bit value.  Higher values mean higher
	preference.

	values:

	0 - ANYTHING that has no peer-review papers for both design and
	implementation, done by third-parties with reasonable credence in
	the field.  Anything for which the expected minimum entropy per bit
	of output is unknown, or below 50%.  This includes all pseudo-random
	RNGs, as we are not evaulating the seeding here.

	Never use anything with preference zero by default.

	
	For H-RNGs that have their design and implementation public and
	peer-reviewed by at least one third-party with reasonable credence
	in the field, and for which the minimum worst-case expected entropy
	per bit of output is known and equal or higher than 50.000% (if it
	was reviewed, it will be known), calculate preference as follows:

	LSW (lower 16 bits) should be the average bandwidth of the RNG, in
	10^3 bit/s. Use 0 for RNGs slower than 10^3 bits/s.  Use 0xFFFF for
	RNGs faster than 65535*10^3 bits/s (if this scale is not good
	enough, I suggest one with 0 being 10^3 bit/s or lower, and 0xFFFF
	being 10^7 bit/s or higher).

	MSW (higher 16 bits) should be the expected worst-case minimum
	entropy per bit of output of the RNG with at least 1% confidence. 0
	means a minimum worst-case entropy per bit of output of 50.000%,
	0xFFFF means a minimum worst-case entropy per bit of output of
	99.999% or higher.


Add a "fail always" RNG device to select by default if only RNGs of
preference zero are available, and select by default the RNG with highest
preference (or the first one you find, in case of a tie), and you are set.

It is not perfect, but it at least it makes some sense.

There *is* a much better way to deal with it, though.  Add the fail always
RNG device, and always select it by default.  Let the user specifically set
which RNG he wants, and it now rates as "trusted", which is the only
fail-proof way to go about it IMHO.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

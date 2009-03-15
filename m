Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZCOAbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZCOAbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 20:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZCOAax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 20:30:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1930 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZCOAaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 20:30:52 -0400
Date: Sun, 15 Mar 2009 00:30:43 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Message-ID: <20090315003039.GA11052@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net> <200903121602.55570.david-b@pacbell.net> <20090313013813.GK24376@sirena.org.uk> <200903141429.24534.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903141429.24534.david-b@pacbell.net>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch 2.6.29-rc7 regulator-next] regulator: refcount fixes
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 02:29:24PM -0700, David Brownell wrote:

> You're not stepping back from the current interface, which is
> a prerequisite to understanding the points I was making:

I'm pretty sure I understand exactly what you're saying but we just
disagree on this one.  Probably best that we agree to disagree.

>  * Almost everywhere else in the kernel, there's only one
>    handle (no per-client facet idiom), for which get/put
>    works.

Looking at things from the point of view of the consumer I just don't
find that it makes any difference since as far as the consumer is
concerned it's all opaque objects manipulated via an API.  I certainly
don't experience any conceptual jar switching between this and things
like the clock API, the patterns in clients the same especially for a
basic consumer doing something along the lines of:

	foo = foo_get(dev, name);
	foo_enable(foo);
	foo_disable(foo);
	foo_put(foo);

Even once you start setting more properties in there I'm struggling to
see the difference being visible.

I feel that you are focusing too much on the implementation here, not
the interface, but like I say I think we're just going to have to agree
to disagree on this one.

>  * The thing that *is* per-client is basically a constraint
>    set ... but it's called a "regulator", which again is
>    confusing.

You could go for regulated_supply or something.  I think that at this
point it's just not worth the trouble to try to change the name, though.

If it helps think of the per client object as representing the
particular physical supply to the physical device.  We could represent
them internally as pass through regulators but since the implementation
should still be opaque to the consumers I don't think that it's worth
doing that unless it buys us something in the implementation.

I'm not overly concerned about the implementation right now since it's
not causing any problems and the opacity we have now for the consumers
supports later refactoring.  Things like the issues with working with
struct device for I2C and SPI devices seem to be causing far more
pressing problems in actual use.

> In the regulator-next tree you've now moved regulator_dev
> into the public interface ... that's the handle to the
> real hardware.  Sort of a hint that it can't really be
> hidden in the way you originally thought.

It's only exposed to the drivers for the regulator hardware; it's not
visible to consumers unless they go peering into the driver API.  The
drivers for the regulators have always had a direct handle on themselves
for obvious reasons - the only change here is that they now know a bit
more about the implementation.

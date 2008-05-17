Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYEQFCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYEQFCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 01:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYEQFCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 01:02:08 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:4442 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYEQFCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 01:02:06 -0400
Message-ID: <fa686aa40805162202m336aade4qd6cfa5b17d6f3892@mail.gmail.com>
Date: Fri, 16 May 2008 23:02:05 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: cbouatmailru@gmail.com
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com
In-Reply-To: <20080516224916.GA16702@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
	 <20080516220338.GA3255@zarina>
	 <fa686aa40805161514r513d0eebt380a76f64abe8434@mail.gmail.com>
	 <20080516224916.GA16702@zarina>
X-Google-Sender-Auth: c34216d1f5597072
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 4:49 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Fri, May 16, 2008 at 04:14:23PM -0600, Grant Likely wrote:
>> > Maybe this code could do something like
>> > spi->dev.platform_data = nc->data;
>> > and board code would fill nc->data at early stages? This needs to be a
>> > convention, not just random use though.. Maybe we can expand the struct
>> > device_node to explicitly include .platform_data for such cases?
>>
>> Hmmm, as you say, this could end up being rather messy.  However, by
>> passing the device node pointer, the driver could extract that data on
>> a per case basis.  (ie. it would be decided on a per driver basis
>> where to get the platform data).  I'm not sure; this bears more
>> thought...
>
> Sometimes it's not worth powder and shot adding OF functionality to
> the drivers, I2C and SPI are major examples. Another [not mmc_spi]
> example is drivers/input/touchscreen/ads7846.c, which is SPI driver
> and needs platform data. There is a board that needs this (touchscreen
> controller on a MPC8360E-RDK).

In my mind; platform_data and the device tree are all about the same
thing: representation.  In other words, how to describe the
configuration of the hardware independent of the driver itself.  The
device tree and platform data structures both solve the same problem.
In both cases, the representation data must be
translated/decoded/interpreted and stored in the drivers own private
data structure so it can be of use.

One of the things I find rather interesting is just how frequently
drivers using platform data structures have a big block of code which
simply copy pdata fields into identically named fields in the device
private data... specifically: copied discretely instead of being a
verbatim block that can be memcopied, or instead of maintaining a
pointer and using the pdata itself.  It highlights for me just how
much pdata structures are decoupled from the driver itself (just like
how the device tree data is decoupled from the driver)... but I
digress.

The point is that the translation of data from the device tree (and
from pdata for that matter) to a form usable by the driver has to live
*somewhere*.  Does it belong in the platform code?  Or should it live
with the driver itself?  I argue that it really belongs as much as
feasibly possible with the driver code.  Even if a pdata structure is
chosen to be used as an intermediary representation, the code is only
relevant to the driver and therefore shouldn't appear anywhere else in
the kernel tree.  Putting it with the driver also has the added
advantage that it can be lumped in with the driver module and
therefore will only get compiled into the kernel if the driver is
present.  Putting driver specific (not platform specific) translation
code anywhere other than with the device driver it is intended for is
just wrong.

In addition, I'd really like to avoid a situation where the same block
of translation code (or at least calls to it) is duplicated all over
the platform code directories.  It's that sort of duplication that the
device tree (and similar schemes) is intended to solve.  I agree that
using platform code is often the best solution, especially when
dealing with one-off board ports that won't appear anywhere else.
However, I strongly believe that the platform code approach should be
the exception, not the rule.  If it is a common data property that all
instantiations of the device must have, then encode it in the device
tree and be done with it.  Doing so keeps platform code straight
forward and reduces duplication.

> Also there is no way to pass functions via device tree, we're
> always end up doing board-specific hooks in the generic drivers...
>
> Finally, let's call this platform_data and be done with it. Then we
> can use this for things like drivers/video/fsl-diu-fb.c (see diu_ops,
> which is global struct, filled by
> arch/powerpc/platforms/86xx/mpc8610_hpcd.c).

Yes, I agree, there are always going to be platform/board specific
hooks and I'm not saying that we should try to eliminate them.  But
(as expressed in the argument above) I don't like the idea of making
the platform code fill in all the necessary pdata structures.  How
about this as an alternative:

Instead of allowing platform code to fill in platform_data pointers at
early platform setup, let it register a driver-specific callback hook
instead.  If the hook it populated, the driver will call it at an
appropriate time to allow the platform code to manipulate the driver
configuration.  The signature of the hook can be driver dependent
(just like how the pdata hook is platform dependent).  Doing this
ensure that the translation code stays where it belongs: with the
driver itself, and it defers execution of the code to a point to
driver initialization time instead of earlier in the platform setup
which should improve boot times in certain circumstances if the
drivers are loaded as modules.

As for adding OF support to the drivers "not worth powder and shot"; I
must disagree.  Adding the device tree support really isn't very
complex and the impact on existing drivers quite minimal.  All of the
code can be restricted to a function called by the drivers probe
routine that can be compiled out entirely if CONFIG_OF is not set.
I've already done similar stuff with drivers supporting both platform
and of_platform busses, and this situation I think should be even less
invasive.

Thoughts?

Cheers,
g.

---
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

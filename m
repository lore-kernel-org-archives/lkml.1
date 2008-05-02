Return-Path: <linux-kernel-owner+w=401wt.eu-S1765878AbYEBJkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765878AbYEBJkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757116AbYEBJkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:40:45 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:21442 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbYEBJkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=asXus5Z6Y/i+qoehhw5DxAYT0gnh4n9B+Hhj+x8K/E+0E+Jf9WovNETcebMIljV70RWRt7mdVZz8l8nTE+yFd2I5d4c3ECcZCnfqn9LaN6IwsLgWTJQ1NCALVu5AgFNKI3SNV5WcDr3yYETalkqEcBWRq3WO7Zf52oAuON7qLp8=
Message-ID: <bc64b4640805020240q6054ecbbr3c569699b69edd8b@mail.gmail.com>
Date: Fri, 2 May 2008 13:40:41 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Paul Walmsley" <paul@pwsan.com>
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, tony@atomide.com,
       "David Brownell" <david-b@pacbell.net>, hiroshi.DOYU@nokia.com
In-Reply-To: <alpine.DEB.1.00.0805012221220.7405@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080420082925.GA32739@doriath.ww600.siemens.net>
	 <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com>
	 <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com>
	 <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com>
	 <bc64b4640804260147o70253917me32b0e35a1ce6ad8@mail.gmail.com>
	 <alpine.DEB.1.00.0805012221220.7405@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


2008/5/2, Paul Walmsley <paul@pwsan.com>:
> Hello Dmitry,
>
>
>  On Sat, 26 Apr 2008, Dmitry wrote:
>
>  > 2008/4/25, Paul Walmsley <paul@pwsan.com>:
>  > >
>
> > > I wouldn't pretend to have a comprehensive list at this point.  But from a
>  > >  brief look, your clk_round_rate() and clk_set_rate() implementations will
>  > >  not work for the present OMAP clock tree.  In OMAP, many parent clocks do
>  > >  not have the same rate as their children.
>  >
>  > You can easily override any calculations in your clk->set_rate/clk->round_rate/
>  > clk->get_rate functions.
>
>
> The problem is that parent clocks shouldn't be automatically set to the
>  same rate as child clocks.  We could probably hack around it in
>  clk->set_rate to ignore those spurious rate changes, but really they
>  shouldn't be done in the first place, at least on OMAP.  clk->set_rate
>  should handle parent rate changes if necessary.  Removing this from
>  clocklib looks trivial - involves deleting about ten lines of clocklib
>  code?

OK. I'll introduce the clk_set_rate_propagate that should be used as a
->set_rate callback. The get_rate logic (to default to the parent
clock) seems to be OK from my POV. Will that suite you?

>
>
>  > My first goals are:
>  > 1) to have an infrastructure to plug in my clocks in a platform-independant way
>
>
> Doesn't the existing clock framework do this already?  Or are you really
>  referring to your clk_functions/multiple consumer additions?  If the
>  latter, then we all would be better served by discussing why the existing
>  clock interface doesn't meet your needs, and figuring out what to do about
>  it, rather than by merging code that initially appears to be common, but
>  with you having the ultimate intention of extending the common clock
>  interface to implement the features that you want.

Yes and no. Nearly all platforms have some type of clk_register. But
to use it you have to burry deeply in the platform code. There is no
easy way for a driver to provide clocks on both the PXA and SA-1100
arms, not telling about other platforms.

>
>
>  > 2) to drop lots of copies of nearly the same code.
>
>
> I don't really see much of a problem with the current situation, as long
>  as all of the implementations use the same interface.  Right now,
>  architectures are free to change their underlying code without having to
>  worry about breaking other architectures or dealing with new gatekeepers,
>  and that's a big plus for the status quo.  Russell is the person who
>  shoulders the burden here of multiple implementations, and when this
>  becomes a pressing problem, I would expect him to be doing most of the
>  advocacy for common code.

Nearly all platform-dependant code is still left in hands of platform
maintainers. There are only few assumptions built into the clocklib.
And I've just agreed to remove one of them.

>
>
>  > >  Assumptions that you make in clocklib may not work well for future chips.
>  > >  Changing clocklib will affect many architectures.  For example, perhaps
>  > >  someone may wish to implement clocks as an actual in-memory tree rather
>  > >  than a list.  Or perhaps someone may need to handle clock usecounting
>  > >  differently, for situations when multiple clocks might share the same
>  > >  enable/disable code, but with different parents.
>  >
>  > Sorry, but WTF? Do you prefer to keep a lot of code and disallow
>  > merging a generification just because of some-that-may-even-not-exist
>  > cases? That sounds
>  > pretty... strange.
>  > And your examples are really strange.
>
>
> Those examples are real; they have been discussed in the past or proposed
>  for the future for OMAP clock framework.  Regarding the second example,
>  that's a very real issue for us right now with our interface clocks, and
>  flexible usecounting is one of the ways that we've considered solving it.
>  As far as the tree example goes, we've got about 200 struct clks in the
>  latest OMAP clock framework, and this will probably increase by 50% over
>  the next year.  We have clock tree operations that have to move both up
>  and down the tree.  Right now we're doing sequential scans on a clock
>  list, but chances are quite high that we will be doing this very
>  differently a few months.

Tell me more please about "flexible usecounting". Or please provide
pointers to relevant threads I can read.

>
>  I cited these examples not because I was interested in having you tell me
>  that my examples were unrealistic or "strange" or should be done
>  differently, but simply to reinforce the message that a top-down approach
>  to a generic clocklib is not likely to be appreciated much by maintainers.
>  I know you keep saying that your code is intended to be be strictly
>  optional.  If you want to prove it, why not consider a bottom-up approach
>  instead?  Right now you've got patches that convert two architectures to
>  use your clocklib.  Instead of using a common library, just duplicate your
>  clock code for each architecture.  There's not much to it.  Propose
>  patches to individual architecture maintainers, and persuade them to
>  replace their existing code with your own.

I don't think that's the way to go. It's pretty stupid to force all
maintainers to agree to worse code only to make it better.

I still didn't receive any strong objections regarding the PXA and
SA-1100. Few other ARM architectures that have simple clk.h would gain
from clocklib by being able to drop non-platform-specific code. The
AVR32 maintainer seems to be looking positievly to adapting clocklib
once it's merged.

Maybe we should merge the core part only for now, to let all platform
maintainers consider it, think about it, provide patches to clocklib
that will be carefully though out and later (when dust settles) merge
the remaining bits of platform support?

-- 
With best wishes
Dmitry

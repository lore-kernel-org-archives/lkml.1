Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYEDL4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYEDL4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 07:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYEDL4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 07:56:15 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52278 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbYEDL4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 07:56:14 -0400
Date: Sun, 4 May 2008 14:55:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - a suggestion how to fix the select issue
Message-ID: <20080504115504.GI5838@cs181133002.pp.htv.fi>
References: <20080504071041.GA15315@uranus.ravnborg.org> <20080504081145.GG5838@cs181133002.pp.htv.fi> <20080504082732.GB17276@uranus.ravnborg.org> <20080504090429.GH5838@cs181133002.pp.htv.fi> <20080504103848.GC17276@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080504103848.GC17276@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 12:38:48PM +0200, Sam Ravnborg wrote:
> On Sun, May 04, 2008 at 12:04:29PM +0300, Adrian Bunk wrote:
> > On Sun, May 04, 2008 at 10:27:32AM +0200, Sam Ravnborg wrote:
> > > On Sun, May 04, 2008 at 11:11:45AM +0300, Adrian Bunk wrote:
> > > > On Sun, May 04, 2008 at 09:10:41AM +0200, Sam Ravnborg wrote:
> > > > >...
> > > > > 
> > > > > config A
> > > > >         bool "a"
> > > > > 
> > > > > config B
> > > > >         bool "b"
> > > > >         depends on A
> > > > > 
> > > > > config C
> > > > >         bool "c"
> > > > >         require B
> > > > > 
> > > > > The require dependency will have impact on visibility.
> > > > > C shall only be visible if all symbols it require are
> > > > > visible. Note that visible does not imply 'chosen'.
> > > > > In this case C would be visible when A is chosen.
> > > > > 
> > > > > When the user then choose C and B is not chosen 
> > > > > then the user is prompted to choose B.
> > > > > 
> > > > > So user has to chose B in order to have C chosen.
> > > > >...
> > > > > Comments?
> > > > 
> > > > 
> > > > Given:
> > > > 
> > > > config A
> > > > 	tristate "a"
> > > > 
> > > > config B
> > > > 	tristate "b"
> > > > 	depends on A
> > > > 
> > > > config C
> > > > 	bool "c"
> > > > 	require B
> > > > 
> > > > CONFIG_A=m
> > > > 
> > > > 
> > > > Will C be visible?
> > > If you followed my description then you would see
> > > that the visibility of C are determineded by the dependencies
> > > of C (none in this case) and the dependencies of the symbol
> > > it requires. In this case B. B dpens on A and A equals m so B is
> > > visible thus C is visible.
> > 
> > *shudder*
> So let me explain it with some other words:
> B is visible because A=m
> C is visible because B is visible.
> Simple.

I understand what you are saying.

The problem is that with A=m, C=y built-in code enabled by C cannot 
access the code enabled by A which can result in a build error.

> > > > The underlying problem is that we use bool for two different cases:
> > > > - non-modular driver (answer would be "no")
> > > > - enable feature in driver (answer would be "depends on the value of D")
> > > Lets try to agree on the semantics with bools first please.
> > > When we have that in place lets extend it to modular - OK?
> > 
> > I doubt the "extension" works this way since most of the interesting 
> > cases are with tristates.
> > 
> > But OK, here's some fun with bools:
> > 
> > config X86
> > 	def_bool y
> > 
> > config A
> > 	bool "a"
> > 
> > config B
> > 	bool "b"
> > 	depends on A
> > 
> > config D
> > 	bool "d"
> > 	depends on !B if X86
> > 
> > config E
> > 	bool "e"
> > 
> > config C
> > 	bool "c"
> > 	depends on D || E
> > 	requires B
> > 
> > Given:
> > - CONFIG_A=y
> > - CONFIG_B=n
> > - CONFIG_D=y
> > - CONFIG_E=n
> > 
> > Will C be visible?
> The above has a syntax error. A 'depends on' cannot have an
> if caluse.

I know I'm bad at the syntax when I'm not trying stuff myself.
	depends on !B || !X86
is the same and should be the correct syntax.

Or make it just
	depends on !B

The problem is not the syntax, the problem is whether C should be 
visible, and what happens if the user enables it.

> And I did not get your point either.
> 
> Are you trying to say that we cannot improve kconfig to better
> express the dependencies or what is your point?

My point is that all this "select follows depenencies" is easily said, 
but doing it in a way that it's better than what we have today is 
nontrivial.

I'm not even sure whether the best solution might be to do it manually 
like we are doing with SSB_POSSIBLE, but if I'd start to convert stuff 
to that I'm sure many maintainers will say "no, kconfig is broken" and 
even reject patches.

If you think I'm wrong implement your suggestion and then handle all the 
cornercases. It might or might not work. I'm just saying that it isn't 
an easy problem.

> Puzzeled...
> 
> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


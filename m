Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYEDMRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYEDMRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYEDMRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:17:13 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35708 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbYEDMRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:17:12 -0400
Date: Sun, 4 May 2008 14:17:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - a suggestion how to fix the select issue
Message-ID: <20080504121747.GA19236@uranus.ravnborg.org>
References: <20080504071041.GA15315@uranus.ravnborg.org> <20080504081145.GG5838@cs181133002.pp.htv.fi> <20080504082732.GB17276@uranus.ravnborg.org> <20080504090429.GH5838@cs181133002.pp.htv.fi> <20080504103848.GC17276@uranus.ravnborg.org> <20080504115504.GI5838@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504115504.GI5838@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > 
> > > > > config A
> > > > > 	tristate "a"
> > > > > 
> > > > > config B
> > > > > 	tristate "b"
> > > > > 	depends on A
> > > > > 
> > > > > config C
> > > > > 	bool "c"
> > > > > 	require B
> > > > > 
> > > > > CONFIG_A=m
> > > > > 
> > > > > 
> > > > > Will C be visible?
> > > > If you followed my description then you would see
> > > > that the visibility of C are determineded by the dependencies
> > > > of C (none in this case) and the dependencies of the symbol
> > > > it requires. In this case B. B dpens on A and A equals m so B is
> > > > visible thus C is visible.
> > > 
> > > *shudder*
> > So let me explain it with some other words:
> > B is visible because A=m
> > C is visible because B is visible.
> > Simple.
> 
> I understand what you are saying.
> 
> The problem is that with A=m, C=y built-in code enabled by C cannot 
> access the code enabled by A which can result in a build error.

That is a different type of issue which would most likely
be solved by a "depends on A == y"

> > > But OK, here's some fun with bools:
> > > 
> > > config X86
> > > 	def_bool y
> > > 
> > > config A
> > > 	bool "a"
> > > 
> > > config B
> > > 	bool "b"
> > > 	depends on A
> > > 
> > > config D
> > > 	bool "d"
> > > 	depends on !B if X86
> > > 
> > > config E
> > > 	bool "e"
> > > 
> > > config C
> > > 	bool "c"
> > > 	depends on D || E
> > > 	requires B
> > > 
> > > Given:
> > > - CONFIG_A=y
> > > - CONFIG_B=n
> > > - CONFIG_D=y
> > > - CONFIG_E=n
> > > 
> > > Will C be visible?
> > The above has a syntax error. A 'depends on' cannot have an
> > if caluse.
> 
> I know I'm bad at the syntax when I'm not trying stuff myself.
> 	depends on !B || !X86
> is the same and should be the correct syntax.
> 
> Or make it just
> 	depends on !B
> 
> The problem is not the syntax, the problem is whether C should be 
> visible, and what happens if the user enables it.
OK - lets analyse this.
B is visible (because A is y)
D is visible (because B is n)
E is visible

So per the definition C is visible.
If user choose 'C' then user will be prompted to choose B
due to the "require B".
User now set B equal to 'y' and we have following situation:
B is visible (because A is y)
D is invisible (because B is y)
E is visible
So per definiton C is still visible.
So user is now prompted to chose C.


On the other hand had we had a:
config C
	bool "c"
	depends on D
	requires B

Then when user set B equal 'y' user no longer
are offered the possibility to chose 'C' as it is no
longer visible.

> > 
> > Are you trying to say that we cannot improve kconfig to better
> > express the dependencies or what is your point?
> 
> My point is that all this "select follows depenencies" is easily said, 
> but doing it in a way that it's better than what we have today is 
> nontrivial.
Which is exactly why I try to involve you in the discussion
of a potential solution.

	Sam

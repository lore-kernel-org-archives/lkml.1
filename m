Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab0CCABn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:01:43 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36369 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab0CCABi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:01:38 -0500
Date: Tue, 2 Mar 2010 16:01:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, mingo@elte.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] kconfig: place git SHA1 in .config output if in
	git tree
Message-ID: <20100303000134.GD6786@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100301042249.GA12289@linux.vnet.ibm.com> <201003012129.36937.elendil@planet.nl> <20100302011633.GJ6758@linux.vnet.ibm.com> <201003021619.34793.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201003021619.34793.elendil@planet.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 04:19:32PM +0100, Frans Pop wrote:
> On Tuesday 02 March 2010, Paul E. McKenney wrote:
> > Sigh!  Because popen() doesn't fail when the command is bogus, it seems.
> > I now do stat() to check for it existing, and that seems to handle the
> > remote-output case.
> 
> Cool. Did you check if it's really necessary to treat the two cases 
> separately? I would expect srctree to always be set, and if I read the 
> root Makefile correctly that's indeed the case:
> srctree         := $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))

You are quite correct, the environment variable is set correctly either
way.  I have therefore switched to the single case as you suggest.

> Hmm. I see you've switched from SRCTREE to KBUILD_SRC. Is that correct? 
> SCRTREE is also used elsewhere in the same file and that's the variable 
> (in lower case; the upper case variant is a C define) that's explicitly 
> exported in the root Makefile.

They both work, but agreed, SRCTREE is what is used elsewhere in the
file, so I have switched back to SRCTREE.  The move to "KBUILD_SRC"
was part of my debugging work.

> > > One other thing. I wonder if this implementation will always reliably
> > > result in the *current* SHA1 being included in the .config. AFAICT
> > > the .config only actually gets written if there are changes, or if you
> > > explicitly do a 'make oldconfig'.
> > >
> > > But if you e.g. pull a stable update and just run 'make', the .config
> > > will likely remain unchanged and will thus still contain the SHA1 from
> > > a previous build.
> >
> > Good point.  But the same is true of the Linux kernel version
> > identifier, right?
> 
> Right. But the increased precision of the SHA1 IMO also demands an 
> increased reliability of its accuracy: if it's not accurate it loses its 
> value.

It does depend on the context -- many test setups do a config for each
build, and are thus guaranteed accurate.

This is another good argument for making this behavior non-default, the
other argument mentioned earlier in this thread being performance.

> Personally I think that maybe the config file is not the correct place for 
> this. For one thing users may well send a config file that's not the 100% 
> exact one used to build the kernel when they know it's close enough that 
> it makes no practical difference (I know I've done so in the past).
> 
> Wouldn't it be more logical to include the line in the dmesg output? My 
> preference would be a separate line below the existing (Linux version) 
> line. That line could only be output if the kernel was built from a VCS.
> It could then even be repeated in oops output.

My concern with only putting it in the dmesg output is that people do
not always capture that.  The oops output is more often captured, but
the kernel only has this information if CONFIG_LOCALVERSION_AUTO is set.

> That would also solve the problem of the config file not being updated.

Another approach would be to append the $(kernelrelease) make variable
to the end of the .config file when building the kernel.release file.
Unfortunately, as noted earlier in this thread, this only happens when
CONFIG_LOCALVERSION_AUTO is set.  And if people are setting such
variables, then they most likely have set things up to keep the version
accurate, in which case putting it at the top of the .config file makes
more sense.

I will send the updated patch in a separate email.

Also dumping the version (whatever it is) during early boot and as part of
oops messages sounds reasonable at first glance.  This could be done as
an independent change, if desired.  Other thoughts on this?

							Thanx, Paul

> Paul E. McKenney wrote:
> >> I'd hate to have that run every time I make a kernel.
> > 
> > Good point...  Should we have an environment variable that controls this
> > behavior?
> 
> I would suggest at most a general enabled/disabled switch (distros might 
> prefer to disable it too), and not more detailed settings to control 
> whether or not to include dirty or whatnot.
> 
> Cheers,
> FJP

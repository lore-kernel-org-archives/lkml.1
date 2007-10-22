Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbXJVEmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbXJVEmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXJVEmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 00:42:33 -0400
Received: from xenotime.net ([66.160.160.81]:32837 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751169AbXJVEmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 00:42:32 -0400
Date: Sun, 21 Oct 2007 21:42:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Henrik Carlqvist <hc1@poolhem.se>,
       bunk@stusta.de
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-Id: <20071021214229.b75e2c3d.rdunlap@xenotime.net>
In-Reply-To: <20071021201416.4ccde183.rdunlap@xenotime.net>
References: <200710201257.55616.nick@ukfsn.org>
	<20071020144238.4f258c8c.hc1@poolhem.se>
	<20071020191700.GB8774@uranus.ravnborg.org>
	<26703.1192942058@turing-police.cc.vt.edu>
	<20071021122402.2f0f3b40.hc1@poolhem.se>
	<20071021094517.78dd1916.rdunlap@xenotime.net>
	<20071021210313.GA6725@uranus.ravnborg.org>
	<20071021174748.92abc989.rdunlap@xenotime.net>
	<20071021201416.4ccde183.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 20:14:16 -0700 Randy Dunlap wrote:

> On Sun, 21 Oct 2007 17:47:48 -0700 Randy Dunlap wrote:
> 
> > On Sun, 21 Oct 2007 23:03:13 +0200 Sam Ravnborg wrote:
> > 
> > > On Sun, Oct 21, 2007 at 09:45:17AM -0700, Randy Dunlap wrote:
> > > > > Is there any other way to specify that a functionality can only be built
> > > > > as a module, not built into the kernel?
> > > > 
> > > > config FOO
> > > > 	depends on BAR && m
> > > > 
> > > > restricts FOO to module-only.
> > > > 
> > > > > In my firsta attempts to post about these tests my post ended up not on
> > > > > the mailing list but as a reply to Sam Ravnborg only, apologies for
> > > > > that...
> > > 
> > > This is obviously the right solution.
> > > Randy - we should document this somewhere together with more kconfig tips'n'tricks.
> > 
> > Agreed.
> 
> So that's one tip or trick... or common idiom.
> 
> > > A new document or do we extend kconfig-language?
> > 
> > I don't see a need for a separate document.  I would just extend
> > kconfig-language.
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> Another common idiom that we see (and sometimes have problems
> with) is this:
> 
> When B (module or subsystem) uses interfaces from A (module or
> subsystem), A can be linked statically into the kernel image or
> can be built as loadable module(s).   This limits how B can be
> built.  If A is linked statically into the kernel image, B can be
> built statically or as loadable module(s).  However, if A is built
> as loadable module(s), then B must be restricted to loadable
> module(s) also.  This can be expressed in kconfig language as:
> 
> config B
> 	depends on A = y || A = B
> 
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> There's also a third issue:  symbols that are specific to a
> particular $arch, but they are in Kconfig files that are common
> to all arches, so kconfig complains about symbol A refers to
> unknown symbol B.  (and I'm just writing this from memory, not
> from testing it, so it could be off a bit.)  One example of this
> was PS3_PS3AV, as copied from an lkml email of 2007-feb-14:
> 
> drivers/video/Kconfig:1604:warning: 'select' used by config symbol 
> 'FB_PS3' refer to undefined symbol 'PS3_PS3AV'
> 
> Someone fixed this one by introducing an intermediate config symbol.
> I didn't follow the details of that fix, but we see this problem
> enough to warrant explaining how to handle it.  E.g., recently
> (from 2007-oct-14) on lkml:
> 
> $ make oldconfig >/dev/null
> drivers/macintosh/Kconfig:121:warning: 'select' used by config 
> symbol 'PMAC_APM_EMU' refers to undefined symbol 'APM_EMULATION'
> 
> 
> 
> Adrian, do you know of other items that should be listed here?

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Continuing with real-life kconfig fun, here's a fourth item that
people need to be aware of.

The construct:

if ARCH_OMAP
	source "drivers/video/omap/Kconfig"
endif

does not prevent kconfig from reading drivers/video/omap/Kconfig.
Instead, it make all config symbols in that file be dependent upon
the ARCH_OMAP symbol.  Adding a config symbol dependency like this
is a common problem that causes config menus not to be displayed as
they should be (not indented or not subordinate as expected).


---
~Randy

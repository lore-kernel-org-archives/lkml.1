Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbXJPFOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbXJPFOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765691AbXJPFOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:14:33 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37011
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765145AbXJPFOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:14:31 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Allow kconfig to accept overrides
Date: Tue, 16 Oct 2007 00:14:15 -0500
User-Agent: KMail/1.9.6
Cc: Jan Engelhardt <jengelh@computergmbh.de>, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       randy.dunlap@oracle.com
References: <Pine.LNX.4.64.0710122341530.16098@fbirervta.pbzchgretzou.qr> <20071016042957.GB27909@uranus.ravnborg.org>
In-Reply-To: <20071016042957.GB27909@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710160014.15653.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 11:29:58 pm Sam Ravnborg wrote:
> Hi Rob & Jan.
>
> On Fri, Oct 12, 2007 at 11:44:08PM +0200, Jan Engelhardt wrote:
> > Allow config variables in .config to override earlier ones in the same
> > file. In other words,
> >
> > 	# CONFIG_SECURITY is not defined
> > 	CONFIG_SECURITY=y
> >
> > will activate it. This makes it a bit easier to do
> >
> > 	(cat original-config myconfig myconfig2 ... >.config)
> >
> > and run menuconfig as expected.
>
> How far is this from the miniconfig functionality?
> Is it the same or can we achieve the miniconfig support
> by extending Jan's patch?
>
> See: http://lkml.org/lkml/2007/10/12/391

Way way back (2.6.10 or thereabouts) I first did a miniconfig via running 
allnoconfig, concatenating a miniconfig to the result, and running "make 
oldconfig" on that.  This concatenation method had two main problems:

1) Around 2.6.15 the kconfig infrastructure changed so the first instance 
symbol won rather than the last symbol.  It looks like this patch just sets 
the behavior back to what we had in 2.6.14 and earlier.

2) When a symbol activates new subsymbols (opening a new menu, for example), 
those dependant symbols would be activated at their oldconfig default values, 
not their allnoconfig default values.  This meant there might be a valid 
configuration that you couldn't specify without saying "symbol=n" to turn 
some of them off in your miniconfig, which is something a miniconfig should 
never have to do.  (This happens when allnoconfig and oldconfig are run in 
two separate passes.  The oldconfig pass uses the wrong default values for 
newly enabled symbols.  Menuconfig has the same defaults as oldconfig, which 
are _not_ the same defaults as allnoconfig.)

Note that the infrastructure I'm using to _read_ miniconfig files is just a 
repurpose of the existing KCONFIG_ALLCONFIG as applied to allnoconfig.  
That's in kconfig already, has been since 2.6.15-ish, and works fine.  The 
syntax is nonobvious (two patches from me to improve said syntax and add some 
error checking were rejected), but the functionality is there and easy enough 
to trigger:

  make allnoconfig KCONFIG_ALLCONFIG=mini.conf

That expands a mini.conf into a .config, and does the other setup necessary.  
(You can feed that O= to build out of tree, or ARCH= to build another 
architecture...  Anything you can currently do with allnoconfig.)

It's the "shrinking a .config into a mini.conf" side of things that uses a 
hideous shell script that's not in the tree:
http://landley.net/hg/firmware/raw-file/tip/sources/toys/miniconfig.sh

To use it:
  make ARCH=arm defconfig
  mv .config tempname
  ARCH=arm ./miniconfig.sh tempname
  ls -l mini.config

(Obviously, the ARCH=arm is optional and you don't have to start with 
defconfig.)

If I had unlimited spare time I might teach kconfig to automatically write a 
mini.conf every time it writes a .config, and have it use whichever was newer 
in the update commands (oldconfig/menuconfig/etc).  But after two rejected 
patches on this topic already, with the shell script meeting my needs, that's 
impressively far down on my todo list.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

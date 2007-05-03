Return-Path: <linux-kernel-owner+w=401wt.eu-S376315AbXECTgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376315AbXECTgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376312AbXECTgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:36:44 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52567 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S376315AbXECTgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:36:43 -0400
Date: Thu, 3 May 2007 21:37:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org, James Ketrenos <jketreno@linux.intel.com>
Subject: Re: build system: no module target ending with slash?
Message-ID: <20070503193736.GA18216@uranus.ravnborg.org>
References: <200705030043.49208.mail@earthworm.de> <20070503042511.GB12644@uranus.ravnborg.org> <20070503061533.GA13399@uranus.ravnborg.org> <200705030917.19630.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705030917.19630.mail@earthworm.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 09:17:15AM +0200, Christian Hesse wrote:
> On Thursday 03 May 2007, Sam Ravnborg wrote:
> > On Thu, May 03, 2007 at 06:25:11AM +0200, Sam Ravnborg wrote:
> > > On Thu, May 03, 2007 at 12:43:43AM +0200, Christian Hesse wrote:
> > > > Hi James, hi everybody,
> > > >
> > > > playing with iwlwifi I try to patch it into the kernel and to build it
> > > > from there. But I have a problem with the build system.
> > > >
> > > > The file drivers/net/wireless/mac80211/Makefile contains one single
> > > > line:
> > > >
> > > > obj-$(CONFIG_IWLWIFI)   += iwlwifi/
> > > >
> > > > When CONFIG_IWLWIFI=m in scripts/Makefile.lib line 29 the target is
> > > > filtered as it ends with a slash. That results in
> > > > drivers/net/wireless/mac80211/built-in.o not being built and the build
> > > > process breaks with an error. What is the correct way to handle this?
> > > > Why are targets ending with a slash filtered?
> > >
> > > Looks buggy. I will take a look tonight.
> >
> > After some coffee...
> >
> > Line 29 in Kbuild.include find all modules and a directory is not a module.
> > In line 26 in same file the directory iwlwifi is included in the list
> > of directories to visit.
> > So there is something else going on.
> 
> In scripts/Kbuild.include line 26 is empty and line 29 is a comment... Do I 
> look at the wrong place?
I looked at lxr.linux.no - so probarly an outdated version.

> 
> I still believe in my version: built-in.o is built if any of $(obj-y) $(obj-m) 
> $(obj-n) $(obj-) $(lib-target) contains anything in scripts/Makefile.build 
> line 77. As scripts/Makefile.lib line 29 filters the only target the object 
> file is not built.

I have applied your patch and tried it out.
The reason for the problem is the placeholder directory mac80211.
kbuild will not waste time building built-in.o for a directory where
it is not necessary. So for mac80211 no built-in.o is created since there
is no need. The only reference is to a module.

The quick-and-dirty workaround is to add a single 
obj-n := xx
in mac80211/Makefile and kbuild is happy again.


I could teach kbuild to create built-in.o also in the case
where we refer to a subdirectory only. But then we would end up with a built-in.o
in all directories where we have a kbuild MAkefile (almost) and that is
not desireable.
So I recommend the proposed workaround for now with a proper comment.

	Sam

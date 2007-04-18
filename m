Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbXDRQAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbXDRQAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbXDRQAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:00:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27062 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbXDRQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:00:54 -0400
Date: Wed, 18 Apr 2007 09:03:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bbpetkov@yahoo.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-Id: <20070418090320.3786edd6.randy.dunlap@oracle.com>
In-Reply-To: <20070417104907.GA6155@gollum.tnic>
References: <20070413091422.GA15426@zmei.tnic>
	<20070414091341.7665d8b0.randy.dunlap@oracle.com>
	<20070415071050.GA4002@gollum.tnic>
	<20070417104907.GA6155@gollum.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 12:49:07 +0200 Borislav Petkov wrote:

> On Sun, Apr 15, 2007 at 09:10:50AM +0200, Borislav Petkov wrote:
> > On Sat, Apr 14, 2007 at 09:13:41AM -0700, Randy Dunlap wrote:
> > > On Fri, 13 Apr 2007 11:14:22 +0200 Borislav Petkov wrote:
> > > 
> > > > This patch shuts warnings of the sort:
> > > > 
> > > > make -C /mnt/samsung_200/sam/kernel/trees/21-rc6/build \
> > > > 	KBUILD_SRC=/mnt/samsung_200/sam/kernel/trees/21-rc6 \
> > > > 	KBUILD_EXTMOD="" -f /mnt/samsung_200/sam/kernel/trees/21-rc6/Makefile mandocs
> > > > make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=scripts/basic
> > > > make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=Documentation/DocBook mandocs
> > > >   SRCTREE=/mnt/samsung_200/sam/kernel/trees/21-rc6/ /mnt/samsung_200/sam/kernel/trees/21-rc6/build/scripts/basic/docproc doc /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/wanbook.tmpl >Documentation/DocBook/wanbook.xml
> > > >   if grep -q refentry Documentation/DocBook/wanbook.xml; then xmlto man -m /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/man Documentation/DocBook/wanbook.xml ; gzip -f Documentation/DocBook/man/*.9; fi
> > > > Note: meta version: No productnumber or alternative     sppp_close
> > > > Note: meta version: No refmiscinfo@class=version        sppp_close
> > > > Note: Writing sppp_close.9
> > > > Note: meta version: No productnumber or alternative     sppp_open
> > > > Note: meta version: No refmiscinfo@class=version        sppp_open
> > > > 
> > > > by adding a RefMiscInfo xml tag in the form of the current kernel version to 
> > > > the function, struct and enum definitions in files included by kernel-doc when 
> > > > building 'mandocs'.  However, the version string appears truncated on the manpage
> > > > due to some constraints in the xml DTD for the man header, I believe, for the
> > > > troff output is truncated too.
> > > 
> > > Hi Borislav,
> > > 
> > > I cannot reproduce this error (either, a la the tex error).
> > > Any hints about how I could do so?
> > 
> > Hm, this is strange. IIRC, the refmiscinfo version tag is imposed by the docbook
> > xsl stylesheets for manpages, see
> > http://www.oasis-open.org/archives/docbook-apps/200508/msg00111.html and
> > especially the 'man'-section, subsection 'extra2 field.' According to it, 
> > the stylesheets check several different locations for version info to be put in
> > the left footer position in the manpage, and if none is found, they simply state
> > that there's no version info, so this is not an error message but simply a
> > notification which, if nothing else, annoys while building the mandocs.
> > 
> > The URL cites the changelog of docbook-xsl 1.69.1 and this is also the
> > version in SLED 10 you're using so you should be getting this, too. I'll
> > try to dig deeper into this. The relevant packs I use are docbook-xsl:
> > 1.72.0.dfsg.1-1, xmlto: 0.0.18-5.1 on debian unstable. 
> 
> Hi Randi,
> 
> I'm pretty sure the reason you cannot reproduce this warning is the line 
> 
> <xsl:param name="refentry.version.suppress">1</xsl:param>
> 
> which can be found in param.xsl, it being a part of the docbook-xsl
> distribution. The parameter's name is self-explanatory and a '1' suppresses
> the version generation. I was able to get this error because in the
> debian docbook-xsl package this param value is set to 0 by default.

Hm, I don't seem to have that file installed (except in
/usr/share/xml/docbook/stylesheet/...).  Where would it normally
be installed?


> This means, some users will get this warning and some will not, depending on the
> setting in the param.xsl file. What is the way to go here wrt to a solution
> dealing with all cases:
> 
> 1. patch the kernel-doc?
> 2. issue an info so that the user can suppress the annoying warning by
> themselves?
> 3. ...?


Are other people seeing these warning messages ??
If so, I think that we should patch the kernel-doc.  I don't think
that many people would read info about how to avoid the warnings.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

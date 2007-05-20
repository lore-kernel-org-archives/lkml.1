Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbXETVOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbXETVOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbXETVOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:14:32 -0400
Received: from [216.16.235.2] ([216.16.235.2]:55619 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbXETVOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:14:31 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 20 May 2007 17:12:36 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Factor out common MODULE_INFO content from module*.h
 files.
In-Reply-To: <20070520205116.GB25339@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0705201651570.19270@localhost.localdomain>
References: <Pine.LNX.4.64.0705201502160.17519@localhost.localdomain>
 <20070520191552.GA25200@uranus.ravnborg.org> <Pine.LNX.4.64.0705201555470.18338@localhost.localdomain>
 <20070520205116.GB25339@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Sam Ravnborg wrote:

> On Sun, May 20, 2007 at 04:06:40PM -0400, Robert P. J. Day wrote:
> > On Sun, 20 May 2007, Sam Ravnborg wrote:
> >
> > > On Sun, May 20, 2007 at 03:06:15PM -0400, Robert P. J. Day wrote:
> > > >
> > > > In order to eventually break the interdependency between the module.h
> > > > and moduleparam.h header files, factor out the common MODULE_INFO
> > > > content into a new header file.
> > >
> > > The moduleinfo.h file looks redundant at first look. Why not push
> > > relevant parts from moduleparam.h (the MODULE_INFO bits) to module.h
> > > and let go of the include of moduleparam.h in module.h (when you
> > > have fixed the users)?
> > >
> > > In this way we do not add an extra .h file. And files that needs
> > > moduleparam.h will anyway always need module.h. But not the other
> > > way around.
> >
> > crap, now i remember why i did it the way i did it.
> >
> > yes, the way you describe it is a simpler solution, but it would break
> > all of the files in the tree that use module parameters and have
> > included *only* module.h, and have been getting away with it all this
> > time only because module.h currently includes moduleparam.h.
> >
> > based on a simple script i have, there are currently 583 files under
> > the drivers/ directory *alone* that are like that.  that is, 583 files
> > that would need to include moduleparam.h instead of module.h simply to
> > continue to compile if the obvious header file fix were made.

> The pain is too high for this. Is seems worthwhile to make the
> change to module.h but adding an additional include to > 500 drivers
> is not worth it.

under the circumstances, is there *any* cleanup worth doing WRT to
this issue?  because of the fact that module.h currently includes
moduleparam.h, developers have been able to get away with being
incredibly sloppy in their includes.

based on a short script i wrote, here are some stats for the drivers/
directory:

$ . ../moduleparam.sh drivers
Number of source files found: 5042
Number of files that include module.h: 3788
Number of files that include moduleparam.h: 358
Number of files that include both: 347
Number of files that include ONLY module.h: 3440
Number of files that include ONLY moduleparam.h: 10
Number of files needing moduleparam.h: 583
Number of files with unnecessary moduleparam.h: 45

interpreting the above:

* there are 347 files that include both module.h and moduleparam.h
when (at the moment) they need to include only the former,

* there are 10 files that include *only* moduleparam.h (which does not
include module.h, so how the heck *those* still build is a mystery),

* there are 583 files that use module parameters in some way that
don't include moduleparam.h, and

* conversely, there are 45 source files that unnecessarily include
moduleparam.h when they don't use module parameters at all.

  at this point, you may be right.  trying to fix this may be more
grief than it's worth.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

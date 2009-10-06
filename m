Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbZJFRgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbZJFRgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbZJFRgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:36:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266AbZJFRgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:36:06 -0400
Date: Tue, 6 Oct 2009 19:35:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] kbuild: Improve version string logic
Message-ID: <20091006173508.GA4786@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 6 Oct 2009, Linus Torvalds wrote:
> > 
> > Unless:
> > 
> > > _That_ i think is a lot harder to confuse with the real .31 than a 
> > > v2.6.31-1234-g16123c4 version string.
> > 
> > .. are you saying that it would be just some automatically generated 
> > thing, just a crippled form of CONFIG_LOCALVERSION_AUTO? Kind of a 
> > CONFIG_LOCALVERSION_AUTO_SHORTFORM?
> 
> So how about this?

this patch is great IMHO. I've modified it to propagate the '+' into the 
long version string as well. I've tested it with auto-version not set 
and it now gives:

 Linux europe 2.6.32-rc3+ #2 SMP Tue Oct 6 19:26:58 CEST 2009 i686 i686 i386 GNU/Linux

the -rc3+ is a clearly visible distinction. This will improve things 
when bugs are reported with LOCALVERSION_AUTO not set - we'll always 
know when a tree is not vanilla.

With autoversion set 'uname -a' gives:

 Linux europe 2.6.32-rc3+00052-g0eca52a-dirty #3 SMP Tue Oct 6 19:29:54 CEST 2009 i686 i686 i386 GNU/Linux

IMO that's intuitive too. We get whatever is described in the 
localversion in addition to the tag. The '+' clearly signals that 'set 
union' operation we've done.

So this patch solves all the problems i had with our versioning. I've 
attached it below with a changelog.

Thanks,

	Ingo

--------------->
Subject: kbuild: Improve version string logic
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Oct 2009 09:31:03 -0700 (PDT)

It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial
way:

 - if it is set, things work the way they always have, and you get a
   extended kernel release like:

	2.6.32-rc3+00052-g0eca52a-dirty

   ( with the difference that the extra version string is separated via
     '+' not via '-'. This improves visibility when we have additional
     changes over a vanilla tag. )

 - but if it is _not_ set, we'll still try to get a version from the
   underlying SCM (we actually support git, hg and SVN right now, even if
   some comments may say "git only"), and if the underlying SCM says it
   has a local version, we append just "+", so you get a version number
   like:

	2.6.32-rc3+

IOW, you'd never get 2.6.32-rc0, but you'd get either the complex git
version number (or SVN/hg/whatever), or at least "2.6.31+" with the "+"
showing that it is more than plain 2.6.31.

The "+" could be anything else, of course. The diff is pretty obvious, you
can argue about exactly _what_ you'd like to see as a suffix for "and then
some".

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Makefile |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -963,16 +963,21 @@ localver = $(subst $(space),, $(string) 
 # .scmversion is used when generating rpm packages so we do not loose
 # the version information from the SCM when we do the build of the kernel
 # from the copied source
-ifdef CONFIG_LOCALVERSION_AUTO
-
 ifeq ($(wildcard .scmversion),)
         _localver-auto = $(shell $(CONFIG_SHELL) \
-                         $(srctree)/scripts/setlocalversion $(srctree))
+                         $(srctree)/scripts/setlocalversion $(srctree) | sed 's/^-/+/')
 else
         _localver-auto = $(shell cat .scmversion 2> /dev/null)
 endif
 
+ifdef CONFIG_LOCALVERSION_AUTO
 	localver-auto  = $(LOCALVERSION)$(_localver-auto)
+else
+	ifeq ($_localver-auto,)
+		localver-auto = $(LOCALVERSION)
+	else
+		localver-auto = $(LOCALVERSION)+
+	endif
 endif
 
 localver-full = $(localver)$(localver-auto)


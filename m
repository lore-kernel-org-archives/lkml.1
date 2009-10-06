Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbZJFQd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbZJFQd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbZJFQd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:33:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932107AbZJFQd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:33:28 -0400
Date: Tue, 6 Oct 2009 09:31:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Linus Torvalds wrote:
> 
> Unless:
> 
> > _That_ i think is a lot harder to confuse with the real .31 than a 
> > v2.6.31-1234-g16123c4 version string.
> 
> .. are you saying that it would be just some automatically generated 
> thing, just a crippled form of CONFIG_LOCALVERSION_AUTO? Kind of a 
> CONFIG_LOCALVERSION_AUTO_SHORTFORM?

So how about this?

It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial 
way:

 - if it is set, things work the way they always have, and you get a 
   extended kernel release like

	2.6.32-rc3-00052-g0eca52a-dirty

 - but if it is _not_ set, we'll still try to get a version from the 
   underlying SCM (we actually support git, hg and SVN right now, even if 
   some comments may say "git only"), and if the underlying SCM says it 
   has a local version, we append just "+", so you get a version number 
   like

	2.6.32-rc3+

IOW, you'd never get 2.6.32-rc0, but you'd get either the complex git 
version number (or SVN/hg/whatever), or at least "2.6.31+" with the "+" 
showing that it is more than plain 2.6.31.

The "+" could be anything else, of course. The diff is pretty obvious, you 
can argue about exactly _what_ you'd like to see as a suffix for "and then 
some".

		Linus

---
 Makefile |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index e50569a..c62b7cc 100644
--- a/Makefile
+++ b/Makefile
@@ -963,8 +963,6 @@ localver = $(subst $(space),, $(string) \
 # .scmversion is used when generating rpm packages so we do not loose
 # the version information from the SCM when we do the build of the kernel
 # from the copied source
-ifdef CONFIG_LOCALVERSION_AUTO
-
 ifeq ($(wildcard .scmversion),)
         _localver-auto = $(shell $(CONFIG_SHELL) \
                          $(srctree)/scripts/setlocalversion $(srctree))
@@ -972,7 +970,14 @@ else
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

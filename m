Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZJLT62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZJLT62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbZJLT62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:58:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38905 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbZJLT61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:58:27 -0400
Date: Mon, 12 Oct 2009 21:57:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>
Cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH, v2] kbuild: Improve version string logic
Message-ID: <20091012195733.GA7351@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006173508.GA4786@elte.hu>
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


This is basically your original patch that adds '+' to the short version 
string of kernels that are 'between' -rc tags. (i dropped the '+' within 
the long version i did in v1 - there were objections against that)

Would this be ok?

	Ingo

-------------->
>From 597e5b15dd0cbb3158afc438e5edae9986e6b76a Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Oct 2009 09:31:03 -0700
Subject: [PATCH] kbuild: Improve version string logic

It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial
way:

 - if it is set, things work the way they always have, and you get a
   extended kernel release like:

	2.6.32-rc3-00052-g0eca52a

 - but if it is _not_ set, we'll still try to get a version from the
   underlying SCM (we actually support git, hg and SVN right now, even if
   some comments may say "git only"), and if the underlying SCM says it
   has a local version, we append just "+", so you get a version number
   like:

	2.6.32-rc3+

IOW, you'd never get 2.6.32-rc0, but you'd get either the complex git
version number (or SVN/hg/whatever), or at least "2.6.31+" with the "+"
showing that it is more than plain 2.6.31.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>
Cc: Dirk Hohndel <hohndel@infradead.org>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <20091006173508.GA4786@elte.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Makefile |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 927d7a3..5dab509 100644
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

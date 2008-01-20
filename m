Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYATUFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYATUFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYATUFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:05:21 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59784 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbYATUFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:05:19 -0500
Date: Sun, 20 Jan 2008 21:05:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>
Subject: kbuild: improved Section mismatch detection
Message-ID: <20080120200527.GA23852@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have spent the last week (the time I can afford to
Linux stuff anyway) to improve the Section mismatch 
warnings detected by modpost.

The problem until now has been that the Section
mismatch warnings were dependent on the actual
configuration of HOTPLUG, HOTPLUG_CPU and MEMORY_HOTPLUG.
In the default configuration with HOTPLUG enbaled most
of the remaining Section mismatch warnings were not
seen and thus many of us thought that everything was great.

Adrian reminded us that KCFLAGS=-fno-inline told
another story with more than 100 Section mismatch
warnings on 64 bit x86 with an allyesconfig build.

As this was not acceptable I set out to make it
less configuration dependent. To do so I quikly
relaised that modpost had to be prepared before this
was a feasible thing to implment.

This serie of patches is:

1)      kbuild: fix so modpost can now check any .o file
2)      kbuild: try harder to find symbol names in modpost
3)      kbuild: code refactoring in modpost
4)      kbuild: introduce blacklisting in modpost
5)      kbuild: check section names consistently in modpost
6)      all archs: consolidate init and exit sections in vmlinux.lds.h
7)      compiler.h: introduce __section()
8)      Use separate sections for __dev/__cpu/__mem code/data

Patch 6) makse a set of trivial changes in all arch vmlinux.lds.S files
and the reason why I copid linux-arch on this mail.

Patch 4) is a major change in modpost where we no longer try to
find all the good guys but instead look for the bad combinations.
This should result in a lot less false warnings and for example got
rid of an irritating warning on sparc64.

Patch 2) is important - previously modpost failed to find the
correct symbol based on address lookup because it wanted an exact
match. Allowing up to 20 bytes offset we now locate almost all
symbols and the warnings are much easier to fix.

Randy and Adrian among others have done a great job fixing
many Section mismatch warnngs over the last month.
But frankly much more people should do this and I can see people
ignoring the warnings.

Therefore the plan is to turn the warnings into hard build errors
at -rc1 time.
This should force people to actually fix the warnings they introduce.

But to do so we need the warnings we have today gettign fixed and
the new improved modpost should help you here.
To further help the plans are to:
- add a config option to enable -fno-inline (or a similar option)
- make the warnings from modpost more descriptive but longer 
- maybe to spend a few hours to fix some of the obvious candidates
  Less than half an hour for each warning for the trivial cases
- Maybe start using __INIT and friends in assembler code
  xen had two bugs in this area recently for example.

It has been questions if it is worth the effort to fix these warnings.
Randy just fixed three oops candidates - do anyone need more facts?

And the cpu code looks rather fragile in the dead/removed CPU cases.
I see several references that will oops and is easy to fix.

	Sam




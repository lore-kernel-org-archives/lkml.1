Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZECU1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZECU1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZECU1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:27:43 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:55085 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbZECU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:27:43 -0400
Date: Sun, 3 May 2009 22:29:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Anders Kaseorg <andersk@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lots of unexpected non-allocatable section warnings
Message-ID: <20090503202939.GA1237@uranus.ravnborg.org>
References: <20090503110517.6d09bca2@hyperion.delvare> <20090503103010.GA27978@uranus.ravnborg.org> <20090503124848.276b437f@hyperion.delvare> <20090503180332.GA31820@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503180332.GA31820@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 08:03:32PM +0200, Sam Ravnborg wrote:
> > > 
> > > Cannot reproduce here..
> > 
> > Given the name of the section, I presume it is somewhat SUSE-specific.
> > I'm running openSUSE 11.1.
> Likely - I could not reprodcue with your config.
> 
> > > Can you send me your config so I can try to see if this is toolchain
> > > version related.
> > 
> > Config attached.
> > 
> > > Also what version of gcc/binutils are you using?
> > 
> > $ gcc --version
> > gcc (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291]
> > 
> > $ ld -v
> > GNU ld (GNU Binutils; openSUSE 11.1) 2.19
> > 
> > > Is this x86 and 32/64 bit?
> > 
> > x86, 64 bit. If you need anything else, let me know.
> 
> Can you send me (off-list) the .o + .ko files
> for one of the failing modules.
> I like to see what the section contains - or at least the flags.
> I do not know on top of my head the commands so
> with the .o faile available I expect to figure it out.

Thanks for the .o file!

This is due to the SUSE specific section as you expected.
We ignore sections named ".comment" but not ".comment" sections
with something appended to the name.

Can you please try appended patch and let me know if it fixes it for you.

Thanks,
	Sam

>From 73aa9cbd4f71afdb173605383f77ebfda6d19ced Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 3 May 2009 22:17:37 +0200
Subject: [PATCH 2/2] kbuild, modpost: fix "unexpected non-allocatable" warning with SUSE gcc

Jean reported that he saw one warning for each module like the one below:
WARNING: arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.o (.comment.SUSE.OPTs): unexpected non-allocatable section.

The warning appeared with the improved version of the
check of the flags in the sections.

That check already ignored sections named ".comment" - but SUSE store
additional info in the comment section and has named it in a SUSE
specific way. Therefore modpost failed to ignore the section.

The fix is to extend the pattern so we ignore all sections
that start with the name ".comment.".

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: Jean Delvare <khali@linux-fr.org>
---
 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a5c17db..268d457 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -727,7 +727,7 @@ int match(const char *sym, const char * const pat[])
 
 /* sections that we do not want to do full section mismatch check on */
 static const char *section_white_list[] =
-	{ ".comment", ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
+	{ ".comment*", ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
 
 /*
  * This is used to find sections missing the SHF_ALLOC flag.
-- 
1.6.3.rc3.40.g75b44


Return-Path: <linux-kernel-owner+w=401wt.eu-S1750807AbXBMQK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750807AbXBMQK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXBMQKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:10:25 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:46902 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbXBMQKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:10:25 -0500
Date: Tue, 13 Feb 2007 17:09:47 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oleg Verych <olecom@flower.upol.cz>, Tony Luck <tony.luck@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in
 localversion files
In-Reply-To: <Pine.LNX.4.64.0702130744030.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702131700190.14457@scrub.home>
References: <20070206011819.160359000@flower.upol.cz> <20070206012208.050237000@flower.upol.cz>
 <12c511ca0702121409t30e126dfh445d13dd2f637e08@mail.gmail.com>
 <Pine.LNX.4.64.0702121437420.8424@woody.linux-foundation.org>
 <20070213003258.GA15534@flower.upol.cz> <20070213050503.GA27441@flower.upol.cz>
 <Pine.LNX.4.64.0702130744030.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 13 Feb 2007, Linus Torvalds wrote:

> > I know it maybe another my "change it all" proposition, but i can't find
> > nothing against `GNU $(wildcard ..)' and `unnecessarily complex "find"'.
> 
> It's the regexp in both cases. $(wildcard ) doesn't do regexp's (only the 
> normal path rules), and traditional 'find' doesn't either. The fact that 
> GNU find does is another matter. I don't think we require GNU find 
> normally.
> 
> And I don't even much like the "backup" thing. Some programs will use 
> other things than "~" as a backup marker. Patch more often uses ".orig", 
> for example. So both methods are fairly complex, but at the same time not 
> quite complex enough.
> 
> It would probably have been a better idea had we made the rule be that the 
> file is called "*localversion" rather than "localversion*", exactly 
> because that way it's unambiguous (people normally use _suffixes_ for 
> filetypes, not prefixes). That would have avoided the whole complexity in 
> wildcarding, but it's too late now..
> 
> 	$(sort $(wildcard $(srctree)/*localversion $(objtree)/*localversion)
> 
> should have worked.

For now I think it's easier to just revert the change to use find, I 
posted the patch for this already a few days ago.
I don't know if it really makes sense to change the rules for this now, 
apparently people are using this, it may not be perfect, but I think in 
the end it's just a matter of taste.

bye, Roman



[PATCH] refix localversion handling

This reverts part of the localversion patch, which now already got into
git. It removes the unnecessary find call, with the simpler $(notdir ...)
fix.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 Makefile |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile
+++ linux-2.6/Makefile
@@ -787,12 +787,14 @@ $(vmlinux-dirs): prepare scripts
 # moment, only git is supported but other SCMs can edit the script
 # scripts/setlocalversion and add the appropriate checks as needed.
 
-pattern = ".*/localversion[^~]*"
-string  = $(shell cat /dev/null \
-	   `find $(objtree) $(srctree) -maxdepth 1 -regex $(pattern) | sort`)
-
-localver = $(subst $(space),, $(string) \
-			      $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
+___localver = $(objtree)/localversion* $(srctree)/localversion*
+__localver  = $(sort $(wildcard $(___localver)))
+# skip files containing '~' (like backup files)
+_localver = $(foreach f,$(__localver),$(if $(findstring ~,$(notdir $(f))),,$(f)))
+
+localver = $(subst $(space),, \
+	   $(shell cat /dev/null $(_localver)) \
+	   $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
 
 # If CONFIG_LOCALVERSION_AUTO is set scripts/setlocalversion is called
 # and if the SCM is know a tag from the SCM is appended.

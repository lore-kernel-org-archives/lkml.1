Return-Path: <linux-kernel-owner+w=401wt.eu-S934290AbZJNAAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290AbZJNAAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761640AbZJNAAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:00:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZJNAAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:00:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mYKSAYdo0e2+WfpG1Wp8pmQnFsoOUr6Jfx0g7AzxUC+gUUt6xMKAd+tRJXQwHVJmv
	I2TPX0OG5LZwsTOu+rkYQ==
Date: Tue, 13 Oct 2009 16:59:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
In-Reply-To: <alpine.LFD.2.01.0910131100180.26777@localhost.localdomain>
Message-ID: <alpine.DEB.1.00.0910131649280.24112@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910130004.46388.elendil@planet.nl> <20091013070505.GC31483@elte.hu> <200910131952.01209.elendil@planet.nl> <alpine.LFD.2.01.0910131100180.26777@localhost.localdomain>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Linus Torvalds wrote:

> > IMHO yes. This change essentially creates a backwards incompatibility with 
> > existing naming schemes. Requiring to patch the change out to preserve an 
> > existing naming scheme just seems a tad unfriendly.
> 
> Let's keep the old behavior by making the AUTO option an three-way choice 
> ("none", "short", "auto"), and making sure that it actually takes work to 
> choose "none" (and that "make oldconfig" doesn't choose it unless you 
> explicitly made the choice before - so people who just re-use old .config 
> files wouldn't get "none" by mistake).
> 

I don't think you want to do that because it would require the .config to 
be posted on bug reports, for example, to determine the setting of 
CONFIG_LOCALVERSION_AUTO before you can interpret the kernel version.  In 
other words, you wouldn't know that "2.6.32-rc4" is actually 200 commits 
beyond the actual release unless you also know that the .config has 
CONFIG_LOCALVERSION_AUTO="none".

Instead, it's better to force something to be appended to the kernel 
release when "git describe" shows a non-zero revision count as you 
earlier suggested.  When CONFIG_LOCALVERSION_AUTO is enabled, that would 
be the output of scripts/setlocalversion; when it is disabled, it would be 
a `+'.  Only when scripts/setlocalversion returns nothing (we're at an 
actual kernel release) will nothing be appended.

The following is on top of my "scripts: suppress setlocalversion output if 
at tagged commit" patch from 
http://marc.info/?l=linux-kernel&m=125542102631704


kbuild: improve version string logic

The LOCALVERSION= string passed to "make" will now always be appended to
the kernel version after CONFIG_LOCALVERSION, if it exists, regardless of
whether CONFIG_LOCALVERSION_AUTO is set or not.  This allows users to
uniquely identify their kernel builds with a string.

scripts/setlocalversion will now always be called to determine whether
the repository is beyond a tagged (release) commit.  With "scripts:
suppress setlocalversion output if at tagged commit", the output of this
script is empty when at a tagged commit.

If CONFIG_LOCALVERSION_AUTO is enabled, the unique SCM tag reported by 
setlocalversion (or .scmversion) is appended to the kernel version, if it 
exists.  When CONFIG_LOCALVERSION_AUTO is not enabled, a `+' is appended
to the kernel version to represent that the kernel has been revised since
the last release.

The end result is this:

 - when LOCALVERSION= is passed to "make", it is appended to the kernel
   version,

 - when CONFIG_LOCALVERSION_AUTO is enabled, a unique SCM identifier is
   appended if the respository has been revised beyond a tagged commit,
   and

 - when CONFIG_LOCALVERSION_AUTO is disabled, a `+' is appended if the 
   repository has been revised beyond a tagged commit.

Also renames variables such as localver-auto and _localver-auto to more 
accurately describe what they represent: localver-extra and
scm-identifier, respectively.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Makefile |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
--- a/Makefile
+++ b/Makefile
@@ -898,9 +898,13 @@ $(vmlinux-dirs): prepare scripts
 #	  $(localver)
 #	    localversion*		(files without backups, containing '~')
 #	    $(CONFIG_LOCALVERSION)	(from kernel config setting)
-#	  $(localver-auto)		(only if CONFIG_LOCALVERSION_AUTO is set)
-#	    ./scripts/setlocalversion	(SCM tag, if one exists)
-#	    $(LOCALVERSION)		(from make command line if provided)
+#	    $(LOCALVERSION)		(from make command line, if provided)
+#	  $(localver-extra)
+#	    $(scm-identifier)		(unique SCM tag, if one exists)
+#	      ./scripts/setlocalversion	(only with CONFIG_LOCALVERSION_AUTO)
+#	      .scmversion		(only with CONFIG_LOCALVERSION_AUTO)
+#	    +				(only without CONFIG_LOCALVERSION_AUTO
+#					 and repository is at non-tagged commit)
 #
 #  Note how the final $(localver-auto) string is included *only* if the
 # kernel config option CONFIG_LOCALVERSION_AUTO is selected.  Also, at the
@@ -914,26 +918,30 @@ string  = $(shell cat /dev/null \
 localver = $(subst $(space),, $(string) \
 			      $(patsubst "%",%,$(CONFIG_LOCALVERSION)))
 
-# If CONFIG_LOCALVERSION_AUTO is set scripts/setlocalversion is called
-# and if the SCM is know a tag from the SCM is appended.
-# The appended tag is determined by the SCM used.
+# scripts/setlocalversion is called to create a unique identifier if the source
+# is managed by a known SCM and the repository has been revised since the last
+# tagged (release) commit.  The format of the identifier is determined by the
+# SCM's implementation.
 #
 # .scmversion is used when generating rpm packages so we do not loose
 # the version information from the SCM when we do the build of the kernel
 # from the copied source
-ifdef CONFIG_LOCALVERSION_AUTO
-
 ifeq ($(wildcard .scmversion),)
-        _localver-auto = $(shell $(CONFIG_SHELL) \
+        scm-identifier = $(shell $(CONFIG_SHELL) \
                          $(srctree)/scripts/setlocalversion $(srctree))
 else
-        _localver-auto = $(shell cat .scmversion 2> /dev/null)
+        scm-identifier = $(shell cat .scmversion 2> /dev/null)
 endif
 
-	localver-auto  = $(LOCALVERSION)$(_localver-auto)
+ifdef CONFIG_LOCALVERSION_AUTO
+	localver-extra = $(scm-identifier)
+else
+	ifneq ($scm-identifier,)
+		localver-extra = +
+	endif
 endif
 
-localver-full = $(localver)$(localver-auto)
+localver-full = $(localver)$(LOCALVERSION)$(localver-extra)
 
 # Store (new) KERNELRELASE string in include/config/kernel.release
 kernelrelease = $(KERNELVERSION)$(localver-full)

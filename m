Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbZJNXoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbZJNXoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761619AbZJNXoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:44:04 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:52736 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761616AbZJNXoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:44:03 -0400
From: Frans Pop <elendil@planet.nl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Date: Thu, 15 Oct 2009 01:43:16 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <20091014073306.GB22778@elte.hu> <alpine.DEB.1.00.0910140037140.29264@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0910140037140.29264@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910150143.18755.elendil@planet.nl>
X-OriginalArrivalTime: 14 Oct 2009 23:43:24.0977 (UTC) FILETIME=[1F210A10:01CA4D28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009, David Rientjes wrote:
> On Wed, 14 Oct 2009, Ingo Molnar wrote:
> Yeah, my patches build upon the base that you originally proposed.  I
> like the `+' suffix for configs with CONFIG_LOCALVERSION_AUTO that
> aren't vanilla kernels.

That is fine for custom kernels. I still maintain that it is hopelessly
wrong for distro kernels.

Distro kernels generally have their own naming schemes.
Debian uses: 2.6.30-2-amd64 (<version>-<ABI>-<flavor>)
Fedora uses: 2.6.30.5-43.fc11.i586

And those kernel versions implicitly already contain the information that
they are not vanilla kernels. So a "+" suffix is totally redundant.

My main argument is that if they build kernels from an SCM, which is quite
likely, they should not suddenly get a "+" appended to those versions.
And IMO they should also not have to patch the Makefile to avoid it.
If this change is made, it should be made in such a way that old version
naming schemes are still possible.

> > But there's been packaging related objections from Frans and others,

I'm personally not convinced that there are actual *technical* packaging
issues, at least not for Debian (see my posts elsewhere in the thread).

However, it is very much possible that the change will break random
scripts that are in use and that expect a certain naming scheme.
Having an out would help those cases as well.

> > and i suspect you'll need to answer/address those instead of further
> > detailing the virtues of proper version names (which i still 100%
> > agree with).
>
> We could easily go with my suggestion of allowing "make LOCALVERSION="
> to override all additions to the kernel version when
> CONFIG_LOCALVERSION_AUTO is disabled.  For such configurations, kernels
> would be built with this variable to specify how it's different from the
> vanilla version and would suppress the `+'.

Using LOCALVERSION= for that would be wrong as it is on a different level
from AUTOVERSION. They should be independent. However, that basic approach
of using an environment variable is certainly an option.

And, while I was working on the patch to implement a tristate AUTOVERSION,
I thought of a very common use case that IMO we do want to cover here.

Many users build custom kernels using a distro config as starting point.
The distro does not want the "+", but we very much _do_ want it in the
custom kernel built by the user.
So the conclusion is that suppressing the "+" is simply not something that
can be set in the config, and thus the tristate solution is wrong.
Only alternative I see is that it must be a build option.

So I propose the following patch on top of the patch proposed by David.
It offers a clean out for users who explicitly do not want *any* SCM-based
suffix added to their kernel version, and is IMO both 1) obvious enough
for expert users and 2) obscure enough that regular users are unlikely to
abuse it. Is that acceptable?

The patch also fixes up the comment I mentioned earlier. The old comment
was outdated anyway and partially made redundant by the change David
already made in the later comment. And it has a typo fix.

David: I think it would be best to just merge this into your patch.

diff --git a/Makefile b/Makefile
index 24e54fd..6fcaba7 100644
--- a/Makefile
+++ b/Makefile
@@ -906,10 +906,8 @@ $(vmlinux-dirs): prepare scripts
 #	    +				(only without CONFIG_LOCALVERSION_AUTO
 #					 and repository is at non-tagged commit)
 #
-#  Note how the final $(localver-auto) string is included *only* if the
-# kernel config option CONFIG_LOCALVERSION_AUTO is selected.  Also, at the
-# moment, only git is supported but other SCMs can edit the script
-# scripts/setlocalversion and add the appropriate checks as needed.
+# Note that the final $(localver-extra) string can be suppressed by setting
+# the environment variable KBUILD_NO_LOCALVERSION_EXTRA.
 
 pattern = ".*/localversion[^~]*"
 string  = $(shell cat /dev/null \
@@ -923,9 +921,11 @@ localver = $(subst $(space),, $(string) \
 # tagged (release) commit.  The format of the identifier is determined by the
 # SCM's implementation.
 #
-# .scmversion is used when generating rpm packages so we do not loose
+# .scmversion is used when generating rpm packages so we do not lose
 # the version information from the SCM when we do the build of the kernel
 # from the copied source
+ifndef KBUILD_NO_LOCALVERSION_EXTRA
+
 ifeq ($(wildcard .scmversion),)
         scm-identifier = $(shell $(CONFIG_SHELL) \
                          $(srctree)/scripts/setlocalversion $(srctree))
@@ -941,6 +941,8 @@ else
 	endif
 endif
 
+endif # ifndef KBUILD_NO_LOCALVERSION_EXTRA
+
 localver-full = $(localver)$(LOCALVERSION)$(localver-extra)
 
 # Store (new) KERNELRELASE string in include/config/kernel.release

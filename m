Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593Ab0ADVb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0ADVb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365Ab0ADVbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:31:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:32233 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0ADVbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:31:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=ZFBkvc1QlPHVUVcg8giXM7Nre8WfHNfUAZKz7OZXw8j7Dqw+4h+4r8q5GVUEBwrHA
	ce/H2V9DNwpdp7tH5aSGA==
Date: Mon, 4 Jan 2010 13:31:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Marek <mmarek@suse.cz>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch] kbuild: improve version string logic
Message-ID: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LOCALVERSION= string passed to "make" will now always be appended to
the kernel version after CONFIG_LOCALVERSION, if it exists, regardless of
whether CONFIG_LOCALVERSION_AUTO is set or not.  This allows users to
uniquely identify their kernel builds with a string.

scripts/setlocalversion will now always be called to determine whether
the repository is beyond a tagged (release) commit.  When at a tagged
commit, this script will now suppress all output.

If CONFIG_LOCALVERSION_AUTO is enabled, the unique SCM tag reported by 
setlocalversion (or .scmversion) is appended to the kernel version, if it 
exists.  When CONFIG_LOCALVERSION_AUTO is not enabled, a `+' is appended
to the kernel version to represent that the kernel has been revised since
the last release unless "make LOCALVERSION=" was used to uniquely identify
the build.

The end result is this:

 - when LOCALVERSION= is passed to "make", it is appended to the kernel
   version,

 - when CONFIG_LOCALVERSION_AUTO is enabled, a unique SCM identifier is
   appended if the respository has been revised beyond a tagged commit,
   and

 - when CONFIG_LOCALVERSION_AUTO is disabled, a `+' is appended if the 
   repository has been revised beyond a tagged commit and LOCALVERSION=
   was not passed to "make".

Examples:

With CONFIG_LOCALVERSION_AUTO: "make" results in
v2.6.32-rc4-00149-ga3ccf63.  If there are uncommited changes to the
respository, it results in v2.6.32-rc4-00149-ga3ccf63-dirty.  If
"make LOCALVERSION=kbuild" were used, it results in
v2.6.32-rc4-kbuild-00149-ga3ccf63-dirty.

Without CONFIG_LOCALVERSION_AUTO, "make" results in v2.6.32-rc4+
unless the repository is at the Linux v2.6.32-rc4 commit (in which
case the version would be v2.6.32-rc4).  If "make LOCALVERSION=kbuild"
were used, it results in v2.6.32-rc4-kbuild.

Also renames variables such as localver-auto and _localver-auto to more 
accurately describe what they represent: localver-extra and
scm-identifier, respectively.

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Makefile                |   43 +++++++++++++++++++++++++++----------------
 scripts/setlocalversion |    3 ++-
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/Makefile b/Makefile
--- a/Makefile
+++ b/Makefile
@@ -898,14 +898,19 @@ $(vmlinux-dirs): prepare scripts
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
+#					 and without LOCALVERSION= and 
+#					 repository is at non-tagged commit)
 #
-#  Note how the final $(localver-auto) string is included *only* if the
-# kernel config option CONFIG_LOCALVERSION_AUTO is selected.  Also, at the
-# moment, only git is supported but other SCMs can edit the script
-# scripts/setlocalversion and add the appropriate checks as needed.
+# For kernels without CONFIG_LOCALVERSION_AUTO compiled from an SCM that has
+# been revised beyond a tagged commit, `+' is appended to the version string
+# when not overridden by using "make LOCALVERSION=".  This indicates that the
+# kernel is not a vanilla release version and has been modified.
 
 pattern = ".*/localversion[^~]*"
 string  = $(shell cat /dev/null \
@@ -914,26 +919,32 @@ string  = $(shell cat /dev/null \
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
+		ifeq ($(LOCALVERSION),)
+			localver-extra = +
+		endif
+	endif
 endif
 
-localver-full = $(localver)$(localver-auto)
+localver-full = $(localver)$(LOCALVERSION)$(localver-extra)
 
 # Store (new) KERNELRELASE string in include/config/kernel.release
 kernelrelease = $(KERNELVERSION)$(localver-full)
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -26,7 +26,8 @@ if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
 		# If we are past a tagged commit (like "v2.6.30-rc5-302-g72357d5"),
 		# we pretty print it.
 		if atag="`git describe 2>/dev/null`"; then
-			echo "$atag" | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
+			echo "$atag" | awk -F- 'int($(NF-1)) > 0	\
+					{printf("-%05d-%s", $(NF-1),$(NF))}'
 
 		# If we don't have a tag at all we print -g{commitish}.
 		else

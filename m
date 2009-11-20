Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZKTPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZKTPL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZKTPL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:11:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57344 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZKTPL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:11:56 -0500
Subject: [PATCH][GIT PULL] kconfig: Fix make O=<dir> local{mod,yes}config
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 20 Nov 2009 10:12:00 -0500
Message-Id: <1258729920.22249.1028.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

I know this is late in the -rc but this fix is for those like
Peter Zijlstra that do all their builds with O=<dir>. But I understand
if this is too much too late. I could just send it off to the stable
folks then. (I would then have to rebase to add the "stable" tag).

-- Steve

Please pull the latest for-linus tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-kconfig.git
for-linus


Steven Rostedt (1):
      kconfig: Fix make O=<dir> local{mod,yes}config

----
 scripts/kconfig/Makefile             |    4 ++--
 scripts/kconfig/streamline_config.pl |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)
---------------------------
commit 463bf9000750e08a85ee0b40da3266aae8a54ba2
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Nov 20 09:21:12 2009 -0500

    kconfig: Fix make O=<dir> local{mod,yes}config
    
    When the output directory is something other than the kernel source,
    the streamline_config script gets confused. This patch passes in the
    source directory to the script so that it can find the proper files.
    
    Reported-by: Peter Zijlstra <peterz@infradead.org>
    Tested-by: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 6d69c7c..80599e3 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -30,7 +30,7 @@ silentoldconfig: $(obj)/conf
 	$< -s $(Kconfig)
 
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
-	$(Q)perl $< $(Kconfig) > .tmp.config
+	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
 	$(Q)if [ -f .config ]; then 				\
 			cmp -s .tmp.config .config ||		\
 			(mv -f .config .config.old.1;		\
@@ -44,7 +44,7 @@ localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)rm -f .tmp.config
 
 localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
-	$(Q)perl $< $(Kconfig) > .tmp.config
+	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
 	$(Q)sed -i s/=m/=y/ .tmp.config
 	$(Q)if [ -f .config ]; then 				\
 			cmp -s .tmp.config .config ||		\
diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 95984db..0d80082 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -43,7 +43,6 @@
 #    make oldconfig
 #
 my $config = ".config";
-my $linuxpath = ".";
 
 my $uname = `uname -r`;
 chomp $uname;
@@ -111,7 +110,11 @@ sub find_config {
 
 find_config;
 
-my @makefiles = `find $linuxpath -name Makefile`;
+# Get the build source and top level Kconfig file (passed in)
+my $ksource = $ARGV[0];
+my $kconfig = $ARGV[1];
+
+my @makefiles = `find $ksource -name Makefile`;
 my %depends;
 my %selects;
 my %prompts;
@@ -119,9 +122,6 @@ my %objects;
 my $var;
 my $cont = 0;
 
-# Get the top level Kconfig file (passed in)
-my $kconfig = $ARGV[0];
-
 # prevent recursion
 my %read_kconfigs;
 
@@ -132,7 +132,7 @@ sub read_kconfig {
     my $config;
     my @kconfigs;
 
-    open(KIN, $kconfig) || die "Can't open $kconfig";
+    open(KIN, "$ksource/$kconfig") || die "Can't open $kconfig";
     while (<KIN>) {
 	chomp;
 



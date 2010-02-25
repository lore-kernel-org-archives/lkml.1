Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab0BYTT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:19:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38235 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab0BYTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:19:56 -0500
X-Authority-Analysis: v=1.0 c=1 a=81-ZCrrXXpwA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=HGNNirQh7TFNGZ8RDJoA:9 a=3h8Eo5CmbHGZZfNPhdkA:7 a=37uurf8JyXwKI_q8jxQqGHwM8nAA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225191954.735993275@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:17:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH 4/5] kconfig: Add LSMOD=file to override the lsmod for localmodconfig
References: <20100225191755.483925025@goodmis.org>
Content-Disposition: inline; filename=0004-kconfig-Add-LSMOD-file-to-override-the-lsmod-for-loc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Doing the following:

	make LSMOD=file localmodconfig

Will make the streamline-config code use the given file instead of
lsmod. If the file is an executable, it will execute it, otherwise
it will read it as text.

	make LSMOD=/my/local/path/lsmod localmodconfig

The above will execute the lsmod in /my/local/path instead of the
lsmods that may be located elsewhere.

	make LSMOD=embedded_board_lsmod localmodconfig

The above will read the "embedded_board_lsmod" as a text file. This
is useful if you are doing a cross compile and need to run the
config against modules that exist on an embedded device.

Note, if the LSMOD= file does is not a path, it will add the
path to the object directory. That is, the above example will look
for "embedded_board_lsmod" in the directory that the binary will
be built in (the O=dir directory).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

 On branch config/linus
---
 scripts/kconfig/Makefile             |   13 +++++++++-
 scripts/kconfig/streamline_config.pl |   38 ++++++++++++++++++++++++---------
 2 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 006c96f..85b9065 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -30,9 +30,18 @@ silentoldconfig: $(obj)/conf
 	$(Q)mkdir -p include/generated
 	$< -s $(Kconfig)
 
+# if no path is given, then use src directory to find file
+ifdef LSMOD
+LSMOD_F = $(shell if [ `basename $(LSMOD)` == $(LSMOD) ]; then \
+		echo $(objtree)/$(LSMOD);			\
+	else							\
+		echo $(LSMOD);					\
+	fi)
+endif
+
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)mkdir -p include/generated
-	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
+	$(Q)perl $< $(srctree) $(Kconfig) $(LSMOD_F) > .tmp.config
 	$(Q)if [ -f .config ]; then 				\
 			cmp -s .tmp.config .config ||		\
 			(mv -f .config .config.old.1;		\
@@ -47,7 +56,7 @@ localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
 
 localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
 	$(Q)mkdir -p include/generated
-	$(Q)perl $< $(srctree) $(Kconfig) > .tmp.config
+	$(Q)perl $< $(srctree) $(Kconfig) $(LSMOD_F) > .tmp.config
 	$(Q)sed -i s/=m/=y/ .tmp.config
 	$(Q)if [ -f .config ]; then 				\
 			cmp -s .tmp.config .config ||		\
diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index d7f7db7..afbd54a 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -113,6 +113,7 @@ find_config;
 # Get the build source and top level Kconfig file (passed in)
 my $ksource = $ARGV[0];
 my $kconfig = $ARGV[1];
+my $lsmod_file = $ARGV[2];
 
 my @makefiles = `find $ksource -name Makefile`;
 my %depends;
@@ -263,21 +264,36 @@ foreach my $makefile (@makefiles) {
 
 my %modules;
 
-# see what modules are loaded on this system
-my $lsmod;
-
-foreach $dir ( ("/sbin", "/bin", "/usr/sbin", "/usr/bin") ) {
-    if ( -x "$dir/lsmod" ) {
-	$lsmod = "$dir/lsmod";
-	last;
+if (defined($lsmod_file)) {
+    if ( ! -f $lsmod_file) {
+	die "$lsmod_file not found";
+    }
+    if ( -x $lsmod_file) {
+	# the file is executable, run it
+	open(LIN, "$lsmod_file|");
+    } else {
+	# Just read the contents
+	open(LIN, "$lsmod_file");
     }
+} else {
+
+    # see what modules are loaded on this system
+    my $lsmod;
+
+    foreach $dir ( ("/sbin", "/bin", "/usr/sbin", "/usr/bin") ) {
+	if ( -x "$dir/lsmod" ) {
+	    $lsmod = "$dir/lsmod";
+	    last;
+	}
 }
-if (!defined($lsmod)) {
-    # try just the path
-    $lsmod = "lsmod";
+    if (!defined($lsmod)) {
+	# try just the path
+	$lsmod = "lsmod";
+    }
+
+    open(LIN,"$lsmod|") || die "Can not call lsmod with $lsmod";
 }
 
-open(LIN,"$lsmod|") || die "Can not call lsmod with $lsmod";
 while (<LIN>) {
 	next if (/^Module/);  # Skip the first line.
 	if (/^(\S+)/) {
-- 
1.6.5



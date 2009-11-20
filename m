Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZKTPvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZKTPvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbZKTPvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:51:04 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:51163 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZKTPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:51:01 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: linux-kernel@vger.kernel.org, lrodriguez@atheros.com
Cc: sam@ravnborg.org, greg@kroah.com, akpm@linux-foundation.org,
       mcgrof@gmail.com, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 3/4] kconfig: streamline_config.pl: add handling for "if" statements in Kconfig
Date: Fri, 20 Nov 2009 15:50:53 +0000
Message-Id: <1258732254-15573-4-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258732254-15573-3-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1258732254-15573-1-git-send-email-alan-jenkins@tuffmail.co.uk>
 <1258732254-15573-2-git-send-email-alan-jenkins@tuffmail.co.uk>
 <1258732254-15573-3-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that certain modules e.g. snd_hda_intel were not being enabled
by "make localmodconfig".  stream_config.pl was unaware of the
dependencies implied by the "if" statements which surround many configs.

1) Maintain a global stack of the dependencies implied by "if" statements
   These dependencies can then added to each config symbol as it is
   created.

2) Refactor read_kconfig() to use more immediate recursion
   This is necessary to ensure correct handling of "source" statements
   which are nested within "if" statements.

 * Declare $_ as a local variable, so that it is not clobbered by
   recursive calls to read_kconfig().

 * Similarly, we change the global file handle KIN to an indirect file
   handle $kin, which we can then declare as a local variable.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 scripts/kconfig/streamline_config.pl |   37 ++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 7a7bcf7..f5b44c1 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -128,30 +128,45 @@ my $kconfig = $ARGV[0];
 # prevent recursion
 my %read_kconfigs;
 
+# stack of dependencies implied by "if" statements
+my @if_deps;
+
 sub read_kconfig {
     my ($kconfig) = @_;
 
     my $state = "NONE";
     my $config;
-    my @kconfigs;
+    my $kin;
+    my $_;
 
-    open(KIN, $kconfig) || (
+    open($kin, $kconfig) || (
 	$kconfig =~ "^[^/]" &&
-	open(KIN, $srctree . "/" . $kconfig)
+	open($kin, $srctree . "/" . $kconfig)
     ) || die "Can't open $kconfig";
 
-    while (<KIN>) {
+    while (<$kin>) {
 	chomp;
 
-	# collect any Kconfig sources
+	# collect the conditions of "if" statements
+	if (/^if\s+(\S+)\s*$/) {
+	    push(@if_deps, $1);
+	} elsif (/^endif/) {
+	    pop(@if_deps);
+	}
+
+	# read in any Kconfig sources
 	if (/^source\s*"(.*)"/) {
-	    $kconfigs[$#kconfigs+1] = $1;
+	    if (!defined($read_kconfigs{$1})) {
+		$read_kconfigs{$1} = 1;
+		read_kconfig($1);
+	    }
 	}
 
 	# configs found
 	if (/^\s*config\s+(\S+)\s*$/) {
 	    $state = "NEW";
 	    $config = $1;
+	    $depends{$config} = join(" ", @if_deps);
 
 	# collect the depends for the config
 	} elsif ($state eq "NEW" && /^\s*depends\s+on\s+(.*)$/) {
@@ -178,15 +193,7 @@ sub read_kconfig {
 	    $state = "NONE";
 	}
     }
-    close(KIN);
-
-    # read in any configs that were found.
-    foreach $kconfig (@kconfigs) {
-	if (!defined($read_kconfigs{$kconfig})) {
-	    $read_kconfigs{$kconfig} = 1;
-	    read_kconfig($kconfig);
-	}
-    }
+    close($kin);
 }
 
 if ($kconfig) {
-- 
1.6.3.3


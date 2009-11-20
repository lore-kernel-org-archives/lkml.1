Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZKTPvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZKTPvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZKTPvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:51:03 -0500
Received: from mxout-08.mxes.net ([216.86.168.183]:51140 "EHLO
	mxout-08.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZKTPu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:50:59 -0500
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
To: linux-kernel@vger.kernel.org, lrodriguez@atheros.com
Cc: sam@ravnborg.org, greg@kroah.com, akpm@linux-foundation.org,
       mcgrof@gmail.com, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [PATCH 2/4] kconfig: streamline_config.pl: fix out-of-tree builds
Date: Fri, 20 Nov 2009 15:50:52 +0000
Message-Id: <1258732254-15573-3-git-send-email-alan-jenkins@tuffmail.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258732254-15573-2-git-send-email-alan-jenkins@tuffmail.co.uk>
References: <1258732254-15573-1-git-send-email-alan-jenkins@tuffmail.co.uk>
 <1258732254-15573-2-git-send-email-alan-jenkins@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should look for Kconfig under $srctree, just like zconf.l does.
This allows "make localmodconfig" to work when using a separate build
directory (e.g. make O=../build).

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 scripts/kconfig/streamline_config.pl |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 7d898e3..7a7bcf7 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -46,7 +46,7 @@ use warnings;
 #    make oldconfig
 #
 my $config = ".config";
-my $linuxpath = ".";
+my $srctree = $ENV{"srctree"} || ".";
 
 my $uname = `uname -r`;
 chomp $uname;
@@ -114,7 +114,7 @@ sub find_config {
 
 find_config;
 
-my @makefiles = `find $linuxpath -name Makefile`;
+my @makefiles = `find $srctree -name Makefile`;
 my %depends;
 my %selects;
 my %prompts;
@@ -135,7 +135,11 @@ sub read_kconfig {
     my $config;
     my @kconfigs;
 
-    open(KIN, $kconfig) || die "Can't open $kconfig";
+    open(KIN, $kconfig) || (
+	$kconfig =~ "^[^/]" &&
+	open(KIN, $srctree . "/" . $kconfig)
+    ) || die "Can't open $kconfig";
+
     while (<KIN>) {
 	chomp;
 
-- 
1.6.3.3


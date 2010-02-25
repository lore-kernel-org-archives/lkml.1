Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab0BYTU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:20:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58451 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab0BYTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:19:56 -0500
X-Authority-Analysis: v=1.0 c=1 a=TXzXOgbB3fMA:10 a=20KFwNOVAAAA:8 a=zNJO5AVcAAAA:8 a=meVymXHHAAAA:8 a=OEG27LXpydlWjQojsbEA:9 a=gCP-VbKTZTxyZL2R3aTI4XPjnisA:4 a=jEp0ucaQiEUA:10 a=OusbKJ8RKEoA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100225191953.599229602@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 25 Feb 2010 14:17:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
       Anton Blanchard <anton@sambo.org>
Subject: [PATCH 2/5] kconfig: Check for if conditions in Kconfig for localmodconfig
References: <20100225191755.483925025@goodmis.org>
Content-Disposition: inline; filename=0002-kconfig-Check-for-if-conditions-in-Kconfig-for-local.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The streamline_config.pl misses the if conditions for checking
dependencies. For Kconfigs with the following construct:

 if MEDIA_SUPPORT

 config VIDEO_DEV

 [...]

If VIDEO_DEV was enabled, the script will miss the fact that MEDIA_SUPPORT
is also needed.

This patch changes streamline_config.pl to include if conditions into
the dependencies of configs.

Reported-by: Anton Blanchard <anton@sambo.org>
Tested-by: Anton Blanchard <anton@sambo.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index 0d80082..9e66fa8 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -121,6 +121,8 @@ my %prompts;
 my %objects;
 my $var;
 my $cont = 0;
+my $iflevel = 0;
+my @ifdeps;
 
 # prevent recursion
 my %read_kconfigs;
@@ -146,6 +148,15 @@ sub read_kconfig {
 	    $state = "NEW";
 	    $config = $1;
 
+	    for (my $i = 0; $i < $iflevel; $i++) {
+		if ($i) {
+		    $depends{$config} .= " " . $ifdeps[$i];
+		} else {
+		    $depends{$config} = $ifdeps[$i];
+		}
+		$state = "DEP";
+	    }
+
 	# collect the depends for the config
 	} elsif ($state eq "NEW" && /^\s*depends\s+on\s+(.*)$/) {
 	    $state = "DEP";
@@ -166,6 +177,21 @@ sub read_kconfig {
 	    # note if the config has a prompt
 	    $prompt{$config} = 1;
 
+	# Check for if statements
+	} elsif (/^if\s+(.*\S)\s*$/) {
+	    my $deps = $1;
+	    # remove beginning and ending non text
+	    $deps =~ s/^[^a-zA-Z0-9_]*//;
+	    $deps =~ s/[^a-zA-Z0-9_]*$//;
+
+	    my @deps = split /[^a-zA-Z0-9_]+/, $deps;
+
+	    $ifdeps[$iflevel++] = join ':', @deps;
+
+	} elsif (/^endif/) {
+
+	    $iflevel-- if ($iflevel);
+
 	# stop on "help"
 	} elsif (/^\s*help\s*$/) {
 	    $state = "NONE";
-- 
1.6.5



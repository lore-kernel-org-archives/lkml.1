Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbYL2MS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbYL2MS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYL2MSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:18:50 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54824 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbYL2MSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:18:50 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: warn about headers using __[us]{8,16,32,64} types w/out linux/types.h
Date: Mon, 29 Dec 2008 07:18:47 -0500
Message-Id: <1230553127-953-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/headers_check.pl |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index bdd9fb6..5036319 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -37,6 +37,7 @@ foreach my $file (@files) {
 		check_include();
 		check_prototypes();
 		check_config();
+		check_sizetypes();
 	}
 	close FH;
 }
@@ -72,3 +73,22 @@ sub check_config
 		printf STDERR "$filename:$lineno: leaks CONFIG_$1 to userspace where it is not valid\n";
 	}
 }
+
+my $linux_types;
+sub check_sizetypes
+{
+	if ($lineno == 1) {
+		$linux_types = 0;
+	} elsif ($linux_types) {
+		return;
+	}
+	if ($line =~ m/^\s*#\s*include\s+<linux\/types.h>/) {
+		$linux_types = 1;
+		return;
+	}
+	if ($line =~ m/__[us](8|16|32|64)\b/) {
+		printf STDERR "$filename:$lineno: found __[us]{8,16,32,64} type w/out #include <linux/types.h>\n";
+		# Warn until headers are all fixed
+		#$ret = 1;
+	}
+}
-- 
1.6.0.6


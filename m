Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZHFMSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZHFMSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZHFMSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:18:53 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:43734 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZHFMSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:18:52 -0400
From: =?utf-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: arjan@infradead.org
Subject: [PATCH] markup_oops: Use modinfo to avoid confusion with underscored module names
Date: Thu,  6 Aug 2009 15:21:55 +0300
Message-Id: <1249561315-2227-1-git-send-email-ozan@pardus.org.tr>
X-Mailer: git-send-email 1.6.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When EIP is at a module having an underscore in its name, the current
code fails to find it because the module filenames has '-' instead of
'_'.

Use modinfo to correctly get the full path to the module.

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
This is just a trivial patch to pinpoint the problem. Usage of modinfo is faster than
searching through the filesystem but may not be desirable as it brings a dependency
to module-init-tools. Replacing underscore occurences by '-' can be another solution.

 scripts/markup_oops.pl |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
index 8977401..bc14f4c 100644
--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -184,10 +184,7 @@ if ($target eq "0") {
 
 # if it's a module, we need to find the .ko file and calculate a load offset
 if ($module ne "") {
-	my $dir = dirname($filename);
-	$dir = $dir . "/";
-	my $mod = $module . ".ko";
-	my $modulefile = `find $dir -name $mod | head -1`;
+	my $modulefile = `modinfo $module | grep 'filename' | gawk '{ print \$2 }'`;
 	chomp($modulefile);
 	$filename = $modulefile;
 	if ($filename eq "") {
-- 
1.6.3.4


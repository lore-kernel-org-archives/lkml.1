Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbZHUVrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbZHUVrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932243AbZHUVqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:46:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59322 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbZHUVqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:46:18 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>, Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 2/7] checkpatch: handle C99 comments correctly (performance issue)
Date: Fri, 21 Aug 2009 22:46:05 +0100
Message-Id: <1250891170-8599-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250891170-8599-1-git-send-email-apw@canonical.com>
References: <1250891170-8599-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@fifo99.com>

This fixes the sanitation process in checkpatch.pl so that it blocks out
the text after a C99 style comment the same way it does with block style
comments. This prevents the text from getting processed as regular code.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index fd64816..aa009a3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -356,6 +356,13 @@ sub sanitise_line {
 			$off++;
 			next;
 		}
+		if ($sanitise_quote eq '' && substr($line, $off, 2) eq '//') {
+			$sanitise_quote = '//';
+
+			substr($res, $off, 2, $sanitise_quote);
+			$off++;
+			next;
+		}
 
 		# A \ in a string means ignore the next character.
 		if (($sanitise_quote eq "'" || $sanitise_quote eq '"') &&
@@ -379,6 +386,8 @@ sub sanitise_line {
 		#print "c<$c> SQ<$sanitise_quote>\n";
 		if ($off != 0 && $sanitise_quote eq '*/' && $c ne "\t") {
 			substr($res, $off, 1, $;);
+		} elsif ($off != 0 && $sanitise_quote eq '//' && $c ne "\t") {
+			substr($res, $off, 1, $;);
 		} elsif ($off != 0 && $sanitise_quote && $c ne "\t") {
 			substr($res, $off, 1, 'X');
 		} else {
@@ -386,6 +395,10 @@ sub sanitise_line {
 		}
 	}
 
+	if ($sanitise_quote eq '//') {
+		$sanitise_quote = '';
+	}
+
 	# The pathname on a #include may be surrounded by '<' and '>'.
 	if ($res =~ /^.\s*\#\s*include\s+\<(.*)\>/) {
 		my $clean = 'X' x length($1);
-- 
1.6.3.3


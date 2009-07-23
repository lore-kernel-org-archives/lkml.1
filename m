Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZGWJwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZGWJwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 05:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZGWJwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 05:52:09 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:54418 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbZGWJwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 05:52:08 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] ftrace: Correctly calculate the first function in the .text section
Date: Thu, 23 Jul 2009 10:51:43 +0100
Message-Id: <1248342703-15758-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug whereby recordmcount.pl didn't stop searching
once it had correctly detected the function at the beginning of the
.text section. To stop it searching, I needed to reset $read_function.
The effect of this bug was that some entries in __mcount_loc section
were created with the negative reloc addends. The last text section
found was used as the base and all mcount calls were at a relative
offset to that, so at final link time the addresses were fixed up to
point to somewhere completely bogus.

This all resulted in ftrace dynamically modifying addresses that weren't
actually mcount callsites.

I also noticed another bug and fixed up the condition from,

	if (!defined($ref_func) || !defined($weak{$text})) {
to
	if (!defined($ref_func) && !defined($weak{$text})) {

This now matches the comment above the conditional.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 scripts/recordmcount.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7109e2b..356ff6a 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -414,8 +414,9 @@ while (<IN>) {
 	    $read_function = 0;
 	} else {
 	    # if we already have a function, and this is weak, skip it
-	    if (!defined($ref_func) || !defined($weak{$text})) {
+	    if (!defined($ref_func) && !defined($weak{$text})) {
 		$ref_func = $text;
+		$read_function = 0;
 	    }
 	}
     } elsif ($read_headers && /$mcount_section/) {
-- 
1.6.4.rc0


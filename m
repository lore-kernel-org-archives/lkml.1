Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZGWQQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZGWQQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZGWQQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:16:41 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:54175 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbZGWQQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:16:41 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ftrace: Only update $offset when we update $ref_func
Date: Thu, 23 Jul 2009 17:16:15 +0100
Message-Id: <1248365775-25196-2-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
In-Reply-To: <1248365775-25196-1-git-send-email-matt@console-pimps.org>
References: <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com>
 <1248365775-25196-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of $offset should be the offset of $ref_func from the
beginning of the object file. Therefore, we should set both variables
together.

This fixes a bug I was hitting on sh where $offset (which is used to
calcualte the addends for the __mcount_loc entries) was being set
multiple times and didn't correspond to $ref_func's offset in the object
file. The addends in __mcount_loc were calculated incorrectly, resulting
in ftrace dynamically modifying addresses that weren't mcount call
sites.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 scripts/recordmcount.pl |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 16c5563..d29baa2 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -403,7 +403,6 @@ while (<IN>) {
     # section found, now is this a start of a function?
     } elsif ($read_function && /$function_regex/) {
 	$text_found = 1;
-	$offset = hex $1;
 	$text = $2;
 
 	# if this is either a local function or a weak function
@@ -412,10 +411,12 @@ while (<IN>) {
 	if (!defined($locals{$text}) && !defined($weak{$text})) {
 	    $ref_func = $text;
 	    $read_function = 0;
+	    $offset = hex $1;
 	} else {
 	    # if we already have a function, and this is weak, skip it
 	    if (!defined($ref_func) && !defined($weak{$text})) {
 		$ref_func = $text;
+		$offset = hex $1;
 	    }
 	}
     } elsif ($read_headers && /$mcount_section/) {
-- 
1.6.4.rc0


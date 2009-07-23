Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbZGWVCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbZGWVCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbZGWVCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:02:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZGWVCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:02:22 -0400
Message-Id: <20090723210220.880275669@goodmis.org>
References: <20090723210047.294710482@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 17:00:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Matt Fleming <matt@console-pimps.org>
Subject: [PATCH 4/4] ftrace: Only update $offset when we update $ref_func
Content-Disposition: inline; filename=0004-ftrace-Only-update-offset-when-we-update-ref_func.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt@console-pimps.org>

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
LKML-Reference: <1248365775-25196-2-git-send-email-matt@console-pimps.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.6.3.3

-- 

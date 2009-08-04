Return-Path: <linux-kernel-owner+w=401wt.eu-S932687AbZHDILG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbZHDILG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbZHDILE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:11:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:36984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932586AbZHDILB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:11:01 -0400
Date: Tue, 4 Aug 2009 08:10:39 GMT
From: tip-bot for Matt Fleming <matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, matt@console-pimps.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, matt@console-pimps.org, tglx@linutronix.de
In-Reply-To: <1248365775-25196-2-git-send-email-matt@console-pimps.org>
References: <1248365775-25196-2-git-send-email-matt@console-pimps.org>
Subject: [tip:tracing/urgent] ftrace: Only update $offset when we update $ref_func
Message-ID: <tip-bd171d5ffc5cb2ba471e8205c679ee9d12b90116@git.kernel.org>
Git-Commit-ID: bd171d5ffc5cb2ba471e8205c679ee9d12b90116
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 08:10:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd171d5ffc5cb2ba471e8205c679ee9d12b90116
Gitweb:     http://git.kernel.org/tip/bd171d5ffc5cb2ba471e8205c679ee9d12b90116
Author:     Matt Fleming <matt@console-pimps.org>
AuthorDate: Thu, 23 Jul 2009 17:16:15 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Jul 2009 12:20:30 -0400

ftrace: Only update $offset when we update $ref_func

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

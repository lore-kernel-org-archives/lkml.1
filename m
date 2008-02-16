Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYBPRpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYBPRpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757692AbYBPRou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:44:50 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:37981 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223AbYBPRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:44:48 -0500
Date: Sat, 16 Feb 2008 09:43:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, richard@rsk.demon.co.uk
Subject: [PATCH] kernel-doc: fix function-pointer-parameter parsing
Message-Id: <20080216094355.8d38e6e8.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Kennedy <richard@rsk.demon.co.uk>

When running "make htmldocs" I'm seeing some non-fatal perl errors
caused by trying to parse the callback function definitions in
blk-core.c.

The errors are "Use of uninitialized value in concatenation (.)..."
in combination with:
Warning(linux-2.6.25-rc2/block/blk-core.c:1877): No description found for parameter ''

The function pointers are defined without a * i.e. 
int (drv_callback)(struct request *)

The compiler is happy with them, but kernel-doc isn't. 

This patch teaches create_parameterlist in kernel-doc to parse this type
of function pointer definition, but is it the right way to fix the
problem ? The problem only seems to occur in blk-core.c.

However with the patch applied, kernel-doc finds the correct parameter
description for the callback in blk_end_request_callback, which is
doesn't normally.

I thought it would be a bit odd to change to code to use the more normal
form of function pointers just to get the documentation to work, so I
fixed kernel-doc instead - even though this is teaching it to understand
code that might go away (The comment for blk_end_request_callback says
that it should not be used and will removed at some point). 

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.25-rc1-git4.orig/scripts/kernel-doc
+++ linux-2.6.25-rc1-git4/scripts/kernel-doc
@@ -1512,13 +1512,13 @@ sub create_parameterlist($$$) {
 	    # corresponding data structures "correctly". Catch it later in
 	    # output_* subs.
 	    push_parameter($arg, "", $file);
-	} elsif ($arg =~ m/\(.*\*/) {
+	} elsif ($arg =~ m/\(.+\)\s*\(/) {
 	    # pointer-to-function
 	    $arg =~ tr/#/,/;
-	    $arg =~ m/[^\(]+\(\*\s*([^\)]+)\)/;
+	    $arg =~ m/[^\(]+\(\*?\s*(\w*)\s*\)/;
 	    $param = $1;
 	    $type = $arg;
-	    $type =~ s/([^\(]+\(\*)$param/$1/;
+	    $type =~ s/([^\(]+\(\*?)\s*$param/$1/;
 	    push_parameter($param, $type, $file);
 	} elsif ($arg) {
 	    $arg =~ s/\s*:\s*/:/g;

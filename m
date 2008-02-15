Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbYBOR0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbYBOR0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYBORZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:25:38 -0500
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:2931 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756978AbYBORZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:25:37 -0500
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2008 12:25:36 EST
Subject: kernel-doc : possible fix for non-fatal perl errors when parsing
	some function pointers
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: rdunlap@xenotime.net
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 17:13:12 +0000
Message-Id: <1203095592.2929.54.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running "make htmldocs" I'm seeing some non-fatal perl errors
caused by trying to parse the callback function definitions in
blk-core.c.

The errors are "Use of uninitialized value in concatenation (.)..."

The function pointers are defined without a * i.e. 
int (drv_callback)(struct request *)

The compiler is happy with them, but kernel-doc isn't. 

This patch teaches create_parameterlist in kernel-doc to parse this type
of function pointer definition, but is it the right way to fix the
problem ? The problem only seems to occur in blk-core.c.

However with the patch applied, kernel-doc finds the correct parameter
description for the callback in blk_end_request_callback, which is
doesn't normally.
(the patch is against v2.6.25-rc1)

I thought it would be a bit odd to change to code to use the more normal
form of function pointers just to get the documentation to work, so I
fixed kernel-doc instead - even though this is teaching it to understand
code that might go away (The comment for blk_end_request_callback says
that it should not be used and will removed at some point). 

Any ideas on which is the best way to fix this?
 
Thanks
Richard






diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 26146cb..68b2e4e 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
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
+	    $type =~ s/([^\(]+\(\*?)$param/$1/;
 	    push_parameter($param, $type, $file);
 	} elsif ($arg) {
 	    $arg =~ s/\s*:\s*/:/g;
--  


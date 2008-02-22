Return-Path: <linux-kernel-owner+w=401wt.eu-S933363AbYBVN00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363AbYBVN00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758419AbYBVN0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:26:17 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:59670 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbYBVN0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:26:16 -0500
Date: Fri, 22 Feb 2008 14:26:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [RFC/PATCH] Update coding standard to avoid ungrepable printk format strings
Message-ID: <20080222132612.GA11717@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 22 Feb 2008 13:19:48.0439 (UTC) FILETIME=[99486E70:01C87555]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC: Update coding standard to avoid split up printk format strings

Common occurrence: You see some error message in the kernel log you don't
understand, Standard way to handle this is to grep the kernel source code 
for that error message and then look at the code and figure out what
is wrong from that.

Unfortunately that is often far more difficult than needed because 
with the strict 80 character limit printk format strings are often split up
over multiple lines. One example for this would be

	  printk(KERN_CRIT "protocol %04x is "
                          "buggy, dev %s\n",
                          skb2->protocol, dev->name);

from net/core/dev.c. If you see this obscure message what would you grep
for? "protocol.*is buggy" will not find it and "is buggy" neither and "buggy"
or "protocol" gives you a zillion of hits that you have review all
by hand. All quite unsatisfactory.

Worse the coding standard actually recommends to split up printks like
this, but I think it is one of the most counter0productive suggestions it
has.

There are two reasonable ways to handle this. Either put the format 
string on an own line with backwards indentation or ignore the column 80
limitation. I think both are better actually than having ungreppable
error messages.

This patch updates the coding standard for to allow this.

Of course it only applies to the printk format string, any other 
printk arguments should be still split up over multiple lines as before.
That is fine because they rarely need to be grepped for.

I expect this proposal will likely be somewhat controversal and I don't expect
universal agreement (and it's likely a bike shed paint topic like
all coding standard issues); but let's see what happens.

I think it would be a valuable improvement of the coding standard.

At some point checkpatch.pl would need to be updated to know about this
exception too, that would be the next step.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/Documentation/CodingStyle
===================================================================
--- linux.orig/Documentation/CodingStyle
+++ linux/Documentation/CodingStyle
@@ -83,20 +83,32 @@ preferred limit.
 Statements longer than 80 columns will be broken into sensible chunks.
 Descendants are always substantially shorter than the parent and are placed
 substantially to the right. The same applies to function headers with a long
-argument list. Long strings are as well broken into shorter strings. The
-only exception to this is where exceeding 80 columns significantly increases
-readability and does not hide information.
+argument list.
 
-void fun(int a, int b, int c)
-{
-	if (condition)
-		printk(KERN_WARNING "Warning this is a long printk with "
-						"3 parameters a: %u b: %u "
-						"c: %u \n", a, b, c);
-	else
-		next_statement;
+It is not recommended to break printk format strings into smaller strings.
+The problem with doing this is that it makes it much harder to grep
+for the error messages in the source if they are split up over multiple
+lines. And grepping for error messages is fairly important for debugging.
+So for the special case of printk format strings (or formatting any other
+user visible error message) the normal 80 character column rule
+does not apply. Or alternatively it is ok to violate the indentation
+rule for the format string only if that makes the end not exceed
+80 characters. For example
+
+void function(void)
+{
+	if (...) {
+		if (...) {
+			printk(
+ "very very long formatting string with argument %d and argument %d\n",
+				a, b);
+		}
+	}
 }
 
+You should still break up the further printk arguments if they exceed 80
+characters though.
+
 		Chapter 3: Placing Braces and Spaces
 
 The other issue that always comes up in C styling is the placement of

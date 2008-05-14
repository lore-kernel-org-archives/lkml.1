Return-Path: <linux-kernel-owner+w=401wt.eu-S1760534AbYENEt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760534AbYENEt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbYENEtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:49:15 -0400
Received: from mail.queued.net ([207.210.101.209]:4791 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbYENEtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:49:14 -0400
Date: Wed, 14 May 2008 00:53:25 -0400
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, mingo@elte.hu, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: [PATCH] checkpatch: update the 80-char-line check to allow for long
 strings
Message-ID: <20080514005325.765178fc@ephemeral>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19:29 * dilinger sends his patch to lkml for a proper flaming
19:32  Quozl> dilinger: it's called "patch hardening"?  ;-}  the heat
              of the flames makes the patch stronger.

I've wasted too much time massaging printk strings in order to satisfy
checkpatch.pl.  Comments on this?





From: Andres Salomon <dilinger@debian.org>


Checkpatch.pl is pretty strict in its lines-must-be-less-than-80-chars
check.  I consider this a good thing in most scenarios; however,
when it comes to strings, I don't consider the following to be readable:

       printk(KERN_WARNING
                       "one two three "
                       "fooooooooooooooooooooooooooooooooooooooooooooooo\n");

CodingStyle backs me up on this (if I'm interpreting that section clearly).
Ingo[0] has also pointed out why this might be a bad thing as well.

This patch is an attempt to make checkpatch.pl more useful.  Folks ignore
long string warnings[1], which is bad form; we don't _want_ people getting
used to ignoring checkpatch.pl warnings any more than we want people
getting used to ignoring compiler warnings.

The patch updates checkpatch.pl to ignore lines that are > 80 chars
if they contain only (quoted) strings and perhaps some additional stuff
at the end.  For example, the following no longer has warnings emitted:

+ printk(KERN_WARNING
+                       "one two three fooooooooooooooooooooooooooooooooooooooooooooooo\n");

+       printk(KERN_WARNING
+                       "one two three fooooooooooooooooooooooooooooooooooooooooo\n",
+                       xyz);

However, the following still triggers checkpatch.pl warnings:

+ printk(KERN_WARNING "one two three fooooooooooooooooooooooooooooooooooooooooooooooo\n");

+       printk(KERN_WARNING
+                       "one two three foooooooooooooooooooooooooooooooooooooo\n", xyz);

I'm sure it's possible to fool the check, but we're not trying to guard
against malicious patch authors.

[0] http://thread.gmane.org/gmane.linux.kernel/679732/focus=679760
[1] http://lists.laptop.org/pipermail/devel/2008-May/014121.html

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b6bbbcd..00f3d05 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1117,7 +1117,7 @@ sub process {
 			ERROR("trailing whitespace\n" . $herevet);
 		}
 #80 column limit
-		if ($line =~ /^\+/ && !($prevrawline=~/\/\*\*/) && $length > 80) {
+		if ($line =~ /^\+/ && !($prevrawline=~/\/\*\*/) && !($line =~ /^\+\s*"/ && $line =~ /"[);,\s]*$/) && $length > 80) {
 			WARN("line over 80 characters\n" . $herecurr);
 		}
 
-- 
1.5.5.1


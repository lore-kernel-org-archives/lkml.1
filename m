Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYJCPux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYJCPux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYJCPum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:50:42 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:58059 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbYJCPum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:50:42 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 10/13] checkpatch: trailing statements ensure we report the end of the line
Date: Fri,  3 Oct 2008 16:25:51 +0100
Message-Id: <1223047554-31111-11-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reporting some complex trailing statements we report only the
starting line of the error, that tends to imply the shown line is in
error and confuse the reader.  As we do know where the actual error is
report that line too with an appropriate gap marker where applicable.

    #ERROR: trailing statements should be on next line
    #1: FILE: Z202.c:1:
    +       for (pbh = page_buffers(bh->b_page); pbh != bh;
    +               pbh = pbh->b_this_page, key++);
    #ERROR: trailing statements should be on next line
    #4: FILE: Z202.c:4:
    +       for (pbh = page_buffers(bh->b_page);
    [...]
    +               pbh = pbh->b_this_page, key++);

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a675f06..2c1afba 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2001,7 +2001,16 @@ sub process {
 			if (length($c) && $s !~ /^\s*{?\s*\\*\s*$/ &&
 			    $c !~ /}\s*while\s*/)
 			{
-				ERROR("trailing statements should be on next line\n" . $herecurr);
+				# Find out how long the conditional actually is.
+				my @newlines = ($c =~ /\n/gs);
+				my $cond_lines = 1 + $#newlines;
+
+				my $stat_real = raw_line($linenr, $cond_lines);
+				if (defined($stat_real) && $cond_lines > 1) {
+					$stat_real = "[...]\n$stat_real";
+				}
+
+				ERROR("trailing statements should be on next line\n" . $herecurr . $stat_real);
 			}
 		}
 
-- 
1.6.0.1.451.gc8d31


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZJZF1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZJZF1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZJZF1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:27:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49796 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbZJZF1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:27:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AE53304.1060803@jp.fujitsu.com>
Date: Mon, 26 Oct 2009 14:26:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] checkpatch: trivial fix for trailing statements check
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if the statement and the conditional are in one line, the line
appears in the report doubly.

And items of this check have no blank line before the next item.

This patch fixes these trivial problems, to improve readability of the
report.

[sample.c]
  > if (cond1
  >        && cond2
  >        && cond3) func_foo();
  >
  > if (cond4) func_bar();

Before:
  > ERROR: trailing statements should be on next line
  > #1: FILE: sample.c:1:
  > +if (cond1
  > [...]
  > +       && cond3) func_foo();
  > ERROR: trailing statements should be on next line
  > #5: FILE: sample.c:5:
  > +if (cond4) func_bar();
  > +if (cond4) func_bar();
  > total: 2 errors, 0 warnings, 5 lines checked

After:
  > ERROR: trailing statements should be on next line
  > #1: FILE: sample.c:1:
  > +if (cond1
  > [...]
  > +       && cond3) func_foo();
  >
  > ERROR: trailing statements should be on next line
  > #5: FILE: sample.c:5:
  > +if (cond4) func_bar();
  >
  > total: 2 errors, 0 warnings, 5 lines checked

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/checkpatch.pl |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 87bbb8b..60a8f99 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2144,8 +2144,10 @@ sub process {
 				# Find out how long the conditional actually is.
 				my @newlines = ($c =~ /\n/gs);
 				my $cond_lines = 1 + $#newlines;
+				my $stat_real = '';
 
-				my $stat_real = raw_line($linenr, $cond_lines);
+				$stat_real = raw_line($linenr, $cond_lines)
+							. "\n" if ($cond_lines);
 				if (defined($stat_real) && $cond_lines > 1) {
 					$stat_real = "[...]\n$stat_real";
 				}
-- 
1.6.4.4



Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZIVCPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZIVCPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZIVCPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:15:14 -0400
Received: from fifo99.com ([67.223.236.141]:40488 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbZIVCOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:14:49 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 4/5] checkpatch: fix __attribute__ matching
Date: Mon, 21 Sep 2009 19:14:50 -0700
Message-Id: <1253585691-10987-4-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following code,

union thread_union init_thread_union
	__attribute__((__section__(".data.init_task"))) =
		{ INIT_THREAD_INFO(init_task) };

There is a non-conforming declaration. It should really be like the
following,

union thread_union init_thread_union
	__attribute__((__section__(".data.init_task"))) = {
		INIT_THREAD_INFO(init_task)
};

However, checkpatch doesn't catch this right now because it doesn't
correctly evaluate the "__attribute__". I just fixed it to pattern
match the attribute in the case above.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c7f741f..fd4fe03 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -134,7 +134,7 @@ our $Attribute	= qr{
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
-			__weak
+			__weak|(?:__attribute__\(.*\))
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline};
@@ -1628,7 +1628,7 @@ sub process {
 		}
 
 # check for initialisation to aggregates open brace on the next line
-		if ($prevline =~ /$Declare\s*$Ident\s*=\s*$/ &&
+		if (($prevline =~ /$Declare\s*$Ident\s*=\s*$/ || $prevline =~ /$Attribute\s*=\s*$/) &&
 		    $line =~ /^.\s*{/) {
 			ERROR("that open brace { should be on the previous line\n" . $hereprev);
 		}
-- 
1.5.6.3


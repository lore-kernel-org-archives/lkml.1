Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbZIVCOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbZIVCOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZIVCOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:14:48 -0400
Received: from fifo99.com ([67.223.236.141]:40481 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZIVCOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:14:48 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 2/5] checkpatch: fix hang in relative indent checking
Date: Mon, 21 Sep 2009 19:14:48 -0700
Message-Id: <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran this command on v2.6.31 ,

./scripts/checkpatch.pl --file net/decnet/dn_fib.c

which resulted in checkpatch hanging without any output.

The lines that cause the hang are,

#define for_nexthops(fi) { int nhsel; const struct dn_fib_nh *nh;\
        for(nhsel = 0, nh = (fi)->fib_nh; nhsel < (fi)->fib_nhs; nh++, nhsel++)

The hang happend in the relative indent checking code. Checkpatch has the
following comment around the relative indent checking block,

# Also ignore a loop construct at the end of a
# preprocessor statement.

Since the line it's hanging on exactly fits the comment it shouldn't even be
checking this line. To resolve this I just prevent the checking like the
comment says should happen.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 09bab22..1c48a6c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1519,7 +1519,7 @@ sub process {
 
 			my $cond_ptr = -1;
 			$continuation = 0;
-			while ($cond_ptr != $cond_lines) {
+			while ($check && $cond_ptr != $cond_lines) {
 				$cond_ptr = $cond_lines;
 
 				# If we see an #else/#elif then the code
-- 
1.5.6.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752456AbZIVCPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbZIVCPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 22:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZIVCOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 22:14:49 -0400
Received: from fifo99.com ([67.223.236.141]:40482 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZIVCOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 22:14:48 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 1/5] checkpatch: fix false errors due to macro concatenation
Date: Mon, 21 Sep 2009 19:14:47 -0700
Message-Id: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro concatenation (##) sequence can cause false errors when checking
macro's. Checkpatch doesn't currently know about the operator.

For example this line,

+ 	entry = (struct ftrace_raw_##call *)raw_data;                   \

is correct but it produces the following error,

ERROR: need consistent spacing around '*' (ctx:WxB)
+       entry = (struct ftrace_raw_##call *)raw_data;\
                                          ^

The line above doesn't have any spacing problems, and if you remove the
macro concatenation sequence checkpatch doesn't give any errors. This change
resolves this by just always removing "##" in every line checked.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2d5ece7..09bab22 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -397,6 +397,11 @@ sub sanitise_line {
 		$res =~ s@(\#\s*(?:error|warning)\s+).*@$1$clean@;
 	}
 
+	# The macro concatenation sequence is unique so we can just delete it.
+	# If it's not deleted it screws up the rest of the matching and can
+	# result in false errors.
+	$res =~ s/($Ident|\s)\s*\#\#\s*($Ident|\s)/$1$2/g;
+
 	return $res;
 }
 
-- 
1.5.6.3


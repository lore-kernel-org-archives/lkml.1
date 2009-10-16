Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZJPSlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZJPSlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZJPSkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:40:05 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53075 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbZJPSkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:40:03 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 5/7] checkpatch: fix __attribute__ matching
Date: Fri, 16 Oct 2009 19:39:30 +0100
Message-Id: <1255718372-22805-6-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255718372-22805-1-git-send-email-apw@canonical.com>
References: <1255718372-22805-1-git-send-email-apw@canonical.com>
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
correctly evaluate the "__attribute__".

It is not at all clear that we care what preceeds an assignment style
attribute when we find the open brace.  Relax the test so we do not need
to check the __attribute__.

Reported-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index cb2dac3..ba105a8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1669,8 +1669,8 @@ sub process {
 		}
 
 # check for initialisation to aggregates open brace on the next line
-		if ($prevline =~ /$Declare\s*$Ident\s*=\s*$/ &&
-		    $line =~ /^.\s*{/) {
+		if ($line =~ /^.\s*{/ &&
+		    $prevline =~ /(?:^|[^=])=\s*$/) {
 			ERROR("that open brace { should be on the previous line\n" . $hereprev);
 		}
 
-- 
1.6.3.3


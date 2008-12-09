Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYLIRzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYLIRzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 12:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbYLIRyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 12:54:33 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:33299 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbYLIRyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 12:54:31 -0500
From: Yuri Tikhonov <yur@emcraft.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fork_init: fix division by zero
Date: Tue, 9 Dec 2008 20:44:40 +0300
User-Agent: KMail/1.9.4
Cc: linuxppc-dev@ozlabs.org, Milton Miller <miltonm@bga.com>,
       Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>,
       Ilya Yanok <yanok@emcraft.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812092044.40649.yur@emcraft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch fixes divide-by-zero error for the
cases of really big PAGE_SIZEs (e.g. 256KB on ppc44x).
Support for such big page sizes on 44x is not present in the
current kernel yet, but coming soon.

Also this patch fixes the comment for the max_threads
settings, as this didn't match the things actually done
in the code.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
---
 kernel/fork.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 2a372a0..b0ac2fb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -181,10 +181,14 @@ void __init fork_init(unsigned long mempages)
 
 	/*
 	 * The default maximum number of threads is set to a safe
-	 * value: the thread structures can take up at most half
-	 * of memory.
+	 * value: the thread structures can take up at most
+	 * (1/8) part of memory.
 	 */
+#if (8 * THREAD_SIZE) > PAGE_SIZE
 	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
+#else
+	max_threads = mempages * PAGE_SIZE / (8 * THREAD_SIZE);
+#endif
 
 	/*
 	 * we need to allow at least 20 threads to boot a system
-- 
1.5.6.1

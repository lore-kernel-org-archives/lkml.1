Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYLJRAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYLJRAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYLJRAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:00:46 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:40305 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYLJRAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:00:45 -0500
From: Yuri Tikhonov <yur@emcraft.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][v2] fork_init: fix division by zero
Date: Wed, 10 Dec 2008 19:50:51 +0300
User-Agent: KMail/1.9.4
Cc: linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
       Milton Miller <miltonm@bga.com>, Wolfgang Denk <wd@denx.de>,
       Detlev Zundel <dzu@denx.de>, Ilya Yanok <yanok@emcraft.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812101950.51958.yur@emcraft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch fixes divide-by-zero error for the
cases of really big PAGE_SIZEs (e.g. 256KB on ppc44x).
Support for big page sizes on 44x is not present in the
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
index 8d6a7dd..638eb7f 100644
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
+	max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));
+#endif
 
 	/*
 	 * we need to allow at least 20 threads to boot a system
-- 
1.5.6.1

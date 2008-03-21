Return-Path: <linux-kernel-owner+w=401wt.eu-S1764993AbYCUXDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764993AbYCUXDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763101AbYCUWvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:51:07 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59361 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763788AbYCUWvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:51:01 -0400
Message-Id: <20080321224359.602382887@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Riku Voipio <riku.voipio@movial.fi>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 32/76] futex: fix init order
Content-Disposition: inline; filename=futex-fix-init-order.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

When the futex init code fails to initialize the futex pseudo file system it
returns early without initializing the hash queues.  Should the boot succeed
then a futex syscall which tries to enqueue a waiter on the hashqueue will
crash due to the unitilialized plist heads.

Initialize the hash queues before the filesystem.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Riku Voipio <riku.voipio@movial.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/futex.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2123,8 +2123,14 @@ static struct file_system_type futex_fs_
 
 static int __init init(void)
 {
-	int i = register_filesystem(&futex_fs_type);
+	int i;
 
+	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
+		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
+		spin_lock_init(&futex_queues[i].lock);
+	}
+
+	i = register_filesystem(&futex_fs_type);
 	if (i)
 		return i;
 
@@ -2134,10 +2140,6 @@ static int __init init(void)
 		return PTR_ERR(futex_mnt);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
-		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
-		spin_lock_init(&futex_queues[i].lock);
-	}
 	return 0;
 }
 __initcall(init);

-- 

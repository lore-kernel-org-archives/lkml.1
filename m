Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbYBOBYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbYBOBYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758308AbYBOBX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:23:59 -0500
Received: from www.tglx.de ([62.245.132.106]:34161 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbYBOBX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:23:58 -0500
Date: Fri, 15 Feb 2008 02:23:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: adrian.bunk@movial.fi, mingo@elte.hu, linux-kernel@vger.kernel.org,
       riku.voipio@movial.fi, mikpe@it.uu.se, buytenh@wantstofly.org,
       rusty@rustcorp.com.au, stable@kernel.org
Subject: [PATCH 1/2] futex: fix init order
In-Reply-To: <alpine.LFD.1.00.0802150216350.12988@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.00.0802150219370.12988@apollo.tec.linutronix.de>
References: <20080211130700.GF27537@movial.fi> <alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de> <20080214134642.600282f1.akpm@linux-foundation.org> <alpine.LFD.1.00.0802150216350.12988@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the futex init code fails to initialize the futex pseudo file
system it returns early without initializing the hash queues. Should
the boot succeed then a futex syscall which tries to enqueue a waiter
on the hashqueue will crash due to the unitilialized plist heads.

Initialize the hash queues before the filesystem.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 kernel/futex.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -2145,8 +2145,14 @@ static struct file_system_type futex_fs_
 
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
 
@@ -2156,10 +2162,6 @@ static int __init init(void)
 		return PTR_ERR(futex_mnt);
 	}
 
-	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
-		plist_head_init(&futex_queues[i].chain, &futex_queues[i].lock);
-		spin_lock_init(&futex_queues[i].lock);
-	}
 	return 0;
 }
 __initcall(init);

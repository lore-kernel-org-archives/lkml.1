Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZK0Cbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZK0Cbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 21:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZK0Cbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 21:31:45 -0500
Received: from ozlabs.org ([203.10.76.45]:57776 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbZK0Cbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 21:31:45 -0500
Date: Fri, 27 Nov 2009 13:28:20 +1100
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, msb@google.com, fweisbec@gmail.com
Subject: PATCH: softlockup: Fix hung_task_check_count sysctl
Message-ID: <20091127022820.GU32182@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm seeing spikes of up to 0.5ms in khungtaskd on a large machine. To reduce
this source of jitter I tried setting hung_task_check_count to 0:

# echo 0 > /proc/sys/kernel/hung_task_check_count

which didn't have the intended response. Change to a post increment of
max_count, so a value of 0 means check 0 tasks.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/kernel/hung_task.c
===================================================================
--- linux.trees.git.orig/kernel/hung_task.c	2009-11-27 13:11:46.000000000 +1100
+++ linux.trees.git/kernel/hung_task.c	2009-11-27 13:11:57.000000000 +1100
@@ -144,7 +144,7 @@ static void check_hung_uninterruptible_t
 
 	rcu_read_lock();
 	do_each_thread(g, t) {
-		if (!--max_count)
+		if (!max_count--)
 			goto unlock;
 		if (!--batch_count) {
 			batch_count = HUNG_TASK_BATCHING;

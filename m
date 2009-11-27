Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZK0FtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZK0FtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZK0FtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:49:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:57836 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbZK0FtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:49:16 -0500
Date: Fri, 27 Nov 2009 05:48:47 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091127022820.GU32182@kryten>
References: <20091127022820.GU32182@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/softlockup] softlockup: Fix hung_task_check_count sysctl
Message-ID: <tip-e5af02261668350b43eb7381648930bde8e872f7@git.kernel.org>
Git-Commit-ID: e5af02261668350b43eb7381648930bde8e872f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5af02261668350b43eb7381648930bde8e872f7
Gitweb:     http://git.kernel.org/tip/e5af02261668350b43eb7381648930bde8e872f7
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Fri, 27 Nov 2009 13:28:20 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Nov 2009 06:21:57 +0100

softlockup: Fix hung_task_check_count sysctl

I'm seeing spikes of up to 0.5ms in khungtaskd on a large
machine. To reduce this source of jitter I tried setting
hung_task_check_count to 0:

 # echo 0 > /proc/sys/kernel/hung_task_check_count

which didn't have the intended response. Change to a post
increment of max_count, so a value of 0 means check 0 tasks.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: msb@google.com
LKML-Reference: <20091127022820.GU32182@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hung_task.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index d4e8417..0c642d5 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -144,7 +144,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 
 	rcu_read_lock();
 	do_each_thread(g, t) {
-		if (!--max_count)
+		if (!max_count--)
 			goto unlock;
 		if (!--batch_count) {
 			batch_count = HUNG_TASK_BATCHING;

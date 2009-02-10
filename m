Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZBJQDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZBJQDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 11:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZBJQDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 11:03:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:33190 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbZBJQDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 11:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=cgMCeMvV9c40o4NGsGiDKXqSekApC0SZT8D4uCZZP4WACqmfk6Kb7HPFRrWJgzzWMy
         5eYgQkyNTKvvi/TXA0LzkToYC9+z5xqa8N/a463HHN2FvQ1c/0f7TbuCHohL8RiSdtTs
         s5ZMcqzQIjv2cd9U/jE/5+waOQovJRkUZOZHE=
Message-ID: <4991a557.1ade660a.582e.7835@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Mandeep Singh Baines <msb@google.com>
Cc: linux-kernel@vger.kernel.org, rientjes@google.com, mbligh@google.com,
       thockin@google.com
Date: Tue, 10 Feb 2009 16:52:37 +0100
Subject: [PATCH] softlockup: ensure the task has been switched out once
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we check if a task has been switched out since the last scan, we might
have a race condition on the following scenario:

_ the task is freshly created and scheduled
_ it puts its state to TASK_UNINTERRUPTIBLE and is not yet switched out
_ check_hung_task() scans this task and will report a false positive because
  t->nvcsw + t->nivcsw == t->last_switch_count == 0

Add a check for such cases.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/hung_task.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 0c924de..022a492 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -72,7 +72,13 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
 {
 	unsigned long switch_count = t->nvcsw + t->nivcsw;
 
-	if (t->flags & PF_FROZEN)
+	/*
+	 * Ensure the task is not frozen.
+	 * Also, when a freshly created task is scheduled once, changes
+	 * its state to TASK_UNINTERRUPTIBLE without having ever been
+	 * switched out once, it musn't be checked.
+	 */
+	if (unlikely(t->flags & PF_FROZEN || !switch_count))
 		return;
 
 	if (switch_count != t->last_switch_count) {
-- 
1.6.1



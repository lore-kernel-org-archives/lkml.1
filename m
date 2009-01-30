Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbZA3UvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbZA3UvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbZA3Uuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:50:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:57367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbZA3Uum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:50:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:in-reply-to:x-operating-system:
	user-agent:x-gmailtapped-by:x-gmailtapped;
	b=du14UuQoRcpTDmoycaZEYcqhhVeBv0Sgz81V1dWYUC+kL3+jYAtRaNaX7T6t85AXv
	bbngHByP6ihJjZNgP8m8g==
Date: Fri, 30 Jan 2009 12:46:41 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] softlockup: convert read_lock in hung_task to rcu_read_lock
Message-ID: <20090130204641.GA11068@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129014245.GM22298@google.com>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.28.16.146
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra suggested the use of RCU.

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 kernel/hung_task.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index ba8ccd4..a841db3 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -127,7 +127,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 	if (test_taint(TAINT_DIE) || did_panic)
 		return;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	do_each_thread(g, t) {
 		if (!--max_count)
 			goto unlock;
@@ -136,7 +136,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 			check_hung_task(t, now, timeout);
 	} while_each_thread(g, t);
  unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 }
 
 static void update_poll_jiffies(void)
-- 
1.5.4.5


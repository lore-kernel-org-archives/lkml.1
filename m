Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZBER4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZBER4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759506AbZBER4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:56:21 -0500
Received: from smtp-out.google.com ([216.239.45.13]:26576 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759346AbZBER4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:56:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:in-reply-to:x-operating-system:
	user-agent:x-gmailtapped-by:x-gmailtapped;
	b=X2vdLbQRHF48TNqoY8WIg0nuZ1fuSB04HueNDzKD9krEAJQ4aPbyPm3AsYho3eImz
	x0P+x54eWJcTlLU3JWcMA==
Date: Thu, 5 Feb 2009 09:56:08 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] softlockup: convert read_lock in hung_task to rcu_read_lock
Message-ID: <20090205175608.GA10819@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205143453.GG28443@elte.hu>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.25.146.78
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) wrote:
> 
> I've applied your patch to tip:core/softlockup, thanks Mandeep!
> 

Oops, I put the conversion to rcu_read_lock in a seperate patch. I
understand now the convention is to use a patch series only when the
patches can be applied independently.

---
Since the tasklist is protected by rcu list operations, it is safe
to convert the read_lock()s to rcu_read_lock().

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 kernel/hung_task.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index d32d293..34b678c 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -155,7 +155,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 	if (test_taint(TAINT_DIE) || did_panic)
 		return;
 
-	read_lock(&tasklist_lock);
+	rcu_read_lock();
 	do_each_thread(g, t) {
 		if (!--max_count)
 			goto unlock;
@@ -171,7 +171,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 			check_hung_task(t, now, timeout);
 	} while_each_thread(g, t);
  unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 }
 
 static void update_poll_jiffies(void)
-- 
1.5.4.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYIKDbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYIKDbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYIKDah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:30:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:33109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYIKDah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:30:37 -0400
Date: Wed, 10 Sep 2008 20:29:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu,
       peterz@infradead.org
Subject: [PATCH 2/3] hrtimer: make the nanosleep() syscall use the per
 process slack
Message-ID: <20080910202940.5f8b3019@infradead.org>
In-Reply-To: <20080910202803.42b5f251@infradead.org>
References: <20080910202803.42b5f251@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: make the nanosleep() syscall use the per process slack

This patch makes the nanosleep() system call use the per process
slack value; with this users are able to externally control existing
applications to reduce the wakeup rate.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/hrtimer.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index a022209..9a4c901 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1563,9 +1563,14 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
 	struct restart_block *restart;
 	struct hrtimer_sleeper t;
 	int ret = 0;
+	unsigned long slack;
+
+	slack = current->timer_slack_ns;
+	if (rt_task(current))
+		slack = 0;
 
 	hrtimer_init_on_stack(&t.timer, clockid, mode);
-	hrtimer_set_expires(&t.timer, timespec_to_ktime(*rqtp));
+	hrtimer_set_expires_range_ns(&t.timer, timespec_to_ktime(*rqtp), slack);
 	if (do_nanosleep(&t, mode))
 		goto out;
 
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

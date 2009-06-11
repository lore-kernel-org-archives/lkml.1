Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbZFKMNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbZFKMNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZFKMNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:13:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZFKMNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:13:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] slow_work_thread() should do the exclusive wait
To: torvalds@osdl.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>
Date: Thu, 11 Jun 2009 13:12:55 +0100
Message-ID: <20090611121255.23701.94984.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

slow_work_thread() sleeps on slow_work_thread_wq without WQ_FLAG_EXCLUSIVE,
this means that slow_work_enqueue()->__wake_up(nr_exclusive => 1) wakes up all
kslowd threads.  This is not what we want, so we change slow_work_thread() to
use prepare_to_wait_exclusive() instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/slow-work.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index b28d191..521ed20 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -372,8 +372,8 @@ static int slow_work_thread(void *_data)
 		vsmax *= atomic_read(&slow_work_thread_count);
 		vsmax /= 100;
 
-		prepare_to_wait(&slow_work_thread_wq, &wait,
-				TASK_INTERRUPTIBLE);
+		prepare_to_wait_exclusive(&slow_work_thread_wq, &wait,
+					  TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&
 		    !slow_work_threads_should_exit &&
 		    !slow_work_available(vsmax) &&


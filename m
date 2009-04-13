Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbZDMSWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbZDMSWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZDMSWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:22:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZDMSWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:22:39 -0400
Date: Mon, 13 Apr 2009 20:17:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Cc: Serge Hallyn <serue@us.ibm.com>, Steve Dickson <steved@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] slow_work_thread() should do the exclusive wait
Message-ID: <20090413181733.GA10424@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slow_work_thread() sleeps on slow_work_thread_wq without WQ_FLAG_EXCLUSIVE,
this means that slow_work_enqueue()->__wake_up(nr_exclusive => 1) wakes up
all kslowd threads. Afaics this is not what we want, change slow_work_thread()
to use prepare_to_wait_exclusive().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.30/kernel/slow-work.c~1_SW_EXCLUSIVE	2009-04-06 00:03:42.000000000 +0200
+++ 6.30/kernel/slow-work.c	2009-04-13 19:40:20.000000000 +0200
@@ -372,8 +372,8 @@ static int slow_work_thread(void *_data)
 		vsmax *= atomic_read(&slow_work_thread_count);
 		vsmax /= 100;
 
-		prepare_to_wait(&slow_work_thread_wq, &wait,
-				TASK_INTERRUPTIBLE);
+		prepare_to_wait_exclusive(&slow_work_thread_wq, &wait,
+						TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&
 		    !slow_work_threads_should_exit &&
 		    !slow_work_available(vsmax) &&


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbZDWQCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbZDWQCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZDWQBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:01:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60220 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZDWQBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:01:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090415162712.342d4c07.akpm@linux-foundation.org>
References: <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Trond.Myklebust@netapp.com, serue@us.ibm.com, steved@redhat.com,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_thread() should do the exclusive wait
Date: Thu, 23 Apr 2009 17:00:35 +0100
Message-ID: <20712.1240502435@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> I wonder if slow_work_cull_timeout() should have some sort of barrier,
> so the write is suitably visible to the woken thread.  Bearing in mind
> that the thread might _already_ have been woken by someone else?

Perhaps the attached patch?

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] slow_work_cull_timeout() should have a memory barrier

slow_work_cull_timeout() should have a write memory barrier so that the setting
of the cull flag is seen before the wakeup takes place.  This is required
because wake_up() does not guarantee any memory barriership at all.

Concomitant to this, slow_work_thread() should have a read memory barrier
between its return from schedule() and its testing of slow_work_cull() as
finish_wait() isn't a guaranteed barrier either.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/slow-work.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 521ed20..96e418d 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -382,6 +382,7 @@ static int slow_work_thread(void *_data)
 		finish_wait(&slow_work_thread_wq, &wait);
 
 		try_to_freeze();
+		smp_rmb();
 
 		vsmax = vslow_work_proportion;
 		vsmax *= atomic_read(&slow_work_thread_count);
@@ -416,6 +417,7 @@ static int slow_work_thread(void *_data)
 static void slow_work_cull_timeout(unsigned long data)
 {
 	slow_work_cull = true;
+	smp_wmb();
 	wake_up(&slow_work_thread_wq);
 }
 

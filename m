Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbZJCNrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbZJCNrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932176AbZJCNrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:47:41 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:35853 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbZJCNrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=saN5bLNm33iJA6R2gHuVUH0mWglyOPyZ+gfn4sUML01gYmU87ph8ex8gzMgIXANQb1
         crWITSegnKXESX4CD+uMRKG46UQvA0xXyKfBAvlJLnKbEFox8BfTGXb3XGCJceAxhbFv
         EcseUW4fgNJeM40vem0yZtTiY1mWTN6T2lGGc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] tracing: Use free_percpu instead of kfree
Date: Sat,  3 Oct 2009 15:47:30 +0200
Message-Id: <1254577650-5623-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the event->profile_enable() failure path, we release the per cpu
buffers using kfree which is wrong because they are per cpu pointers.
Although free_percpu only wraps kfree for now, that may change in the
future so lets use the correct way.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_event_profile.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index e52784b..8d5c171 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -53,8 +53,8 @@ static int ftrace_profile_enable_event(struct ftrace_event_call *event)
 
 fail_buf_nmi:
 	if (!total_profile_count) {
-		kfree(trace_profile_buf_nmi);
-		kfree(trace_profile_buf);
+		free_percpu(trace_profile_buf_nmi);
+		free_percpu(trace_profile_buf);
 		trace_profile_buf_nmi = NULL;
 		trace_profile_buf = NULL;
 	}
-- 
1.6.2.3


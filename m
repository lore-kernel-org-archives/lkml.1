Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZCRJTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZCRJTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZCRJTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:19:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:57618 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbZCRJTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:19:05 -0400
Date: Wed, 18 Mar 2009 09:18:28 GMT
From: Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:tracing/tasks] tracing: stop command line recording when tracing is disabled
Message-ID: <tip-18aecd362a1c991fbf5f7919ae051a77532ba2f8@git.kernel.org>
Git-Commit-ID: 18aecd362a1c991fbf5f7919ae051a77532ba2f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 09:18:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18aecd362a1c991fbf5f7919ae051a77532ba2f8
Gitweb:     http://git.kernel.org/tip/18aecd362a1c991fbf5f7919ae051a77532ba2f8
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 18 Mar 2009 08:56:58 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 10:10:16 +0100

tracing: stop command line recording when tracing is disabled

Impact: prevent overwrite of command line entries

When the tracer is stopped the command line recording continues to
record. The check for tracing_is_on() is not sufficient here as the
ringbuffer status is not affected by setting
debug/tracing/tracing_enabled to 0. On a non idle system this can
result in the loss of the command line information for the stopped
trace, which makes the trace harder to read and analyse.

Check tracer_enabled to allow further recording.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1ce6208..7b6043e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -797,7 +797,8 @@ void trace_find_cmdline(int pid, char comm[])
 
 void tracing_record_cmdline(struct task_struct *tsk)
 {
-	if (atomic_read(&trace_record_cmdline_disabled) || !tracing_is_on())
+	if (atomic_read(&trace_record_cmdline_disabled) || !tracer_enabled ||
+	    !tracing_is_on())
 		return;
 
 	trace_save_cmdline(tsk);

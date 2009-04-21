Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZDUOEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZDUOEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZDUOEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:04:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:33363 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZDUOEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:04:08 -0400
Date: Tue, 21 Apr 2009 14:03:29 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090421094616.GA14561@elte.hu>
References: <20090421094616.GA14561@elte.hu>
Subject: [tip:tracing/core] ring-buffer: only warn on wrap if buffer is bigger than two pages
Message-ID: <tip-3554228d4289098a8fe5cfd87512ec32a19bbe5a@git.kernel.org>
Git-Commit-ID: 3554228d4289098a8fe5cfd87512ec32a19bbe5a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 14:03:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3554228d4289098a8fe5cfd87512ec32a19bbe5a
Gitweb:     http://git.kernel.org/tip/3554228d4289098a8fe5cfd87512ec32a19bbe5a
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 21 Apr 2009 09:41:26 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 16:00:45 +0200

ring-buffer: only warn on wrap if buffer is bigger than two pages

On boot up, to save memory, ftrace allocates the minimum buffer
which is two pages. Ftrace also goes through a series of tests
(when configured) on boot up. These tests can fill up a page within
a single interrupt.

The ring buffer also has a WARN_ON when it detects that the buffer was
completely filled within a single commit (other commits are allowed to
be nested).

Combine the small buffer on start up, with the tests that can fill more
than a single page within an interrupt, this can trigger the WARN_ON.

This patch makes the WARN_ON only happen when the ring buffer consists
of more than two pages.

[ Impact: prevent false WARN_ON in ftrace startup tests ]

Reported-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20090421094616.GA14561@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/ring_buffer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 7bcfd3e..61dbdf2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1241,7 +1241,8 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		 * about it.
 		 */
 		if (unlikely(next_page == commit_page)) {
-			WARN_ON_ONCE(1);
+			/* This can easily happen on small ring buffers */
+			WARN_ON_ONCE(buffer->pages > 2);
 			goto out_reset;
 		}
 

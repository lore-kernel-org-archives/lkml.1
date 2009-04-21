Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbZDUNzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbZDUNzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZDUNzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:55:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZDUNzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:55:42 -0400
Date: Tue, 21 Apr 2009 09:55:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][GIT PULL] ring-buffer: only warn on wrap if buffer is bigger
 than two pages
In-Reply-To: <20090421094616.GA14561@elte.hu>
Message-ID: <alpine.DEB.2.00.0904210954090.10097@gandalf.stny.rr.com>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (1):
      ring-buffer: only warn on wrap if buffer is bigger than two pages

----
 kernel/trace/ring_buffer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
---------------------------
commit b76929b6d87e98e49a0988b863debb1a12bcf42b
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Apr 21 09:41:26 2009 -0400

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
 



Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbZBLSmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbZBLSmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 13:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbZBLSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 13:41:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbZBLSlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 13:41:55 -0500
Date: Thu, 12 Feb 2009 13:41:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: [git pull] ring-buffer: rename label out_unlock to out_reset
Message-ID: <alpine.DEB.1.10.0902121334330.15469@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
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
      ring-buffer: rename label out_unlock to out_reset

----
 kernel/trace/ring_buffer.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)
---------------------------
commit 45141d4667d208421ca787a3301542b6a5e0b112
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Feb 12 13:19:48 2009 -0500

    ring-buffer: rename label out_unlock to out_reset
    
    Impact: clean up
    
    While reviewing the ring buffer code, I thougth I saw a bug with
    
    	if (!__raw_spin_trylock(&cpu_buffer->lock))
    		goto out_unlock;
    
    But I forgot that we use a variable "lock_taken" that is set if
    the spinlock is taken, and only unlock it if that variable is set.
    
    To avoid further confusion from other reviewers, this patch
    renames the label out_unlock with out_reset, which is the more
    appropriate name.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index dc18b5b..f39d7e9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1017,7 +1017,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		 */
 		if (unlikely(in_nmi())) {
 			if (!__raw_spin_trylock(&cpu_buffer->lock))
-				goto out_unlock;
+				goto out_reset;
 		} else
 			__raw_spin_lock(&cpu_buffer->lock);
 
@@ -1030,7 +1030,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
 		/* we grabbed the lock before incrementing */
 		if (RB_WARN_ON(cpu_buffer, next_page == reader_page))
-			goto out_unlock;
+			goto out_reset;
 
 		/*
 		 * If for some reason, we had an interrupt storm that made
@@ -1039,12 +1039,12 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 		 */
 		if (unlikely(next_page == commit_page)) {
 			WARN_ON_ONCE(1);
-			goto out_unlock;
+			goto out_reset;
 		}
 
 		if (next_page == head_page) {
 			if (!(buffer->flags & RB_FL_OVERWRITE))
-				goto out_unlock;
+				goto out_reset;
 
 			/* tail_page has not moved yet? */
 			if (tail_page == cpu_buffer->tail_page) {
@@ -1118,7 +1118,7 @@ __rb_reserve_next(struct ring_buffer_per_cpu *cpu_buffer,
 
 	return event;
 
- out_unlock:
+ out_reset:
 	/* reset write */
 	if (tail <= BUF_PAGE_SIZE)
 		local_set(&tail_page->write, tail);

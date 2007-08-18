Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbXHRRhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbXHRRhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbXHRRg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 13:36:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:41977 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbXHRRg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 13:36:58 -0400
Date: Sat, 18 Aug 2007 21:39:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] exec: simplify ->sighand switching
Message-ID: <20070818173947.GA209@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is no any reason to do recalc_sigpending() after changing ->sighand.
To begin with, recalc_sigpending() does not take ->sighand into account.

This means we don't need to take newsighand->siglock while changing sighands.
rcu_assign_pointer() provides a necessary barrier, and if another process
reads the new ->sighand it should either take tasklist_lock or it should use
lock_task_sighand() which has a corresponding smp_read_barrier_depends().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/fs/exec.c~2_SWITCH	2007-08-18 18:19:41.000000000 +0400
+++ t/fs/exec.c	2007-08-18 18:26:48.000000000 +0400
@@ -945,12 +945,7 @@ no_thread_group:
 
 		write_lock_irq(&tasklist_lock);
 		spin_lock(&oldsighand->siglock);
-		spin_lock_nested(&newsighand->siglock, SINGLE_DEPTH_NESTING);
-
 		rcu_assign_pointer(tsk->sighand, newsighand);
-		recalc_sigpending();
-
-		spin_unlock(&newsighand->siglock);
 		spin_unlock(&oldsighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 
@@ -960,12 +955,11 @@ no_thread_group:
 	BUG_ON(!thread_group_leader(tsk));
 	return 0;
 }
-	
+
 /*
  * These functions flushes out all traces of the currently running executable
  * so that a new one can be started
  */
-
 static void flush_old_files(struct files_struct * files)
 {
 	long j = -1;


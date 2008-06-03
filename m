Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbYFCVuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbYFCVuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYFCVuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:50:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYFCVuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:50:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@tv-sign.ru>, ebiederm@xmission.com, mingo@elte.hu,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] coredump: zap_threads() must skip kernel threads
In-Reply-To: Andrew Morton's message of  Tuesday, 3 June 2008 14:15:48 -0700 <20080603141548.15d60a32.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080601153045.GA8244@tv-sign.ru>
	<20080603141548.15d60a32.akpm@linux-foundation.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080603214959.0208826FC96@magilla.localdomain>
Date: Tue,  3 Jun 2008 14:49:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a bugfix, yes?
> 
> How does it get triggered?

Yes, I think it fixes a bug.  The trigger would be an aio request doing
some work (inside aio_kick_handler) simultaneous with some thread in the
requester's mm doing a core dump (inside zap_threads).

> Do you think the bug is sufficiently serious to fix it in 2.6.26?  In
> 2.6.25.x?  If so, it would be better if this patch were not dependent
> upon the preceding ones, which do not appear to be 2.6.26 or -stable
> material.

It has probably never been seen for real, but might be possible to produce
with an exploit that works hard to hit the race.  I'm not sure off hand
what all the bad effects would be, mainly those of SIGKILL'ing the
workqueue thread (keventd I guess).  The core-dumping threads will be stuck
in uninterruptible waits and never be killable.

Oleg's cleanups make the fix much nicer because there is an easy persistent
flag to check without races.  Probably the most isolated fix for this is
something like the bit below (wholly untested).  This is hairy enough that
I think Oleg's 1/3 + 2/3 would be preferable even for -stable.


Thanks,
Roland


diff --git a/fs/exec.c b/fs/exec.c
index 9448f1b..0000000 100644  
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1545,8 +1545,23 @@ static inline int zap_threads(struct tas
 
 		p = g;
 		do {
-			if (p->mm) {
-				if (p->mm == mm) {
+			struct mm_struct *pmm = p->mm;
+			if (pmm) {
+				/*
+				 * We must ignore a kernel thread (aio)
+				 * using PF_BORROWED_MM.  But we need
+				 * task_lock() to avoid races with use_mm()
+				 * or unuse_mm().
+				 */
+				if (pmm == mm) {
+					task_lock(p);
+					if (p->flags & PF_BORROWED_MM)
+						pmm = NULL;
+					else
+						pmm = p->mm;
+					task_unlock(p);
+				}
+				if (pmm == mm) {
 					/*
 					 * p->sighand can't disappear, but
 					 * may be changed by de_thread()

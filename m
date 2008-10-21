Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYJUDIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYJUDIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 23:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYJUDIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 23:08:11 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:64771 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751946AbYJUDIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 23:08:10 -0400
Date: Tue, 21 Oct 2008 12:07:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Frank Mayhar <fmayhar@google.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] binfmt_elf_fdpic: Update for cputime changes.
Message-ID: <20081021030740.GA28346@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Frank Mayhar <fmayhar@google.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f06febc96ba8e0af80bcc3eaec0a109e88275fac "timers: fix itimer/many
thread hang" introduced a new task_cputime interface and subsequently
only converted binfmt_elf over to it. This results in the build for
binfmt_elf_fdpic blowing up given that p->signal->{u,s}time have
disappeared from underneath us.

Apply the same trivial fix from binfmt_elf to binfmt_elf_fdpic.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 fs/binfmt_elf_fdpic.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 0e8367c..5b5424c 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1390,20 +1390,15 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
+		struct task_cputime cputime;
+
 		/*
-		 * This is the record for the group leader.  Add in the
-		 * cumulative times of previous dead threads.  This total
-		 * won't include the time of each live thread whose state
-		 * is included in the core dump.  The final total reported
-		 * to our parent process when it calls wait4 will include
-		 * those sums as well as the little bit more time it takes
-		 * this and each other thread to finish dying after the
-		 * core dump synchronization phase.
+		 * This is the record for the group leader.  It shows the
+		 * group-wide total, not its individual thread total.
 		 */
-		cputime_to_timeval(cputime_add(p->utime, p->signal->utime),
-				   &prstatus->pr_utime);
-		cputime_to_timeval(cputime_add(p->stime, p->signal->stime),
-				   &prstatus->pr_stime);
+		thread_group_cputime(p, &cputime);
+		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
+		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
 		cputime_to_timeval(p->utime, &prstatus->pr_utime);
 		cputime_to_timeval(p->stime, &prstatus->pr_stime);

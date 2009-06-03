Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZFCNHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZFCNHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZFCNHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:07:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:44790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbZFCNHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:07:10 -0400
Date: Wed, 3 Jun 2009 13:06:33 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Add a comm hook for pure fork()s
Message-ID: <tip-226f62fdd53d5b2c74e242aa11f6ad43d0285d3f@git.kernel.org>
Git-Commit-ID: 226f62fdd53d5b2c74e242aa11f6ad43d0285d3f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 13:06:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  226f62fdd53d5b2c74e242aa11f6ad43d0285d3f
Gitweb:     http://git.kernel.org/tip/226f62fdd53d5b2c74e242aa11f6ad43d0285d3f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 3 Jun 2009 11:23:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 14:14:30 +0200

perf_counter: Add a comm hook for pure fork()s

I noticed missing COMM events and found that we missed
reporting them for pure forks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/fork.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 23bf757..b7d7a9f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1412,6 +1412,12 @@ long do_fork(unsigned long clone_flags,
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
+		} else {
+			/*
+			 * vfork will do an exec which will call
+			 * set_task_comm()
+			 */
+			perf_counter_comm(p);
 		}
 
 		audit_finish_fork(p);

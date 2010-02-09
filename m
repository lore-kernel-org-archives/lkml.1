Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0BIKwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 05:52:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:41691 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0BIKwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 05:52:50 -0500
Date: Tue, 9 Feb 2010 10:52:00 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       anton@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100209034304.GA3702@kryten>
References: <20100209034304.GA3702@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix hypervisor sample reporting
Message-ID: <tip-7fbfc683f1cc4051aa095ebe48d9d1e8b015682d@git.kernel.org>
Git-Commit-ID: 7fbfc683f1cc4051aa095ebe48d9d1e8b015682d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Feb 2010 10:52:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fbfc683f1cc4051aa095ebe48d9d1e8b015682d
Gitweb:     http://git.kernel.org/tip/7fbfc683f1cc4051aa095ebe48d9d1e8b015682d
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Tue, 9 Feb 2010 14:43:05 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 9 Feb 2010 10:52:40 +0100

perf: Fix hypervisor sample reporting

cpumode bits are defined as such:

 #define PERF_RECORD_MISC_KERNEL                 (1 << 0)
 #define PERF_RECORD_MISC_USER                   (2 << 0)
 #define PERF_RECORD_MISC_HYPERVISOR             (3 << 0)

We need to compare against the complete value of cpumode,
otherwise hypervisor samples get incorrectly attributed as
userspace.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: fweisbec@gmail.com
LKML-Reference: <20100209034304.GA3702@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index bb0fd6d..8a9e6ba 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -295,10 +295,10 @@ void thread__find_addr_location(struct thread *self,
 	al->thread = self;
 	al->addr = addr;
 
-	if (cpumode & PERF_RECORD_MISC_KERNEL) {
+	if (cpumode == PERF_RECORD_MISC_KERNEL) {
 		al->level = 'k';
 		mg = &session->kmaps;
-	} else if (cpumode & PERF_RECORD_MISC_USER)
+	} else if (cpumode == PERF_RECORD_MISC_USER)
 		al->level = '.';
 	else {
 		al->level = 'H';

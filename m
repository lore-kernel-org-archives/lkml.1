Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbZKWLy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbZKWLy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbZKWLy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:54:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:56102 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068AbZKWLy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:54:28 -0500
Date: Mon, 23 Nov 2009 11:53:42 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Optimize the swcounter hotpath
Message-ID: <tip-a4234bfcf4d72a10a99176cdef007345e9c3b4aa@git.kernel.org>
Git-Commit-ID: a4234bfcf4d72a10a99176cdef007345e9c3b4aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4234bfcf4d72a10a99176cdef007345e9c3b4aa
Gitweb:     http://git.kernel.org/tip/a4234bfcf4d72a10a99176cdef007345e9c3b4aa
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 23 Nov 2009 10:57:59 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 11:48:27 +0100

perf_events: Optimize the swcounter hotpath

The structure init creates a bit memcpy, which shows
up big time in perf annotate output:

          :      ffffffff810a859d <__perf_sw_event>:
     1.68 :      ffffffff810a859d:       55                      push   %rbp
     1.69 :      ffffffff810a859e:       41 89 fa                mov    %edi,%r10d
     0.01 :      ffffffff810a85a1:       49 89 c9                mov    %rcx,%r9
     0.00 :      ffffffff810a85a4:       31 c0                   xor    %eax,%eax
     1.71 :      ffffffff810a85a6:       b9 16 00 00 00          mov    $0x16,%ecx
     0.00 :      ffffffff810a85ab:       48 89 e5                mov    %rsp,%rbp
     0.00 :      ffffffff810a85ae:       48 83 ec 60             sub    $0x60,%rsp
     1.52 :      ffffffff810a85b2:       48 8d 7d a0             lea    -0x60(%rbp),%rdi
    85.20 :      ffffffff810a85b6:       f3 ab                   rep stos %eax,%es:(%rdi)

None of the callees depends on the structure being pre-initialized,
so only initialize ->addr. This gets rid of the memcpy overhead.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index abe1ef4..20df8ab 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3954,12 +3954,12 @@ out:
 void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 			    struct pt_regs *regs, u64 addr)
 {
-	struct perf_sample_data data = {
-		.addr = addr,
-	};
+	struct perf_sample_data data;
 
-	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi,
-				&data, regs);
+	data.addr = addr;
+	data.raw  = NULL;
+
+	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi, &data, regs);
 }
 
 static void perf_swevent_read(struct perf_event *event)

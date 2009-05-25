Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZEYDkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZEYDkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZEYDkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:40:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:60109 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZEYDko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:40:44 -0400
Date: Mon, 25 May 2009 03:39:50 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Increase mmap limit
Message-ID: <tip-a3862d3f814ce7dfca9eed56ac23d29db3aee8d5@git.kernel.org>
Git-Commit-ID: a3862d3f814ce7dfca9eed56ac23d29db3aee8d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 03:39:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3862d3f814ce7dfca9eed56ac23d29db3aee8d5
Gitweb:     http://git.kernel.org/tip/a3862d3f814ce7dfca9eed56ac23d29db3aee8d5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 24 May 2009 09:02:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 24 May 2009 09:02:37 +0200

perf_counter: Increase mmap limit

In a default 'perf top' run the tool will create a counter for
each online CPU. With enough CPUs this will eventually exhaust
the default limit.

So scale it up with the number of online CPUs.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index cb40625..6cdf824 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1704,6 +1704,12 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	user_extra = nr_pages + 1;
 	user_lock_limit = sysctl_perf_counter_mlock >> (PAGE_SHIFT - 10);
+
+	/*
+	 * Increase the limit linearly with more CPUs:
+	 */
+	user_lock_limit *= num_online_cpus();
+
 	user_locked = atomic_long_read(&user->locked_vm) + user_extra;
 
 	extra = 0;

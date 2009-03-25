Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbZCYMJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbZCYMJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760437AbZCYMIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:08:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:57146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760926AbZCYMID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:08:03 -0400
Date: Wed, 25 Mar 2009 12:07:20 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237981712.7972.812.camel@twins>
References: <1237981712.7972.812.camel@twins>
Subject: [tip:perfcounters/core] perf_counter: allow and require one-page mmap on counting counters
Message-ID: <tip-bb0ad4e22511e7caa715362945ad0766c7cca37e@git.kernel.org>
Git-Commit-ID: bb0ad4e22511e7caa715362945ad0766c7cca37e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 12:07:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb0ad4e22511e7caa715362945ad0766c7cca37e
Gitweb:     http://git.kernel.org/tip/bb0ad4e22511e7caa715362945ad0766c7cca37e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Mar 2009 12:48:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 13:02:54 +0100

perf_counter: allow and require one-page mmap on counting counters

A brainfart stopped single page mmap()s working. The rest of the code
should be perfectly fine with not having any data pages.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1237981712.7972.812.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f3e1b27..95e0257 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1369,7 +1369,11 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	vma_size = vma->vm_end - vma->vm_start;
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
-	if (nr_pages == 0 || !is_power_of_2(nr_pages))
+	/*
+	 * If we have data pages ensure they're a power-of-two number, so we
+	 * can do bitmasks instead of modulo.
+	 */
+	if (nr_pages != 0 && !is_power_of_2(nr_pages))
 		return -EINVAL;
 
 	if (vma_size != PAGE_SIZE * (1 + nr_pages))

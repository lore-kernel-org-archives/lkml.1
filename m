Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbZCYMHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbZCYMHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760371AbZCYMHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:07:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:57117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760296AbZCYMH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:07:28 -0400
Date: Wed, 25 Mar 2009 12:06:45 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       arjan@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
Reply-To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       efault@gmx.de, tglx@linutronix.de, fengguang.wu@intel.com,
       mingo@elte.hu
In-Reply-To: <20090325113316.921433024@chello.nl>
References: <20090325113316.921433024@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: sanity check on the output API
Message-ID: <tip-91d876bd14c82826b69bf23f502cb283959ebb1f@git.kernel.org>
Git-Commit-ID: 91d876bd14c82826b69bf23f502cb283959ebb1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 12:06:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91d876bd14c82826b69bf23f502cb283959ebb1f
Gitweb:     http://git.kernel.org/tip/91d876bd14c82826b69bf23f502cb283959ebb1f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Mar 2009 12:30:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 13:02:52 +0100

perf_counter: sanity check on the output API

Ensure we never write more than we said we would.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
LKML-Reference: <20090325113316.921433024@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d76e311..7669afe 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1422,6 +1422,7 @@ struct perf_output_handle {
 	struct perf_counter	*counter;
 	struct perf_mmap_data	*data;
 	unsigned int		offset;
+	unsigned int		head;
 	int			wakeup;
 };
 
@@ -1447,6 +1448,7 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	handle->counter	= counter;
 	handle->data	= data;
 	handle->offset	= offset;
+	handle->head	= head;
 	handle->wakeup	= (offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT);
 
 	return 0;
@@ -1485,6 +1487,8 @@ static void perf_output_copy(struct perf_output_handle *handle,
 	} while (len);
 
 	handle->offset = offset;
+
+	WARN_ON_ONCE(handle->offset > handle->head);
 }
 
 #define perf_output_put(handle, x) \

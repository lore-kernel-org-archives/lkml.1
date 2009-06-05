Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZFEG0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZFEG0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbZFEG0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:26:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:49800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbZFEG0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:26:14 -0400
Date: Fri, 5 Jun 2009 06:24:45 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18984.33964.21541.743096@cargo.ozlabs.ibm.com>
References: <18984.33964.21541.743096@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Fix lockup with interrupting counters
Message-ID: <tip-6dc5f2a41759987e35e757ef00192e7b424563bb@git.kernel.org>
Git-Commit-ID: 6dc5f2a41759987e35e757ef00192e7b424563bb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 06:24:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6dc5f2a41759987e35e757ef00192e7b424563bb
Gitweb:     http://git.kernel.org/tip/6dc5f2a41759987e35e757ef00192e7b424563bb
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Fri, 5 Jun 2009 12:36:28 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 08:22:26 +0200

perf_counter: Fix lockup with interrupting counters

Commit 8e3747c1 ("perf_counter: Change data head from u32 to u64")
changed the type of 'head' in struct perf_mmap_data from atomic_t
to atomic_long_t, but missed converting one use of atomic_read on
it to atomic_long_read.  The effect of using atomic_read rather than
atomic_long_read on powerpc (and other big-endian architectures) is
that we get the high half of the 64-bit quantity, resulting in the
cmpxchg retry loop in perf_output_begin spinning forever as soon as
data->head becomes non-zero.  On little-endian architectures such as
x86 we would get the low half, resulting in a lockup once data->head
becomes greater than 4G.

This fixes it by using atomic_long_read rather than atomic_read.

[ Impact: fix perfcounter lockup on PowerPC / big-endian systems ]

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18984.33964.21541.743096@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 195712e..a5d3e2a 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2234,7 +2234,7 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	perf_output_lock(handle);
 
 	do {
-		offset = head = atomic_read(&data->head);
+		offset = head = atomic_long_read(&data->head);
 		head += size;
 	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
 

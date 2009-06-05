Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZFECgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZFECgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZFECgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:36:31 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:51201 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbZFECgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:36:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18984.33964.21541.743096@cargo.ozlabs.ibm.com>
Date: Fri, 5 Jun 2009 12:36:28 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Fix lockup with interrupting counters
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Paul Mackerras <paulus@samba.org>
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
 
-- 
1.6.0.4


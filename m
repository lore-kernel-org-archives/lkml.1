Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbZDMTpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbZDMTpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbZDMTpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:45:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36038 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZDMTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:45:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=GvjvkEhRV56L3oMw0TrYoc8T94ZhD8z2IJLwsJ/ihHcIhPDciwXb5Ix6zftInJ2VZ
	JXhP61kNSkmgG/w4znsJg==
MIME-Version: 1.0
Date: Mon, 13 Apr 2009 12:44:57 -0700
Message-ID: <604427e00904131244y68fa7e62x85d599f588776eee@mail.gmail.com>
Subject: [V4][PATCH 0/4]page fault retry with NOPAGE_RETRY
From: Ying Han <yinghan@google.com>
To: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page fault retry with NOPAGE_RETRY
Allow major faults to drop the mmap_sem read lock while waiting for
synchronous disk read. This allows another thread which wishes to grab
down_write(mmap_sem) to proceed while the current is waiting the disk IO.

The patch replace the 'write' with flag of handle_mm_fault() to
FAULT_FLAG_RETRY as identify that the caller can tolerate the retry in the
filemap_fault call patch.

Compiled and booted on x86_64. (Andrew: can you help on other arches )

changelog[v4]:
- split the patch into four parts. the first two patches is a cleanup of
  Linus "untested" patch, which replace the boolen "writeaccess" to be a
  flag in handle_mm_fault. and the last two patches add the
  FAULT_FLAG_RETRY support.
- include all arches cleanups.
- add more comments as Andrew suggested.
- cleanups as Fengguang Wu suggested.

changelog[v3]:
- applied fixes and cleanups from Wu Fengguang.
filemap VM_FAULT_RETRY fixes
[PATCH 01/14] mm: fix find_lock_page_retry() return value parsing
[PATCH 02/14] mm: fix major/minor fault accounting on retried fault
[PATCH 04/14] mm: reduce duplicate page fault code
[PATCH 05/14] readahead: account mmap_miss for VM_FAULT_RETRY

- split the patch into two parts. first part includes FAULT_FLAG_RETRY
  support with no current user change. second part includes individual
  per-architecture cleanups that enable FAULT_FLAG_RETRY.
  currently there are mainly two users for handle_mm_fault, we enable
  FAULT_FLAG_RETRY for actual fault handler and leave get_user_pages
  unchanged.

changelog[v2]:
- reduce the runtime overhead by extending the 'write' flag of
  handle_mm_fault() to indicate the retry hint.
- add another two branches in filemap_fault with retry logic.
- replace find_lock_page with find_lock_page_retry to make the code
  cleaner.

Benchmarks:
case 1. one application has a high count of threads each faulting in
different pages of a hugefile. Benchmark indicate that this double data
structure walking in case of major fault results in << 1% performance hit.

case 2. add another thread in the above application which in a tight loop
of mmap()/munmap(). Here we measure loop count in the new thread while other
threads doing the same amount of work as case one. we got << 3% performance
hit on the Complete Time(benchmark value for case one) and 10% performance
improvement on the mmap()/munmap() counter.

This patch helps a lot in cases we have writer which is waitting behind all
readers, so it could execute much faster.

benchmarks from Wufengguang:
Just tested the sparse-random-read-on-sparse-file case, and found the
performance impact to be 0.4% (8.706s vs 8.744s) in the worst case.
Kind of acceptable.

without FAULT_FLAG_RETRY:
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse
3.28s user 5.39s system 99% cpu 8.692 total
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse
3.17s user 5.54s system 99% cpu 8.742 total
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse
3.18s user 5.48s system 99% cpu 8.684 total

FAULT_FLAG_RETRY:
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse
3.18s user 5.63s system 99% cpu 8.825 total
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse
3.22s user 5.47s system 99% cpu 8.718 total
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse
3.13s user 5.55s system 99% cpu 8.690 total

In the above faked workload, the mmap read page offsets are loaded from
stride-100 and performed on /mnt/btrfs-ram/sparse, which are created by:

	seq 0 100 1000000 > stride-100
	dd if=/dev/zero of=/mnt/btrfs-ram/sparse bs=1M count=1 seek=1024000

Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ying Han <yinghan@google.com>

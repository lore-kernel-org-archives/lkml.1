Return-Path: <linux-kernel-owner+w=401wt.eu-S1765011AbZDHUCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765011AbZDHUCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbZDHUCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:02:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4901 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbZDHUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:02:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=kmpr7f21VC/cUnra9ziB+TX1pErw63puskQPisA+4FyeeXojh9p+Ul2O1eqAJ4rRa
	BbTlodePUFI5/LREO+EFA==
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 13:02:23 -0700
Message-ID: <604427e00904081302p7aad170bu5ff0702415455f7@mail.gmail.com>
Subject: [PATCH][0/2]page_fault retry with NOPAGE_RETRY
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

Benchmarks:
posted on [V1]:
case 1. one application has a high count of threads each faulting in
different pages of a hugefile. Benchmark indicate that this double data
structure walking in case of major fault results in << 1% performance hit.

case 2. add another thread in the above application which in a tight loop
of
mmap()/munmap(). Here we measure loop count in the new thread while other
threads doing the same amount of work as case one. we got << 3% performance
hit on the Complete Time(benchmark value for case one) and 10% performance
improvement on the mmap()/munmap() counter.

This patch helps a lot in cases we have writer which is waitting behind all
readers, so it could execute much faster.

some new test results from Wufengguang:
Just tested the sparse-random-read-on-sparse-file case, and found the
performance impact to be 0.4% (8.706s vs 8.744s). Kind of acceptable.

without FAULT_FLAG_RETRY:
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse  3.28s user
5.39s system 99% cpu 8.692 total
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse  3.17s user
5.54s system 99% cpu 8.742 total
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse  3.18s user
5.48s system 99% cpu 8.684 total

FAULT_FLAG_RETRY:
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse  3.18s user
5.63s system 99% cpu 8.825 total
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse  3.22s user
5.47s system 99% cpu 8.718 total
iotrace.rb --load stride-100 --mplay /mnt/btrfs-ram/sparse  3.13s user
5.55s system 99% cpu 8.690 total

In the above faked workload, the mmap read page offsets are loaded from
stride-100 and performed on /mnt/btrfs-ram/sparse, which are created by:

	seq 0 100 1000000 > stride-100
	dd if=/dev/zero of=/mnt/btrfs-ram/sparse bs=1M count=1 seek=1024000

Signed-off-by: Ying Han <yinghan@google.com>
	       Mike Waychison <mikew@google.com>

 arch/x86/mm/fault.c |   20 ++++++++++++++
 include/linux/fs.h  |    2 +-
 include/linux/mm.h  |    2 +
 mm/filemap.c        |   72 ++++++++++++++++++++++++++++++++++++++++++++++++--
 mm/memory.c         |   33 +++++++++++++++++------
 5 files changed, 116 insertions(+), 13 deletions(-)

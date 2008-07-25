Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYGYVLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYGYVLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYGYVLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:11:01 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43490 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbYGYVK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:10:59 -0400
Date: Fri, 25 Jul 2008 14:10:35 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: gerald.schaefer@de.ibm.com
Cc: schwidefsky@de.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       agl@us.ibm.com
Subject: s390 hugetlb oops with libhugetlbfs test-suite
Message-ID: <20080725211035.GA19738@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerald,

Having noticed that the hugetlbfs code recently got an update to work on s390,
I decided to port the libhugetlbfs test-suite to work on s390. The current
development snapshot is available at
http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20080724.tar.gz.  You
will need a patch [1] to build on s390, but it should roughly work otherwise.
The specific testcase that causes the oops is counters. The bit set in the
flags is PG_Reserved, I think.

Bad page state in process 'counters'
page:000003e040000000 flags:0x0000000000000400 mapping:0000000000000000 mapcount
:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
CPU: 3 Not tainted 2.6.26-autokern1 #1
Process counters (pid: 5578, task: 000000003f3ca958, ksp: 000000003f1bbc08)
0000000000000005 000000003f1bb920 0000000000000002 0000000000000000
       000000003f1bb9c0 000000003f1bb938 000000003f1bb938 000000000003cfe2
       0000000000000000 0000000000000400 0000000000000000 000000000000000b
       0000000000000008 0000000000000000 000000003f1bb920 000000003f1bb998
       000000000024a780 0000000000016b0a 000000003f1bb920 000000003f1bb970
Call Trace:
(Ý<0000000000016a6c>¨ show_trace+0xdc/0xec)
 Ý<000000000007a38a>¨ bad_page+0x96/0xc8
 Ý<000000000007b11c>¨ free_hot_cold_page+0x9c/0x1e4
 Ý<0000000000099e4a>¨ __unmap_hugepage_range+0x38a/0x3cc
 Ý<0000000000099edc>¨ unmap_hugepage_range+0x50/0x78
 Ý<00000000000877d6>¨ unmap_vmas+0x14e/0xb34
 Ý<000000000008c6f2>¨ exit_mmap+0x14a/0x2f8
 Ý<00000000000397dc>¨ mmput+0x60/0x110
 Ý<00000000000401b4>¨ do_exit+0x264/0x7f4
 Ý<00000000000407d6>¨ do_group_exit+0x92/0xc0
 Ý<000000000004b558>¨ get_signal_to_deliver+0x344/0x36c
 Ý<000000000001d746>¨ do_signal+0xe2/0x878
 Ý<0000000000023b7a>¨ sysc_sigpending+0xe/0x22
 Ý<000000000040123a>¨ 0x40123a

[1]

libhugetlbfs: Add basic s390x support

The tests/Makefile change is needed until the signal check can be added
for s390.

diff --git a/Makefile b/Makefile
index f1f83fa..59fdb47 100644
--- a/Makefile
+++ b/Makefile
@@ -63,6 +63,13 @@ CC64 = gcc -m64
 LIB64 = lib64
 CFLAGS += -DNO_ELFLINK
 else
+ifeq ($(ARCH),s390x)
+CC64 = gcc -m64
+CC32 = gcc -m31
+LIB64 = lib64
+LIB32 = lib
+CFLAGS += -DNO_ELFLINK
+else
 $(error "Unrecognized architecture ($(ARCH))")
 endif
 endif
@@ -70,6 +77,7 @@ endif
 endif
 endif
 endif
+endif
 
 ifdef CC32
 OBJDIRS += obj32
diff --git a/tests/Makefile b/tests/Makefile
index b723db7..ebd7fb8 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -2,7 +2,7 @@ PREFIX = /usr/local
 
 LIB_TESTS = gethugepagesize test_root find_path unlinked_fd misalign \
 	readback truncate shared private fork-cow empty_mounts large_mounts \
-	meminfo_nohuge ptrace-write-hugepage icache-hygiene slbpacaflush \
+	meminfo_nohuge ptrace-write-hugepage slbpacaflush \
 	chunk-overcommit mprotect alloc-instantiate-race mlock \
 	truncate_reserve_wraparound truncate_sigbus_versus_oom \
 	map_high_truncate_2 truncate_above_4GB direct \

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

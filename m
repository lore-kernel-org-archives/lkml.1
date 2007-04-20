Return-Path: <linux-kernel-owner+w=401wt.eu-S2993282AbXDTQn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993282AbXDTQn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993284AbXDTQn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:43:57 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:35491 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993282AbXDTQn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:43:57 -0400
From: Balbir Singh <balbir@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nagar@watson.ibm.com, jlan@sgi.com, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 20 Apr 2007 22:13:41 +0530
Message-Id: <20070420164341.14718.5013.sendpatchset@balbir-laptop>
Subject: [PATCH -mm] Taskstats fix the structure members alignment issue
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We broke the the alignment of members of taskstats to the 8 byte boundary
with the CSA patches. In the current kernel, the taskstats structure is
not suitable for use by 32 bit applications in a 64 bit kernel.

On x86_64

Offsets of taskstats' members (64 bit kernel, 64 bit application)

@taskstats'offsetof[@taskstats'indices] = (
        0,      # version
        4,      # ac_exitcode
        8,      # ac_flag
        9,      # ac_nice
        16,     # cpu_count
        24,     # cpu_delay_total
        32,     # blkio_count
        40,     # blkio_delay_total
        48,     # swapin_count
        56,     # swapin_delay_total
        64,     # cpu_run_real_total
        72,     # cpu_run_virtual_total
        80,     # ac_comm
        112,    # ac_sched
        113,    # ac_pad
        116,    # ac_uid
        120,    # ac_gid
        124,    # ac_pid
        128,    # ac_ppid
        132,    # ac_btime
        136,    # ac_etime
        144,    # ac_utime
        152,    # ac_stime
        160,    # ac_minflt
        168,    # ac_majflt
        176,    # coremem
        184,    # virtmem
        192,    # hiwater_rss
        200,    # hiwater_vm
        208,    # read_char
        216,    # write_char
        224,    # read_syscalls
        232,    # write_syscalls
        240,    # read_bytes
        248,    # write_bytes
        256,    # cancelled_write_bytes
    );


Offsets of taskstats' members (64 bit kernel, 32 bit application)

@taskstats'offsetof[@taskstats'indices] = (
        0,      # version
        4,      # ac_exitcode
        8,      # ac_flag
        9,      # ac_nice
        12,     # cpu_count
        20,     # cpu_delay_total
        28,     # blkio_count
        36,     # blkio_delay_total
        44,     # swapin_count
        52,     # swapin_delay_total
        60,     # cpu_run_real_total
        68,     # cpu_run_virtual_total
        76,     # ac_comm
        108,    # ac_sched
        109,    # ac_pad
        112,    # ac_uid
        116,    # ac_gid
        120,    # ac_pid
        124,    # ac_ppid
        128,    # ac_btime
        132,    # ac_etime
        140,    # ac_utime
        148,    # ac_stime
        156,    # ac_minflt
        164,    # ac_majflt
        172,    # coremem
        180,    # virtmem
        188,    # hiwater_rss
        196,    # hiwater_vm
        204,    # read_char
        212,    # write_char
        220,    # read_syscalls
        228,    # write_syscalls
        236,    # read_bytes
        244,    # write_bytes
        252,    # cancelled_write_bytes
    );


This is one way to solve the problem without re-arranging structure members is
to pack the structure. The patch adds an __attribute__((aligned(8))) to the
taskstats structure members so that 32 bit applications using taskstats
can work with a 64 bit kernel.

Using __attribute__((packed)) would break the 64 bit alignment of members.

The fix was tested on x86_64. After the fix, we got

Offsets of taskstats' members (64 bit kernel, 64 bit application)

@taskstats'offsetof[@taskstats'indices] = (
        0,      # version
        4,      # ac_exitcode
        8,      # ac_flag
        9,      # ac_nice
        16,     # cpu_count
        24,     # cpu_delay_total
        32,     # blkio_count
        40,     # blkio_delay_total
        48,     # swapin_count
        56,     # swapin_delay_total
        64,     # cpu_run_real_total
        72,     # cpu_run_virtual_total
        80,     # ac_comm
        112,    # ac_sched
        113,    # ac_pad
        120,    # ac_uid
        124,    # ac_gid
        128,    # ac_pid
        132,    # ac_ppid
        136,    # ac_btime
        144,    # ac_etime
        152,    # ac_utime
        160,    # ac_stime
        168,    # ac_minflt
        176,    # ac_majflt
        184,    # coremem
        192,    # virtmem
        200,    # hiwater_rss
        208,    # hiwater_vm
        216,    # read_char
        224,    # write_char
        232,    # read_syscalls
        240,    # write_syscalls
        248,    # read_bytes
        256,    # write_bytes
        264,    # cancelled_write_bytes
    );


Offsets of taskstats' members (64 bit kernel, 32 bit application)

@taskstats'offsetof[@taskstats'indices] = (
        0,      # version
        4,      # ac_exitcode
        8,      # ac_flag
        9,      # ac_nice
        16,     # cpu_count
        24,     # cpu_delay_total
        32,     # blkio_count
        40,     # blkio_delay_total
        48,     # swapin_count
        56,     # swapin_delay_total
        64,     # cpu_run_real_total
        72,     # cpu_run_virtual_total
        80,     # ac_comm
        112,    # ac_sched
        113,    # ac_pad
        120,    # ac_uid
        124,    # ac_gid
        128,    # ac_pid
        132,    # ac_ppid
        136,    # ac_btime
        144,    # ac_etime
        152,    # ac_utime
        160,    # ac_stime
        168,    # ac_minflt
        176,    # ac_majflt
        184,    # coremem
        192,    # virtmem
        200,    # hiwater_rss
        208,    # hiwater_vm
        216,    # read_char
        224,    # write_char
        232,    # read_syscalls
        240,    # write_syscalls
        248,    # read_bytes
        256,    # write_bytes
        264,    # cancelled_write_bytes
    );


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/taskstats.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN include/linux/taskstats.h~fix-taskstats-alignment include/linux/taskstats.h
--- linux-2.6.20/include/linux/taskstats.h~fix-taskstats-alignment	2007-04-19 12:28:25.000000000 +0530
+++ linux-2.6.20-balbir/include/linux/taskstats.h	2007-04-19 13:21:48.000000000 +0530
@@ -66,7 +66,7 @@ struct taskstats {
 	/* Delay waiting for cpu, while runnable
 	 * count, delay_total NOT updated atomically
 	 */
-	__u64	cpu_count;
+	__u64	cpu_count __attribute__((aligned(8)));
 	__u64	cpu_delay_total;
 
 	/* Following four fields atomically updated using task->delays->lock */
@@ -101,14 +101,17 @@ struct taskstats {
 
 	/* Basic Accounting Fields start */
 	char	ac_comm[TS_COMM_LEN];	/* Command name */
-	__u8	ac_sched;		/* Scheduling discipline */
+	__u8	ac_sched __attribute__((aligned(8)));
+					/* Scheduling discipline */
 	__u8	ac_pad[3];
-	__u32	ac_uid;			/* User ID */
+	__u32	ac_uid __attribute__((aligned(8)));
+					/* User ID */
 	__u32	ac_gid;			/* Group ID */
 	__u32	ac_pid;			/* Process ID */
 	__u32	ac_ppid;		/* Parent process ID */
 	__u32	ac_btime;		/* Begin time [sec since 1970] */
-	__u64	ac_etime;		/* Elapsed time [usec] */
+	__u64	ac_etime __attribute__((aligned(8)));
+					/* Elapsed time [usec] */
 	__u64	ac_utime;		/* User CPU time [usec] */
 	__u64	ac_stime;		/* SYstem CPU time [usec] */
 	__u64	ac_minflt;		/* Minor Page Fault Count */
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

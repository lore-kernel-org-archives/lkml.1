Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbYDBIG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbYDBIG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYDBIFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:05:53 -0400
Received: from mx.ATComputing.nl ([195.108.229.5]:39873 "EHLO
	mx.ATComputing.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbYDBIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:05:51 -0400
Date: Wed, 2 Apr 2008 09:31:51 +0200
From: Gerlof Langeveld <gerlof@ATComputing.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 2/3] accounting: task counters for disk/network
Message-ID: <20080402073151.GB8419@atcmpg.ATComputing.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.7i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Gerlof Langeveld <gerlof@atcomputing.nl>

Process level counters related to CPU, memory, disk and network utilization
should also be preserved in the process accounting record, once the
process has finished.

This patch depends on patch 1/3 "accounting: task counters for disk/network".

The additional disk and network I/O counters should be stored in the
process accounting record at the moment that a process exits. For this
reason a new type of process accounting record (type 6) is introduced
as a configurable option.

The performance monitor 'atop' uses a similar kernel patch for several
years now to supply a complete overview of all processes (so also
exited processes) that utilized certain system resources.

Modified source files
  include/linux/acct.h:       addition new format of process accounting record

  kernel/acct.c:              fill new format of process accounting record

Since this new type of record is optional, all modifications are ifdef'd
with a macro (CONFIG_PROCESS_ACCT_V6).
Patch applies to kernel version 2.6.24.4

Signed-off-by: Gerlof Langeveld <gerlof@atcomputing.nl>
---

diff -uprN -X linux-2.6.24.4-vanilla/Documentation/dontdiff linux-2.6.24.4-vanilla/include/linux/acct.h linux-2.6.24.4-modified/include/linux/acct.h
--- linux-2.6.24.4-vanilla/include/linux/acct.h	2008-03-24 19:49:18.000000000 +0100
+++ linux-2.6.24.4-modified/include/linux/acct.h	2008-03-25 14:01:30.000000000 +0100
@@ -97,6 +97,54 @@ struct acct_v3
 	char		ac_comm[ACCT_COMM];	/* Command Name */
 };
 
+struct acct_v6 {
+
+	char		ac_flag;		/* Flags */
+	char		ac_version;		/* Always set to ACCT_VERSION */
+	__u32		ac_pid;			/* Process ID */
+	__u32		ac_ppid;		/* Parent Process ID */
+	__u16		ac_uid16;		/* LSB of Real User ID */
+	__u16		ac_gid16;		/* LSB of Real Group ID */
+	__u16		ac_tty;			/* Control Terminal */
+	__u32		ac_btime;		/* Process Creation Time */
+	comp_t		ac_utime;		/* User Time */
+	comp_t		ac_stime;		/* System Time */
+	comp_t		ac_etime;		/* Elapsed Time */
+	comp_t		ac_mem;			/* Virtual  Memory */
+	comp_t		ac_rss;			/* Resident Memory */
+	comp_t		ac_io;			/* Chars Transferred */
+	comp_t		ac_rw;			/* Blocks Read or Written */
+	comp_t		ac_bread;		/* Blocks Read */
+	comp_t		ac_bwrite;		/* Blocks Written */
+	comp2_t		ac_dskrsz;		/* Cum. blocks read */
+	comp2_t		ac_dskwsz;		/* Cum. blocks written */
+	comp_t		ac_tcpsnd;		/* TCP send requests */
+	comp_t		ac_tcprcv;		/* TCP recv requests */
+	comp2_t		ac_tcpssz;		/* TCP cum. length   */
+	comp2_t		ac_tcprsz;		/* TCP cum. length   */
+	comp_t		ac_udpsnd;		/* UDP send requests */
+	comp_t		ac_udprcv;		/* UDP recv requests */
+	comp2_t		ac_udpssz;		/* UDP cum. length   */
+	comp2_t		ac_udprsz;		/* UDP cum. length   */
+	comp_t		ac_rawsnd;		/* RAW send requests */
+	comp_t		ac_rawrcv;		/* RAW recv requests */
+	comp_t		ac_minflt;		/* Minor Pagefaults */
+	comp_t		ac_majflt;		/* Major Pagefaults */
+	comp_t		ac_swaps;		/* Number of Swaps */
+/* m68k had no padding here. */
+#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
+	__u16		ac_ahz;			/* AHZ */
+#endif
+	__u32		ac_exitcode;		/* Exitcode */
+	char		ac_comm[ACCT_COMM + 1];	/* Command Name */
+	__u8		ac_etime_hi;		/* Elapsed Time MSB */
+	__u16		ac_etime_lo;		/* Elapsed Time LSB */
+	__u32		ac_uid;			/* Real User ID */
+	__u32		ac_gid;			/* Real Group ID */
+};
+
+
+
 /*
  *  accounting flags
  */
@@ -143,7 +191,11 @@ extern void acct_process(void);
  * 5: new binary incompatible format (128 bytes, second half)
  *
  */
-
+#ifdef CONFIG_PROCESS_ACCT_V6
+#define ACCT_VERSION	6
+#define AHZ		(USER_HZ)
+typedef struct acct_v6 acct_t;
+#else
 #ifdef CONFIG_BSD_PROCESS_ACCT_V3
 #define ACCT_VERSION	3
 #define AHZ		100
@@ -157,6 +209,7 @@ typedef struct acct_v3 acct_t;
 #define AHZ		(USER_HZ)
 typedef struct acct acct_t;
 #endif
+#endif
 
 #else
 #define ACCT_VERSION	2
diff -uprN -X linux-2.6.24.4-vanilla/Documentation/dontdiff linux-2.6.24.4-vanilla/kernel/acct.c linux-2.6.24.4-modified/kernel/acct.c
--- linux-2.6.24.4-vanilla/kernel/acct.c	2008-03-25 14:09:18.000000000 +0100
+++ linux-2.6.24.4-modified/kernel/acct.c	2008-03-25 14:07:45.000000000 +0100
@@ -344,7 +344,7 @@ static comp_t encode_comp_t(unsigned lon
 	return exp;
 }
 
-#if ACCT_VERSION==1 || ACCT_VERSION==2
+#if ACCT_VERSION == 1 || ACCT_VERSION == 2 || ACCT_VERSION == 6
 /*
  * encode an u64 into a comp2_t (24 bits)
  *
@@ -484,6 +484,37 @@ static void do_acct_process(struct file 
 	ac.ac_pid = current->tgid;
 	ac.ac_ppid = current->real_parent->tgid;
 #endif
+#if ACCT_VERSION == 6
+	ac.ac_pid    = current->pid;
+	ac.ac_ppid   = current->parent->pid;
+	ac.ac_uid16  = current->uid;
+	ac.ac_gid16  = current->gid;
+	ac.ac_ahz    = AHZ;
+	ac.ac_rss    = current->mm ?
+		encode_comp_t(get_mm_rss(current->mm)<<(PAGE_SHIFT-10)) :
+		encode_comp_t(0);
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	ac.ac_bread  = encode_comp_t(current->ioac.dsk_rio);
+	ac.ac_bwrite = encode_comp_t(current->ioac.dsk_wio);
+	ac.ac_dskrsz = encode_comp2_t(current->ioac.dsk_rsz);
+	ac.ac_dskwsz = encode_comp2_t(current->ioac.dsk_wsz);
+	ac.ac_tcpsnd = encode_comp_t(current->ioac.tcp_snd);
+	ac.ac_tcprcv = encode_comp_t(current->ioac.tcp_rcv);
+	ac.ac_tcpssz = encode_comp2_t(current->ioac.tcp_ssz);
+	ac.ac_tcprsz = encode_comp2_t(current->ioac.tcp_rsz);
+	ac.ac_udpsnd = encode_comp_t(current->ioac.udp_snd);
+	ac.ac_udprcv = encode_comp_t(current->ioac.udp_rcv);
+	ac.ac_udpssz = encode_comp2_t(current->ioac.udp_ssz);
+	ac.ac_udprsz = encode_comp2_t(current->ioac.udp_rsz);
+	ac.ac_rawsnd = encode_comp_t(current->ioac.raw_snd);
+	ac.ac_rawrcv = encode_comp_t(current->ioac.raw_rcv);
+#else
+	ac.ac_bread  = ac.ac_bwrite = ac.ac_dskrsz = ac.ac_dskwsz = 0;
+	ac.ac_tcpsnd = ac.ac_tcprcv = ac.ac_tcpssz = ac.ac_tcprsz = 0;
+	ac.ac_udpsnd = ac.ac_udprcv = ac.ac_udpssz = ac.ac_udprsz = 0;
+	ac.ac_rawsnd = ac.ac_rawrcv = 0;
+#endif
+#endif
 
 	spin_lock_irq(&current->sighand->siglock);
 	tty = current->signal->tty;

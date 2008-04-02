Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYDBHtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYDBHtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYDBHtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:49:13 -0400
Received: from mx.ATComputing.nl ([195.108.229.5]:47316 "EHLO
	mx.ATComputing.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYDBHtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:49:11 -0400
X-Greylist: delayed 1100 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 03:49:11 EDT
Date: Wed, 2 Apr 2008 09:30:37 +0200
From: Gerlof Langeveld <gerlof@ATComputing.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/3] accounting: task counters for disk/network
Message-ID: <20080402073037.GA8419@atcmpg.ATComputing.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.7i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Gerlof Langeveld <gerlof@atcomputing.nl>

Proper performance analysis requires the availability of system level
and process level counters for CPU, memory, disk and network utilization.
The current kernel offers the system level counters, however process level
counters are only (sufficiently) available for CPU and memory utilization.

The kernel feature "task I/O accounting" currently maintains
per process counters for the number of bytes transferred to/from disk.
These counters are available via /proc/pid/io. It is still not possible
to find out which process issues the physical disk transfer. Besides,
not *all* disk transfers are accounted to processes (e.g. swap-transfers
by kswapd, journaling transfers).

This patch extends "task I/O accounting" by counting real *physical*
disk transfers per process and by counting IPv4/IPv6 socket transfers
per process.
The modified output generated for /proc/pid/io will be as follows:

  $ cat /proc/3179/io
  rchar: 49934
  wchar: 4
  syscr: 27
  syscw: 1
  read_bytes: 200704
  write_bytes: 4096
  cancelled_write_bytes: 0
  disk_read: 8                      <---- this line is added
  disk_read_sect: 392               <---- this line is added
  disk_write: 0                     <---- this line is added
  disk_write_sect: 0                <---- this line is added
  tcp_send: 0                       <---- this line is added
  tcp_send_bytes: 0                 <---- this line is added
  tcp_recv: 0                       <---- this line is added
  tcp_recv_bytes: 0                 <---- this line is added
  udp_send: 27                      <---- this line is added
  udp_send_bytes: 1296              <---- this line is added
  udp_recv: 27                      <---- this line is added
  udp_recv_bytes: 29484             <---- this line is added
  raw_send: 0                       <---- this line is added
  raw_recv: 0                       <---- this line is added

The performance monitor 'atop' uses a similar kernel patch for
several years already to be able to show these per process statistics.

Modified source files
  include/linux/task_io_accounting.h:   addition of new counters to the
                                        struct task_io_accounting

  fs/proc/base.c:                       generate output via /proc/pid/io

  block/ll_rw_blk.c:                    per process counting of physical
                                        disk access
 
  net/socket.c:                         per process counting of socket
                                        transfers

  kernel/acct.c:                        add number of disk reads/writes to
                                        standard accounting record

Since "task I/O accounting" is currently optional (CONFIG_TASK_IO_ACCOUNTING),
all modifications are ifdef'd with the same macro as well.
Patch applies to kernel version 2.6.24.4

Signed-off-by: Gerlof Langeveld <gerlof@atcomputing.nl>
---

diff -uprN -X linux-2.6.24.4-vanilla/Documentation/dontdiff linux-2.6.24.4-vanilla/block/ll_rw_blk.c linux-2.6.24.4-modified/block/ll_rw_blk.c
--- linux-2.6.24.4-vanilla/block/ll_rw_blk.c	2008-03-24 19:49:18.000000000 +0100
+++ linux-2.6.24.4-modified/block/ll_rw_blk.c	2008-03-25 13:52:14.000000000 +0100
@@ -2739,6 +2739,19 @@ static void drive_stat_acct(struct reque
 		disk_round_stats(rq->rq_disk);
 		rq->rq_disk->in_flight++;
 	}
+
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	switch (rw) {
+	case READ:
+		current->group_leader->ioac.dsk_rio += new_io;
+		current->group_leader->ioac.dsk_rsz += rq->nr_sectors;
+		break;
+	case WRITE:
+		current->group_leader->ioac.dsk_wio += new_io;
+		current->group_leader->ioac.dsk_wsz += rq->nr_sectors;
+		break;
+	}
+#endif
 }
 
 /*
diff -uprN -X linux-2.6.24.4-vanilla/Documentation/dontdiff linux-2.6.24.4-vanilla/fs/proc/base.c linux-2.6.24.4-modified/fs/proc/base.c
--- linux-2.6.24.4-vanilla/fs/proc/base.c	2008-03-24 19:49:18.000000000 +0100
+++ linux-2.6.24.4-modified/fs/proc/base.c	2008-03-25 13:52:14.000000000 +0100
@@ -2174,7 +2174,21 @@ static int proc_pid_io_accounting(struct
 #endif
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
-			"cancelled_write_bytes: %llu\n",
+			"cancelled_write_bytes: %llu\n"
+			"disk_read: %llu\n"
+			"disk_read_sect: %llu\n"
+			"disk_write: %llu\n"
+			"disk_write_sect: %llu\n"
+			"tcp_send: %llu\n"
+			"tcp_send_bytes: %llu\n"
+			"tcp_recv: %llu\n"
+			"tcp_recv_bytes: %llu\n"
+			"udp_send: %llu\n"
+			"udp_send_bytes: %llu\n"
+			"udp_recv: %llu\n"
+			"udp_recv_bytes: %llu\n"
+			"raw_send: %llu\n"
+			"raw_recv: %llu\n",
 #ifdef CONFIG_TASK_XACCT
 			(unsigned long long)task->rchar,
 			(unsigned long long)task->wchar,
@@ -2183,7 +2197,21 @@ static int proc_pid_io_accounting(struct
 #endif
 			(unsigned long long)task->ioac.read_bytes,
 			(unsigned long long)task->ioac.write_bytes,
-			(unsigned long long)task->ioac.cancelled_write_bytes);
+			(unsigned long long)task->ioac.cancelled_write_bytes,
+			(unsigned long long)task->ioac.dsk_rio,
+			(unsigned long long)task->ioac.dsk_rsz,
+			(unsigned long long)task->ioac.dsk_wio,
+			(unsigned long long)task->ioac.dsk_wsz,
+			(unsigned long long)task->ioac.tcp_snd,
+			(unsigned long long)task->ioac.tcp_ssz,
+			(unsigned long long)task->ioac.tcp_rcv,
+			(unsigned long long)task->ioac.tcp_rsz,
+			(unsigned long long)task->ioac.udp_snd,
+			(unsigned long long)task->ioac.udp_ssz,
+			(unsigned long long)task->ioac.udp_rcv,
+			(unsigned long long)task->ioac.udp_rsz,
+			(unsigned long long)task->ioac.raw_snd,
+			(unsigned long long)task->ioac.raw_rcv);
 }
 #endif
 
diff -uprN -X linux-2.6.24.4-vanilla/Documentation/dontdiff linux-2.6.24.4-vanilla/include/linux/task_io_accounting.h linux-2.6.24.4-modified/include/linux/task_io_accounting.h
--- linux-2.6.24.4-vanilla/include/linux/task_io_accounting.h	2008-03-24 19:49:18.000000000 +0100
+++ linux-2.6.24.4-modified/include/linux/task_io_accounting.h	2008-03-25 13:52:14.000000000 +0100
@@ -30,6 +30,23 @@ struct task_io_accounting {
 	 * information loss in doing that.
 	 */
 	u64 cancelled_write_bytes;
+
+	/*
+	 * Number of physical reads and writes to disk by this task
+	 * and the accumulated size of these physical transfers.
+	 */
+	u64 dsk_rio, dsk_wio;
+	u64 dsk_rsz, dsk_wsz;
+
+	/*
+	 * Number of sends and receives issued for IPv4/IPv6 by
+	 * this task on TCP, UDP and raw sockets with their accumulated size.
+	 */
+	u64 tcp_snd, tcp_rcv;
+	u64 tcp_ssz, tcp_rsz;
+	u64 udp_snd, udp_rcv;
+	u64 udp_ssz, udp_rsz;
+	u64 raw_snd, raw_rcv;
 };
 #else
 struct task_io_accounting {
diff -uprN -X linux-2.6.24.4-vanilla/Documentation/dontdiff linux-2.6.24.4-vanilla/kernel/acct.c linux-2.6.24.4-modified/kernel/acct.c
--- linux-2.6.24.4-vanilla/kernel/acct.c	2008-03-24 19:49:18.000000000 +0100
+++ linux-2.6.24.4-modified/kernel/acct.c	2008-03-25 13:55:07.000000000 +0100
@@ -497,7 +497,11 @@ static void do_acct_process(struct file 
 	ac.ac_exitcode = pacct->ac_exitcode;
 	spin_unlock_irq(&current->sighand->siglock);
 	ac.ac_io = encode_comp_t(0 /* current->io_usage */);	/* %% */
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	ac.ac_rw = encode_comp_t(current->ioac.dsk_rio + current->ioac.dsk_wio);
+#else
 	ac.ac_rw = encode_comp_t(ac.ac_io / 1024);
+#endif
 	ac.ac_swaps = encode_comp_t(0);
 
 	/*
diff -uprN -X linux-2.6.24.4-vanilla/Documentation/dontdiff linux-2.6.24.4-vanilla/net/socket.c linux-2.6.24.4-modified/net/socket.c
--- linux-2.6.24.4-vanilla/net/socket.c	2008-03-24 19:49:18.000000000 +0100
+++ linux-2.6.24.4-modified/net/socket.c	2008-03-25 13:52:14.000000000 +0100
@@ -551,10 +551,30 @@ static inline int __sock_sendmsg(struct 
 	si->size = size;
 
 	err = security_socket_sendmsg(sock, msg, size);
-	if (err)
-		return err;
+	if (!err)
+		err = sock->ops->sendmsg(iocb, sock, msg, size);
 
-	return sock->ops->sendmsg(iocb, sock, msg, size);
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	if (err >= 0 && sock->sk) {
+		switch (sock->sk->sk_family) {
+		case PF_INET:
+		case PF_INET6:
+			switch (sock->sk->sk_type) {
+			case SOCK_STREAM:
+				current->group_leader->ioac.tcp_snd++;
+				current->group_leader->ioac.tcp_ssz += size;
+				break;
+			case SOCK_DGRAM:
+				current->group_leader->ioac.udp_snd++;
+				current->group_leader->ioac.udp_ssz += size;
+				break;
+			case SOCK_RAW:
+				current->group_leader->ioac.raw_snd++;
+			}
+		}
+	}
+#endif
+       return err;
 }
 
 int sock_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
@@ -633,10 +653,31 @@ static inline int __sock_recvmsg(struct 
 	si->flags = flags;
 
 	err = security_socket_recvmsg(sock, msg, size, flags);
-	if (err)
-		return err;
+	if (!err)
+		err = sock->ops->recvmsg(iocb, sock, msg, size, flags);
 
-	return sock->ops->recvmsg(iocb, sock, msg, size, flags);
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	if (err >= 0 && sock->sk) {
+		switch (sock->sk->sk_family) {
+		case PF_INET:
+		case PF_INET6:
+			switch (sock->sk->sk_type) {
+			case SOCK_STREAM:
+				current->group_leader->ioac.tcp_rcv++;
+				current->group_leader->ioac.tcp_rsz += size;
+				break;
+			case SOCK_DGRAM:
+				current->group_leader->ioac.udp_rcv++;
+				current->group_leader->ioac.udp_rsz += size;
+				break;
+			case SOCK_RAW:
+				current->group_leader->ioac.raw_rcv++;
+				break;
+			}
+		}
+	}
+#endif
+	return err;
 }
 
 int sock_recvmsg(struct socket *sock, struct msghdr *msg,

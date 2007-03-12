Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXCLRUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXCLRUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965416AbXCLRUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:20:02 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:34595 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928AbXCLRUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:20:00 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] getrusage() : Fill ru_inblock and ru_oublock fields if possible
Date: Mon, 12 Mar 2007 18:20:03 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070307012234.GN9621@outflux.net> <20070310183341.GB10460@outflux.net> <20070310162101.716b6b57.akpm@linux-foundation.org>
In-Reply-To: <20070310162101.716b6b57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DvY9F+l6ReMoTG7"
Message-Id: <200703121820.03340.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_DvY9F+l6ReMoTG7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

if CONFIG_TASK_IO_ACCOUNTING is defined, we update io accounting counters f=
or=20
each task.

This patch permits reporting of values using the well known getrusage()=20
syscall, filling ru_inblock and ru_oublock instead of null values.

As TASK_IO_ACCOUNTING currently counts bytes counts, we approximate blocks=
=20
count doing : nr_blocks =3D nr_bytes / 512

Example of use :
=2D---------------------
After patch is applied, /usr/bin/time command can now give a good=20
approximation of IO that the process had to do.

$ /usr/bin/time grep tototo /usr/include/*
Command exited with non-zero status 1
0.00user 0.02system 0:02.11elapsed 1%CPU (0avgtext+0avgdata 0maxresident)k
24288inputs+0outputs (0major+259minor)pagefaults 0swaps

$ /usr/bin/time dd if=3D/dev/zero of=3D/tmp/testfile count=3D1000
1000+0 enregistrements lus
1000+0 enregistrements =E9crits
512000 octets (512 kB) copi=E9s, 0,00326601 seconde, 157 MB/s
0.00user 0.00system 0:00.00elapsed 80%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+3000outputs (0major+299minor)pagefaults 0swaps

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--Boundary-00=_DvY9F+l6ReMoTG7
Content-Type: text/plain;
  charset="iso-8859-1";
  name="getrusage_add_inblock_and_oublock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="getrusage_add_inblock_and_oublock.patch"

--- linux-2.6.21-rc3/kernel/sys.c	2007-03-12 17:30:34.000000000 +0100
+++ linux-2.6.21-rc3-ed/kernel/sys.c	2007-03-12 17:50:15.000000000 +0100
@@ -29,6 +29,7 @@
 #include <linux/signal.h>
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
+#include <linux/task_io_accounting_ops.h>
 
 #include <linux/compat.h>
 #include <linux/syscalls.h>
@@ -2021,6 +2022,8 @@ static void k_getrusage(struct task_stru
 			r->ru_nivcsw = p->signal->cnivcsw;
 			r->ru_minflt = p->signal->cmin_flt;
 			r->ru_majflt = p->signal->cmaj_flt;
+			r->ru_inblock = task_io_get_inblock(p);
+			r->ru_oublock = task_io_get_oublock(p);
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -2032,6 +2035,8 @@ static void k_getrusage(struct task_stru
 			r->ru_nivcsw += p->signal->nivcsw;
 			r->ru_minflt += p->signal->min_flt;
 			r->ru_majflt += p->signal->maj_flt;
+			r->ru_inblock += task_io_get_inblock(p);
+			r->ru_oublock += task_io_get_oublock(p);
 			t = p;
 			do {
 				utime = cputime_add(utime, t->utime);
@@ -2040,6 +2045,8 @@ static void k_getrusage(struct task_stru
 				r->ru_nivcsw += t->nivcsw;
 				r->ru_minflt += t->min_flt;
 				r->ru_majflt += t->maj_flt;
+				r->ru_inblock += task_io_get_inblock(t);
+				r->ru_oublock += task_io_get_oublock(t);
 				t = next_thread(t);
 			} while (t != p);
 			break;
--- linux-2.6.21-rc3/include/linux/task_io_accounting_ops.h	2007-03-12 17:30:34.000000000 +0100
+++ linux-2.6.21-rc3-ed/include/linux/task_io_accounting_ops.h	2007-03-12 17:50:15.000000000 +0100
@@ -10,11 +10,29 @@ static inline void task_io_account_read(
 	current->ioac.read_bytes += bytes;
 }
 
+/*
+ * We approximate number of blocks, because we account bytes only.
+ * A 'block' is 512 bytes
+ */
+static inline unsigned long task_io_get_inblock(const struct task_struct *p)
+{
+	return p->ioac.read_bytes >> 9;
+}
+
 static inline void task_io_account_write(size_t bytes)
 {
 	current->ioac.write_bytes += bytes;
 }
 
+/*
+ * We approximate number of blocks, because we account bytes only.
+ * A 'block' is 512 bytes
+ */
+static inline unsigned long task_io_get_oublock(const struct task_struct *p)
+{
+	return p->ioac.write_bytes >> 9;
+}
+
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
 	current->ioac.cancelled_write_bytes += bytes;
@@ -31,10 +49,20 @@ static inline void task_io_account_read(
 {
 }
 
+static inline unsigned long task_io_get_inblock(const struct task_struct *p)
+{
+	return 0;
+}
+
 static inline void task_io_account_write(size_t bytes)
 {
 }
 
+static inline unsigned long task_io_get_oublock(const struct task_struct *p)
+{
+	return 0;
+}
+
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
 }

--Boundary-00=_DvY9F+l6ReMoTG7--

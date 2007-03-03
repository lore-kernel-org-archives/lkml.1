Return-Path: <linux-kernel-owner+w=401wt.eu-S1030429AbXCCVoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030429AbXCCVoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 16:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030449AbXCCVoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 16:44:37 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:59805 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030429AbXCCVog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 16:44:36 -0500
Date: Sat, 03 Mar 2007 22:44:33 +0100
Message-Id: <1662188763@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@in.ibm.com, csturtiv@sgi.com, daw@sgi.com,
       guillaume.thouvenin@bull.net, jlan@sgi.com,
       linux-kernel@vger.kernel.org, nagar@watson.ibm.com, tee@sgi.com
Subject: [PATCH] Documentation for io-accounting / reporting via procfs
Organization: http://freemail.web.de/
Content-Type: multipart/mixed;
 boundary="=-------------11729582751896115957"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--=-------------11729582751896115957
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit

This one adds some documentation for the new and very useful io-accounting feature.
It's being added to Documentation/filesystems/proc.txt

Signed-off-by: Roland Kletzing devzero@web.de

diff -uprN linux-2.6.20/Documentation/filesystems/proc.txt.orig linux-2.6.20/Documentation/filesystems/proc.txt
--- linux-2.6.20/Documentation/filesystems/proc.txt.orig        2007-03-03 21:54:31.489538216 +0100
+++ linux-2.6.20/Documentation/filesystems/proc.txt     2007-03-03 22:18:44.973575056 +0100
@@ -41,6 +41,7 @@ Table of Contents
   2.11 /proc/sys/fs/mqueue - POSIX message queues filesystem
   2.12 /proc/<pid>/oom_adj - Adjust the oom-killer score
   2.13 /proc/<pid>/oom_score - Display current oom-killer score
+  2.14 /proc/<pid>/io - Display the IO accounting fields

 ------------------------------------------------------------------------------
 Preface
@@ -1990,3 +1991,107 @@ need to  recompile  the kernel, or even
 command to write value into these files, thereby changing the default settings
 of the kernel.
 ------------------------------------------------------------------------------
+
+2.14  /proc/<pid>/io - Display the IO accounting fields
+-------------------------------------------------------
+
+This file contains IO statistics for each running process
+
+Example
+-------
+
+test:/tmp # dd if=/dev/zero of=/tmp/test.dat &
+[1] 3828
+
+test:/tmp # cat /proc/3828/io
+rchar: 323934931
+wchar: 323929600
+syscr: 632687
+syscw: 632675
+read_bytes: 0
+write_bytes: 323932160
+cancelled_write_bytes: 0
+
+
+Description
+-----------
+
+rchar
+-----
+
+I/O counter: chars read
+The number of bytes which this task has caused to be read from storage. This
+is simply the sum of bytes which this process passed to read() and pread().
+It includes things like tty IO and it is unaffected by whether or not actual
+physical disk IO was required (the read might have been satisfied from
+pagecache)
+
+
+wchar
+-----
+
+I/O counter: chars written
+The number of bytes which this task has caused, or shall cause to be written
+to disk. Similar caveats apply here as with rchar.
+
+
+syscr
+-----
+
+I/O counter: read syscalls
+Attempt to count the number of read I/O operations, i.e. syscalls like read()
+and pread().
+
+
+syscw
+-----
+
+I/O counter: write syscalls
+Attempt to count the number of write I/O operations, i.e. syscalls like
+write() and pwrite().
+
+
+read_bytes
+----------
+
+I/O counter: bytes read
+Attempt to count the number of bytes which this process really did cause to
+be fetched from the storage layer. Done at the submit_bio() level, so it is
+accurate for block-backed filesystems. <please add status regarding NFS and
+CIFS at a later time>
+
+
+write_bytes
+-----------
+
+I/O counter: bytes written
+Attempt to count the number of bytes which this process caused to be sent to
+the storage layer. This is done at page-dirtying time.
+
+
+cancelled_write_bytes
+---------------------
+
+The big inaccuracy here is truncate. If a process writes 1MB to a file and
+then deletes the file, it will in fact perform no writeout. But it will have
+been accounted as having caused 1MB of write.
+In other words: The number of bytes which this process caused to not happen,
+by truncating pagecache. A task can cause "negative" IO too. If this task
+truncates some dirty pagecache, some IO which another task has been accounted
+for (in it's write_bytes) will not be happening. We _could_ just subtract that
+from the truncating task's write_bytes, but there is information loss in doing
+that.
+
+
+Note
+----
+
+At it's current implementation state, it's a bit racy on 32-bit machines: If
+process A reads process B's /proc/pid/io while process B is updating one of
+those 64-bit counters, process A could see an intermediate result.
+
+
+More information about this can be found within taskstats documentation at
+Documentation/accounting .
+
+------------------------------------------------------------------------------


_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114


--=-------------11729582751896115957
Content-Type: text/x-patch;
 name="add-io-statistics-documentation.patch"
Content-Disposition: attachment;
 filename="add-io-statistics-documentation.patch"
Content-Transfer-Encoding: 7bit

--- linux-2.6.20/Documentation/filesystems/proc.txt.orig	2007-03-03 21:54:31.489538216 +0100
+++ linux-2.6.20/Documentation/filesystems/proc.txt	2007-03-03 22:18:44.973575056 +0100
@@ -41,6 +41,7 @@ Table of Contents
   2.11	/proc/sys/fs/mqueue - POSIX message queues filesystem
   2.12	/proc/<pid>/oom_adj - Adjust the oom-killer score
   2.13	/proc/<pid>/oom_score - Display current oom-killer score
+  2.14	/proc/<pid>/io - Display the IO accounting fields
 
 ------------------------------------------------------------------------------
 Preface
@@ -1990,3 +1991,107 @@ need to  recompile  the kernel, or even 
 command to write value into these files, thereby changing the default settings
 of the kernel.
 ------------------------------------------------------------------------------
+
+2.14  /proc/<pid>/io - Display the IO accounting fields
+-------------------------------------------------------
+
+This file contains IO statistics for each running process 
+
+Example
+-------
+
+test:/tmp # dd if=/dev/zero of=/tmp/test.dat &
+[1] 3828
+
+test:/tmp # cat /proc/3828/io
+rchar: 323934931
+wchar: 323929600
+syscr: 632687
+syscw: 632675
+read_bytes: 0
+write_bytes: 323932160
+cancelled_write_bytes: 0
+
+
+Description 
+-----------
+
+rchar
+-----
+
+I/O counter: chars read
+The number of bytes which this task has caused to be read from storage. This
+is simply the sum of bytes which this process passed to read() and pread(). 
+It includes things like tty IO and it is unaffected by whether or not actual
+physical disk IO was required (the read might have been satisfied from 
+pagecache)
+
+
+wchar
+-----
+
+I/O counter: chars written
+The number of bytes which this task has caused, or shall cause to be written 
+to disk. Similar caveats apply here as with rchar.
+
+
+syscr
+-----
+
+I/O counter: read syscalls
+Attempt to count the number of read I/O operations, i.e. syscalls like read()
+and pread().
+
+
+syscw
+-----
+
+I/O counter: write syscalls
+Attempt to count the number of write I/O operations, i.e. syscalls like 
+write() and pwrite().
+
+
+read_bytes
+----------
+
+I/O counter: bytes read
+Attempt to count the number of bytes which this process really did cause to
+be fetched from the storage layer. Done at the submit_bio() level, so it is
+accurate for block-backed filesystems. <please add status regarding NFS and
+CIFS at a later time>
+
+
+write_bytes
+-----------
+
+I/O counter: bytes written
+Attempt to count the number of bytes which this process caused to be sent to
+the storage layer. This is done at page-dirtying time.
+
+
+cancelled_write_bytes
+---------------------
+
+The big inaccuracy here is truncate. If a process writes 1MB to a file and
+then deletes the file, it will in fact perform no writeout. But it will have
+been accounted as having caused 1MB of write.
+In other words: The number of bytes which this process caused to not happen, 
+by truncating pagecache. A task can cause "negative" IO too. If this task
+truncates some dirty pagecache, some IO which another task has been accounted
+for (in it's write_bytes) will not be happening. We _could_ just subtract that
+from the truncating task's write_bytes, but there is information loss in doing
+that.
+
+
+Note
+----
+
+At it's current implementation state, it's a bit racy on 32-bit machines: If 
+process A reads process B's /proc/pid/io while process B is updating one of 
+those 64-bit counters, process A could see an intermediate result.
+
+
+More information about this can be found within taskstats documentation at 
+Documentation/accounting .
+
+------------------------------------------------------------------------------

--=-------------11729582751896115957--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1030262AbXCCOTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262AbXCCOTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030265AbXCCOTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:19:08 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:48206 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030262AbXCCOTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:19:07 -0500
Date: Sat, 03 Mar 2007 15:19:02 +0100
Message-Id: <1661550864@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, balbir@in.ibm.com, csturtiv@sgi.com, daw@sgi.com,
       guillaume.thouvenin@bull.net, jlan@sgi.com, nagar@watson.ibm.com,
       tee@sgi.com
Subject: [RFC] Documentation for io-accounting / reporting via procfs
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

I have tried to compile some docs for the new and very useful io-accounting feature, mostly by grabbing the existing information from lkml/sources.

Feel free to comment, modify, ignore - whatever.

If you like it, maybe this can be merged into Documentation/filesystems/proc.txt  later !?

regards
Roland Kletzing
Sysadmin


--------------------------------------------------------------------------------

/proc/$PID/io   - Show the IO accounting fields.

Example
-------

test:/tmp # dd if=/dev/zero of=/tmp/test.dat &
[1] 3828

test:/tmp # cat /proc/3828/io
rchar: 323934931
wchar: 323929600
syscr: 632687
syscw: 632675
read_bytes: 0
write_bytes: 323932160
cancelled_write_bytes: 0


Description
-----------

rchar: (unsigned long long)

  The number of bytes which this task has caused to be read from storage.
  This is simply the sum of bytes which this process passed to read() and
  pread().  It includes things like tty IO and it is unaffected by whether 
  or not actual physical disk IO was required (the read might have been
  satisfied from pagecache)


wchar: (unsigned long long)

  The number of bytes which this task has caused, or shall cause to be written
  to disk. Similar caveats apply here as with rchar.


syscr: (unsigned long long)

  I/O counter: read syscalls
  Attempt to count the number of read I/O operations, i.e. syscalls like read()
  and pread().


syscw: (unsigned long long)

  I/O counter: write syscalls
  Attempt to count the number of write I/O operations, i.e. syscalls like write()
  and pwrite().


read_bytes: (unsigned long long)

  I/O counter: bytes read
  Attempt to count the number of bytes which this process really did cause to
  be fetched from the storage layer.  Done at the submit_bio() level, so it is
  accurate for block-backed filesystems. <please add status regarding NFS and CIFS
  at a later time>


write_bytes: (unsigned long long)

  I/O counter: bytes written
  Attempt to count the number of bytes which this process caused to be sent to
  the storage layer. This is done at page-dirtying time.


cancelled_write_bytes: (unsigned long long)

  The big inaccuracy here is truncate.  If a process writes 1MB to a file and
  then deletes the file, it will in fact perform no writeout.  But it will have
  been accounted as having caused 1MB of write.
  In other words: The number of bytes which this process caused to not happen,
  by truncating pagecache. A task can cause "negative" IO too.  If this task
  truncates some dirty pagecache, some IO which another task has been accounted
  for (in its write_bytes) will not be happening.  We _could_ just subtract that
  from the truncating task's write_bytes, but there is information loss in doing
  that.


Note:

  At it`s current implementation state, it's a bit racy on 32-bit machines: if process 
  A reads process B's /proc/pid/io while process B is updating one of those 64-bit 
  counters, process A could see an intermediate result.



More information about this can be found within taskstats documentation at
Documentation/accounting

--------------------------------------------------------------------------------




akpm@osdl.org
From: Andrew Morton <akpm@osdl.org>

Add a simple /proc/pid/io to show the IO accounting fields.

Maybe this shouldn't be merged in mainline - the preferred reporting channel
is taskstats. But given the poor state of our userspace support for
taskstats, this is useful for developer-testing, at least. And it improves
the changes that the procps developers will wire it up into top(1). Opinions
are sought.

The patch also wires up the existing IO-accounting fields.

It's a bit racy on 32-bit machines: if process A reads process B's
/proc/pid/io while process B is updating one of those 64-bit counters, process
A could see an intermediate result.

Cc: Jay Lan <jlan@sgi.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Chris Sturtivant <csturtiv@sgi.com>
Cc: Tony Ernst <tee@sgi.com>
Cc: Guillaume Thouvenin <guillaume.thouvenin@bull.net>
Cc: David Wright <daw@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

fs/proc/base.c | 24 ++++++++++++++++++++++++
1 file changed, 24 insertions(+)

diff -puN fs/proc/base.c~io-accounting-report-in-procfs fs/proc/base.c
--- a/fs/proc/base.c~io-accounting-report-in-procfs
+++ a/fs/proc/base.c
@@ -1804,6 +1804,27 @@ static int proc_base_fill_cache(struct f
proc_base_instantiate, task, p);
}

+#ifdef CONFIG_TASK_IO_ACCOUNTING
+static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
+{
+ return sprintf(buffer,
+ "rchar: %llu\n"
+ "wchar: %llu\n"
+ "syscr: %llu\n"
+ "syscw: %llu\n"
+ "read_bytes: %llu\n"
+ "write_bytes: %llu\n"
+ "cancelled_write_bytes: %llu\n",
+ (unsigned long long)task->rchar,
+ (unsigned long long)task->wchar,
+ (unsigned long long)task->syscr,
+ (unsigned long long)task->syscw,
+ (unsigned long long)task->ioac.read_bytes,
+ (unsigned long long)task->ioac.write_bytes,
+ (unsigned long long)task->ioac.cancelled_write_bytes);
+}
+#endif
+
/*
* Thread groups
*/
@@ -1855,6 +1876,9 @@ static struct pid_entry tgid_base_stuff[
#ifdef CONFIG_FAULT_INJECTION
REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
#endif
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+ INF("io", S_IRUGO, pid_io_accounting),
+#endif
};

static int proc_tgid_base_readdir(struct file * filp,
_
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
Please read the FAQ at http://www.tux.org/lkml/
_______________________________________________________________________
Viren-Scan für Ihren PC! Jetzt für jeden. Sofort, online und kostenlos.
Gleich testen! http://www.pc-sicherheit.web.de/freescan/?mc=022222


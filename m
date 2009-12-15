Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbZLOTU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbZLOTU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZLOTU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:20:58 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52567 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbZLOTU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:20:58 -0500
Message-ID: <4B27E191.5050408@us.ibm.com>
Date: Tue, 15 Dec 2009 11:20:49 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] trace-cmd: fix invalid write due to cpus and cpu_count confusion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix invalid write due to cpus and cpu_count confusion

trace-cmd would fail with:

# ./trace-cmd record -e sched ls -ltr
enable sched
cpus: 8   cpu_count: 0
*** glibc detected *** ./trace-cmd: free(): invalid next size (normal): 0x0000000000e760b0 ***
======= Backtrace: =========
/lib64/libc.so.6[0x3f18671ce2]
/lib64/libc.so.6(cfree+0x8c)[0x3f1867590c]
/lib64/libc.so.6(fclose+0x14b)[0x3f18660d0b]
./trace-cmd[0x40397e]
./trace-cmd(main+0x7df)[0x404777]
/lib64/libc.so.6(__libc_start_main+0xf4)[0x3f1861d974]
./trace-cmd[0x4029f9]
======= Memory map: ========
00400000-00418000 r-xp 00000000 08:04 1922384                            /test/dvhart/source/trace-cmd.git/trace-cmd
00617000-00618000 rw-p 00017000 08:04 1922384                            /test/dvhart/source/trace-cmd.git/trace-cmd
00e76000-00e97000 rw-p 00000000 00:00 0                                  [heap]
3f18200000-3f1821c000 r-xp 00000000 08:03 327334                         /lib64/ld-2.5.so
3f1841b000-3f1841c000 r--p 0001b000 08:03 327334                         /lib64/ld-2.5.so
3f1841c000-3f1841d000 rw-p 0001c000 08:03 327334                         /lib64/ld-2.5.so
3f18600000-3f1874c000 r-xp 00000000 08:03 327335                         /lib64/libc-2.5.so
3f1874c000-3f1894c000 ---p 0014c000 08:03 327335                         /lib64/libc-2.5.so
3f1894c000-3f18950000 r--p 0014c000 08:03 327335                         /lib64/libc-2.5.so
3f18950000-3f18951000 rw-p 00150000 08:03 327335                         /lib64/libc-2.5.so
3f18951000-3f18956000 rw-p 00000000 00:00 0 
3f18a00000-3f18a02000 r-xp 00000000 08:03 327341                         /lib64/libdl-2.5.so
3f18a02000-3f18c02000 ---p 00002000 08:03 327341                         /lib64/libdl-2.5.so
3f18c02000-3f18c03000 r--p 00002000 08:03 327341                         /lib64/libdl-2.5.so
3f18c03000-3f18c04000 rw-p 00003000 08:03 327341                         /lib64/libdl-2.5.so
3f19a00000-3f19a0d000 r-xp 00000000 08:03 327350                         /lib64/libgcc_s-4.1.2-20080825.so.1
3f19a0d000-3f19c0d000 ---p 0000d000 08:03 327350                         /lib64/libgcc_s-4.1.2-20080825.so.1
3f19c0d000-3f19c0e000 rw-p 0000d000 08:03 327350                         /lib64/libgcc_s-4.1.2-20080825.so.1
7f4ef8000000-7f4ef8021000 rw-p 00000000 00:00 0 
7f4ef8021000-7f4efc000000 ---p 00000000 00:00 0 
7f4effbea000-7f4effbec000 rw-p 00000000 00:00 0 
7f4effc00000-7f4effc03000 rw-p 00000000 00:00 0 
7ffffb0c5000-7ffffb0da000 rw-p 00000000 00:00 0                          [stack]
7ffffb1ff000-7ffffb200000 r-xp 00000000 00:00 0                          [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
Aborted

The cpus and cpu_count line above I added to understand the ambiguity of
those variables. The cpus variable appears redundant. This patch uses
the global cpu_count directly. If cpu_count should not be updated until
later for some reason, then the code could be updated to use cpus
instead. The way it was however tries to write to pids[] which has a
size of 0.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>

diff --git a/trace-cmd.c b/trace-cmd.c
index aada9a4..0d53e8c 100644
--- a/trace-cmd.c
+++ b/trace-cmd.c
@@ -576,19 +576,17 @@ static int create_recorder(int cpu)
 
 static void start_threads(void)
 {
-	int cpus;
 	int i;
 
-	cpus = count_cpus();
+	cpu_count = count_cpus();
 
 	/* make a thread for every CPU we have */
 	pids = malloc_or_die(sizeof(*pids) * cpu_count);
 
 	memset(pids, 0, sizeof(*pids) * cpu_count);
 
-	cpu_count = cpus;
 
-	for (i = 0; i < cpus; i++) {
+	for (i = 0; i < cpu_count; i++) {
 		pids[i] = create_recorder(i);
 	}
 }
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762832AbZEFWOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762832AbZEFWOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761543AbZEFVzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:09 -0400
Received: from kroah.org ([198.145.64.141]:57372 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761542AbZEFVzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:01 2009
Message-Id: <20090506214801.821197342@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Arjan van de Ven <arjan@linux.intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 47/58] proc: avoid information leaks to non-privileged processes
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=proc-avoid-information-leaks-to-non-privileged-processes.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jake Edge <jake@lwn.net>

commit f83ce3e6b02d5e48b3a43b001390e2b58820389d upstream.

By using the same test as is used for /proc/pid/maps and /proc/pid/smaps,
only allow processes that can ptrace() a given process to see information
that might be used to bypass address space layout randomization (ASLR).
These include eip, esp, wchan, and start_stack in /proc/pid/stat as well
as the non-symbolic output from /proc/pid/wchan.

ASLR can be bypassed by sampling eip as shown by the proof-of-concept
code at http://code.google.com/p/fuzzyaslr/ As part of a presentation
(http://www.cr0.org/paper/to-jt-linux-alsr-leak.pdf) esp and wchan were
also noted as possibly usable information leaks as well.  The
start_stack address also leaks potentially useful information.

Cc: Stable Team <stable@kernel.org>
Signed-off-by: Jake Edge <jake@lwn.net>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/array.c |   13 +++++++++----
 fs/proc/base.c  |    5 ++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -80,6 +80,7 @@
 #include <linux/delayacct.h>
 #include <linux/seq_file.h>
 #include <linux/pid_namespace.h>
+#include <linux/ptrace.h>
 #include <linux/tracehook.h>
 
 #include <asm/pgtable.h>
@@ -352,6 +353,7 @@ static int do_task_stat(struct seq_file 
 	char state;
 	pid_t ppid = 0, pgid = -1, sid = -1;
 	int num_threads = 0;
+	int permitted;
 	struct mm_struct *mm;
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
@@ -364,11 +366,14 @@ static int do_task_stat(struct seq_file 
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
+	permitted = ptrace_may_access(task, PTRACE_MODE_READ);
 	mm = get_task_mm(task);
 	if (mm) {
 		vsize = task_vsize(mm);
-		eip = KSTK_EIP(task);
-		esp = KSTK_ESP(task);
+		if (permitted) {
+			eip = KSTK_EIP(task);
+			esp = KSTK_ESP(task);
+		}
 	}
 
 	get_task_comm(tcomm, task);
@@ -424,7 +429,7 @@ static int do_task_stat(struct seq_file 
 		unlock_task_sighand(task, &flags);
 	}
 
-	if (!whole || num_threads < 2)
+	if (permitted && (!whole || num_threads < 2))
 		wchan = get_wchan(task);
 	if (!whole) {
 		min_flt = task->min_flt;
@@ -476,7 +481,7 @@ static int do_task_stat(struct seq_file 
 		rsslim,
 		mm ? mm->start_code : 0,
 		mm ? mm->end_code : 0,
-		mm ? mm->start_stack : 0,
+		(permitted && mm) ? mm->start_stack : 0,
 		esp,
 		eip,
 		/* The signal information here is obsolete.
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -321,7 +321,10 @@ static int proc_pid_wchan(struct task_st
 	wchan = get_wchan(task);
 
 	if (lookup_symbol_name(wchan, symname) < 0)
-		return sprintf(buffer, "%lu", wchan);
+		if (!ptrace_may_access(task, PTRACE_MODE_READ))
+			return 0;
+		else
+			return sprintf(buffer, "%lu", wchan);
 	else
 		return sprintf(buffer, "%s", symname);
 }



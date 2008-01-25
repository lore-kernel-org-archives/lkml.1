Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbYAYWBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbYAYWBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbYAYWBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:01:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:65405 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbYAYWBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:01:37 -0500
Message-ID: <479A5C35.6040605@windriver.com>
Date: Fri, 25 Jan 2008 16:01:25 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] [KGDB] core code cleanups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2008 22:01:13.0666 (UTC) FILETIME=[CD2A3A20:01C85F9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is against the x86-git which included the kgdb core.

Per review request from the x86-git maintainers, the kgdb-core has had
the kgdb_handle_exception() separated into individual functions.  This
patch does nothing other than re-organize the code.  There are no
functional kgdb changes.

kgdb_handle_exception now calls gdb_serial_stub() to handle the
debugger communications.  The gdb_serial_stub() has call out to sub
handlers for all the major gdb serial packet types.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 kernel/kgdb.c | 1144 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 636 insertions(+), 508 deletions(-)

--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -147,6 +147,18 @@ struct debuggerinfo_struct {
 	struct task_struct *task;
 } kgdb_info[NR_CPUS];
 
+struct kgdb_state {
+	int all_cpus_synced;
+	int ex_vector;
+	int signo;
+	int err_code;
+	int processor;
+	int pass_exception;
+	long threadid;
+	long kgdb_usethreadid;
+	struct pt_regs *linux_regs;
+};
+
 /* to keep track of the CPU which is doing the single stepping*/
 atomic_t cpu_doing_single_step = ATOMIC_INIT(-1);
 int kgdb_softlock_skip[NR_CPUS];
@@ -932,9 +944,588 @@ int kgdb_io_ready(int print_wait)
 	return 1;
 }
 
+/* All the functions that start with gdb_cmd are the various
+ * operations to implement the handlers for the gdbserial protocol
+ * where KGDB is communicating with an external debugger
+ */
+/* Handle the '?' status packets */
+static void gdb_cmd_status(struct kgdb_state *ks)
+{
+	/* We know that this packet is only sent
+	 * during initial connect.  So to be safe,
+	 * we clear out our breakpoints now in case
+	 * GDB is reconnecting. */
+	remove_all_break();
+	/* Also, if we haven't been able to roundup all
+	 * CPUs, send an 'O' packet informing the user
+	 * as much.  Only need to do this once. */
+	if (!ks->all_cpus_synced)
+		kgdb_msg_write("Not all CPUs have been "
+					   "synced for KGDB\n", 39);
+	remcom_out_buffer[0] = 'S';
+	remcom_out_buffer[1] = hexchars[ks->signo >> 4];
+	remcom_out_buffer[2] = hexchars[ks->signo % 16];
+}
+
+/* Handle the 'g' get registers request */
+static void gdb_cmd_getregs(struct kgdb_state *ks)
+{
+	struct pt_regs *shadowregs;
+	struct task_struct *thread;
+	void *local_debuggerinfo;
+	int i;
+
+	thread = kgdb_usethread;
+	if (!thread) {
+		thread = kgdb_info[ks->processor].task;
+		local_debuggerinfo =
+			kgdb_info[ks->processor].debuggerinfo;
+	} else {
+		local_debuggerinfo = NULL;
+		for (i = 0; i < NR_CPUS; i++) {
+			/* Try to find the task on some other
+			 * or possibly this node if we do not
+			 * find the matching task then we try
+			 * to approximate the results.
+			 */
+			if (thread == kgdb_info[i].task)
+				local_debuggerinfo =
+					kgdb_info[i].debuggerinfo;
+		}
+	}
+
+	/* All threads that don't have debuggerinfo should be
+	 * in __schedule() sleeping, since all other CPUs
+	 * are in kgdb_wait, and thus have debuggerinfo. */
+	if (kgdb_ops->shadowth &&
+		ks->kgdb_usethreadid >= pid_max + num_online_cpus()) {
+		shadowregs = kgdb_shadow_regs(ks->linux_regs,
+					  ks->kgdb_usethreadid -
+					  pid_max -
+					  num_online_cpus());
+		if (!shadowregs) {
+			error_packet(remcom_out_buffer,
+						 -EINVAL);
+			return;
+		}
+		regs_to_gdb_regs(gdb_regs, shadowregs);
+	} else if (local_debuggerinfo)
+		regs_to_gdb_regs(gdb_regs, local_debuggerinfo);
+	else {
+		/* Pull stuff saved during
+		 * switch_to; nothing else is
+		 * accessible (or even particularly relevant).
+		 * This should be enough for a stack trace. */
+		sleeping_thread_to_gdb_regs(gdb_regs, thread);
+	}
+	kgdb_mem2hex((char *)gdb_regs, remcom_out_buffer,
+				 NUMREGBYTES);
+}
+
+/* Handle the 'G' set registers request */
+static void gdb_cmd_setregs(struct kgdb_state *ks)
+{
+	kgdb_hex2mem(&remcom_in_buffer[1], (char *)gdb_regs,
+				 NUMREGBYTES);
+
+	if (kgdb_usethread && kgdb_usethread != current)
+		error_packet(remcom_out_buffer, -EINVAL);
+	else {
+		gdb_regs_to_regs(gdb_regs, ks->linux_regs);
+		strcpy(remcom_out_buffer, "OK");
+	}
+}
+
+/* Handle the 'm' memory read bytes */
+static void gdb_cmd_memread(struct kgdb_state *ks)
+{
+	unsigned long addr;
+	unsigned long length;
+	char *ptr = &remcom_in_buffer[1];
+
+	if (kgdb_hex2long(&ptr, &addr) > 0 && *ptr++ == ',' &&
+		kgdb_hex2long(&ptr, &length) > 0) {
+		ptr = kgdb_mem2hex((char *)addr,
+				   remcom_out_buffer,
+				   length);
+		if (IS_ERR(ptr))
+			error_packet(remcom_out_buffer, PTR_ERR(ptr));
+	} else
+		error_packet(remcom_out_buffer, -EINVAL);
+}
+
+/* Handle the 'M' memory write bytes */
+static void gdb_cmd_memwrite(struct kgdb_state *ks)
+{
+	char *ptr = write_mem_msg(0);
+
+	if (IS_ERR(ptr))
+		error_packet(remcom_out_buffer, PTR_ERR(ptr));
+	else
+		strcpy(remcom_out_buffer, "OK");
+}
+
+/* Handle the 'X' memory binary write bytes */
+static void gdb_cmd_binwrite(struct kgdb_state *ks)
+{
+	char *ptr = write_mem_msg(1);
+
+	if (IS_ERR(ptr))
+		error_packet(remcom_out_buffer, PTR_ERR(ptr));
+	else
+		strcpy(remcom_out_buffer, "OK");
+}
+
+/* Handle the 'D' or 'k', detach or kill packets */
+static void gdb_cmd_detachkill(struct kgdb_state *ks)
+{
+	int error;
+
+	/* The detach case */
+	if (remcom_in_buffer[0] == 'D') {
+		error = remove_all_break();
+		if (error < 0)
+			error_packet(remcom_out_buffer, error);
+		else {
+			strcpy(remcom_out_buffer, "OK");
+			kgdb_connected = 0;
+		}
+		put_packet(remcom_out_buffer);
+	} else {
+	/* Assume the kill case, with no exit code checking, trying to
+	 * force detach the debugger
+	 */
+		remove_all_break();
+		kgdb_connected = 0;
+	}
+}
+
+
+/* Handle the 'R' reboot packets */
+static int gdb_cmd_reboot(struct kgdb_state *ks)
+{
+	/* For now, only honor R0 */
+	if (strcmp(remcom_in_buffer, "R0") == 0) {
+		printk(KERN_CRIT "Executing reboot\n");
+		strcpy(remcom_out_buffer, "OK");
+		put_packet(remcom_out_buffer);
+		emergency_sync();
+		/* Execution should not return from
+		 * machine_restart()
+		 */
+		machine_restart(NULL);
+		kgdb_connected = 0;
+		return 1;
+	}
+
+	return 0;
+}
+
+
+/* Handle the 'q' query packets */
+static void gdb_cmd_query(struct kgdb_state *ks)
+{
+	char *ptr;
+	int i;
+	struct task_struct *thread;
+	int numshadowth = num_online_cpus() + kgdb_ops->shadowth;
+	unsigned char thref[8];
+
+	switch (remcom_in_buffer[1]) {
+	case 's':
+	case 'f':
+		if (memcmp(remcom_in_buffer + 2, "ThreadInfo", 10)) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			break;
+		}
+
+		/*
+		 * If we have not yet completed in
+		 * pidhash_init() there isn't much we
+		 * can give back.
+		 */
+		if (init_pid_ns.last_pid == 0) {
+			if (remcom_in_buffer[1] == 'f')
+				strcpy(remcom_out_buffer,
+				"m0000000000000001");
+			break;
+		}
+
+		if (remcom_in_buffer[1] == 'f')
+			ks->threadid = 1;
+
+		remcom_out_buffer[0] = 'm';
+		ptr = remcom_out_buffer + 1;
+		for (i = 0; i < 17 && ks->threadid < pid_max + numshadowth;
+			 ks->threadid++) {
+			thread = getthread(ks->linux_regs, ks->threadid);
+			if (thread) {
+				int_to_threadref(thref, ks->threadid);
+				pack_threadid(ptr, thref);
+				ptr += 16;
+				*(ptr++) = ',';
+				i++;
+			}
+		}
+		*(--ptr) = '\0';
+		break;
+
+	case 'C':
+		/* Current thread id */
+		strcpy(remcom_out_buffer, "QC");
+		ks->threadid = shadow_pid(current->pid);
+		int_to_threadref(thref, ks->threadid);
+		pack_threadid(remcom_out_buffer + 2, thref);
+		break;
+	case 'T':
+		if (memcmp(remcom_in_buffer + 1,
+				   "ThreadExtraInfo,", 16)) {
+			error_packet(remcom_out_buffer,
+						 -EINVAL);
+			break;
+		}
+		ks->threadid = 0;
+		ptr = remcom_in_buffer + 17;
+		kgdb_hex2long(&ptr, &ks->threadid);
+		if (!getthread(ks->linux_regs, ks->threadid)) {
+			error_packet(remcom_out_buffer,
+						 -EINVAL);
+			break;
+		}
+		if (ks->threadid < pid_max)
+			kgdb_mem2hex(getthread(ks->linux_regs,
+					ks->threadid)->comm,
+					remcom_out_buffer, 16);
+		else if (ks->threadid >= pid_max + num_online_cpus())
+			kgdb_shadowinfo(ks->linux_regs,
+					remcom_out_buffer,
+					ks->threadid - pid_max -
+					num_online_cpus());
+		else {
+			static char tmpstr[23 + BUF_THREAD_ID_SIZE];
+			sprintf(tmpstr, "Shadow task %d for pid 0",
+					(int)(ks->threadid - pid_max));
+			kgdb_mem2hex(tmpstr, remcom_out_buffer,
+						 strlen(tmpstr));
+		}
+		break;
+	}
+}
+
+/* Handle the 'H' task query packets */
+static void gdb_cmd_task(struct kgdb_state *ks)
+{
+	struct task_struct *thread;
+	char *ptr;
+
+	switch (remcom_in_buffer[1]) {
+	case 'g':
+		ptr = &remcom_in_buffer[2];
+		kgdb_hex2long(&ptr, &ks->threadid);
+		thread = getthread(ks->linux_regs, ks->threadid);
+		if (!thread && ks->threadid > 0) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			break;
+		}
+		kgdb_usethread = thread;
+		ks->kgdb_usethreadid = ks->threadid;
+		strcpy(remcom_out_buffer, "OK");
+		break;
+	case 'c':
+		ptr = &remcom_in_buffer[2];
+		kgdb_hex2long(&ptr, &ks->threadid);
+		if (!ks->threadid)
+			kgdb_contthread = NULL;
+		else {
+			thread = getthread(ks->linux_regs,
+							   ks->threadid);
+			if (!thread && ks->threadid > 0) {
+				error_packet(remcom_out_buffer, -EINVAL);
+				break;
+			}
+			kgdb_contthread = thread;
+		}
+		strcpy(remcom_out_buffer, "OK");
+		break;
+	}
+}
+
+/* Handle the 'T' thread query packets */
+static void gdb_cmd_thread(struct kgdb_state *ks)
+{
+	char *ptr = &remcom_in_buffer[1];
+	struct task_struct *thread;
+
+	kgdb_hex2long(&ptr, &ks->threadid);
+	thread = getthread(ks->linux_regs, ks->threadid);
+	if (thread)
+		strcpy(remcom_out_buffer, "OK");
+	else
+		error_packet(remcom_out_buffer, -EINVAL);
+}
+
+/* Handle the 'z' or 'Z' breakpoint remove or set packets */
+static void gdb_cmd_break(struct kgdb_state *ks)
+{
+	/* Since GDB-5.3, it's been drafted that '0' is a software
+	 * breakpoint, '1' is a hardware breakpoint, so let's do that.
+	 */
+	char *bpt_type = &remcom_in_buffer[1];
+	char *ptr = &remcom_in_buffer[2];
+	unsigned long addr;
+	unsigned long length;
+	int error = 0;
+
+	if (kgdb_ops->set_hw_breakpoint && *bpt_type >= '1') {
+		/* Unsupported */
+		if (*bpt_type > '4')
+			return;
+	} else if (*bpt_type != '0' && *bpt_type != '1')
+		/* Unsupported. */
+		return;
+	/* Test if this is a hardware breakpoint, and
+	 * if we support it. */
+	if (*bpt_type == '1' &&
+		!(kgdb_ops->flags & KGDB_HW_BREAKPOINT))
+		/* Unsupported. */
+		return;
+
+	if (*(ptr++) != ',') {
+		error_packet(remcom_out_buffer, -EINVAL);
+		return;
+	} else if (kgdb_hex2long(&ptr, &addr)) {
+		if (*(ptr++) != ',' ||
+			!kgdb_hex2long(&ptr, &length)) {
+			error_packet(remcom_out_buffer, -EINVAL);
+			return;
+		}
+	} else {
+		error_packet(remcom_out_buffer, -EINVAL);
+		return;
+	}
+
+	if (remcom_in_buffer[0] == 'Z' && *bpt_type == '0')
+		error = kgdb_set_sw_break(addr);
+	else if (remcom_in_buffer[0] == 'z' && *bpt_type == '0')
+		error = kgdb_remove_sw_break(addr);
+	else if (remcom_in_buffer[0] == 'Z')
+		error = kgdb_ops->set_hw_breakpoint(addr,
+			(int)length, *bpt_type);
+	else if (remcom_in_buffer[0] == 'z')
+		error = kgdb_ops->remove_hw_breakpoint(addr,
+			(int) length, *bpt_type);
+
+	if (error == 0)
+		strcpy(remcom_out_buffer, "OK");
+	else
+		error_packet(remcom_out_buffer, error);
+}
+
+/* Handle the 'C' signal / exception passing packets */
+static int gdb_cmd_exception_pass(struct kgdb_state *ks)
+{
+	/* C09 == pass exception
+	 * C15 == detach kgdb, pass exception
+	 * C30 == detach kgdb, stop attachwait, pass exception
+	 */
+	if (remcom_in_buffer[1] == '0' &&
+		remcom_in_buffer[2] == '9') {
+		ks->pass_exception = 1;
+		remcom_in_buffer[0] = 'c';
+	} else if (remcom_in_buffer[1] == '1' &&
+			   remcom_in_buffer[2] == '5') {
+		ks->pass_exception = 1;
+		remcom_in_buffer[0] = 'D';
+		remove_all_break();
+		kgdb_connected = 0;
+		return 1;
+	} else if (remcom_in_buffer[1] == '3' &&
+			   remcom_in_buffer[2] == '0') {
+		ks->pass_exception = 1;
+		attachwait = 0;
+		remcom_in_buffer[0] = 'D';
+		remove_all_break();
+		kgdb_connected = 0;
+		return 1;
+	} else {
+		error_packet(remcom_out_buffer, -EINVAL);
+	    return 0;
+	}
+
+	/* Indicate fall through */
+	return -1;
+}
 
 /*
- * This function does all command procesing for interfacing to gdb.
+ * This function performs all gdbserial command procesing
+ */
+static int gdb_serial_stub(struct kgdb_state *ks)
+{
+	int error = 0;
+	int tmp;
+
+	/* Clear the out buffer. */
+	memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
+
+	if (kgdb_connected) {
+		unsigned char thref[8];
+		char *ptr;
+		/* Warn debugger if the CPUs are not synced with an 'O'
+		 * packet */
+		if (!ks->all_cpus_synced)
+			kgdb_msg_write("Not all CPUs have been synced for "
+			       "KGDB\n", 39);
+		/* Reply to host that an exception has occurred */
+		ptr = remcom_out_buffer;
+		*ptr++ = 'T';
+		*ptr++ = hexchars[(ks->signo >> 4) % 16];
+		*ptr++ = hexchars[ks->signo % 16];
+		ptr += strlen(strcpy(ptr, "thread:"));
+		int_to_threadref(thref, shadow_pid(current->pid));
+		ptr = pack_threadid(ptr, thref);
+		*ptr++ = ';';
+		put_packet(remcom_out_buffer);
+	}
+
+	kgdb_usethread = kgdb_info[ks->processor].task;
+	ks->kgdb_usethreadid = shadow_pid(kgdb_info[ks->processor].task->pid);
+	ks->pass_exception = 0;
+
+	while (kgdb_io_ops.read_char) {
+		error = 0;
+
+		/* Clear the out buffer. */
+		memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
+
+		get_packet(remcom_in_buffer);
+
+		switch (remcom_in_buffer[0]) {
+		case '?': /* gdbserial status */
+			gdb_cmd_status(ks);
+			break;
+		case 'g': /* return the value of the CPU registers */
+			gdb_cmd_getregs(ks);
+			break;
+		case 'G': /* set the value of the CPU registers - return OK */
+			gdb_cmd_setregs(ks);
+			break;
+		case 'm': /* mAA..AA,LLLL  Read LLLL bytes at address AA..AA */
+			gdb_cmd_memread(ks);
+			break;
+		case 'M': /* MAA..AA,LLLL: Write LLLL bytes at address AA..AA */
+			gdb_cmd_memwrite(ks);
+			break;
+		case 'X': /* XAA..AA,LLLL: Write LLLL bytes at address AA..AA */
+			gdb_cmd_binwrite(ks);
+			break;
+			/* kill or detach. KGDB should treat this like a
+			 * continue.
+			 */
+		case 'D': /* Debugger detach */
+		case 'k': /* Debugger detach via kill */
+			gdb_cmd_detachkill(ks);
+			goto default_handle;
+		case 'R': /* Reboot */
+			if (gdb_cmd_reboot(ks))
+				goto default_handle;
+			break;
+		case 'q': /* query command */
+			gdb_cmd_query(ks);
+			break;
+		case 'H': /* task related */
+			gdb_cmd_task(ks);
+			break;
+		case 'T': /* Query thread status */
+			gdb_cmd_thread(ks);
+			break;
+		case 'z': /* Break point remove */
+		case 'Z': /* Break point set */
+			gdb_cmd_break(ks);
+			break;
+		case 'C': /* Exception passing */
+			tmp = gdb_cmd_exception_pass(ks);
+			if (tmp > 0)
+				goto default_handle;
+			if (tmp == 0)
+				break;
+			/* Fall through on tmp < 0 */
+		case 'c': /* Continue packet */
+		case 's': /* Single step packet */
+			if (kgdb_contthread && kgdb_contthread != current) {
+				/* Can't switch threads in kgdb */
+				error_packet(remcom_out_buffer, -EINVAL);
+				break;
+			}
+			kgdb_activate_sw_breakpoints();
+			/* Fall through to default processing */
+		default:
+default_handle:
+			error = kgdb_arch_handle_exception(ks->ex_vector,
+						ks->signo,
+						ks->err_code,
+						remcom_in_buffer,
+						remcom_out_buffer,
+						ks->linux_regs);
+			/* Leave cmd processing on error, detach,
+			 * kill, continue, or single step.
+			 */
+			if (error >= 0 || remcom_in_buffer[0] == 'D' ||
+			    remcom_in_buffer[0] == 'k') {
+				error = 0;
+				goto kgdb_exit;
+			}
+
+		}		/* switch */
+
+		/* reply to the request */
+		put_packet(remcom_out_buffer);
+	}
+
+kgdb_exit:
+	if (ks->pass_exception)
+		error = 1;
+	return error;
+}
+
+static int kgdb_reenter_check(struct kgdb_state *ks)
+{
+	unsigned long addr;
+	if (atomic_read(&debugger_active) != raw_smp_processor_id() + 1)
+		return 0;
+
+	/* Panic on recursive debugger calls. */
+	exception_level++;
+	addr = kgdb_arch_pc(ks->ex_vector, ks->linux_regs);
+	kgdb_deactivate_sw_breakpoints();
+	/* If the break point removed ok at the place exception
+	 * occurred, try to recover and print a warning to the end
+	 * user because the user planted a breakpoint in a place that
+	 * KGDB needs in order to function.
+	 */
+	if (kgdb_remove_sw_break(addr) == 0) {
+		exception_level = 0;
+		kgdb_skipexception(ks->ex_vector, ks->linux_regs);
+		kgdb_activate_sw_breakpoints();
+		printk(KERN_CRIT
+		   "KGDB: re-enter error: breakpoint removed\n");
+		WARN_ON(1);
+		return 1;
+	}
+	remove_all_break();
+	kgdb_skipexception(ks->ex_vector, ks->linux_regs);
+	if (exception_level > 1) {
+		dump_stack();
+		panic("Recursive entry to debugger");
+	}
+
+	printk(KERN_CRIT
+		   "KGDB: re-enter exception: ALL breakpoints killed\n");
+	dump_stack();
+	panic("Recursive entry to debugger");
+	return 1;
+}
+
+/* kgdb_handle_exception() - main entry point from a kernel exception
  *
  * Locking hierarchy:
  *	interface locks, if any (begin_session)
@@ -945,56 +1536,27 @@ int kgdb_io_ready(int print_wait)
  * of a for_each_online_cpu.
  *
  */
-int kgdb_handle_exception(int ex_vector, int signo, int err_code,
-			  struct pt_regs *linux_regs)
+int kgdb_handle_exception(int evector, int signo, int ecode,
+			  struct pt_regs *regs)
 {
-	unsigned long length;
-	unsigned long addr;
-	char *ptr;
 	unsigned long flags;
 	unsigned i;
-	long threadid;
-	unsigned char thref[8];
-	struct task_struct *thread = NULL;
 	unsigned procid;
-	int numshadowth = num_online_cpus() + kgdb_ops->shadowth;
-	long kgdb_usethreadid = 0;
 	int error = 0;
-	int all_cpus_synced = 0;
-	struct pt_regs *shadowregs;
-	int processor = raw_smp_processor_id();
-	void *local_debuggerinfo;
-	int pass_exception = 0;
+	struct kgdb_state kgdb_var;
+	struct kgdb_state *ks = &kgdb_var;
 
-	/* Panic on recursive debugger calls. */
-	if (atomic_read(&debugger_active) == raw_smp_processor_id() + 1) {
-		exception_level++;
-		addr = kgdb_arch_pc(ex_vector, linux_regs);
-		kgdb_deactivate_sw_breakpoints();
-		/* If the break point removed ok at the place exception
-		 * occurred, try to recover and print a warning to the end
-		 * user because the user planted a breakpoint in a place that
-		 * KGDB needs in order to function.
-		 */
-		if (kgdb_remove_sw_break(addr) == 0) {
-			exception_level = 0;
-			kgdb_skipexception(ex_vector, linux_regs);
-			kgdb_activate_sw_breakpoints();
-			printk(KERN_CRIT
-			"KGDB: re-enter error: breakpoint removed\n");
-			WARN_ON(1);
-			return 0;
-		}
-		remove_all_break();
-		kgdb_skipexception(ex_vector, linux_regs);
-		if (exception_level > 1)
-			panic("Recursive entry to debugger");
+	ks->processor = raw_smp_processor_id();
+	ks->all_cpus_synced = 0;
+	ks->ex_vector = evector;
+	ks->signo = signo;
+	ks->ex_vector = evector;
+	ks->err_code = ecode;
+	ks->kgdb_usethreadid = 0;
+	ks->linux_regs = regs;
 
-		printk(KERN_CRIT
-			"KGDB: re-enter exception: ALL breakpoints killed\n");
-		panic("Recursive entry to debugger");
-		return 0;
-	}
+	if (kgdb_reenter_check(ks))
+		return 0; /* Ouch, double exception ! */
 
  acquirelock:
 
@@ -1004,9 +1566,13 @@ int kgdb_handle_exception(int ex_vector,
 	 */
 	local_irq_save(flags);
 
-	/* Hold debugger_active */
 	procid = raw_smp_processor_id();
 
+	/* Being the process of declaring a master debug processor, the
+	 * goal is to have only one single processor set debugger_active
+	 * to the number of the cpu + 1.  The atomic variable kgdb_sync is
+	 * used to control the selection.
+	 */
 	while (1) {
 		int i = 25;	/* an arbitrary number */
 		if (atomic_read(&kgdb_sync) < 0 &&
@@ -1024,8 +1590,9 @@ int kgdb_handle_exception(int ex_vector,
 	}
 
 	/*
-	 * Don't enter if the last instance of the exception handler wanted to
-	 * come into the debugger again.
+	 * Do not start the debugger connection on this CPU if the last
+	 * instance of the exception handler wanted to come into the
+	 * debugger on a different CPU via a single step
 	 */
 	if (atomic_read(&cpu_doing_single_step) != -1 &&
 	    atomic_read(&cpu_doing_single_step) != procid) {
@@ -1039,40 +1606,40 @@ int kgdb_handle_exception(int ex_vector,
 
 	if (!kgdb_io_ready(1)) {
 		error = 1;
-		goto kgdb_restore;
+		goto kgdb_restore; /* No I/O connection, so resume the system */
 	}
 
 	/*
-	* Don't enter if we have hit a removed breakpoint.
-	*/
-	if (kgdb_skipexception(ex_vector, linux_regs))
+	 * Don't enter if we have hit a removed breakpoint.
+	 */
+	if (kgdb_skipexception(ks->ex_vector, ks->linux_regs))
 		goto kgdb_restore;
 
-	/*
-	 * Call the I/O drivers pre_exception routine
-	 * if the I/O driver defined one
-	 */
+	/* Call the I/O driver's pre_exception routine */
 	if (kgdb_io_ops.pre_exception)
 		kgdb_io_ops.pre_exception();
 
-	kgdb_info[processor].debuggerinfo = linux_regs;
-	kgdb_info[processor].task = current;
+	kgdb_info[ks->processor].debuggerinfo = ks->linux_regs;
+	kgdb_info[ks->processor].task = current;
 
-	kgdb_disable_hw_debug(linux_regs);
+	kgdb_disable_hw_debug(ks->linux_regs);
 
+	/* Get the slave CPU lock which will hold all the non-master
+	 * processors in a spin state while the debugger is active
+	 */
 	if (!debugger_step || !kgdb_contthread)
 		for (i = 0; i < NR_CPUS; i++)
 			spin_lock(&slavecpulocks[i]);
 
 #ifdef CONFIG_SMP
-	/* Make sure we get the other CPUs */
+	/* Signal the other CPUs to enter kgdb_wait() */
 	if (!debugger_step || !kgdb_contthread)
 		kgdb_roundup_cpus(flags);
 #endif
 
 	/* spin_lock code is good enough as a barrier so we don't
 	 * need one here */
-	atomic_set(&procindebug[processor], 1);
+	atomic_set(&procindebug[ks->processor], 1);
 
 	/* Wait a reasonable time for the other CPUs to be notified and
 	 * be waiting for us.  Very early on this could be imperfect
@@ -1085,467 +1652,28 @@ int kgdb_handle_exception(int ex_vector,
 				num++;
 		}
 		if (num >= num_online_cpus()) {
-			all_cpus_synced = 1;
+			ks->all_cpus_synced = 1;
 			break;
 		}
 	}
 
-	/* Clear the out buffer. */
-	memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
-
 	/* Master processor is completely in the debugger */
-	kgdb_post_master_code(linux_regs, ex_vector, err_code);
+	kgdb_post_master_code(ks->linux_regs, ks->ex_vector, ks->err_code);
 	kgdb_deactivate_sw_breakpoints();
 	debugger_step = 0;
 	kgdb_contthread = NULL;
 	exception_level = 0;
 
-	if (kgdb_connected) {
-		/* If we're still unable to roundup all of the CPUs,
-		 * send an 'O' packet informing the user again. */
-		if (!all_cpus_synced)
-			kgdb_msg_write("Not all CPUs have been synced for "
-				       "KGDB\n", 39);
-		/* Reply to host that an exception has occurred */
-		ptr = remcom_out_buffer;
-		*ptr++ = 'T';
-		*ptr++ = hexchars[(signo >> 4) % 16];
-		*ptr++ = hexchars[signo % 16];
-		ptr += strlen(strcpy(ptr, "thread:"));
-		int_to_threadref(thref, shadow_pid(current->pid));
-		ptr = pack_threadid(ptr, thref);
-		*ptr++ = ';';
-
-		put_packet(remcom_out_buffer);
-	}
-
-	kgdb_usethread = kgdb_info[processor].task;
-	kgdb_usethreadid = shadow_pid(kgdb_info[processor].task->pid);
-
-	while (kgdb_io_ops.read_char) {
-		char *bpt_type;
-		error = 0;
-
-		/* Clear the out buffer. */
-		memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
-
-		get_packet(remcom_in_buffer);
-
-		switch (remcom_in_buffer[0]) {
-		case '?':
-			/* We know that this packet is only sent
-			 * during initial connect.  So to be safe,
-			 * we clear out our breakpoints now incase
-			 * GDB is reconnecting. */
-			remove_all_break();
-			/* Also, if we haven't been able to roundup all
-			 * CPUs, send an 'O' packet informing the user
-			 * as much.  Only need to do this once. */
-			if (!all_cpus_synced)
-				kgdb_msg_write("Not all CPUs have been "
-					       "synced for KGDB\n", 39);
-			remcom_out_buffer[0] = 'S';
-			remcom_out_buffer[1] = hexchars[signo >> 4];
-			remcom_out_buffer[2] = hexchars[signo % 16];
-			break;
-
-		case 'g':	/* return the value of the CPU registers */
-			thread = kgdb_usethread;
-
-			if (!thread) {
-				thread = kgdb_info[processor].task;
-				local_debuggerinfo =
-				    kgdb_info[processor].debuggerinfo;
-			} else {
-				local_debuggerinfo = NULL;
-				for (i = 0; i < NR_CPUS; i++) {
-					/* Try to find the task on some other
-					 * or possibly this node if we do not
-					 * find the matching task then we try
-					 * to approximate the results.
-					 */
-					if (thread == kgdb_info[i].task)
-						local_debuggerinfo =
-						    kgdb_info[i].debuggerinfo;
-				}
-			}
-
-			/* All threads that don't have debuggerinfo should be
-			 * in __schedule() sleeping, since all other CPUs
-			 * are in kgdb_wait, and thus have debuggerinfo. */
-			if (kgdb_ops->shadowth &&
-			    kgdb_usethreadid >= pid_max + num_online_cpus()) {
-				shadowregs = kgdb_shadow_regs(linux_regs,
-							      kgdb_usethreadid -
-							      pid_max -
-							      num_online_cpus
-							      ());
-				if (!shadowregs) {
-					error_packet(remcom_out_buffer,
-						     -EINVAL);
-					break;
-				}
-				regs_to_gdb_regs(gdb_regs, shadowregs);
-			} else if (local_debuggerinfo)
-				regs_to_gdb_regs(gdb_regs, local_debuggerinfo);
-			else {
-				/* Pull stuff saved during
-				 * switch_to; nothing else is
-				 * accessible (or even particularly relevant).
-				 * This should be enough for a stack trace. */
-				sleeping_thread_to_gdb_regs(gdb_regs, thread);
-			}
-			kgdb_mem2hex((char *)gdb_regs, remcom_out_buffer,
-				     NUMREGBYTES);
-			break;
-
-			/* set the value of the CPU registers - return OK */
-		case 'G':
-			kgdb_hex2mem(&remcom_in_buffer[1], (char *)gdb_regs,
-				     NUMREGBYTES);
-
-			if (kgdb_usethread && kgdb_usethread != current)
-				error_packet(remcom_out_buffer, -EINVAL);
-			else {
-				gdb_regs_to_regs(gdb_regs, linux_regs);
-				strcpy(remcom_out_buffer, "OK");
-			}
-			break;
-
-			/* mAA..AA,LLLL  Read LLLL bytes at address AA..AA */
-		case 'm':
-			ptr = &remcom_in_buffer[1];
-			if (kgdb_hex2long(&ptr, &addr) > 0 && *ptr++ == ',' &&
-			    kgdb_hex2long(&ptr, &length) > 0) {
-				ptr = kgdb_mem2hex((char *)addr,
-					remcom_out_buffer,
-					length);
-				if (IS_ERR(ptr))
-					error_packet(remcom_out_buffer,
-						     PTR_ERR(ptr));
-			} else
-				error_packet(remcom_out_buffer, -EINVAL);
-			break;
-
-			/* MAA..AA,LLLL: Write LLLL bytes at address AA..AA */
-		case 'M':
-			ptr = write_mem_msg(0);
-			if (IS_ERR(ptr))
-				error_packet(remcom_out_buffer, PTR_ERR(ptr));
-			else
-				strcpy(remcom_out_buffer, "OK");
-			break;
-			/* XAA..AA,LLLL: Write LLLL bytes at address AA..AA */
-		case 'X':
-			ptr = write_mem_msg(1);
-			if (IS_ERR(ptr))
-				error_packet(remcom_out_buffer, PTR_ERR(ptr));
-			else
-				strcpy(remcom_out_buffer, "OK");
-			break;
-
-			/* kill or detach. KGDB should treat this like a
-			 * continue.
-			 */
-		case 'D':
-			error = remove_all_break();
-			if (error < 0)
-				error_packet(remcom_out_buffer, error);
-			else {
-				strcpy(remcom_out_buffer, "OK");
-				kgdb_connected = 0;
-			}
-			put_packet(remcom_out_buffer);
-			goto default_handle;
-
-		case 'k':
-			/* Don't care about error from remove_all_break */
-			remove_all_break();
-			kgdb_connected = 0;
-			goto default_handle;
-
-			/* Reboot */
-		case 'R':
-			/* For now, only honor R0 */
-			if (strcmp(remcom_in_buffer, "R0") == 0) {
-				printk(KERN_CRIT "Executing reboot\n");
-				strcpy(remcom_out_buffer, "OK");
-				put_packet(remcom_out_buffer);
-				emergency_sync();
-				/* Execution should not return from
-				 * machine_restart()
-				 */
-				machine_restart(NULL);
-				kgdb_connected = 0;
-				goto default_handle;
-			}
-
-			/* query */
-		case 'q':
-			switch (remcom_in_buffer[1]) {
-			case 's':
-			case 'f':
-				if (memcmp(remcom_in_buffer + 2, "ThreadInfo",
-					   10)) {
-					error_packet(remcom_out_buffer,
-						     -EINVAL);
-					break;
-				}
-
-				/*
-				 * If we have not yet completed in
-				 * pidhash_init() there isn't much we
-				 * can give back.
-				 */
-				if (init_pid_ns.last_pid == 0) {
-					if (remcom_in_buffer[1] == 'f')
-						strcpy(remcom_out_buffer,
-						       "m0000000000000001");
-					break;
-				}
-
-				if (remcom_in_buffer[1] == 'f')
-					threadid = 1;
-
-				remcom_out_buffer[0] = 'm';
-				ptr = remcom_out_buffer + 1;
-				for (i = 0; i < 17 && threadid < pid_max +
-				     numshadowth; threadid++) {
-					thread = getthread(linux_regs,
-							   threadid);
-					if (thread) {
-						int_to_threadref(thref,
-								 threadid);
-						pack_threadid(ptr, thref);
-						ptr += 16;
-						*(ptr++) = ',';
-						i++;
-					}
-				}
-				*(--ptr) = '\0';
-				break;
-
-			case 'C':
-				/* Current thread id */
-				strcpy(remcom_out_buffer, "QC");
-
-				threadid = shadow_pid(current->pid);
-
-				int_to_threadref(thref, threadid);
-				pack_threadid(remcom_out_buffer + 2, thref);
-				break;
-			case 'T':
-				if (memcmp(remcom_in_buffer + 1,
-					   "ThreadExtraInfo,", 16)) {
-					error_packet(remcom_out_buffer,
-						     -EINVAL);
-					break;
-				}
-				threadid = 0;
-				ptr = remcom_in_buffer + 17;
-				kgdb_hex2long(&ptr, &threadid);
-				if (!getthread(linux_regs, threadid)) {
-					error_packet(remcom_out_buffer,
-						     -EINVAL);
-					break;
-				}
-				if (threadid < pid_max)
-					kgdb_mem2hex(getthread(linux_regs,
-							       threadid)->comm,
-						     remcom_out_buffer, 16);
-				else if (threadid >= pid_max +
-					   num_online_cpus())
-					kgdb_shadowinfo(linux_regs,
-							remcom_out_buffer,
-							threadid - pid_max -
-							num_online_cpus());
-				else {
-					static char tmpstr[23 +
-							   BUF_THREAD_ID_SIZE];
-					sprintf(tmpstr, "Shadow task %d"
-						" for pid 0",
-						(int)(threadid - pid_max));
-					kgdb_mem2hex(tmpstr, remcom_out_buffer,
-						     strlen(tmpstr));
-				}
-				break;
-			}
-			break;
-
-			/* task related */
-		case 'H':
-			switch (remcom_in_buffer[1]) {
-			case 'g':
-				ptr = &remcom_in_buffer[2];
-				kgdb_hex2long(&ptr, &threadid);
-				thread = getthread(linux_regs, threadid);
-				if (!thread && threadid > 0) {
-					error_packet(remcom_out_buffer,
-						     -EINVAL);
-					break;
-				}
-				kgdb_usethread = thread;
-				kgdb_usethreadid = threadid;
-				strcpy(remcom_out_buffer, "OK");
-				break;
-
-			case 'c':
-				ptr = &remcom_in_buffer[2];
-				kgdb_hex2long(&ptr, &threadid);
-				if (!threadid)
-					kgdb_contthread = NULL;
-				else {
-					thread = getthread(linux_regs,
-							   threadid);
-					if (!thread && threadid > 0) {
-						error_packet(remcom_out_buffer,
-							     -EINVAL);
-						break;
-					}
-					kgdb_contthread = thread;
-				}
-				strcpy(remcom_out_buffer, "OK");
-				break;
-			}
-			break;
-
-			/* Query thread status */
-		case 'T':
-			ptr = &remcom_in_buffer[1];
-			kgdb_hex2long(&ptr, &threadid);
-			thread = getthread(linux_regs, threadid);
-			if (thread)
-				strcpy(remcom_out_buffer, "OK");
-			else
-				error_packet(remcom_out_buffer, -EINVAL);
-			break;
-		/* Since GDB-5.3, it's been drafted that '0' is a software
-		 * breakpoint, '1' is a hardware breakpoint, so let's do
-		 * that.
-		 */
-		case 'z':
-		case 'Z':
-			bpt_type = &remcom_in_buffer[1];
-			ptr = &remcom_in_buffer[2];
-
-			if (kgdb_ops->set_hw_breakpoint && *bpt_type >= '1') {
-				/* Unsupported */
-				if (*bpt_type > '4')
-					break;
-			} else if (*bpt_type != '0' && *bpt_type != '1')
-				/* Unsupported. */
-				break;
-			/* Test if this is a hardware breakpoint, and
-			 * if we support it. */
-			if (*bpt_type == '1' &&
-			    !(kgdb_ops->flags & KGDB_HW_BREAKPOINT))
-				/* Unsupported. */
-				break;
-
-			if (*(ptr++) != ',') {
-				error_packet(remcom_out_buffer, -EINVAL);
-				break;
-			} else if (kgdb_hex2long(&ptr, &addr)) {
-				if (*(ptr++) != ',' ||
-				    !kgdb_hex2long(&ptr, &length)) {
-					error_packet(remcom_out_buffer,
-						     -EINVAL);
-					break;
-				}
-			} else {
-				error_packet(remcom_out_buffer, -EINVAL);
-				break;
-			}
+	/* Talk to debugger with gdbserial protocol */
+	error = gdb_serial_stub(ks);
 
-			if (remcom_in_buffer[0] == 'Z' && *bpt_type == '0')
-				error = kgdb_set_sw_break(addr);
-			else if (remcom_in_buffer[0] == 'z' && *bpt_type == '0')
-				error = kgdb_remove_sw_break(addr);
-			else if (remcom_in_buffer[0] == 'Z')
-				error = kgdb_ops->set_hw_breakpoint(addr,
-								    (int)length,
-								    *bpt_type);
-			else if (remcom_in_buffer[0] == 'z')
-				error = kgdb_ops->remove_hw_breakpoint(addr,
-							       (int)
-							       length,
-							       *bpt_type);
-
-			if (error == 0)
-				strcpy(remcom_out_buffer, "OK");
-			else
-				error_packet(remcom_out_buffer, error);
-
-			break;
-		case 'C':
-			/* C09 == pass exception
-			 * C15 == detach kgdb, pass exception
-			 * C30 == detach kgdb, stop attachwait, pass exception
-			 */
-			if (remcom_in_buffer[1] == '0' &&
-				remcom_in_buffer[2] == '9') {
-				pass_exception = 1;
-				remcom_in_buffer[0] = 'c';
-			} else if (remcom_in_buffer[1] == '1' &&
-					   remcom_in_buffer[2] == '5') {
-				pass_exception = 1;
-				remcom_in_buffer[0] = 'D';
-				remove_all_break();
-				kgdb_connected = 0;
-				goto default_handle;
-			} else if (remcom_in_buffer[1] == '3' &&
-					   remcom_in_buffer[2] == '0') {
-				pass_exception = 1;
-				attachwait = 0;
-				remcom_in_buffer[0] = 'D';
-				remove_all_break();
-				kgdb_connected = 0;
-				goto default_handle;
-			} else {
-				error_packet(remcom_out_buffer, error);
-				break;
-			}
-		case 'c':
-		case 's':
-			if (kgdb_contthread && kgdb_contthread != current) {
-				/* Can't switch threads in kgdb */
-				error_packet(remcom_out_buffer, -EINVAL);
-				break;
-			}
-			kgdb_activate_sw_breakpoints();
-			/* Followthrough to default processing */
-		default:
-default_handle:
-			error = kgdb_arch_handle_exception(ex_vector, signo,
-							   err_code,
-							   remcom_in_buffer,
-							   remcom_out_buffer,
-							   linux_regs);
-			if (error >= 0 || remcom_in_buffer[0] == 'D' ||
-			    remcom_in_buffer[0] == 'k') {
-				error = 0;
-				goto kgdb_exit;
-			}
-
-		}		/* switch */
-
-		/* reply to the request */
-		put_packet(remcom_out_buffer);
-	}
-
- kgdb_exit:
-	if (pass_exception)
-		error = 1;
-	/*
-	 * Call the I/O driver's post_exception routine
-	 * if the I/O driver defined one.
-	 */
+	/* Call the I/O driver's post_exception routine */
 	if (kgdb_io_ops.post_exception)
 		kgdb_io_ops.post_exception();
 
-	kgdb_info[processor].debuggerinfo = NULL;
-	kgdb_info[processor].task = NULL;
-	atomic_set(&procindebug[processor], 0);
+	kgdb_info[ks->processor].debuggerinfo = NULL;
+	kgdb_info[ks->processor].task = NULL;
+	atomic_set(&procindebug[ks->processor], 0);
 
 	if (!debugger_step || !kgdb_contthread) {
 		for (i = 0; i < NR_CPUS; i++)
@@ -1581,7 +1709,7 @@ default_handle:
 	atomic_set(&debugger_active, 0);
 	atomic_set(&kgdb_sync, -1);
 	clocksource_touch_watchdog();
-	kgdb_softlock_skip[processor] = 1;
+	kgdb_softlock_skip[ks->processor] = 1;
 	local_irq_restore(flags);
 
 	return error;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519Ab0AKM0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0AKM0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488Ab0AKM0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:26:22 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51834 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab0AKM0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:26:09 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jan 2010 17:56:03 +0530
Message-Id: <20100111122603.22050.1039.sendpatchset@srikar.in.ibm.com>
In-Reply-To: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
Subject: [RFC] [PATCH 6/7] Uprobes Documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uprobes documentation

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
---
 Documentation/uprobes.txt |  460 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 460 insertions(+)

Index: new_uprobes.git/Documentation/uprobes.txt
===================================================================
--- /dev/null
+++ new_uprobes.git/Documentation/uprobes.txt
@@ -0,0 +1,460 @@
+Title	: User-Space Probes (Uprobes)
+Author	: Jim Keniston <jkenisto@us.ibm.com>
+
+CONTENTS
+
+1. Concepts: Uprobes
+2. Architectures Supported
+3. Configuring Uprobes
+4. API Reference
+5. Uprobes Features and Limitations
+6. Interoperation with Kprobes
+7. Interoperation with Utrace
+8. Probe Overhead
+9. TODO
+10. Uprobes Team
+11. Uprobes Example
+
+1. Concepts: Uprobes
+
+Uprobes enables you to dynamically break into any routine in a
+user application and collect debugging and performance information
+non-disruptively. You can trap at any code address, specifying a
+kernel handler routine to be invoked when the breakpoint is hit.
+
+A uprobe can be inserted on any instruction in the application's
+virtual address space.  The registration function
+register_uprobe() specifies which process is to be probed, where
+the probe is to be inserted, and what handler is to be called when
+the probe is hit.
+
+Typically, Uprobes-based instrumentation is packaged as a kernel
+module.  In the simplest case, the module's init function installs
+("registers") one or more probes, and the exit function unregisters
+them.  However, probes can be registered or unregistered in response
+to other events as well.  For example:
+- A probe handler itself can register and/or unregister probes.
+- You can establish Utrace callbacks to register and/or unregister
+probes when a particular process forks, clones a thread,
+execs, enters a system call, receives a signal, exits, etc.
+See the utrace documentation in Documentation/DocBook.
+
+1.1 How Does a Uprobe Work?
+
+When a uprobe is registered, Uprobes makes a copy of the probed
+instruction, stops the probed application, replaces the first byte(s)
+of the probed instruction with a breakpoint instruction (e.g., int3
+on i386 and x86_64), and allows the probed application to continue.
+(When inserting the breakpoint, Uprobes uses the same copy-on-write
+mechanism that ptrace uses, so that the breakpoint affects only that
+process, and not any other process running that program.  This is
+true even if the probed instruction is in a shared library.)
+
+When a CPU hits the breakpoint instruction, a trap occurs, the CPU's
+user-mode registers are saved, and a SIGTRAP signal is generated.
+Uprobes intercepts the SIGTRAP and finds the associated uprobe.
+It then executes the handler associated with the uprobe, passing the
+handler the addresses of the uprobe struct and the saved registers.
+The handler may block, but keep in mind that the probed thread remains
+stopped while your handler runs.
+
+Next, Uprobes single-steps its copy of the probed instruction and
+resumes execution of the probed process at the instruction following
+the probepoint.  (It would be simpler to single-step the actual
+instruction in place, but then Uprobes would have to temporarily
+remove the breakpoint instruction.  This would create problems in a
+multithreaded application.  For example, it would open a time window
+when another thread could sail right past the probepoint.)
+
+Instruction copies to be single-stepped are stored in a per-process
+"single-step out of line (XOL) area," which is a little VM area
+created by Uprobes in each probed process's address space.
+
+1.2 The Role of Utrace
+
+When a probe is registered on a previously unprobed process,
+Uprobes establishes a tracing "engine" with Utrace (see
+Documentation/utrace.txt) for each thread (task) in the process.
+Uprobes uses the Utrace "quiesce" mechanism to stop all the threads
+prior to insertion or removal of a breakpoint.  Utrace also notifies
+Uprobes of breakpoint and single-step traps and of other interesting
+events in the lifetime of the probed process, such as fork, clone,
+exec, and exit.
+
+1.3 Multithreaded Applications
+
+Uprobes supports the probing of multithreaded applications.  Uprobes
+imposes no limit on the number of threads in a probed application.
+All threads in a process use the same text pages, so every probe
+in a process affects all threads; of course, each thread hits the
+probepoint (and runs the handler) independently.  Multiple threads
+may run the same handler simultaneously.  If you want a particular
+thread or set of threads to run a particular handler, your handler
+should check current or current->pid to determine which thread has
+hit the probepoint.
+
+When a process clones a new thread, that thread automatically shares
+all current and future probes established for that process.
+
+Keep in mind that when you register or unregister a probe, the
+breakpoint is not inserted or removed until Utrace has stopped all
+threads in the process.  The register/unregister function returns
+after the breakpoint has been inserted/removed (but see the next
+section).
+
+1.5 Registering Probes within Probe Handlers
+
+A uprobe handler can call [un]register_uprobe() functions.
+A handler can even unregister its own probe.  However, when invoked
+from a handler, the actual [un]register operations do not take
+place immediately.  Rather, they are queued up and executed after
+all handlers for that probepoint have been run.  In the handler,
+the [un]register call returns -EINPROGRESS.  If you set the
+registration_callback field in the uprobe object, that callback will
+be called when the [un]register operation completes.
+
+2. Architectures Supported
+
+This ubp-based version of Uprobes is implemented on the following
+architectures:
+
+- x86
+
+3. Configuring Uprobes
+
+When configuring the kernel using make menuconfig/xconfig/oldconfig,
+ensure that CONFIG_UPROBES is set to "y".  Select "Infrastructure for
+tracing and debugging user processes" to enable Utrace.  Under "General
+setup" select "User-space breakpoint assistance" then select
+"User-space probes".
+
+So that you can load and unload Uprobes-based instrumentation modules,
+make sure "Loadable module support" (CONFIG_MODULES) and "Module
+unloading" (CONFIG_MODULE_UNLOAD) are set to "y".
+
+4. API Reference
+
+The Uprobes API includes a "register" function and an "unregister"
+function for uprobes.  Here are terse, mini-man-page specifications for
+these functions and the associated probe handlers that you'll write.
+See the latter half of this document for examples.
+
+4.1 register_uprobe
+
+#include <linux/uprobes.h>
+int register_uprobe(struct uprobe *u);
+
+Sets a breakpoint at virtual address u->vaddr in the process whose
+pid is u->pid.  When the breakpoint is hit, Uprobes calls u->handler.
+
+register_uprobe() returns 0 on success, -EINPROGRESS if
+register_uprobe() was called from a uprobe  handler (and therefore
+delayed), or a negative errno otherwise.
+
+Section 4.4, "User's Callback for Delayed Registrations",
+explains how to be notified upon completion of a delayed
+registration.
+
+User's handler (u->handler):
+#include <linux/uprobes.h>
+#include <linux/ptrace.h>
+void handler(struct uprobe *u, struct pt_regs *regs);
+
+Called with u pointing to the uprobe associated with the breakpoint,
+and regs pointing to the struct containing the registers saved when
+the breakpoint was hit.
+
+4.3 unregister_uprobe
+
+#include <linux/uprobes.h>
+void unregister_uprobe(struct uprobe *u);
+
+Removes the specified probe.  The unregister function can be called
+at any time after the probe has been registered, and can be called
+from a uprobe handler.
+
+4.4 User's Callback for Delayed Registrations
+
+#include <linux/uprobes.h>
+void registration_callback(struct uprobe *u, int reg, int result);
+
+As previously mentioned, the functions described in Section 4 can
+be called from within a uprobe.  When that happens, the
+[un]registration operation is delayed until all handlers
+associated with that handler's probepoint have been run.  Upon
+completion of the [un]registration operation, Uprobes checks the
+registration_callback member of the associated uprobe:
+u->registration_callback for [un]register_uprobe. Uprobes calls
+that callback function, if any, passing it the following values:
+
+- u = the address of the uprobe object.
+
+- reg = 1 for register_uprobe() or 0 for unregister_uprobe()
+
+- result = the return value that register_uprobe() would have
+returned if this weren't a delayed operation.  This is always 0
+for unregister_uprobe().
+
+NOTE: Uprobes calls the registration_callback ONLY in the case of a
+delayed [un]registration.
+
+5. Uprobes Features and Limitations
+
+The user is expected to assign values to the following members
+of struct uprobe: pid, vaddr, handler, and (as needed)
+registration_callback.  Other members are reserved for Uprobes's use.
+Uprobes may produce unexpected results if you:
+- assign non-zero values to reserved members of struct uprobe;
+- change the contents of a uprobe object while it is registered; or
+- attempt to register a uprobe that is already registered.
+
+Uprobes allows any number of uprobes at a particular address.  For
+a particular probepoint, handlers are run in the order in which
+they were registered.
+
+Any number of kernel modules may probe a particular process
+simultaneously, and a particular module may probe any number of
+processes simultaneously.
+
+Probes are shared by all threads in a process (including newly
+created threads).
+
+If a probed process exits or execs, Uprobes automatically
+unregisters all uprobes associated with that process.  Subsequent
+attempts to unregister these probes will be treated as no-ops.
+
+On the other hand, if a probed memory area is removed from the
+process's virtual memory map (e.g., via dlclose(3) or munmap(2)),
+it's currently up to you to unregister the probes first.
+
+There is no way to specify that probes should be inherited across fork;
+Uprobes removes all probepoints in the newly created child process.
+See Section 7, "Interoperation with Utrace", for more information on
+this topic.
+
+On at least some architectures, Uprobes makes no attempt to verify
+that the probe address you specify actually marks the start of an
+instruction.  If you get this wrong, chaos may ensue.
+
+To avoid interfering with interactive debuggers, Uprobes will refuse
+to insert a probepoint where a breakpoint instruction already exists,
+unless it was Uprobes that put it there.  Some architectures may
+refuse to insert probes on other types of instructions.
+
+If you install a probe in an inline-able function, Uprobes makes
+no attempt to chase down all inline instances of the function and
+install probes there.  gcc may inline a function without being asked,
+so keep this in mind if you're not seeing the probe hits you expect.
+
+A probe handler can modify the environment of the probed function
+-- e.g., by modifying data structures, or by modifying the
+contents of the pt_regs struct (which are restored to the registers
+upon return from the breakpoint).  So Uprobes can be used, for example,
+to install a bug fix or to inject faults for testing.  Uprobes, of
+course, has no way to distinguish the deliberately injected faults
+from the accidental ones.  Don't drink and probe.
+
+When you register the first probe at probepoint or unregister the
+last probe probe at a probepoint, Uprobes asks Utrace to "quiesce"
+the probed process so that Uprobes can insert or remove the breakpoint
+instruction.  If the process is not already stopped, Utrace stops it.
+If the process is entering an interruptible system call at that instant,
+this may cause the system call to finish early or fail with EINTR.
+
+When Uprobes establishes a probepoint on a previous unprobed page
+of text, Linux creates a new copy of the page via its copy-on-write
+mechanism.  When probepoints are removed, Uprobes makes no attempt
+to consolidate identical copies of the same page.  This could affect
+memory availability if you probe many, many pages in many, many
+long-running processes.
+
+6. Interoperation with Kprobes
+
+Uprobes is intended to interoperate usefully with Kprobes (see
+Documentation/kprobes.txt).  For example, an instrumentation module
+can make calls to both the Kprobes API and the Uprobes API.
+
+A uprobe handler can register or unregister kprobes,
+jprobes, and kretprobes, as well as uprobes.  On the
+other hand, a kprobe, jprobe, or kretprobe handler must not sleep, and
+therefore cannot register or unregister any of these types of probes.
+(Ideas for removing this restriction are welcome.)
+
+Note that the overhead of a uprobe hit is several times that of
+a k[ret]probe hit.
+
+7. Interoperation with Utrace
+
+As mentioned in Section 1.2, Uprobes is a client of Utrace.  For each
+probed thread, Uprobes establishes a Utrace engine, and registers
+callbacks for the following types of events: clone/fork, exec, exit,
+and "core-dump" signals (which include breakpoint traps).  Uprobes
+establishes this engine when the process is first probed, or when
+Uprobes is notified of the thread's creation, whichever comes first.
+
+An instrumentation module can use both the Utrace and Uprobes APIs (as
+well as Kprobes).  When you do this, keep the following facts in mind:
+
+- For a particular event, Utrace callbacks are called in the order in
+which the engines are established.  Utrace does not currently provide
+a mechanism for altering this order.
+
+- When Uprobes learns that a probed process has forked, it removes
+the breakpoints in the child process.
+
+- When Uprobes learns that a probed process has exec-ed or exited,
+it disposes of its data structures for that process (first allowing
+any outstanding [un]registration operations to terminate).
+
+- When a probed thread hits a breakpoint or completes single-stepping
+of a probed instruction, engines with the UTRACE_EVENT(SIGNAL_CORE)
+flag set are notified.
+
+If you want to establish probes in a newly forked child, you can use
+the following procedure:
+
+- Register a report_clone callback with Utrace.  In this callback,
+the CLONE_THREAD flag distinguishes between the creation of a new
+thread vs. a new process.
+
+- In your report_clone callback, call utrace_attach_task() to attach to
+the child process, and call utrace_control(..., UTRACE_REPORT)
+The child process will quiesce at a point where it is ready to
+be probed.
+
+- In your report_quiesce callback, register the desired probes.
+(Note that you cannot use the same probe object for both parent
+and child.  If you want to duplicate the probepoints, you must
+create a new set of uprobe objects.)
+
+8. Probe Overhead
+
+On a typical CPU in use in 2007, a uprobe hit takes about 3
+microseconds to process.  Specifically, a benchmark that hits the
+same probepoint repeatedly, firing a simple handler each time, reports
+300,000 to 350,000 hits per second, depending on the architecture.
+
+Here are sample overhead figures (in usec) for x86 architecture.
+
+x86: Intel Pentium M, 1495 MHz, 2957.31 bogomips
+uprobe = 2.9 usec;
+
+9. TODO
+
+a. Support for other architectures.
+b. Support return probes.
+
+10. Uprobes Team
+
+The following people have made major contributions to Uprobes:
+Jim Keniston - jkenisto@us.ibm.com
+Srikar Dronamraju - srikar@linux.vnet.ibm.com
+Ananth Mavinakayanahalli - ananth@in.ibm.com
+Prasanna Panchamukhi - prasanna@in.ibm.com
+Dave Wilder - dwilder@us.ibm.com
+
+11. Uprobes Example
+
+Here's a sample kernel module showing the use of Uprobes to count the
+number of times an instruction at a particular address is executed,
+and optionally (unless verbose=0) report each time it's executed.
+----- cut here -----
+/* uprobe_example.c */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/uprobes.h>
+
+/*
+ * Usage: insmod uprobe_example.ko pid=<pid> vaddr=<address> [verbose=0]
+ * where <pid> identifies the probed process and <address> is the virtual
+ * address of the probed instruction.
+ */
+
+static int pid = 0;
+module_param(pid, int, 0);
+MODULE_PARM_DESC(pid, "pid");
+
+static int verbose = 1;
+module_param(verbose, int, 0);
+MODULE_PARM_DESC(verbose, "verbose");
+
+static long vaddr = 0;
+module_param(vaddr, long, 0);
+MODULE_PARM_DESC(vaddr, "vaddr");
+
+static int nhits;
+static struct uprobe usp;
+
+static void uprobe_handler(struct uprobe *u, struct pt_regs *regs)
+{
+	nhits++;
+	if (verbose)
+		printk(KERN_INFO "Hit #%d on probepoint at %#lx\n",
+			nhits, u->vaddr);
+}
+
+int __init init_module(void)
+{
+	int ret;
+	usp.pid = pid;
+	usp.vaddr = vaddr;
+	usp.handler = uprobe_handler;
+	printk(KERN_INFO "Registering uprobe on pid %d, vaddr %#lx\n",
+		usp.pid, usp.vaddr);
+	ret = register_uprobe(&usp);
+	if (ret != 0) {
+		printk(KERN_ERR "register_uprobe() failed, returned %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+void __exit cleanup_module(void)
+{
+	printk(KERN_INFO "Unregistering uprobe on pid %d, vaddr %#lx\n",
+		usp.pid, usp.vaddr);
+	printk(KERN_INFO "Probepoint was hit %d times\n", nhits);
+	unregister_uprobe(&usp);
+}
+MODULE_LICENSE("GPL");
+----- cut here -----
+
+You can build the kernel module, uprobe_example.ko, using the following
+Makefile:
+----- cut here -----
+obj-m := uprobe_example.o
+KDIR := /lib/modules/$(shell uname -r)/build
+PWD := $(shell pwd)
+default:
+	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
+clean:
+	rm -f *.mod.c *.ko *.o .*.cmd
+	rm -rf .tmp_versions
+----- cut here -----
+
+For example, if you want to run myprog and monitor its calls to myfunc(),
+you can do the following:
+
+$ make			// Build the uprobe_example module.
+...
+$ nm -p myprog | awk '$3=="myfunc"'
+080484a8 T myfunc
+$ ./myprog &
+$ ps
+  PID TTY          TIME CMD
+ 4367 pts/3    00:00:00 bash
+ 8156 pts/3    00:00:00 myprog
+ 8157 pts/3    00:00:00 ps
+$ su -
+...
+# insmod uprobe_example.ko pid=8156 vaddr=0x080484a8
+
+In /var/log/messages and on the console, you will see a message of the
+form "kernel: Hit #1 on probepoint at 0x80484a8" each time myfunc()
+is called.  To turn off probing, remove the module:
+
+# rmmod uprobe_example
+
+In /var/log/messages and on the console, you will see a message of the
+form "Probepoint was hit 5 times".

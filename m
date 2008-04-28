Return-Path: <linux-kernel-owner+w=401wt.eu-S935668AbYD1Spf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935668AbYD1Spf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765906AbYD1Sp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:45:26 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:55030 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbYD1SpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:45:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=I+cc/z+vltoih7dM/QqTl332E76VqCdt7f2p0hYMLLL7uOhoo1B7f8gb74uFDi5a51U4+4zcmBpV7vDhGqSomQCYHRcCSulKwcnPrTXz2DWkKgZT7PYuJBDDaX3gABoUL5bG5laiejvwmp0/iabvCl8NIfT04Kz1EpkDLbA6sN0=
Date: Mon, 28 Apr 2008 21:45:04 +0300
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Pekka Paalanen <pq@iki.fi>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 1/3] mmiotrace full patch, preview 3
Message-ID: <20080428214504.5c359195@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is the third full mmiotrace patch set for review (a bit late, sorry).
These patches do not apply to any git tree that I know of, but after Ingo
pushes a new version of his sched-devel/latest tree, these patches should
be subtractable from there.

I created these three patches by reorganizing patches in the
sched-devel/latest tree to get all the mmiotrace patches to the top,
and the end result is identical to the original, though I had to solve
some conflicts along the way. I included my last 5+1 patches, too.

This first patch adds the bulk of the new code, only introducing new files.
The second patch establishes the interfaces to the ftrace framework, and
the third patch hooks everything up into the Kbuild system, page fault
handler, and ioremap functions.

All three patches went through checkpatch.pl, getting complaints only
about the use of 'volatile', which is used to duplicate the parameter
signature of iounmap() for the functions mmiotrace_iounmap() and
iounmap_trace_core() in the first patch.

New development since preview 2, March 9th:
- Abandoning the binary user space interface that used relay, and
- moving to ftrace framework interfaces, which
- produces the trace log in text format rather than binary, and
- made the special user space logging program obsolete.
- lots of cleanups, e.g. reference_kmmio() removed
- refactor dis/arm_kmmio_fault_page() and add check for page levels
- work around recursive probe hits on SMP, trying to survive
- added user documentation
- If HOTPLUG_CPU, disable all but one CPU when mmiotrace is activated,
- and also restore the CPUs when mmiotrace is deactivated.
- detect and print buffer overrun counts (losing events)

Some of the new code depends on the new features in the ftrace framework,
many thanks to Steven for those.

The current state is that mmiotrace seems to work fine, also on SMP,
but on SMP there's a chance to miss events due to CPUs racing. At last
the log produced via ftrace framework is up-to-spec. Inserting user
comments (markers in mmiotrace-parlance) into the log is not yet
supported. All in all, after some more testing on my part, IMHO this
is in a mergeable state.


Thanks,
Pekka Paalanen


 Documentation/tracers/mmiotrace.txt |  164 +++++++++++
 arch/x86/mm/kmmio.c                 |  500 ++++++++++++++++++++++++++++++++++
 arch/x86/mm/mmio-mod.c              |  513 +++++++++++++++++++++++++++++++++++
 arch/x86/mm/pf_in.c                 |  489 +++++++++++++++++++++++++++++++++
 arch/x86/mm/pf_in.h                 |   39 +++
 arch/x86/mm/testmmiotrace.c         |   71 +++++
 include/linux/mmiotrace.h           |   85 ++++++
 7 files changed, 1861 insertions(+), 0 deletions(-)

diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
new file mode 100644
index 0000000..a4afb56
--- /dev/null
+++ b/Documentation/tracers/mmiotrace.txt
@@ -0,0 +1,164 @@
+		In-kernel memory-mapped I/O tracing
+
+
+Home page and links to optional user space tools:
+
+	http://nouveau.freedesktop.org/wiki/MmioTrace
+
+MMIO tracing was originally developed by Intel around 2003 for their Fault
+Injection Test Harness. In Dec 2006 - Jan 2007, using the code from Intel,
+Jeff Muizelaar created a tool for tracing MMIO accesses with the Nouveau
+project in mind. Since then many people have contributed.
+
+Mmiotrace was built for reverse engineering any memory-mapped IO device with
+the Nouveau project as the first real user. Only x86 and x86_64 architectures
+are supported.
+
+Out-of-tree mmiotrace was originally modified for mainline inclusion and
+ftrace framework by Pekka Paalanen <pq@iki.fi>.
+
+
+Preparation
+-----------
+
+Mmiotrace feature is compiled in by the CONFIG_MMIOTRACE option. Tracing is
+disabled by default, so it is safe to have this set to yes. SMP systems are
+supported, but tracing is unreliable and may miss events if more than one CPU
+is on-line, therefore mmiotrace takes all but one CPU off-line during run-time
+activation. You can re-enable CPUs by hand, but you have been warned, there
+is no way to automatically detect if you are losing events due to CPUs racing.
+
+
+Usage Quick Reference
+---------------------
+
+$ mount -t debugfs debugfs /debug
+$ echo mmiotrace > /debug/tracing/current_tracer
+$ cat /debug/tracing/trace_pipe > mydump.txt &
+Start X or whatever.
+$ echo "X is up" > /debug/tracing/marker
+$ echo none > /debug/tracing/current_tracer
+Check for lost events.
+
+
+Usage
+-----
+
+Make sure debugfs is mounted to /debug. If not, (requires root privileges)
+$ mount -t debugfs debugfs /debug
+
+Check that the driver you are about to trace is not loaded.
+
+Activate mmiotrace (requires root privileges):
+$ echo mmiotrace > /debug/tracing/current_tracer
+
+Start storing the trace:
+$ cat /debug/tracing/trace_pipe > mydump.txt &
+The 'cat' process should stay running (sleeping) in the background.
+
+Load the driver you want to trace and use it. Mmiotrace will only catch MMIO
+accesses to areas that are ioremapped while mmiotrace is active.
+
+[Unimplemented feature:]
+During tracing you can place comments (markers) into the trace by
+$ echo "X is up" > /debug/tracing/marker
+This makes it easier to see which part of the (huge) trace corresponds to
+which action. It is recommended to place descriptive markers about what you
+do.
+
+Shut down mmiotrace (requires root privileges):
+$ echo none > /debug/tracing/current_tracer
+The 'cat' process exits. If it does not, kill it by issuing 'fg' command and
+pressing ctrl+c.
+
+Check that mmiotrace did not lose events due to a buffer filling up. Either
+$ grep -i lost mydump.txt
+which tells you exactly how many events were lost, or use
+$ dmesg
+to view your kernel log and look for "mmiotrace has lost events" warning. If
+events were lost, the trace is incomplete. You should enlarge the buffers and
+try again. Buffers are enlarged by first seeing how large the current buffers
+are:
+$ cat /debug/tracing/trace_entries
+gives you a number. Approximately double this number and write it back, for
+instance:
+$ echo 128000 > /debug/tracing/trace_entries
+Then start again from the top.
+
+If you are doing a trace for a driver project, e.g. Nouveau, you should also
+do the following before sending your results:
+$ lspci -vvv > lspci.txt
+$ dmesg > dmesg.txt
+$ tar zcf pciid-nick-mmiotrace.tar.gz mydump.txt lspci.txt dmesg.txt
+and then send the .tar.gz file. The trace compresses considerably. Replace
+"pciid" and "nick" with the PCI ID or model name of your piece of hardware
+under investigation and your nick name.
+
+
+How Mmiotrace Works
+-------------------
+
+Access to hardware IO-memory is gained by mapping addresses from PCI bus by
+calling one of the ioremap_*() functions. Mmiotrace is hooked into the
+__ioremap() function and gets called whenever a mapping is created. Mapping is
+an event that is recorded into the trace log. Note, that ISA range mappings
+are not caught, since the mapping always exists and is returned directly.
+
+MMIO accesses are recorded via page faults. Just before __ioremap() returns,
+the mapped pages are marked as not present. Any access to the pages causes a
+fault. The page fault handler calls mmiotrace to handle the fault. Mmiotrace
+marks the page present, sets TF flag to achieve single stepping and exits the
+fault handler. The instruction that faulted is executed and debug trap is
+entered. Here mmiotrace again marks the page as not present. The instruction
+is decoded to get the type of operation (read/write), data width and the value
+read or written. These are stored to the trace log.
+
+Setting the page present in the page fault handler has a race condition on SMP
+machines. During the single stepping other CPUs may run freely on that page
+and events can be missed without a notice. Re-enabling other CPUs during
+tracing is discouraged.
+
+
+Trace Log Format
+----------------
+
+The raw log is text and easily filtered with e.g. grep and awk. One record is
+one line in the log. A record starts with a keyword, followed by keyword
+dependant arguments. Arguments are separated by a space, or continue until the
+end of line. The format for version 20070824 is as follows:
+
+Explanation	Keyword	Space separated arguments
+---------------------------------------------------------------------------
+
+read event	R	width, timestamp, map id, physical, value, PC, PID
+write event	W	width, timestamp, map id, physical, value, PC, PID
+ioremap event	MAP	timestamp, map id, physical, virtual, length, PC, PID
+iounmap event	UNMAP	timestamp, map id, PC, PID
+marker		MARK	timestamp, text
+version		VERSION	the string "20070824"
+info for reader	LSPCI	one line from lspci -v
+PCI address map	PCIDEV	space separated /proc/bus/pci/devices data
+unk. opcode	UNKNOWN	timestamp, map id, physical, data, PC, PID
+
+Timestamp is in seconds with decimals. Physical is a PCI bus address, virtual
+is a kernel virtual address. Width is the data width in bytes and value is the
+data value. Map id is an arbitrary id number identifying the mapping that was
+used in an operation. PC is the program counter and PID is process id. PC is
+zero if it is not recorded. PID is always zero as tracing MMIO accesses
+originating in user space memory is not yet supported.
+
+For instance, the following awk filter will pass all 32-bit writes that target
+physical addresses in the range [0xfb73ce40, 0xfb800000[
+
+$ awk '/W 4 / { adr=strtonum($5); if (adr >= 0xfb73ce40 &&
+adr < 0xfb800000) print; }'
+
+
+Tools for Developers
+--------------------
+
+The user space tools include utilities for:
+- replacing numeric addresses and values with hardware register names
+- replaying MMIO logs, i.e., re-executing the recorded writes
+
+
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
new file mode 100644
index 0000000..40567d8
--- /dev/null
+++ b/arch/x86/mm/kmmio.c
@@ -0,0 +1,500 @@
+/* Support for MMIO probes.
+ * Benfit many code from kprobes
+ * (C) 2002 Louis Zhuang <louis.zhuang@intel.com>.
+ *     2007 Alexander Eichner
+ *     2008 Pekka Paalanen <pq@iki.fi>
+ */
+
+#include <linux/list.h>
+#include <linux/rculist.h>
+#include <linux/spinlock.h>
+#include <linux/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/uaccess.h>
+#include <linux/ptrace.h>
+#include <linux/preempt.h>
+#include <linux/percpu.h>
+#include <linux/kdebug.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <linux/errno.h>
+#include <asm/debugreg.h>
+#include <linux/mmiotrace.h>
+
+#define KMMIO_PAGE_HASH_BITS 4
+#define KMMIO_PAGE_TABLE_SIZE (1 << KMMIO_PAGE_HASH_BITS)
+
+struct kmmio_fault_page {
+	struct list_head list;
+	struct kmmio_fault_page *release_next;
+	unsigned long page; /* location of the fault page */
+
+	/*
+	 * Number of times this page has been registered as a part
+	 * of a probe. If zero, page is disarmed and this may be freed.
+	 * Used only by writers (RCU).
+	 */
+	int count;
+};
+
+struct kmmio_delayed_release {
+	struct rcu_head rcu;
+	struct kmmio_fault_page *release_list;
+};
+
+struct kmmio_context {
+	struct kmmio_fault_page *fpage;
+	struct kmmio_probe *probe;
+	unsigned long saved_flags;
+	unsigned long addr;
+	int active;
+};
+
+static DEFINE_SPINLOCK(kmmio_lock);
+
+/* Protected by kmmio_lock */
+unsigned int kmmio_count;
+
+/* Read-protected by RCU, write-protected by kmmio_lock. */
+static struct list_head kmmio_page_table[KMMIO_PAGE_TABLE_SIZE];
+static LIST_HEAD(kmmio_probes);
+
+static struct list_head *kmmio_page_list(unsigned long page)
+{
+	return &kmmio_page_table[hash_long(page, KMMIO_PAGE_HASH_BITS)];
+}
+
+/* Accessed per-cpu */
+static DEFINE_PER_CPU(struct kmmio_context, kmmio_ctx);
+
+/*
+ * this is basically a dynamic stabbing problem:
+ * Could use the existing prio tree code or
+ * Possible better implementations:
+ * The Interval Skip List: A Data Structure for Finding All Intervals That
+ * Overlap a Point (might be simple)
+ * Space Efficient Dynamic Stabbing with Fast Queries - Mikkel Thorup
+ */
+/* Get the kmmio at this addr (if any). You must be holding RCU read lock. */
+static struct kmmio_probe *get_kmmio_probe(unsigned long addr)
+{
+	struct kmmio_probe *p;
+	list_for_each_entry_rcu(p, &kmmio_probes, list) {
+		if (addr >= p->addr && addr <= (p->addr + p->len))
+			return p;
+	}
+	return NULL;
+}
+
+/* You must be holding RCU read lock. */
+static struct kmmio_fault_page *get_kmmio_fault_page(unsigned long page)
+{
+	struct list_head *head;
+	struct kmmio_fault_page *p;
+
+	page &= PAGE_MASK;
+	head = kmmio_page_list(page);
+	list_for_each_entry_rcu(p, head, list) {
+		if (p->page == page)
+			return p;
+	}
+	return NULL;
+}
+
+static void set_page_present(unsigned long addr, bool present, int *pglevel)
+{
+	pteval_t pteval;
+	pmdval_t pmdval;
+	int level;
+	pmd_t *pmd;
+	pte_t *pte = lookup_address(addr, &level);
+
+	if (!pte) {
+		pr_err("kmmio: no pte for page 0x%08lx\n", addr);
+		return;
+	}
+
+	if (pglevel)
+		*pglevel = level;
+
+	switch (level) {
+	case PG_LEVEL_2M:
+		pmd = (pmd_t *)pte;
+		pmdval = pmd_val(*pmd) & ~_PAGE_PRESENT;
+		if (present)
+			pmdval |= _PAGE_PRESENT;
+		set_pmd(pmd, __pmd(pmdval));
+		break;
+
+	case PG_LEVEL_4K:
+		pteval = pte_val(*pte) & ~_PAGE_PRESENT;
+		if (present)
+			pteval |= _PAGE_PRESENT;
+		set_pte_atomic(pte, __pte(pteval));
+		break;
+
+	default:
+		pr_err("kmmio: unexpected page level 0x%x.\n", level);
+		return;
+	}
+
+	__flush_tlb_one(addr);
+}
+
+/** Mark the given page as not present. Access to it will trigger a fault. */
+static void arm_kmmio_fault_page(unsigned long page, int *page_level)
+{
+	set_page_present(page & PAGE_MASK, false, page_level);
+}
+
+/** Mark the given page as present. */
+static void disarm_kmmio_fault_page(unsigned long page, int *page_level)
+{
+	set_page_present(page & PAGE_MASK, true, page_level);
+}
+
+/*
+ * This is being called from do_page_fault().
+ *
+ * We may be in an interrupt or a critical section. Also prefecthing may
+ * trigger a page fault. We may be in the middle of process switch.
+ * We cannot take any locks, because we could be executing especially
+ * within a kmmio critical section.
+ *
+ * Local interrupts are disabled, so preemption cannot happen.
+ * Do not enable interrupts, do not sleep, and watch out for other CPUs.
+ */
+/*
+ * Interrupts are disabled on entry as trap3 is an interrupt gate
+ * and they remain disabled thorough out this function.
+ */
+int kmmio_handler(struct pt_regs *regs, unsigned long addr)
+{
+	struct kmmio_context *ctx;
+	struct kmmio_fault_page *faultpage;
+	int ret = 0; /* default to fault not handled */
+
+	/*
+	 * Preemption is now disabled to prevent process switch during
+	 * single stepping. We can only handle one active kmmio trace
+	 * per cpu, so ensure that we finish it before something else
+	 * gets to run. We also hold the RCU read lock over single
+	 * stepping to avoid looking up the probe and kmmio_fault_page
+	 * again.
+	 */
+	preempt_disable();
+	rcu_read_lock();
+
+	faultpage = get_kmmio_fault_page(addr);
+	if (!faultpage) {
+		/*
+		 * Either this page fault is not caused by kmmio, or
+		 * another CPU just pulled the kmmio probe from under
+		 * our feet. The latter case should not be possible.
+		 */
+		goto no_kmmio;
+	}
+
+	ctx = &get_cpu_var(kmmio_ctx);
+	if (ctx->active) {
+		disarm_kmmio_fault_page(faultpage->page, NULL);
+		if (addr == ctx->addr) {
+			/*
+			 * On SMP we sometimes get recursive probe hits on the
+			 * same address. Context is already saved, fall out.
+			 */
+			pr_debug("kmmio: duplicate probe hit on CPU %d, for "
+						"address 0x%08lx.\n",
+						smp_processor_id(), addr);
+			ret = 1;
+			goto no_kmmio_ctx;
+		}
+		/*
+		 * Prevent overwriting already in-flight context.
+		 * This should not happen, let's hope disarming at least
+		 * prevents a panic.
+		 */
+		pr_emerg("kmmio: recursive probe hit on CPU %d, "
+					"for address 0x%08lx. Ignoring.\n",
+					smp_processor_id(), addr);
+		pr_emerg("kmmio: previous hit was at 0x%08lx.\n",
+					ctx->addr);
+		goto no_kmmio_ctx;
+	}
+	ctx->active++;
+
+	ctx->fpage = faultpage;
+	ctx->probe = get_kmmio_probe(addr);
+	ctx->saved_flags = (regs->flags & (X86_EFLAGS_TF | X86_EFLAGS_IF));
+	ctx->addr = addr;
+
+	if (ctx->probe && ctx->probe->pre_handler)
+		ctx->probe->pre_handler(ctx->probe, regs, addr);
+
+	/*
+	 * Enable single-stepping and disable interrupts for the faulting
+	 * context. Local interrupts must not get enabled during stepping.
+	 */
+	regs->flags |= X86_EFLAGS_TF;
+	regs->flags &= ~X86_EFLAGS_IF;
+
+	/* Now we set present bit in PTE and single step. */
+	disarm_kmmio_fault_page(ctx->fpage->page, NULL);
+
+	/*
+	 * If another cpu accesses the same page while we are stepping,
+	 * the access will not be caught. It will simply succeed and the
+	 * only downside is we lose the event. If this becomes a problem,
+	 * the user should drop to single cpu before tracing.
+	 */
+
+	put_cpu_var(kmmio_ctx);
+	return 1; /* fault handled */
+
+no_kmmio_ctx:
+	put_cpu_var(kmmio_ctx);
+no_kmmio:
+	rcu_read_unlock();
+	preempt_enable_no_resched();
+	return ret;
+}
+
+/*
+ * Interrupts are disabled on entry as trap1 is an interrupt gate
+ * and they remain disabled thorough out this function.
+ * This must always get called as the pair to kmmio_handler().
+ */
+static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
+{
+	int ret = 0;
+	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
+
+	if (!ctx->active) {
+		pr_debug("kmmio: spurious debug trap on CPU %d.\n",
+							smp_processor_id());
+		goto out;
+	}
+
+	if (ctx->probe && ctx->probe->post_handler)
+		ctx->probe->post_handler(ctx->probe, condition, regs);
+
+	arm_kmmio_fault_page(ctx->fpage->page, NULL);
+
+	regs->flags &= ~X86_EFLAGS_TF;
+	regs->flags |= ctx->saved_flags;
+
+	/* These were acquired in kmmio_handler(). */
+	ctx->active--;
+	BUG_ON(ctx->active);
+	rcu_read_unlock();
+	preempt_enable_no_resched();
+
+	/*
+	 * if somebody else is singlestepping across a probe point, flags
+	 * will have TF set, in which case, continue the remaining processing
+	 * of do_debug, as if this is not a probe hit.
+	 */
+	if (!(regs->flags & X86_EFLAGS_TF))
+		ret = 1;
+out:
+	put_cpu_var(kmmio_ctx);
+	return ret;
+}
+
+/* You must be holding kmmio_lock. */
+static int add_kmmio_fault_page(unsigned long page)
+{
+	struct kmmio_fault_page *f;
+
+	page &= PAGE_MASK;
+	f = get_kmmio_fault_page(page);
+	if (f) {
+		if (!f->count)
+			arm_kmmio_fault_page(f->page, NULL);
+		f->count++;
+		return 0;
+	}
+
+	f = kmalloc(sizeof(*f), GFP_ATOMIC);
+	if (!f)
+		return -1;
+
+	f->count = 1;
+	f->page = page;
+	list_add_rcu(&f->list, kmmio_page_list(f->page));
+
+	arm_kmmio_fault_page(f->page, NULL);
+
+	return 0;
+}
+
+/* You must be holding kmmio_lock. */
+static void release_kmmio_fault_page(unsigned long page,
+				struct kmmio_fault_page **release_list)
+{
+	struct kmmio_fault_page *f;
+
+	page &= PAGE_MASK;
+	f = get_kmmio_fault_page(page);
+	if (!f)
+		return;
+
+	f->count--;
+	BUG_ON(f->count < 0);
+	if (!f->count) {
+		disarm_kmmio_fault_page(f->page, NULL);
+		f->release_next = *release_list;
+		*release_list = f;
+	}
+}
+
+int register_kmmio_probe(struct kmmio_probe *p)
+{
+	unsigned long flags;
+	int ret = 0;
+	unsigned long size = 0;
+
+	spin_lock_irqsave(&kmmio_lock, flags);
+	if (get_kmmio_probe(p->addr)) {
+		ret = -EEXIST;
+		goto out;
+	}
+	kmmio_count++;
+	list_add_rcu(&p->list, &kmmio_probes);
+	while (size < p->len) {
+		if (add_kmmio_fault_page(p->addr + size))
+			pr_err("kmmio: Unable to set page fault.\n");
+		size += PAGE_SIZE;
+	}
+out:
+	spin_unlock_irqrestore(&kmmio_lock, flags);
+	/*
+	 * XXX: What should I do here?
+	 * Here was a call to global_flush_tlb(), but it does not exist
+	 * anymore. It seems it's not needed after all.
+	 */
+	return ret;
+}
+EXPORT_SYMBOL(register_kmmio_probe);
+
+static void rcu_free_kmmio_fault_pages(struct rcu_head *head)
+{
+	struct kmmio_delayed_release *dr = container_of(
+						head,
+						struct kmmio_delayed_release,
+						rcu);
+	struct kmmio_fault_page *p = dr->release_list;
+	while (p) {
+		struct kmmio_fault_page *next = p->release_next;
+		BUG_ON(p->count);
+		kfree(p);
+		p = next;
+	}
+	kfree(dr);
+}
+
+static void remove_kmmio_fault_pages(struct rcu_head *head)
+{
+	struct kmmio_delayed_release *dr = container_of(
+						head,
+						struct kmmio_delayed_release,
+						rcu);
+	struct kmmio_fault_page *p = dr->release_list;
+	struct kmmio_fault_page **prevp = &dr->release_list;
+	unsigned long flags;
+	spin_lock_irqsave(&kmmio_lock, flags);
+	while (p) {
+		if (!p->count)
+			list_del_rcu(&p->list);
+		else
+			*prevp = p->release_next;
+		prevp = &p->release_next;
+		p = p->release_next;
+	}
+	spin_unlock_irqrestore(&kmmio_lock, flags);
+	/* This is the real RCU destroy call. */
+	call_rcu(&dr->rcu, rcu_free_kmmio_fault_pages);
+}
+
+/*
+ * Remove a kmmio probe. You have to synchronize_rcu() before you can be
+ * sure that the callbacks will not be called anymore. Only after that
+ * you may actually release your struct kmmio_probe.
+ *
+ * Unregistering a kmmio fault page has three steps:
+ * 1. release_kmmio_fault_page()
+ *    Disarm the page, wait a grace period to let all faults finish.
+ * 2. remove_kmmio_fault_pages()
+ *    Remove the pages from kmmio_page_table.
+ * 3. rcu_free_kmmio_fault_pages()
+ *    Actally free the kmmio_fault_page structs as with RCU.
+ */
+void unregister_kmmio_probe(struct kmmio_probe *p)
+{
+	unsigned long flags;
+	unsigned long size = 0;
+	struct kmmio_fault_page *release_list = NULL;
+	struct kmmio_delayed_release *drelease;
+
+	spin_lock_irqsave(&kmmio_lock, flags);
+	while (size < p->len) {
+		release_kmmio_fault_page(p->addr + size, &release_list);
+		size += PAGE_SIZE;
+	}
+	list_del_rcu(&p->list);
+	kmmio_count--;
+	spin_unlock_irqrestore(&kmmio_lock, flags);
+
+	drelease = kmalloc(sizeof(*drelease), GFP_ATOMIC);
+	if (!drelease) {
+		pr_crit("kmmio: leaking kmmio_fault_page objects.\n");
+		return;
+	}
+	drelease->release_list = release_list;
+
+	/*
+	 * This is not really RCU here. We have just disarmed a set of
+	 * pages so that they cannot trigger page faults anymore. However,
+	 * we cannot remove the pages from kmmio_page_table,
+	 * because a probe hit might be in flight on another CPU. The
+	 * pages are collected into a list, and they will be removed from
+	 * kmmio_page_table when it is certain that no probe hit related to
+	 * these pages can be in flight. RCU grace period sounds like a
+	 * good choice.
+	 *
+	 * If we removed the pages too early, kmmio page fault handler might
+	 * not find the respective kmmio_fault_page and determine it's not
+	 * a kmmio fault, when it actually is. This would lead to madness.
+	 */
+	call_rcu(&drelease->rcu, remove_kmmio_fault_pages);
+}
+EXPORT_SYMBOL(unregister_kmmio_probe);
+
+static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
+								void *args)
+{
+	struct die_args *arg = args;
+
+	if (val == DIE_DEBUG && (arg->err & DR_STEP))
+		if (post_kmmio_handler(arg->err, arg->regs) == 1)
+			return NOTIFY_STOP;
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nb_die = {
+	.notifier_call = kmmio_die_notifier
+};
+
+static int __init init_kmmio(void)
+{
+	int i;
+	for (i = 0; i < KMMIO_PAGE_TABLE_SIZE; i++)
+		INIT_LIST_HEAD(&kmmio_page_table[i]);
+	return register_die_notifier(&nb_die);
+}
+fs_initcall(init_kmmio); /* should be before device_initcall() */
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
new file mode 100644
index 0000000..a8d2a00
--- /dev/null
+++ b/arch/x86/mm/mmio-mod.c
@@ -0,0 +1,513 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2005
+ *               Jeff Muizelaar, 2006, 2007
+ *               Pekka Paalanen, 2008 <pq@iki.fi>
+ *
+ * Derived from the read-mod example from relay-examples by Tom Zanussi.
+ */
+#define DEBUG 1
+
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/version.h>
+#include <linux/kallsyms.h>
+#include <asm/pgtable.h>
+#include <linux/mmiotrace.h>
+#include <asm/e820.h> /* for ISA_START_ADDRESS */
+#include <asm/atomic.h>
+#include <linux/percpu.h>
+#include <linux/cpu.h>
+
+#include "pf_in.h"
+
+#define NAME "mmiotrace: "
+
+struct trap_reason {
+	unsigned long addr;
+	unsigned long ip;
+	enum reason_type type;
+	int active_traces;
+};
+
+struct remap_trace {
+	struct list_head list;
+	struct kmmio_probe probe;
+	unsigned long phys;
+	unsigned long id;
+};
+
+/* Accessed per-cpu. */
+static DEFINE_PER_CPU(struct trap_reason, pf_reason);
+static DEFINE_PER_CPU(struct mmiotrace_rw, cpu_trace);
+
+#if 0 /* XXX: no way gather this info anymore */
+/* Access to this is not per-cpu. */
+static DEFINE_PER_CPU(atomic_t, dropped);
+#endif
+
+static struct dentry *marker_file;
+
+static DEFINE_MUTEX(mmiotrace_mutex);
+static DEFINE_SPINLOCK(trace_lock);
+static atomic_t mmiotrace_enabled;
+static LIST_HEAD(trace_list);		/* struct remap_trace */
+
+/*
+ * Locking in this file:
+ * - mmiotrace_mutex enforces enable/disable_mmiotrace() critical sections.
+ * - mmiotrace_enabled may be modified only when holding mmiotrace_mutex
+ *   and trace_lock.
+ * - Routines depending on is_enabled() must take trace_lock.
+ * - trace_list users must hold trace_lock.
+ * - is_enabled() guarantees that mmio_trace_record is allowed.
+ * - pre/post callbacks assume the effect of is_enabled() being true.
+ */
+
+/* module parameters */
+static unsigned long	filter_offset;
+static int		nommiotrace;
+static int		trace_pc;
+
+module_param(filter_offset, ulong, 0);
+module_param(nommiotrace, bool, 0);
+module_param(trace_pc, bool, 0);
+
+MODULE_PARM_DESC(filter_offset, "Start address of traced mappings.");
+MODULE_PARM_DESC(nommiotrace, "Disable actual MMIO tracing.");
+MODULE_PARM_DESC(trace_pc, "Record address of faulting instructions.");
+
+static bool is_enabled(void)
+{
+	return atomic_read(&mmiotrace_enabled);
+}
+
+#if 0 /* XXX: needs rewrite */
+/*
+ * Write callback for the debugfs entry:
+ * Read a marker and write it to the mmio trace log
+ */
+static ssize_t write_marker(struct file *file, const char __user *buffer,
+						size_t count, loff_t *ppos)
+{
+	char *event = NULL;
+	struct mm_io_header *headp;
+	ssize_t len = (count > 65535) ? 65535 : count;
+
+	event = kzalloc(sizeof(*headp) + len, GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	headp = (struct mm_io_header *)event;
+	headp->type = MMIO_MAGIC | (MMIO_MARKER << MMIO_OPCODE_SHIFT);
+	headp->data_len = len;
+
+	if (copy_from_user(event + sizeof(*headp), buffer, len)) {
+		kfree(event);
+		return -EFAULT;
+	}
+
+	spin_lock_irq(&trace_lock);
+#if 0 /* XXX: convert this to use tracing */
+	if (is_enabled())
+		relay_write(chan, event, sizeof(*headp) + len);
+	else
+#endif
+		len = -EINVAL;
+	spin_unlock_irq(&trace_lock);
+	kfree(event);
+	return len;
+}
+#endif
+
+static void print_pte(unsigned long address)
+{
+	int level;
+	pte_t *pte = lookup_address(address, &level);
+
+	if (!pte) {
+		pr_err(NAME "Error in %s: no pte for page 0x%08lx\n",
+							__func__, address);
+		return;
+	}
+
+	if (level == PG_LEVEL_2M) {
+		pr_emerg(NAME "4MB pages are not currently supported: "
+							"0x%08lx\n", address);
+		BUG();
+	}
+	pr_info(NAME "pte for 0x%lx: 0x%llx 0x%llx\n", address,
+		(unsigned long long)pte_val(*pte),
+		(unsigned long long)pte_val(*pte) & _PAGE_PRESENT);
+}
+
+/*
+ * For some reason the pre/post pairs have been called in an
+ * unmatched order. Report and die.
+ */
+static void die_kmmio_nesting_error(struct pt_regs *regs, unsigned long addr)
+{
+	const struct trap_reason *my_reason = &get_cpu_var(pf_reason);
+	pr_emerg(NAME "unexpected fault for address: 0x%08lx, "
+					"last fault for address: 0x%08lx\n",
+					addr, my_reason->addr);
+	print_pte(addr);
+	print_symbol(KERN_EMERG "faulting IP is at %s\n", regs->ip);
+	print_symbol(KERN_EMERG "last faulting IP was at %s\n", my_reason->ip);
+#ifdef __i386__
+	pr_emerg("eax: %08lx   ebx: %08lx   ecx: %08lx   edx: %08lx\n",
+			regs->ax, regs->bx, regs->cx, regs->dx);
+	pr_emerg("esi: %08lx   edi: %08lx   ebp: %08lx   esp: %08lx\n",
+			regs->si, regs->di, regs->bp, regs->sp);
+#else
+	pr_emerg("rax: %016lx   rcx: %016lx   rdx: %016lx\n",
+					regs->ax, regs->cx, regs->dx);
+	pr_emerg("rsi: %016lx   rdi: %016lx   rbp: %016lx   rsp: %016lx\n",
+				regs->si, regs->di, regs->bp, regs->sp);
+#endif
+	put_cpu_var(pf_reason);
+	BUG();
+}
+
+static void pre(struct kmmio_probe *p, struct pt_regs *regs,
+						unsigned long addr)
+{
+	struct trap_reason *my_reason = &get_cpu_var(pf_reason);
+	struct mmiotrace_rw *my_trace = &get_cpu_var(cpu_trace);
+	const unsigned long instptr = instruction_pointer(regs);
+	const enum reason_type type = get_ins_type(instptr);
+	struct remap_trace *trace = p->user_data;
+
+	/* it doesn't make sense to have more than one active trace per cpu */
+	if (my_reason->active_traces)
+		die_kmmio_nesting_error(regs, addr);
+	else
+		my_reason->active_traces++;
+
+	my_reason->type = type;
+	my_reason->addr = addr;
+	my_reason->ip = instptr;
+
+	my_trace->phys = addr - trace->probe.addr + trace->phys;
+	my_trace->map_id = trace->id;
+
+	/*
+	 * Only record the program counter when requested.
+	 * It may taint clean-room reverse engineering.
+	 */
+	if (trace_pc)
+		my_trace->pc = instptr;
+	else
+		my_trace->pc = 0;
+
+	/*
+	 * XXX: the timestamp recorded will be *after* the tracing has been
+	 * done, not at the time we hit the instruction. SMP implications
+	 * on event ordering?
+	 */
+
+	switch (type) {
+	case REG_READ:
+		my_trace->opcode = MMIO_READ;
+		my_trace->width = get_ins_mem_width(instptr);
+		break;
+	case REG_WRITE:
+		my_trace->opcode = MMIO_WRITE;
+		my_trace->width = get_ins_mem_width(instptr);
+		my_trace->value = get_ins_reg_val(instptr, regs);
+		break;
+	case IMM_WRITE:
+		my_trace->opcode = MMIO_WRITE;
+		my_trace->width = get_ins_mem_width(instptr);
+		my_trace->value = get_ins_imm_val(instptr);
+		break;
+	default:
+		{
+			unsigned char *ip = (unsigned char *)instptr;
+			my_trace->opcode = MMIO_UNKNOWN_OP;
+			my_trace->width = 0;
+			my_trace->value = (*ip) << 16 | *(ip + 1) << 8 |
+								*(ip + 2);
+		}
+	}
+	put_cpu_var(cpu_trace);
+	put_cpu_var(pf_reason);
+}
+
+static void post(struct kmmio_probe *p, unsigned long condition,
+							struct pt_regs *regs)
+{
+	struct trap_reason *my_reason = &get_cpu_var(pf_reason);
+	struct mmiotrace_rw *my_trace = &get_cpu_var(cpu_trace);
+
+	/* this should always return the active_trace count to 0 */
+	my_reason->active_traces--;
+	if (my_reason->active_traces) {
+		pr_emerg(NAME "unexpected post handler");
+		BUG();
+	}
+
+	switch (my_reason->type) {
+	case REG_READ:
+		my_trace->value = get_ins_reg_val(my_reason->ip, regs);
+		break;
+	default:
+		break;
+	}
+
+	mmio_trace_rw(my_trace);
+	put_cpu_var(cpu_trace);
+	put_cpu_var(pf_reason);
+}
+
+static void ioremap_trace_core(unsigned long offset, unsigned long size,
+							void __iomem *addr)
+{
+	static atomic_t next_id;
+	struct remap_trace *trace = kmalloc(sizeof(*trace), GFP_KERNEL);
+	struct mmiotrace_map map = {
+		.phys = offset,
+		.virt = (unsigned long)addr,
+		.len = size,
+		.opcode = MMIO_PROBE
+	};
+
+	if (!trace) {
+		pr_err(NAME "kmalloc failed in ioremap\n");
+		return;
+	}
+
+	*trace = (struct remap_trace) {
+		.probe = {
+			.addr = (unsigned long)addr,
+			.len = size,
+			.pre_handler = pre,
+			.post_handler = post,
+			.user_data = trace
+		},
+		.phys = offset,
+		.id = atomic_inc_return(&next_id)
+	};
+	map.map_id = trace->id;
+
+	spin_lock_irq(&trace_lock);
+	if (!is_enabled())
+		goto not_enabled;
+
+	mmio_trace_mapping(&map);
+	list_add_tail(&trace->list, &trace_list);
+	if (!nommiotrace)
+		register_kmmio_probe(&trace->probe);
+
+not_enabled:
+	spin_unlock_irq(&trace_lock);
+}
+
+void
+mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr)
+{
+	if (!is_enabled()) /* recheck and proper locking in *_core() */
+		return;
+
+	pr_debug(NAME "ioremap_*(0x%lx, 0x%lx) = %p\n", offset, size, addr);
+	if ((filter_offset) && (offset != filter_offset))
+		return;
+	ioremap_trace_core(offset, size, addr);
+}
+
+static void iounmap_trace_core(volatile void __iomem *addr)
+{
+	struct mmiotrace_map map = {
+		.phys = 0,
+		.virt = (unsigned long)addr,
+		.len = 0,
+		.opcode = MMIO_UNPROBE
+	};
+	struct remap_trace *trace;
+	struct remap_trace *tmp;
+	struct remap_trace *found_trace = NULL;
+
+	pr_debug(NAME "Unmapping %p.\n", addr);
+
+	spin_lock_irq(&trace_lock);
+	if (!is_enabled())
+		goto not_enabled;
+
+	list_for_each_entry_safe(trace, tmp, &trace_list, list) {
+		if ((unsigned long)addr == trace->probe.addr) {
+			if (!nommiotrace)
+				unregister_kmmio_probe(&trace->probe);
+			list_del(&trace->list);
+			found_trace = trace;
+			break;
+		}
+	}
+	map.map_id = (found_trace) ? found_trace->id : -1;
+	mmio_trace_mapping(&map);
+
+not_enabled:
+	spin_unlock_irq(&trace_lock);
+	if (found_trace) {
+		synchronize_rcu(); /* unregister_kmmio_probe() requirement */
+		kfree(found_trace);
+	}
+}
+
+void mmiotrace_iounmap(volatile void __iomem *addr)
+{
+	might_sleep();
+	if (is_enabled()) /* recheck and proper locking in *_core() */
+		iounmap_trace_core(addr);
+}
+
+static void clear_trace_list(void)
+{
+	struct remap_trace *trace;
+	struct remap_trace *tmp;
+
+	/*
+	 * No locking required, because the caller ensures we are in a
+	 * critical section via mutex, and is_enabled() is false,
+	 * i.e. nothing can traverse or modify this list.
+	 * Caller also ensures is_enabled() cannot change.
+	 */
+	list_for_each_entry(trace, &trace_list, list) {
+		pr_notice(NAME "purging non-iounmapped "
+					"trace @0x%08lx, size 0x%lx.\n",
+					trace->probe.addr, trace->probe.len);
+		if (!nommiotrace)
+			unregister_kmmio_probe(&trace->probe);
+	}
+	synchronize_rcu(); /* unregister_kmmio_probe() requirement */
+
+	list_for_each_entry_safe(trace, tmp, &trace_list, list) {
+		list_del(&trace->list);
+		kfree(trace);
+	}
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static cpumask_t downed_cpus;
+
+static void enter_uniprocessor(void)
+{
+	int cpu;
+	int err;
+
+	get_online_cpus();
+	downed_cpus = cpu_online_map;
+	cpu_clear(first_cpu(cpu_online_map), downed_cpus);
+	if (num_online_cpus() > 1)
+		pr_notice(NAME "Disabling non-boot CPUs...\n");
+	put_online_cpus();
+
+	for_each_cpu_mask(cpu, downed_cpus) {
+		err = cpu_down(cpu);
+		if (!err)
+			pr_info(NAME "CPU%d is down.\n", cpu);
+		else
+			pr_err(NAME "Error taking CPU%d down: %d\n", cpu, err);
+	}
+	if (num_online_cpus() > 1)
+		pr_warning(NAME "multiple CPUs still online, "
+						"may miss events.\n");
+}
+
+static void leave_uniprocessor(void)
+{
+	int cpu;
+	int err;
+
+	if (cpus_weight(downed_cpus) == 0)
+		return;
+	pr_notice(NAME "Re-enabling CPUs...\n");
+	for_each_cpu_mask(cpu, downed_cpus) {
+		err = cpu_up(cpu);
+		if (!err)
+			pr_info(NAME "enabled CPU%d.\n", cpu);
+		else
+			pr_err(NAME "cannot re-enable CPU%d: %d\n", cpu, err);
+	}
+}
+
+#else /* !CONFIG_HOTPLUG_CPU */
+static void enter_uniprocessor(void)
+{
+	if (num_online_cpus() > 1)
+		pr_warning(NAME "multiple CPUs are online, may miss events. "
+			"Suggest booting with maxcpus=1 kernel argument.\n");
+}
+
+static void leave_uniprocessor(void)
+{
+}
+#endif
+
+#if 0 /* XXX: out of order */
+static struct file_operations fops_marker = {
+	.owner =	THIS_MODULE,
+	.write =	write_marker
+};
+#endif
+
+void enable_mmiotrace(void)
+{
+	mutex_lock(&mmiotrace_mutex);
+	if (is_enabled())
+		goto out;
+
+#if 0 /* XXX: tracing does not support text entries */
+	marker_file = debugfs_create_file("marker", 0660, dir, NULL,
+								&fops_marker);
+	if (!marker_file)
+		pr_err(NAME "marker file creation failed.\n");
+#endif
+
+	if (nommiotrace)
+		pr_info(NAME "MMIO tracing disabled.\n");
+	enter_uniprocessor();
+	spin_lock_irq(&trace_lock);
+	atomic_inc(&mmiotrace_enabled);
+	spin_unlock_irq(&trace_lock);
+	pr_info(NAME "enabled.\n");
+out:
+	mutex_unlock(&mmiotrace_mutex);
+}
+
+void disable_mmiotrace(void)
+{
+	mutex_lock(&mmiotrace_mutex);
+	if (!is_enabled())
+		goto out;
+
+	spin_lock_irq(&trace_lock);
+	atomic_dec(&mmiotrace_enabled);
+	BUG_ON(is_enabled());
+	spin_unlock_irq(&trace_lock);
+
+	clear_trace_list(); /* guarantees: no more kmmio callbacks */
+	leave_uniprocessor();
+	if (marker_file) {
+		debugfs_remove(marker_file);
+		marker_file = NULL;
+	}
+
+	pr_info(NAME "disabled.\n");
+out:
+	mutex_unlock(&mmiotrace_mutex);
+}
diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
new file mode 100644
index 0000000..efa1911
--- /dev/null
+++ b/arch/x86/mm/pf_in.c
@@ -0,0 +1,489 @@
+/*
+ *  Fault Injection Test harness (FI)
+ *  Copyright (C) Intel Crop.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
+ *  USA.
+ *
+ */
+
+/*  Id: pf_in.c,v 1.1.1.1 2002/11/12 05:56:32 brlock Exp
+ *  Copyright by Intel Crop., 2002
+ *  Louis Zhuang (louis.zhuang@intel.com)
+ *
+ *  Bjorn Steinbrink (B.Steinbrink@gmx.de), 2007
+ */
+
+#include <linux/module.h>
+#include <linux/ptrace.h> /* struct pt_regs */
+#include "pf_in.h"
+
+#ifdef __i386__
+/* IA32 Manual 3, 2-1 */
+static unsigned char prefix_codes[] = {
+	0xF0, 0xF2, 0xF3, 0x2E, 0x36, 0x3E, 0x26, 0x64,
+	0x65, 0x2E, 0x3E, 0x66, 0x67
+};
+/* IA32 Manual 3, 3-432*/
+static unsigned int reg_rop[] = {
+	0x8A, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+};
+static unsigned int reg_wop[] = { 0x88, 0x89 };
+static unsigned int imm_wop[] = { 0xC6, 0xC7 };
+/* IA32 Manual 3, 3-432*/
+static unsigned int rw8[] = { 0x88, 0x8A, 0xC6 };
+static unsigned int rw32[] = {
+	0x89, 0x8B, 0xC7, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+};
+static unsigned int mw8[] = { 0x88, 0x8A, 0xC6, 0xB60F, 0xBE0F };
+static unsigned int mw16[] = { 0xB70F, 0xBF0F };
+static unsigned int mw32[] = { 0x89, 0x8B, 0xC7 };
+static unsigned int mw64[] = {};
+#else /* not __i386__ */
+static unsigned char prefix_codes[] = {
+	0x66, 0x67, 0x2E, 0x3E, 0x26, 0x64, 0x65, 0x36,
+	0xF0, 0xF3, 0xF2,
+	/* REX Prefixes */
+	0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
+	0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f
+};
+/* AMD64 Manual 3, Appendix A*/
+static unsigned int reg_rop[] = {
+	0x8A, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+};
+static unsigned int reg_wop[] = { 0x88, 0x89 };
+static unsigned int imm_wop[] = { 0xC6, 0xC7 };
+static unsigned int rw8[] = { 0xC6, 0x88, 0x8A };
+static unsigned int rw32[] = {
+	0xC7, 0x89, 0x8B, 0xB60F, 0xB70F, 0xBE0F, 0xBF0F
+};
+/* 8 bit only */
+static unsigned int mw8[] = { 0xC6, 0x88, 0x8A, 0xB60F, 0xBE0F };
+/* 16 bit only */
+static unsigned int mw16[] = { 0xB70F, 0xBF0F };
+/* 16 or 32 bit */
+static unsigned int mw32[] = { 0xC7 };
+/* 16, 32 or 64 bit */
+static unsigned int mw64[] = { 0x89, 0x8B };
+#endif /* not __i386__ */
+
+static int skip_prefix(unsigned char *addr, int *shorted, int *enlarged,
+								int *rexr)
+{
+	int i;
+	unsigned char *p = addr;
+	*shorted = 0;
+	*enlarged = 0;
+	*rexr = 0;
+
+restart:
+	for (i = 0; i < ARRAY_SIZE(prefix_codes); i++) {
+		if (*p == prefix_codes[i]) {
+			if (*p == 0x66)
+				*shorted = 1;
+#ifdef __amd64__
+			if ((*p & 0xf8) == 0x48)
+				*enlarged = 1;
+			if ((*p & 0xf4) == 0x44)
+				*rexr = 1;
+#endif
+			p++;
+			goto restart;
+		}
+	}
+
+	return (p - addr);
+}
+
+static int get_opcode(unsigned char *addr, unsigned int *opcode)
+{
+	int len;
+
+	if (*addr == 0x0F) {
+		/* 0x0F is extension instruction */
+		*opcode = *(unsigned short *)addr;
+		len = 2;
+	} else {
+		*opcode = *addr;
+		len = 1;
+	}
+
+	return len;
+}
+
+#define CHECK_OP_TYPE(opcode, array, type) \
+	for (i = 0; i < ARRAY_SIZE(array); i++) { \
+		if (array[i] == opcode) { \
+			rv = type; \
+			goto exit; \
+		} \
+	}
+
+enum reason_type get_ins_type(unsigned long ins_addr)
+{
+	unsigned int opcode;
+	unsigned char *p;
+	int shorted, enlarged, rexr;
+	int i;
+	enum reason_type rv = OTHERS;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+
+	CHECK_OP_TYPE(opcode, reg_rop, REG_READ);
+	CHECK_OP_TYPE(opcode, reg_wop, REG_WRITE);
+	CHECK_OP_TYPE(opcode, imm_wop, IMM_WRITE);
+
+exit:
+	return rv;
+}
+#undef CHECK_OP_TYPE
+
+static unsigned int get_ins_reg_width(unsigned long ins_addr)
+{
+	unsigned int opcode;
+	unsigned char *p;
+	int i, shorted, enlarged, rexr;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+
+	for (i = 0; i < ARRAY_SIZE(rw8); i++)
+		if (rw8[i] == opcode)
+			return 1;
+
+	for (i = 0; i < ARRAY_SIZE(rw32); i++)
+		if (rw32[i] == opcode)
+			return (shorted ? 2 : (enlarged ? 8 : 4));
+
+	printk(KERN_ERR "mmiotrace: Unknown opcode 0x%02x\n", opcode);
+	return 0;
+}
+
+unsigned int get_ins_mem_width(unsigned long ins_addr)
+{
+	unsigned int opcode;
+	unsigned char *p;
+	int i, shorted, enlarged, rexr;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+
+	for (i = 0; i < ARRAY_SIZE(mw8); i++)
+		if (mw8[i] == opcode)
+			return 1;
+
+	for (i = 0; i < ARRAY_SIZE(mw16); i++)
+		if (mw16[i] == opcode)
+			return 2;
+
+	for (i = 0; i < ARRAY_SIZE(mw32); i++)
+		if (mw32[i] == opcode)
+			return shorted ? 2 : 4;
+
+	for (i = 0; i < ARRAY_SIZE(mw64); i++)
+		if (mw64[i] == opcode)
+			return shorted ? 2 : (enlarged ? 8 : 4);
+
+	printk(KERN_ERR "mmiotrace: Unknown opcode 0x%02x\n", opcode);
+	return 0;
+}
+
+/*
+ * Define register ident in mod/rm byte.
+ * Note: these are NOT the same as in ptrace-abi.h.
+ */
+enum {
+	arg_AL = 0,
+	arg_CL = 1,
+	arg_DL = 2,
+	arg_BL = 3,
+	arg_AH = 4,
+	arg_CH = 5,
+	arg_DH = 6,
+	arg_BH = 7,
+
+	arg_AX = 0,
+	arg_CX = 1,
+	arg_DX = 2,
+	arg_BX = 3,
+	arg_SP = 4,
+	arg_BP = 5,
+	arg_SI = 6,
+	arg_DI = 7,
+#ifdef __amd64__
+	arg_R8  = 8,
+	arg_R9  = 9,
+	arg_R10 = 10,
+	arg_R11 = 11,
+	arg_R12 = 12,
+	arg_R13 = 13,
+	arg_R14 = 14,
+	arg_R15 = 15
+#endif
+};
+
+static unsigned char *get_reg_w8(int no, struct pt_regs *regs)
+{
+	unsigned char *rv = NULL;
+
+	switch (no) {
+	case arg_AL:
+		rv = (unsigned char *)&regs->ax;
+		break;
+	case arg_BL:
+		rv = (unsigned char *)&regs->bx;
+		break;
+	case arg_CL:
+		rv = (unsigned char *)&regs->cx;
+		break;
+	case arg_DL:
+		rv = (unsigned char *)&regs->dx;
+		break;
+	case arg_AH:
+		rv = 1 + (unsigned char *)&regs->ax;
+		break;
+	case arg_BH:
+		rv = 1 + (unsigned char *)&regs->bx;
+		break;
+	case arg_CH:
+		rv = 1 + (unsigned char *)&regs->cx;
+		break;
+	case arg_DH:
+		rv = 1 + (unsigned char *)&regs->dx;
+		break;
+#ifdef __amd64__
+	case arg_R8:
+		rv = (unsigned char *)&regs->r8;
+		break;
+	case arg_R9:
+		rv = (unsigned char *)&regs->r9;
+		break;
+	case arg_R10:
+		rv = (unsigned char *)&regs->r10;
+		break;
+	case arg_R11:
+		rv = (unsigned char *)&regs->r11;
+		break;
+	case arg_R12:
+		rv = (unsigned char *)&regs->r12;
+		break;
+	case arg_R13:
+		rv = (unsigned char *)&regs->r13;
+		break;
+	case arg_R14:
+		rv = (unsigned char *)&regs->r14;
+		break;
+	case arg_R15:
+		rv = (unsigned char *)&regs->r15;
+		break;
+#endif
+	default:
+		printk(KERN_ERR "mmiotrace: Error reg no# %d\n", no);
+		break;
+	}
+	return rv;
+}
+
+static unsigned long *get_reg_w32(int no, struct pt_regs *regs)
+{
+	unsigned long *rv = NULL;
+
+	switch (no) {
+	case arg_AX:
+		rv = &regs->ax;
+		break;
+	case arg_BX:
+		rv = &regs->bx;
+		break;
+	case arg_CX:
+		rv = &regs->cx;
+		break;
+	case arg_DX:
+		rv = &regs->dx;
+		break;
+	case arg_SP:
+		rv = &regs->sp;
+		break;
+	case arg_BP:
+		rv = &regs->bp;
+		break;
+	case arg_SI:
+		rv = &regs->si;
+		break;
+	case arg_DI:
+		rv = &regs->di;
+		break;
+#ifdef __amd64__
+	case arg_R8:
+		rv = &regs->r8;
+		break;
+	case arg_R9:
+		rv = &regs->r9;
+		break;
+	case arg_R10:
+		rv = &regs->r10;
+		break;
+	case arg_R11:
+		rv = &regs->r11;
+		break;
+	case arg_R12:
+		rv = &regs->r12;
+		break;
+	case arg_R13:
+		rv = &regs->r13;
+		break;
+	case arg_R14:
+		rv = &regs->r14;
+		break;
+	case arg_R15:
+		rv = &regs->r15;
+		break;
+#endif
+	default:
+		printk(KERN_ERR "mmiotrace: Error reg no# %d\n", no);
+	}
+
+	return rv;
+}
+
+unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs)
+{
+	unsigned int opcode;
+	unsigned char mod_rm;
+	int reg;
+	unsigned char *p;
+	int i, shorted, enlarged, rexr;
+	unsigned long rv;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+	for (i = 0; i < ARRAY_SIZE(reg_rop); i++)
+		if (reg_rop[i] == opcode) {
+			rv = REG_READ;
+			goto do_work;
+		}
+
+	for (i = 0; i < ARRAY_SIZE(reg_wop); i++)
+		if (reg_wop[i] == opcode) {
+			rv = REG_WRITE;
+			goto do_work;
+		}
+
+	printk(KERN_ERR "mmiotrace: Not a register instruction, opcode "
+							"0x%02x\n", opcode);
+	goto err;
+
+do_work:
+	mod_rm = *p;
+	reg = ((mod_rm >> 3) & 0x7) | (rexr << 3);
+	switch (get_ins_reg_width(ins_addr)) {
+	case 1:
+		return *get_reg_w8(reg, regs);
+
+	case 2:
+		return *(unsigned short *)get_reg_w32(reg, regs);
+
+	case 4:
+		return *(unsigned int *)get_reg_w32(reg, regs);
+
+#ifdef __amd64__
+	case 8:
+		return *(unsigned long *)get_reg_w32(reg, regs);
+#endif
+
+	default:
+		printk(KERN_ERR "mmiotrace: Error width# %d\n", reg);
+	}
+
+err:
+	return 0;
+}
+
+unsigned long get_ins_imm_val(unsigned long ins_addr)
+{
+	unsigned int opcode;
+	unsigned char mod_rm;
+	unsigned char mod;
+	unsigned char *p;
+	int i, shorted, enlarged, rexr;
+	unsigned long rv;
+
+	p = (unsigned char *)ins_addr;
+	p += skip_prefix(p, &shorted, &enlarged, &rexr);
+	p += get_opcode(p, &opcode);
+	for (i = 0; i < ARRAY_SIZE(imm_wop); i++)
+		if (imm_wop[i] == opcode) {
+			rv = IMM_WRITE;
+			goto do_work;
+		}
+
+	printk(KERN_ERR "mmiotrace: Not an immediate instruction, opcode "
+							"0x%02x\n", opcode);
+	goto err;
+
+do_work:
+	mod_rm = *p;
+	mod = mod_rm >> 6;
+	p++;
+	switch (mod) {
+	case 0:
+		/* if r/m is 5 we have a 32 disp (IA32 Manual 3, Table 2-2)  */
+		/* AMD64: XXX Check for address size prefix? */
+		if ((mod_rm & 0x7) == 0x5)
+			p += 4;
+		break;
+
+	case 1:
+		p += 1;
+		break;
+
+	case 2:
+		p += 4;
+		break;
+
+	case 3:
+	default:
+		printk(KERN_ERR "mmiotrace: not a memory access instruction "
+						"at 0x%lx, rm_mod=0x%02x\n",
+						ins_addr, mod_rm);
+	}
+
+	switch (get_ins_reg_width(ins_addr)) {
+	case 1:
+		return *(unsigned char *)p;
+
+	case 2:
+		return *(unsigned short *)p;
+
+	case 4:
+		return *(unsigned int *)p;
+
+#ifdef __amd64__
+	case 8:
+		return *(unsigned long *)p;
+#endif
+
+	default:
+		printk(KERN_ERR "mmiotrace: Error: width.\n");
+	}
+
+err:
+	return 0;
+}
diff --git a/arch/x86/mm/pf_in.h b/arch/x86/mm/pf_in.h
new file mode 100644
index 0000000..e05341a
--- /dev/null
+++ b/arch/x86/mm/pf_in.h
@@ -0,0 +1,39 @@
+/*
+ *  Fault Injection Test harness (FI)
+ *  Copyright (C) Intel Crop.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
+ *  USA.
+ *
+ */
+
+#ifndef __PF_H_
+#define __PF_H_
+
+enum reason_type {
+	NOT_ME,	/* page fault is not in regions */
+	NOTHING,	/* access others point in regions */
+	REG_READ,	/* read from addr to reg */
+	REG_WRITE,	/* write from reg to addr */
+	IMM_WRITE,	/* write from imm to addr */
+	OTHERS	/* Other instructions can not intercept */
+};
+
+enum reason_type get_ins_type(unsigned long ins_addr);
+unsigned int get_ins_mem_width(unsigned long ins_addr);
+unsigned long get_ins_reg_val(unsigned long ins_addr, struct pt_regs *regs);
+unsigned long get_ins_imm_val(unsigned long ins_addr);
+
+#endif /* __PF_H_ */
diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
new file mode 100644
index 0000000..d877c5b
--- /dev/null
+++ b/arch/x86/mm/testmmiotrace.c
@@ -0,0 +1,71 @@
+/*
+ * Written by Pekka Paalanen, 2008 <pq@iki.fi>
+ */
+#include <linux/module.h>
+#include <linux/io.h>
+
+#define MODULE_NAME "testmmiotrace"
+
+static unsigned long mmio_address;
+module_param(mmio_address, ulong, 0);
+MODULE_PARM_DESC(mmio_address, "Start address of the mapping of 16 kB.");
+
+static void do_write_test(void __iomem *p)
+{
+	unsigned int i;
+	for (i = 0; i < 256; i++)
+		iowrite8(i, p + i);
+	for (i = 1024; i < (5 * 1024); i += 2)
+		iowrite16(i * 12 + 7, p + i);
+	for (i = (5 * 1024); i < (16 * 1024); i += 4)
+		iowrite32(i * 212371 + 13, p + i);
+}
+
+static void do_read_test(void __iomem *p)
+{
+	unsigned int i;
+	for (i = 0; i < 256; i++)
+		ioread8(p + i);
+	for (i = 1024; i < (5 * 1024); i += 2)
+		ioread16(p + i);
+	for (i = (5 * 1024); i < (16 * 1024); i += 4)
+		ioread32(p + i);
+}
+
+static void do_test(void)
+{
+	void __iomem *p = ioremap_nocache(mmio_address, 0x4000);
+	if (!p) {
+		pr_err(MODULE_NAME ": could not ioremap, aborting.\n");
+		return;
+	}
+	do_write_test(p);
+	do_read_test(p);
+	iounmap(p);
+}
+
+static int __init init(void)
+{
+	if (mmio_address == 0) {
+		pr_err(MODULE_NAME ": you have to use the module argument "
+							"mmio_address.\n");
+		pr_err(MODULE_NAME ": DO NOT LOAD THIS MODULE UNLESS"
+				" YOU REALLY KNOW WHAT YOU ARE DOING!\n");
+		return -ENXIO;
+	}
+
+	pr_warning(MODULE_NAME ": WARNING: mapping 16 kB @ 0x%08lx "
+					"in PCI address space, and writing "
+					"rubbish in there.\n", mmio_address);
+	do_test();
+	return 0;
+}
+
+static void __exit cleanup(void)
+{
+	pr_debug(MODULE_NAME ": unloaded.\n");
+}
+
+module_init(init);
+module_exit(cleanup);
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
new file mode 100644
index 0000000..de8e912
--- /dev/null
+++ b/include/linux/mmiotrace.h
@@ -0,0 +1,85 @@
+#ifndef MMIOTRACE_H
+#define MMIOTRACE_H
+
+#include <linux/types.h>
+
+#include <linux/list.h>
+
+struct kmmio_probe;
+struct pt_regs;
+
+typedef void (*kmmio_pre_handler_t)(struct kmmio_probe *,
+				struct pt_regs *, unsigned long addr);
+typedef void (*kmmio_post_handler_t)(struct kmmio_probe *,
+				unsigned long condition, struct pt_regs *);
+
+struct kmmio_probe {
+	struct list_head list; /* kmmio internal list */
+	unsigned long addr; /* start location of the probe point */
+	unsigned long len; /* length of the probe region */
+	kmmio_pre_handler_t pre_handler; /* Called before addr is executed. */
+	kmmio_post_handler_t post_handler; /* Called after addr is executed */
+	void *user_data;
+};
+
+/* kmmio is active by some kmmio_probes? */
+static inline int is_kmmio_active(void)
+{
+	extern unsigned int kmmio_count;
+	return kmmio_count;
+}
+
+extern int register_kmmio_probe(struct kmmio_probe *p);
+extern void unregister_kmmio_probe(struct kmmio_probe *p);
+
+/* Called from page fault handler. */
+extern int kmmio_handler(struct pt_regs *regs, unsigned long addr);
+
+/* Called from ioremap.c */
+#ifdef CONFIG_MMIOTRACE
+extern void
+mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr);
+extern void mmiotrace_iounmap(volatile void __iomem *addr);
+#else
+static inline void
+mmiotrace_ioremap(unsigned long offset, unsigned long size, void __iomem *addr)
+{
+}
+static inline void mmiotrace_iounmap(volatile void __iomem *addr)
+{
+}
+#endif /* CONFIG_MMIOTRACE_HOOKS */
+
+enum mm_io_opcode {
+	MMIO_READ = 0x1,     /* struct mmiotrace_rw */
+	MMIO_WRITE = 0x2,    /* struct mmiotrace_rw */
+	MMIO_PROBE = 0x3,    /* struct mmiotrace_map */
+	MMIO_UNPROBE = 0x4,  /* struct mmiotrace_map */
+	MMIO_MARKER = 0x5,   /* raw char data */
+	MMIO_UNKNOWN_OP = 0x6, /* struct mmiotrace_rw */
+};
+
+struct mmiotrace_rw {
+	unsigned long phys;	/* PCI address of register */
+	unsigned long value;
+	unsigned long pc;	/* optional program counter */
+	int map_id;
+	unsigned char opcode;	/* one of MMIO_{READ,WRITE,UNKNOWN_OP} */
+	unsigned char width;	/* size of register access in bytes */
+};
+
+struct mmiotrace_map {
+	unsigned long phys;	/* base address in PCI space */
+	unsigned long virt;	/* base virtual address */
+	unsigned long len;	/* mapping size */
+	int map_id;
+	unsigned char opcode;	/* MMIO_PROBE or MMIO_UNPROBE */
+};
+
+/* in kernel/trace/trace_mmiotrace.c */
+extern void enable_mmiotrace(void);
+extern void disable_mmiotrace(void);
+extern void mmio_trace_rw(struct mmiotrace_rw *rw);
+extern void mmio_trace_mapping(struct mmiotrace_map *map);
+
+#endif /* MMIOTRACE_H */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbYLYQ7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbYLYQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 11:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYLYQ67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 11:58:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50808 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYLYQ65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 11:58:57 -0500
Date: Thu, 25 Dec 2008 17:58:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] OProfile updates for v2.6.29
Message-ID: <20081225165838.GA31627@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest oprofile-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git oprofile-for-linus

[ it merges without conflicts with the x86 tree and with the tracing tree. ]

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      oprofile: select RING_BUFFER

Robert Richter (19):
      oprofile: comment cleanup
      oprofile: update comment for oprofile_add_sample()
      oprofile: whitspace changes only
      oprofile: fix typo
      x86/oprofile: reordering IBS code in op_model_amd.c
      x86/oprofile: cleanup IBS init/exit functions in op_model_amd.c
      oprofile: implement switch/case in buffer_sync.c
      oprofile: set values to default when creating oprofilefs
      ring_buffer: update description for ring_buffer_alloc()
      ftrace: remove unused function arg in trace_iterator_increment()
      oprofile: adding cpu buffer r/w access functions
      oprofile: adding cpu_buffer_write_commit()
      oprofile: adding cpu_buffer_entries()
      oprofile: moving cpu_buffer_reset() to cpu_buffer.h
      ring_buffer: add remaining cpu functions to ring_buffer.h
      oprofile: port to the new ring_buffer
      oprofile: remove nr_available_slots()
      oprofile: fix lost sample counter
      ring_buffer: adding EXPORT_SYMBOLs


 arch/Kconfig                      |    2 +
 arch/x86/oprofile/op_model_amd.c  |   89 +++++++++--------
 drivers/oprofile/buffer_sync.c    |  117 ++++++++--------------
 drivers/oprofile/cpu_buffer.c     |  197 +++++++++++++++++++------------------
 drivers/oprofile/cpu_buffer.h     |   69 +++++++++++++-
 drivers/oprofile/oprofile_files.c |   15 +++-
 include/linux/oprofile.h          |    3 +-
 include/linux/ring_buffer.h       |    2 +
 kernel/trace/ring_buffer.c        |   36 +++++++-
 kernel/trace/trace.c              |    4 +-
 10 files changed, 306 insertions(+), 228 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 471e72d..2e13aa2 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -6,6 +6,8 @@ config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
 	depends on HAVE_OPROFILE
+	select TRACING
+	select RING_BUFFER
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 5095137..98658f2 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -65,11 +65,13 @@ static unsigned long reset_value[NUM_COUNTERS];
 #define IBS_FETCH_BEGIN 3
 #define IBS_OP_BEGIN    4
 
-/* The function interface needs to be fixed, something like add
-   data. Should then be added to linux/oprofile.h. */
+/*
+ * The function interface needs to be fixed, something like add
+ * data. Should then be added to linux/oprofile.h.
+ */
 extern void
-oprofile_add_ibs_sample(struct pt_regs *const regs,
-			unsigned int *const ibs_sample, int ibs_code);
+oprofile_add_ibs_sample(struct pt_regs * const regs,
+			unsigned int * const ibs_sample, int ibs_code);
 
 struct ibs_fetch_sample {
 	/* MSRC001_1031 IBS Fetch Linear Address Register */
@@ -104,11 +106,6 @@ struct ibs_op_sample {
 	unsigned int ibs_dc_phys_high;
 };
 
-/*
- * unitialize the APIC for the IBS interrupts if needed on AMD Family10h+
-*/
-static void clear_ibs_nmi(void);
-
 static int ibs_allowed;	/* AMD Family10h and later */
 
 struct op_ibs_config {
@@ -223,7 +220,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 						(unsigned int *)&ibs_fetch,
 						IBS_FETCH_BEGIN);
 
-			/*reenable the IRQ */
+			/* reenable the IRQ */
 			rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 			high &= ~IBS_FETCH_HIGH_VALID_BIT;
 			high |= IBS_FETCH_HIGH_ENABLE;
@@ -331,8 +328,10 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	unsigned int low, high;
 	int i;
 
-	/* Subtle: stop on all counters to avoid race with
-	 * setting our pm callback */
+	/*
+	 * Subtle: stop on all counters to avoid race with setting our
+	 * pm callback
+	 */
 	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -343,13 +342,15 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 
 #ifdef CONFIG_OPROFILE_IBS
 	if (ibs_allowed && ibs_config.fetch_enabled) {
-		low = 0;		/* clear max count and enable */
+		/* clear max count and enable */
+		low = 0;
 		high = 0;
 		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 	}
 
 	if (ibs_allowed && ibs_config.op_enabled) {
-		low = 0;		/* clear max count and enable */
+		/* clear max count and enable */
+		low = 0;
 		high = 0;
 		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
 	}
@@ -370,18 +371,7 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
-#ifndef CONFIG_OPROFILE_IBS
-
-/* no IBS support */
-
-static int op_amd_init(struct oprofile_operations *ops)
-{
-	return 0;
-}
-
-static void op_amd_exit(void) {}
-
-#else
+#ifdef CONFIG_OPROFILE_IBS
 
 static u8 ibs_eilvt_off;
 
@@ -395,7 +385,7 @@ static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
 	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
 }
 
-static int pfm_amd64_setup_eilvt(void)
+static int init_ibs_nmi(void)
 {
 #define IBSCTL_LVTOFFSETVAL		(1 << 8)
 #define IBSCTL				0x1cc
@@ -443,18 +433,22 @@ static int pfm_amd64_setup_eilvt(void)
 	return 0;
 }
 
-/*
- * initialize the APIC for the IBS interrupts
- * if available (AMD Family10h rev B0 and later)
- */
-static void setup_ibs(void)
+/* uninitialize the APIC for the IBS interrupts if needed */
+static void clear_ibs_nmi(void)
+{
+	if (ibs_allowed)
+		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
+}
+
+/* initialize the APIC for the IBS interrupts if available */
+static void ibs_init(void)
 {
 	ibs_allowed = boot_cpu_has(X86_FEATURE_IBS);
 
 	if (!ibs_allowed)
 		return;
 
-	if (pfm_amd64_setup_eilvt()) {
+	if (init_ibs_nmi()) {
 		ibs_allowed = 0;
 		return;
 	}
@@ -462,14 +456,12 @@ static void setup_ibs(void)
 	printk(KERN_INFO "oprofile: AMD IBS detected\n");
 }
 
-
-/*
- * unitialize the APIC for the IBS interrupts if needed on AMD Family10h
- * rev B0 and later */
-static void clear_ibs_nmi(void)
+static void ibs_exit(void)
 {
-	if (ibs_allowed)
-		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
+	if (!ibs_allowed)
+		return;
+
+	clear_ibs_nmi();
 }
 
 static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
@@ -519,7 +511,7 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 
 static int op_amd_init(struct oprofile_operations *ops)
 {
-	setup_ibs();
+	ibs_init();
 	create_arch_files = ops->create_files;
 	ops->create_files = setup_ibs_files;
 	return 0;
@@ -527,10 +519,21 @@ static int op_amd_init(struct oprofile_operations *ops)
 
 static void op_amd_exit(void)
 {
-	clear_ibs_nmi();
+	ibs_exit();
 }
 
-#endif
+#else
+
+/* no IBS support */
+
+static int op_amd_init(struct oprofile_operations *ops)
+{
+	return 0;
+}
+
+static void op_amd_exit(void) {}
+
+#endif /* CONFIG_OPROFILE_IBS */
 
 struct op_x86_model_spec const op_amd_spec = {
 	.init			= op_amd_init,
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index b55cd23..737bd94 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -268,18 +268,6 @@ lookup_dcookie(struct mm_struct *mm, unsigned long addr, off_t *offset)
 	return cookie;
 }
 
-static void increment_tail(struct oprofile_cpu_buffer *b)
-{
-	unsigned long new_tail = b->tail_pos + 1;
-
-	rmb();	/* be sure fifo pointers are synchromized */
-
-	if (new_tail < b->buffer_size)
-		b->tail_pos = new_tail;
-	else
-		b->tail_pos = 0;
-}
-
 static unsigned long last_cookie = INVALID_COOKIE;
 
 static void add_cpu_switch(int i)
@@ -331,28 +319,25 @@ static void add_trace_begin(void)
 
 #define IBS_FETCH_CODE_SIZE	2
 #define IBS_OP_CODE_SIZE	5
-#define IBS_EIP(offset)				\
-	(((struct op_sample *)&cpu_buf->buffer[(offset)])->eip)
-#define IBS_EVENT(offset)				\
-	(((struct op_sample *)&cpu_buf->buffer[(offset)])->event)
 
 /*
  * Add IBS fetch and op entries to event buffer
  */
-static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
-			  struct mm_struct *mm)
+static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
 {
 	unsigned long rip;
 	int i, count;
 	unsigned long ibs_cookie = 0;
 	off_t offset;
+	struct op_sample *sample;
 
-	increment_tail(cpu_buf);	/* move to RIP entry */
-
-	rip = IBS_EIP(cpu_buf->tail_pos);
+	sample = cpu_buffer_read_entry(cpu);
+	if (!sample)
+		goto Error;
+	rip = sample->eip;
 
 #ifdef __LP64__
-	rip += IBS_EVENT(cpu_buf->tail_pos) << 32;
+	rip += sample->event << 32;
 #endif
 
 	if (mm) {
@@ -376,8 +361,8 @@ static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
 	add_event_entry(offset);	/* Offset from Dcookie */
 
 	/* we send the Dcookie offset, but send the raw Linear Add also*/
-	add_event_entry(IBS_EIP(cpu_buf->tail_pos));
-	add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+	add_event_entry(sample->eip);
+	add_event_entry(sample->event);
 
 	if (code == IBS_FETCH_CODE)
 		count = IBS_FETCH_CODE_SIZE;	/*IBS FETCH is 2 int64s*/
@@ -385,10 +370,17 @@ static void add_ibs_begin(struct oprofile_cpu_buffer *cpu_buf, int code,
 		count = IBS_OP_CODE_SIZE;	/*IBS OP is 5 int64s*/
 
 	for (i = 0; i < count; i++) {
-		increment_tail(cpu_buf);
-		add_event_entry(IBS_EIP(cpu_buf->tail_pos));
-		add_event_entry(IBS_EVENT(cpu_buf->tail_pos));
+		sample = cpu_buffer_read_entry(cpu);
+		if (!sample)
+			goto Error;
+		add_event_entry(sample->eip);
+		add_event_entry(sample->event);
 	}
+
+	return;
+
+Error:
+	return;
 }
 
 #endif
@@ -466,33 +458,6 @@ static inline int is_code(unsigned long val)
 }
 
 
-/* "acquire" as many cpu buffer slots as we can */
-static unsigned long get_slots(struct oprofile_cpu_buffer *b)
-{
-	unsigned long head = b->head_pos;
-	unsigned long tail = b->tail_pos;
-
-	/*
-	 * Subtle. This resets the persistent last_task
-	 * and in_kernel values used for switching notes.
-	 * BUT, there is a small window between reading
-	 * head_pos, and this call, that means samples
-	 * can appear at the new head position, but not
-	 * be prefixed with the notes for switching
-	 * kernel mode or a task switch. This small hole
-	 * can lead to mis-attribution or samples where
-	 * we don't know if it's in the kernel or not,
-	 * at the start of an event buffer.
-	 */
-	cpu_buffer_reset(b);
-
-	if (head >= tail)
-		return head - tail;
-
-	return head + (b->buffer_size - tail);
-}
-
-
 /* Move tasks along towards death. Any tasks on dead_tasks
  * will definitely have no remaining references in any
  * CPU buffers at this point, because we use two lists,
@@ -559,61 +524,61 @@ typedef enum {
  */
 void sync_buffer(int cpu)
 {
-	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
 	struct mm_struct *mm = NULL;
+	struct mm_struct *oldmm;
 	struct task_struct *new;
 	unsigned long cookie = 0;
 	int in_kernel = 1;
 	sync_buffer_state state = sb_buffer_start;
-#ifndef CONFIG_OPROFILE_IBS
 	unsigned int i;
 	unsigned long available;
-#endif
 
 	mutex_lock(&buffer_mutex);
 
 	add_cpu_switch(cpu);
 
-	/* Remember, only we can modify tail_pos */
-
-#ifndef CONFIG_OPROFILE_IBS
-	available = get_slots(cpu_buf);
+	cpu_buffer_reset(cpu);
+	available = cpu_buffer_entries(cpu);
 
 	for (i = 0; i < available; ++i) {
-#else
-	while (get_slots(cpu_buf)) {
-#endif
-		struct op_sample *s = &cpu_buf->buffer[cpu_buf->tail_pos];
+		struct op_sample *s = cpu_buffer_read_entry(cpu);
+		if (!s)
+			break;
 
 		if (is_code(s->eip)) {
-			if (s->event <= CPU_IS_KERNEL) {
+			switch (s->event) {
+			case 0:
+			case CPU_IS_KERNEL:
 				/* kernel/userspace switch */
 				in_kernel = s->event;
 				if (state == sb_buffer_start)
 					state = sb_sample_start;
 				add_kernel_ctx_switch(s->event);
-			} else if (s->event == CPU_TRACE_BEGIN) {
+				break;
+			case CPU_TRACE_BEGIN:
 				state = sb_bt_start;
 				add_trace_begin();
+				break;
 #ifdef CONFIG_OPROFILE_IBS
-			} else if (s->event == IBS_FETCH_BEGIN) {
+			case IBS_FETCH_BEGIN:
 				state = sb_bt_start;
-				add_ibs_begin(cpu_buf, IBS_FETCH_CODE, mm);
-			} else if (s->event == IBS_OP_BEGIN) {
+				add_ibs_begin(cpu, IBS_FETCH_CODE, mm);
+				break;
+			case IBS_OP_BEGIN:
 				state = sb_bt_start;
-				add_ibs_begin(cpu_buf, IBS_OP_CODE, mm);
+				add_ibs_begin(cpu, IBS_OP_CODE, mm);
+				break;
 #endif
-			} else {
-				struct mm_struct *oldmm = mm;
-
+			default:
 				/* userspace context switch */
+				oldmm = mm;
 				new = (struct task_struct *)s->event;
-
 				release_mm(oldmm);
 				mm = take_tasks_mm(new);
 				if (mm != oldmm)
 					cookie = get_exec_dcookie(mm);
 				add_user_ctx_switch(new, cookie);
+				break;
 			}
 		} else if (state >= sb_bt_start &&
 			   !add_sample(mm, s, in_kernel)) {
@@ -622,8 +587,6 @@ void sync_buffer(int cpu)
 				atomic_inc(&oprofile_stats.bt_lost_no_mapping);
 			}
 		}
-
-		increment_tail(cpu_buf);
 	}
 	release_mm(mm);
 
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 01d38e7..6109096 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -28,6 +28,25 @@
 #include "buffer_sync.h"
 #include "oprof.h"
 
+#define OP_BUFFER_FLAGS	0
+
+/*
+ * Read and write access is using spin locking. Thus, writing to the
+ * buffer by NMI handler (x86) could occur also during critical
+ * sections when reading the buffer. To avoid this, there are 2
+ * buffers for independent read and write access. Read access is in
+ * process context only, write access only in the NMI handler. If the
+ * read buffer runs empty, both buffers are swapped atomically. There
+ * is potentially a small window during swapping where the buffers are
+ * disabled and samples could be lost.
+ *
+ * Using 2 buffers is a little bit overhead, but the solution is clear
+ * and does not require changes in the ring buffer implementation. It
+ * can be changed to a single buffer solution when the ring buffer
+ * access is implemented as non-locking atomic code.
+ */
+struct ring_buffer *op_ring_buffer_read;
+struct ring_buffer *op_ring_buffer_write;
 DEFINE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
 static void wq_sync_buffer(struct work_struct *work);
@@ -37,12 +56,12 @@ static int work_enabled;
 
 void free_cpu_buffers(void)
 {
-	int i;
-
-	for_each_possible_cpu(i) {
-		vfree(per_cpu(cpu_buffer, i).buffer);
-		per_cpu(cpu_buffer, i).buffer = NULL;
-	}
+	if (op_ring_buffer_read)
+		ring_buffer_free(op_ring_buffer_read);
+	op_ring_buffer_read = NULL;
+	if (op_ring_buffer_write)
+		ring_buffer_free(op_ring_buffer_write);
+	op_ring_buffer_write = NULL;
 }
 
 unsigned long oprofile_get_cpu_buffer_size(void)
@@ -64,14 +83,16 @@ int alloc_cpu_buffers(void)
 
 	unsigned long buffer_size = fs_cpu_buffer_size;
 
+	op_ring_buffer_read = ring_buffer_alloc(buffer_size, OP_BUFFER_FLAGS);
+	if (!op_ring_buffer_read)
+		goto fail;
+	op_ring_buffer_write = ring_buffer_alloc(buffer_size, OP_BUFFER_FLAGS);
+	if (!op_ring_buffer_write)
+		goto fail;
+
 	for_each_possible_cpu(i) {
 		struct oprofile_cpu_buffer *b = &per_cpu(cpu_buffer, i);
 
-		b->buffer = vmalloc_node(sizeof(struct op_sample) * buffer_size,
-			cpu_to_node(i));
-		if (!b->buffer)
-			goto fail;
-
 		b->last_task = NULL;
 		b->last_is_kernel = -1;
 		b->tracing = 0;
@@ -124,57 +145,31 @@ void end_cpu_work(void)
 	flush_scheduled_work();
 }
 
-/* Resets the cpu buffer to a sane state. */
-void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf)
-{
-	/* reset these to invalid values; the next sample
-	 * collected will populate the buffer with proper
-	 * values to initialize the buffer
-	 */
-	cpu_buf->last_is_kernel = -1;
-	cpu_buf->last_task = NULL;
-}
-
-/* compute number of available slots in cpu_buffer queue */
-static unsigned long nr_available_slots(struct oprofile_cpu_buffer const *b)
+static inline int
+add_sample(struct oprofile_cpu_buffer *cpu_buf,
+	   unsigned long pc, unsigned long event)
 {
-	unsigned long head = b->head_pos;
-	unsigned long tail = b->tail_pos;
+	struct op_entry entry;
+	int ret;
 
-	if (tail > head)
-		return (tail - head) - 1;
+	ret = cpu_buffer_write_entry(&entry);
+	if (ret)
+		return ret;
 
-	return tail + (b->buffer_size - head) - 1;
-}
+	entry.sample->eip = pc;
+	entry.sample->event = event;
 
-static void increment_head(struct oprofile_cpu_buffer *b)
-{
-	unsigned long new_head = b->head_pos + 1;
-
-	/* Ensure anything written to the slot before we
-	 * increment is visible */
-	wmb();
-
-	if (new_head < b->buffer_size)
-		b->head_pos = new_head;
-	else
-		b->head_pos = 0;
-}
+	ret = cpu_buffer_write_commit(&entry);
+	if (ret)
+		return ret;
 
-static inline void
-add_sample(struct oprofile_cpu_buffer *cpu_buf,
-	   unsigned long pc, unsigned long event)
-{
-	struct op_sample *entry = &cpu_buf->buffer[cpu_buf->head_pos];
-	entry->eip = pc;
-	entry->event = event;
-	increment_head(cpu_buf);
+	return 0;
 }
 
-static inline void
+static inline int
 add_code(struct oprofile_cpu_buffer *buffer, unsigned long value)
 {
-	add_sample(buffer, ESCAPE_CODE, value);
+	return add_sample(buffer, ESCAPE_CODE, value);
 }
 
 /* This must be safe from any context. It's safe writing here
@@ -198,11 +193,6 @@ static int log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
 		return 0;
 	}
 
-	if (nr_available_slots(cpu_buf) < 3) {
-		cpu_buf->sample_lost_overflow++;
-		return 0;
-	}
-
 	is_kernel = !!is_kernel;
 
 	task = current;
@@ -210,26 +200,29 @@ static int log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
 	/* notice a switch from user->kernel or vice versa */
 	if (cpu_buf->last_is_kernel != is_kernel) {
 		cpu_buf->last_is_kernel = is_kernel;
-		add_code(cpu_buf, is_kernel);
+		if (add_code(cpu_buf, is_kernel))
+			goto fail;
 	}
 
 	/* notice a task switch */
 	if (cpu_buf->last_task != task) {
 		cpu_buf->last_task = task;
-		add_code(cpu_buf, (unsigned long)task);
+		if (add_code(cpu_buf, (unsigned long)task))
+			goto fail;
 	}
 
-	add_sample(cpu_buf, pc, event);
+	if (add_sample(cpu_buf, pc, event))
+		goto fail;
+
 	return 1;
+
+fail:
+	cpu_buf->sample_lost_overflow++;
+	return 0;
 }
 
 static int oprofile_begin_trace(struct oprofile_cpu_buffer *cpu_buf)
 {
-	if (nr_available_slots(cpu_buf) < 4) {
-		cpu_buf->sample_lost_overflow++;
-		return 0;
-	}
-
 	add_code(cpu_buf, CPU_TRACE_BEGIN);
 	cpu_buf->tracing = 1;
 	return 1;
@@ -253,8 +246,10 @@ void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 	if (!oprofile_begin_trace(cpu_buf))
 		return;
 
-	/* if log_sample() fail we can't backtrace since we lost the source
-	 * of this event */
+	/*
+	 * if log_sample() fail we can't backtrace since we lost the
+	 * source of this event
+	 */
 	if (log_sample(cpu_buf, pc, is_kernel, event))
 		oprofile_ops.backtrace(regs, backtrace_depth);
 	oprofile_end_trace(cpu_buf);
@@ -272,49 +267,55 @@ void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 
 #define MAX_IBS_SAMPLE_SIZE 14
 
-void oprofile_add_ibs_sample(struct pt_regs *const regs,
-			     unsigned int *const ibs_sample, int ibs_code)
+void oprofile_add_ibs_sample(struct pt_regs * const regs,
+			     unsigned int * const ibs_sample, int ibs_code)
 {
 	int is_kernel = !user_mode(regs);
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(cpu_buffer);
 	struct task_struct *task;
+	int fail = 0;
 
 	cpu_buf->sample_received++;
 
-	if (nr_available_slots(cpu_buf) < MAX_IBS_SAMPLE_SIZE) {
-		/* we can't backtrace since we lost the source of this event */
-		cpu_buf->sample_lost_overflow++;
-		return;
-	}
-
 	/* notice a switch from user->kernel or vice versa */
 	if (cpu_buf->last_is_kernel != is_kernel) {
+		if (add_code(cpu_buf, is_kernel))
+			goto fail;
 		cpu_buf->last_is_kernel = is_kernel;
-		add_code(cpu_buf, is_kernel);
 	}
 
 	/* notice a task switch */
 	if (!is_kernel) {
 		task = current;
 		if (cpu_buf->last_task != task) {
+			if (add_code(cpu_buf, (unsigned long)task))
+				goto fail;
 			cpu_buf->last_task = task;
-			add_code(cpu_buf, (unsigned long)task);
 		}
 	}
 
-	add_code(cpu_buf, ibs_code);
-	add_sample(cpu_buf, ibs_sample[0], ibs_sample[1]);
-	add_sample(cpu_buf, ibs_sample[2], ibs_sample[3]);
-	add_sample(cpu_buf, ibs_sample[4], ibs_sample[5]);
+	fail = fail || add_code(cpu_buf, ibs_code);
+	fail = fail || add_sample(cpu_buf, ibs_sample[0], ibs_sample[1]);
+	fail = fail || add_sample(cpu_buf, ibs_sample[2], ibs_sample[3]);
+	fail = fail || add_sample(cpu_buf, ibs_sample[4], ibs_sample[5]);
 
 	if (ibs_code == IBS_OP_BEGIN) {
-		add_sample(cpu_buf, ibs_sample[6], ibs_sample[7]);
-		add_sample(cpu_buf, ibs_sample[8], ibs_sample[9]);
-		add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
+		fail = fail || add_sample(cpu_buf, ibs_sample[6], ibs_sample[7]);
+		fail = fail || add_sample(cpu_buf, ibs_sample[8], ibs_sample[9]);
+		fail = fail || add_sample(cpu_buf, ibs_sample[10], ibs_sample[11]);
 	}
 
+	if (fail)
+		goto fail;
+
 	if (backtrace_depth)
 		oprofile_ops.backtrace(regs, backtrace_depth);
+
+	return;
+
+fail:
+	cpu_buf->sample_lost_overflow++;
+	return;
 }
 
 #endif
@@ -332,21 +333,21 @@ void oprofile_add_trace(unsigned long pc)
 	if (!cpu_buf->tracing)
 		return;
 
-	if (nr_available_slots(cpu_buf) < 1) {
-		cpu_buf->tracing = 0;
-		cpu_buf->sample_lost_overflow++;
-		return;
-	}
+	/*
+	 * broken frame can give an eip with the same value as an
+	 * escape code, abort the trace if we get it
+	 */
+	if (pc == ESCAPE_CODE)
+		goto fail;
 
-	/* broken frame can give an eip with the same value as an escape code,
-	 * abort the trace if we get it */
-	if (pc == ESCAPE_CODE) {
-		cpu_buf->tracing = 0;
-		cpu_buf->backtrace_aborted++;
-		return;
-	}
+	if (add_sample(cpu_buf, pc, 0))
+		goto fail;
 
-	add_sample(cpu_buf, pc, 0);
+	return;
+fail:
+	cpu_buf->tracing = 0;
+	cpu_buf->backtrace_aborted++;
+	return;
 }
 
 /*
diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
index d3cc262..aacb0f0 100644
--- a/drivers/oprofile/cpu_buffer.h
+++ b/drivers/oprofile/cpu_buffer.h
@@ -15,6 +15,7 @@
 #include <linux/workqueue.h>
 #include <linux/cache.h>
 #include <linux/sched.h>
+#include <linux/ring_buffer.h>
 
 struct task_struct;
 
@@ -32,6 +33,12 @@ struct op_sample {
 	unsigned long event;
 };
 
+struct op_entry {
+	struct ring_buffer_event *event;
+	struct op_sample *sample;
+	unsigned long irq_flags;
+};
+
 struct oprofile_cpu_buffer {
 	volatile unsigned long head_pos;
 	volatile unsigned long tail_pos;
@@ -39,7 +46,6 @@ struct oprofile_cpu_buffer {
 	struct task_struct *last_task;
 	int last_is_kernel;
 	int tracing;
-	struct op_sample *buffer;
 	unsigned long sample_received;
 	unsigned long sample_lost_overflow;
 	unsigned long backtrace_aborted;
@@ -48,9 +54,68 @@ struct oprofile_cpu_buffer {
 	struct delayed_work work;
 };
 
+extern struct ring_buffer *op_ring_buffer_read;
+extern struct ring_buffer *op_ring_buffer_write;
 DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
 
-void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf);
+/*
+ * Resets the cpu buffer to a sane state.
+ *
+ * reset these to invalid values; the next sample collected will
+ * populate the buffer with proper values to initialize the buffer
+ */
+static inline void cpu_buffer_reset(int cpu)
+{
+	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
+
+	cpu_buf->last_is_kernel = -1;
+	cpu_buf->last_task = NULL;
+}
+
+static inline int cpu_buffer_write_entry(struct op_entry *entry)
+{
+	entry->event = ring_buffer_lock_reserve(op_ring_buffer_write,
+						sizeof(struct op_sample),
+						&entry->irq_flags);
+	if (entry->event)
+		entry->sample = ring_buffer_event_data(entry->event);
+	else
+		entry->sample = NULL;
+
+	if (!entry->sample)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline int cpu_buffer_write_commit(struct op_entry *entry)
+{
+	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event,
+					 entry->irq_flags);
+}
+
+static inline struct op_sample *cpu_buffer_read_entry(int cpu)
+{
+	struct ring_buffer_event *e;
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	if (e)
+		return ring_buffer_event_data(e);
+	if (ring_buffer_swap_cpu(op_ring_buffer_read,
+				 op_ring_buffer_write,
+				 cpu))
+		return NULL;
+	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
+	if (e)
+		return ring_buffer_event_data(e);
+	return NULL;
+}
+
+/* "acquire" as many cpu buffer slots as we can */
+static inline unsigned long cpu_buffer_entries(int cpu)
+{
+	return ring_buffer_entries_cpu(op_ring_buffer_read, cpu)
+		+ ring_buffer_entries_cpu(op_ring_buffer_write, cpu);
+}
 
 /* transient events for the CPU buffer -> event buffer */
 #define CPU_IS_KERNEL 1
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index cc106d5..d820199 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -14,9 +14,13 @@
 #include "oprofile_stats.h"
 #include "oprof.h"
 
-unsigned long fs_buffer_size = 131072;
-unsigned long fs_cpu_buffer_size = 8192;
-unsigned long fs_buffer_watershed = 32768; /* FIXME: tune */
+#define FS_BUFFER_SIZE_DEFAULT		131072
+#define FS_CPU_BUFFER_SIZE_DEFAULT	8192
+#define FS_BUFFER_WATERSHED_DEFAULT	32768	/* FIXME: tune */
+
+unsigned long fs_buffer_size;
+unsigned long fs_cpu_buffer_size;
+unsigned long fs_buffer_watershed;
 
 static ssize_t depth_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
@@ -120,6 +124,11 @@ static const struct file_operations dump_fops = {
 
 void oprofile_create_files(struct super_block *sb, struct dentry *root)
 {
+	/* reinitialize default values */
+	fs_buffer_size =	FS_BUFFER_SIZE_DEFAULT;
+	fs_cpu_buffer_size =	FS_CPU_BUFFER_SIZE_DEFAULT;
+	fs_buffer_watershed =	FS_BUFFER_WATERSHED_DEFAULT;
+
 	oprofilefs_create_file(sb, root, "enable", &enable_fops);
 	oprofilefs_create_file_perm(sb, root, "dump", &dump_fops, 0666);
 	oprofilefs_create_file(sb, root, "buffer", &event_buffer_fops);
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 5231861..1ce9fe5 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -86,8 +86,7 @@ int oprofile_arch_init(struct oprofile_operations * ops);
 void oprofile_arch_exit(void);
 
 /**
- * Add a sample. This may be called from any context. Pass
- * smp_processor_id() as cpu.
+ * Add a sample. This may be called from any context.
  */
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event);
 
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index e097c2e..de9d8c1 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -116,6 +116,8 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu);
 
 unsigned long ring_buffer_entries(struct ring_buffer *buffer);
 unsigned long ring_buffer_overruns(struct ring_buffer *buffer);
+unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu);
+unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 
 u64 ring_buffer_time_stamp(int cpu);
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 668bbb5..30d57dd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -31,6 +31,7 @@ void tracing_on(void)
 {
 	ring_buffers_off = 0;
 }
+EXPORT_SYMBOL_GPL(tracing_on);
 
 /**
  * tracing_off - turn off all tracing buffers
@@ -44,6 +45,7 @@ void tracing_off(void)
 {
 	ring_buffers_off = 1;
 }
+EXPORT_SYMBOL_GPL(tracing_off);
 
 /* Up this if you want to test the TIME_EXTENTS and normalization */
 #define DEBUG_SHIFT 0
@@ -60,12 +62,14 @@ u64 ring_buffer_time_stamp(int cpu)
 
 	return time;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_time_stamp);
 
 void ring_buffer_normalize_time_stamp(int cpu, u64 *ts)
 {
 	/* Just stupid testing the normalize function and deltas */
 	*ts >>= DEBUG_SHIFT;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_normalize_time_stamp);
 
 #define RB_EVNT_HDR_SIZE (sizeof(struct ring_buffer_event))
 #define RB_ALIGNMENT_SHIFT	2
@@ -115,6 +119,7 @@ unsigned ring_buffer_event_length(struct ring_buffer_event *event)
 {
 	return rb_event_length(event);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_event_length);
 
 /* inline for ring buffer fast paths */
 static inline void *
@@ -136,6 +141,7 @@ void *ring_buffer_event_data(struct ring_buffer_event *event)
 {
 	return rb_event_data(event);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_event_data);
 
 #define for_each_buffer_cpu(buffer, cpu)		\
 	for_each_cpu_mask(cpu, buffer->cpumask)
@@ -381,7 +387,7 @@ extern int ring_buffer_page_too_big(void);
 
 /**
  * ring_buffer_alloc - allocate a new ring_buffer
- * @size: the size in bytes that is needed.
+ * @size: the size in bytes per cpu that is needed.
  * @flags: attributes to set for the ring buffer.
  *
  * Currently the only flag that is available is the RB_FL_OVERWRITE
@@ -444,6 +450,7 @@ struct ring_buffer *ring_buffer_alloc(unsigned long size, unsigned flags)
 	kfree(buffer);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_alloc);
 
 /**
  * ring_buffer_free - free a ring buffer.
@@ -459,6 +466,7 @@ ring_buffer_free(struct ring_buffer *buffer)
 
 	kfree(buffer);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_free);
 
 static void rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer);
 
@@ -620,6 +628,7 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	mutex_unlock(&buffer->mutex);
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_resize);
 
 static inline int rb_null_event(struct ring_buffer_event *event)
 {
@@ -1220,6 +1229,7 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer,
 		preempt_enable_notrace();
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_lock_reserve);
 
 static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 		      struct ring_buffer_event *event)
@@ -1269,6 +1279,7 @@ int ring_buffer_unlock_commit(struct ring_buffer *buffer,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_unlock_commit);
 
 /**
  * ring_buffer_write - write data to the buffer without reserving
@@ -1334,6 +1345,7 @@ int ring_buffer_write(struct ring_buffer *buffer,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_write);
 
 static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
 {
@@ -1360,6 +1372,7 @@ void ring_buffer_record_disable(struct ring_buffer *buffer)
 {
 	atomic_inc(&buffer->record_disabled);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_record_disable);
 
 /**
  * ring_buffer_record_enable - enable writes to the buffer
@@ -1372,6 +1385,7 @@ void ring_buffer_record_enable(struct ring_buffer *buffer)
 {
 	atomic_dec(&buffer->record_disabled);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_record_enable);
 
 /**
  * ring_buffer_record_disable_cpu - stop all writes into the cpu_buffer
@@ -1393,6 +1407,7 @@ void ring_buffer_record_disable_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	atomic_inc(&cpu_buffer->record_disabled);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_record_disable_cpu);
 
 /**
  * ring_buffer_record_enable_cpu - enable writes to the buffer
@@ -1412,6 +1427,7 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	atomic_dec(&cpu_buffer->record_disabled);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_record_enable_cpu);
 
 /**
  * ring_buffer_entries_cpu - get the number of entries in a cpu buffer
@@ -1428,6 +1444,7 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	return cpu_buffer->entries;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
 
 /**
  * ring_buffer_overrun_cpu - get the number of overruns in a cpu_buffer
@@ -1444,6 +1461,7 @@ unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	return cpu_buffer->overrun;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_overrun_cpu);
 
 /**
  * ring_buffer_entries - get the number of entries in a buffer
@@ -1466,6 +1484,7 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 
 	return entries;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_entries);
 
 /**
  * ring_buffer_overrun_cpu - get the number of overruns in buffer
@@ -1488,6 +1507,7 @@ unsigned long ring_buffer_overruns(struct ring_buffer *buffer)
 
 	return overruns;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_overruns);
 
 /**
  * ring_buffer_iter_reset - reset an iterator
@@ -1513,6 +1533,7 @@ void ring_buffer_iter_reset(struct ring_buffer_iter *iter)
 	else
 		iter->read_stamp = iter->head_page->time_stamp;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_iter_reset);
 
 /**
  * ring_buffer_iter_empty - check if an iterator has no more to read
@@ -1527,6 +1548,7 @@ int ring_buffer_iter_empty(struct ring_buffer_iter *iter)
 	return iter->head_page == cpu_buffer->commit_page &&
 		iter->head == rb_commit_index(cpu_buffer);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_iter_empty);
 
 static void
 rb_update_read_stamp(struct ring_buffer_per_cpu *cpu_buffer,
@@ -1797,6 +1819,7 @@ ring_buffer_peek(struct ring_buffer *buffer, int cpu, u64 *ts)
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_peek);
 
 /**
  * ring_buffer_iter_peek - peek at the next event to be read
@@ -1867,6 +1890,7 @@ ring_buffer_iter_peek(struct ring_buffer_iter *iter, u64 *ts)
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_iter_peek);
 
 /**
  * ring_buffer_consume - return an event and consume it
@@ -1894,6 +1918,7 @@ ring_buffer_consume(struct ring_buffer *buffer, int cpu, u64 *ts)
 
 	return event;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_consume);
 
 /**
  * ring_buffer_read_start - start a non consuming read of the buffer
@@ -1934,6 +1959,7 @@ ring_buffer_read_start(struct ring_buffer *buffer, int cpu)
 
 	return iter;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_read_start);
 
 /**
  * ring_buffer_finish - finish reading the iterator of the buffer
@@ -1950,6 +1976,7 @@ ring_buffer_read_finish(struct ring_buffer_iter *iter)
 	atomic_dec(&cpu_buffer->record_disabled);
 	kfree(iter);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_read_finish);
 
 /**
  * ring_buffer_read - read the next item in the ring buffer by the iterator
@@ -1971,6 +1998,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts)
 
 	return event;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_read);
 
 /**
  * ring_buffer_size - return the size of the ring buffer (in bytes)
@@ -1980,6 +2008,7 @@ unsigned long ring_buffer_size(struct ring_buffer *buffer)
 {
 	return BUF_PAGE_SIZE * buffer->pages;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_size);
 
 static void
 rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
@@ -2022,6 +2051,7 @@ void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 
 	spin_unlock_irqrestore(&cpu_buffer->lock, flags);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
 /**
  * ring_buffer_reset - reset a ring buffer
@@ -2034,6 +2064,7 @@ void ring_buffer_reset(struct ring_buffer *buffer)
 	for_each_buffer_cpu(buffer, cpu)
 		ring_buffer_reset_cpu(buffer, cpu);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_reset);
 
 /**
  * rind_buffer_empty - is the ring buffer empty?
@@ -2052,6 +2083,7 @@ int ring_buffer_empty(struct ring_buffer *buffer)
 	}
 	return 1;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_empty);
 
 /**
  * ring_buffer_empty_cpu - is a cpu buffer of a ring buffer empty?
@@ -2068,6 +2100,7 @@ int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu)
 	cpu_buffer = buffer->buffers[cpu];
 	return rb_per_cpu_empty(cpu_buffer);
 }
+EXPORT_SYMBOL_GPL(ring_buffer_empty_cpu);
 
 /**
  * ring_buffer_swap_cpu - swap a CPU buffer between two ring buffers
@@ -2117,6 +2150,7 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ring_buffer_swap_cpu);
 
 static ssize_t
 rb_simple_read(struct file *filp, char __user *ubuf,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d86e325..a96b335 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -914,7 +914,7 @@ enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
 };
 
-static void trace_iterator_increment(struct trace_iterator *iter, int cpu)
+static void trace_iterator_increment(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
 	ftrace_disable_cpu();
@@ -993,7 +993,7 @@ static void *find_next_entry_inc(struct trace_iterator *iter)
 	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
 
 	if (iter->ent)
-		trace_iterator_increment(iter, iter->cpu);
+		trace_iterator_increment(iter);
 
 	return iter->ent ? iter : NULL;
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbZDSNxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbZDSNxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZDSNxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:53:00 -0400
Received: from ozlabs.org ([203.10.76.45]:58091 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034AbZDSNw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:52:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest & virtio fixes
Date: Sun, 19 Apr 2009 23:22:52 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>,
       virtualization@lists.linux-foundation.org,
       Matias Zabaljauregui <zabaljauregui@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Matt Kraai <kraai@ftbfs.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904192322.52817.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ff54250a0ebab7f90a5f848a0ba63f999830c872:
  Linus Torvalds (1):
        Remove 'recurse into child resources' logic from 'reserve_region_with_split()'

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest-and-virtio.git master

Marcelo Tosatti (1):
      virtio: fix suspend when using virtio_balloon

Matias Zabaljauregui (1):
      lguest: fix crash on vmlinux images

Matt Kraai (1):
      lguest: tell git to ignore Documentation/lguest/lguest

Rusty Russell (2):
      lguest: fix guest crash on non-linear addresses in gdt pvops
      lguest: document 32-bit and PAE requirements

 Documentation/lguest/.gitignore     |    1 +
 Documentation/lguest/lguest.txt     |   11 ++++++-----
 arch/x86/include/asm/lguest_hcall.h |    2 +-
 arch/x86/lguest/boot.c              |   16 +++++++++-------
 drivers/lguest/lg.h                 |    3 ++-
 drivers/lguest/segments.c           |   13 +++++++------
 drivers/lguest/x86/core.c           |    9 +++++++--
 drivers/virtio/virtio_balloon.c     |    3 ++-
 8 files changed, 35 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/lguest/.gitignore

commit 88df781afb788fa588dbf2e77f205214022a8893
Author: Matias Zabaljauregui <zabaljauregui@gmail.com>
Date:   Wed Apr 8 17:58:39 2009 -0300

    lguest: fix crash on vmlinux images
    
    Typical message: 'lguest: unhandled trap 6 at 0x418726 (0x0)'
    
    vmlinux guests were broken by 4cd8b5e2a159f18a1507f1187b44a1acbfa6341b
    'lguest: use KVM hypercalls', which rewrites guest text from kvm hypercalls
    to trap 31.
    
    The Launcher mmaps the kernel image.  The Guest executes and
    immediately faults in the first text page (read-only).  Then it hits a
    hypercall, and we rewrite that hypercall, causing a copy-on-write.
    But the Guest pagetables still refer to the old page: we fault again,
    but as Host we see the hypercall already rewritten, and pass the fault
    back to the Guest.  The Guest hasn't set up an IDT yet, so we kill it.
    
    This doesn't happen with bzImages: they unpack themselves and so the
    text pages are already read-write.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Tested-by: Patrick McHardy <kaber@trash.net>

 drivers/lguest/x86/core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

commit a489f0b555b753f9df8ddc24c7e74f657ef7ee7b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sun Apr 19 23:14:00 2009 -0600

    lguest: fix guest crash on non-linear addresses in gdt pvops
    
    Fixes guest crash 'lguest: bad read address 0x4800000 len 256'
    
    The new per-cpu allocator ends up handing a non-linear address to
    write_gdt_entry.  We do __pa() on it, and hand it to the host, which
    kills us.
    
    I've long wanted to make the hypercall "LOAD_GDT_ENTRY" to match the IDT
    code, but had no pressing reason until now.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: lguest@ozlabs.org

 arch/x86/include/asm/lguest_hcall.h |    2 +-
 arch/x86/lguest/boot.c              |   16 +++++++++-------
 drivers/lguest/lg.h                 |    3 ++-
 drivers/lguest/segments.c           |   13 +++++++------
 drivers/lguest/x86/core.c           |    4 ++--
 5 files changed, 21 insertions(+), 17 deletions(-)

commit 84a139a985300901dfad99bd93c7345d180af860
Author: Marcelo Tosatti <mtosatti@redhat.com>
Date:   Thu Apr 16 21:14:04 2009 -0300

    virtio: fix suspend when using virtio_balloon
    
    Break out of wait_event_interruptible() if freezing has been requested,
    in the vballoon thread. Without this change vballoon refuses to stop and
    the system can't suspend.
    
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: stable@kernel.org

 drivers/virtio/virtio_balloon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

commit 9536c26b31ae34ba6371a1b8f406028e9756f913
Author: Matt Kraai <kraai@ftbfs.org>
Date:   Thu Apr 16 23:46:20 2009 -0700

    lguest: tell git to ignore Documentation/lguest/lguest
    
    This is the example lguest launcher binary.
    
    Signed-off-by: Matt Kraai <kraai@ftbfs.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 Documentation/lguest/.gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

commit 38cfe968040250b89c3554a17219a9fda45b9665
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sun Apr 19 23:14:02 2009 -0600

    lguest: document 32-bit and PAE requirements
    
    Robert noted that we don't actually document that lguest is 32-bit only,
    nor that PAE must be off (CONFIG_PAE is now prompted for if HIGHMEM is
    set to "off).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: lguest@ozlabs.org
    Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>

 Documentation/lguest/lguest.txt |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/lguest/.gitignore b/Documentation/lguest/.gitignore
new file mode 100644
index 0000000..115587f
--- /dev/null
+++ b/Documentation/lguest/.gitignore
@@ -0,0 +1 @@
+lguest
diff --git a/Documentation/lguest/lguest.txt b/Documentation/lguest/lguest.txt
index 29510dc..28c7473 100644
--- a/Documentation/lguest/lguest.txt
+++ b/Documentation/lguest/lguest.txt
@@ -3,11 +3,11 @@
  /,    /`      - or, A Young Coder's Illustrated Hypervisor
  \\"--\\    http://lguest.ozlabs.org
 
-Lguest is designed to be a minimal hypervisor for the Linux kernel, for
-Linux developers and users to experiment with virtualization with the
-minimum of complexity.  Nonetheless, it should have sufficient
-features to make it useful for specific tasks, and, of course, you are
-encouraged to fork and enhance it (see drivers/lguest/README).
+Lguest is designed to be a minimal 32-bit x86 hypervisor for the Linux kernel,
+for Linux developers and users to experiment with virtualization with the
+minimum of complexity.  Nonetheless, it should have sufficient features to
+make it useful for specific tasks, and, of course, you are encouraged to fork
+and enhance it (see drivers/lguest/README).
 
 Features:
 
@@ -37,6 +37,7 @@ Running Lguest:
      "Paravirtualized guest support" = Y
         "Lguest guest support" = Y
      "High Memory Support" = off/4GB
+     "PAE (Physical Address Extension) Support" = N
      "Alignment value to which kernel should be aligned" = 0x100000
         (CONFIG_PARAVIRT=y, CONFIG_LGUEST_GUEST=y, CONFIG_HIGHMEM64G=n and
          CONFIG_PHYSICAL_ALIGN=0x100000)
diff --git a/arch/x86/include/asm/lguest_hcall.h b/arch/x86/include/asm/lguest_hcall.h
index 0f4ee71..faae199 100644
--- a/arch/x86/include/asm/lguest_hcall.h
+++ b/arch/x86/include/asm/lguest_hcall.h
@@ -5,7 +5,6 @@
 #define LHCALL_FLUSH_ASYNC	0
 #define LHCALL_LGUEST_INIT	1
 #define LHCALL_SHUTDOWN		2
-#define LHCALL_LOAD_GDT		3
 #define LHCALL_NEW_PGTABLE	4
 #define LHCALL_FLUSH_TLB	5
 #define LHCALL_LOAD_IDT_ENTRY	6
@@ -17,6 +16,7 @@
 #define LHCALL_SET_PMD		15
 #define LHCALL_LOAD_TLS		16
 #define LHCALL_NOTIFY		17
+#define LHCALL_LOAD_GDT_ENTRY	18
 
 #define LGUEST_TRAP_ENTRY 0x1F
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index e94a11e..a208536 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -273,15 +273,15 @@ static void lguest_load_idt(const struct desc_ptr *desc)
  * controls the entire thing and the Guest asks it to make changes using the
  * LOAD_GDT hypercall.
  *
- * This is the opposite of the IDT code where we have a LOAD_IDT_ENTRY
- * hypercall and use that repeatedly to load a new IDT.  I don't think it
- * really matters, but wouldn't it be nice if they were the same?  Wouldn't
- * it be even better if you were the one to send the patch to fix it?
+ * This is the exactly like the IDT code.
  */
 static void lguest_load_gdt(const struct desc_ptr *desc)
 {
-	BUG_ON((desc->size + 1) / 8 != GDT_ENTRIES);
-	kvm_hypercall2(LHCALL_LOAD_GDT, __pa(desc->address), GDT_ENTRIES);
+	unsigned int i;
+	struct desc_struct *gdt = (void *)desc->address;
+
+	for (i = 0; i < (desc->size+1)/8; i++)
+		kvm_hypercall3(LHCALL_LOAD_GDT_ENTRY, i, gdt[i].a, gdt[i].b);
 }
 
 /* For a single GDT entry which changes, we do the lazy thing: alter our GDT,
@@ -291,7 +291,9 @@ static void lguest_write_gdt_entry(struct desc_struct *dt, int entrynum,
 				   const void *desc, int type)
 {
 	native_write_gdt_entry(dt, entrynum, desc, type);
-	kvm_hypercall2(LHCALL_LOAD_GDT, __pa(dt), GDT_ENTRIES);
+	/* Tell Host about this new entry. */
+	kvm_hypercall3(LHCALL_LOAD_GDT_ENTRY, entrynum,
+		       dt[entrynum].a, dt[entrynum].b);
 }
 
 /* OK, I lied.  There are three "thread local storage" GDT entries which change
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index ac8a4a3..af92a17 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -158,7 +158,8 @@ void free_interrupts(void);
 /* segments.c: */
 void setup_default_gdt_entries(struct lguest_ro_state *state);
 void setup_guest_gdt(struct lg_cpu *cpu);
-void load_guest_gdt(struct lg_cpu *cpu, unsigned long table, u32 num);
+void load_guest_gdt_entry(struct lg_cpu *cpu, unsigned int i,
+			  u32 low, u32 hi);
 void guest_load_tls(struct lg_cpu *cpu, unsigned long tls_array);
 void copy_gdt(const struct lg_cpu *cpu, struct desc_struct *gdt);
 void copy_gdt_tls(const struct lg_cpu *cpu, struct desc_struct *gdt);
diff --git a/drivers/lguest/segments.c b/drivers/lguest/segments.c
index 4f15439..7ede64f 100644
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -144,18 +144,19 @@ void copy_gdt(const struct lg_cpu *cpu, struct desc_struct *gdt)
 			gdt[i] = cpu->arch.gdt[i];
 }
 
-/*H:620 This is where the Guest asks us to load a new GDT (LHCALL_LOAD_GDT).
- * We copy it from the Guest and tweak the entries. */
-void load_guest_gdt(struct lg_cpu *cpu, unsigned long table, u32 num)
+/*H:620 This is where the Guest asks us to load a new GDT entry
+ * (LHCALL_LOAD_GDT_ENTRY).  We tweak the entry and copy it in. */
+void load_guest_gdt_entry(struct lg_cpu *cpu, u32 num, u32 lo, u32 hi)
 {
 	/* We assume the Guest has the same number of GDT entries as the
 	 * Host, otherwise we'd have to dynamically allocate the Guest GDT. */
 	if (num > ARRAY_SIZE(cpu->arch.gdt))
 		kill_guest(cpu, "too many gdt entries %i", num);
 
-	/* We read the whole thing in, then fix it up. */
-	__lgread(cpu, cpu->arch.gdt, table, num * sizeof(cpu->arch.gdt[0]));
-	fixup_gdt_table(cpu, 0, ARRAY_SIZE(cpu->arch.gdt));
+	/* Set it up, then fix it. */
+	cpu->arch.gdt[num].a = lo;
+	cpu->arch.gdt[num].b = hi;
+	fixup_gdt_table(cpu, num, num+1);
 	/* Mark that the GDT changed so the core knows it has to copy it again,
 	 * even if the Guest is run on the same CPU. */
 	cpu->changed |= CHANGED_GDT;
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index a6b7176..1a83910 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -324,6 +324,11 @@ static void rewrite_hypercall(struct lg_cpu *cpu)
 	u8 insn[3] = {0xcd, 0x1f, 0x90};
 
 	__lgwrite(cpu, guest_pa(cpu, cpu->regs->eip), insn, sizeof(insn));
+	/* The above write might have caused a copy of that page to be made
+	 * (if it was read-only).  We need to make sure the Guest has
+	 * up-to-date pagetables.  As this doesn't happen often, we can just
+	 * drop them all. */
+	guest_pagetable_clear_all(cpu);
 }
 
 static bool is_hypercall(struct lg_cpu *cpu)
@@ -563,8 +568,8 @@ void __exit lguest_arch_host_fini(void)
 int lguest_arch_do_hcall(struct lg_cpu *cpu, struct hcall_args *args)
 {
 	switch (args->arg0) {
-	case LHCALL_LOAD_GDT:
-		load_guest_gdt(cpu, args->arg1, args->arg2);
+	case LHCALL_LOAD_GDT_ENTRY:
+		load_guest_gdt_entry(cpu, args->arg1, args->arg2, args->arg3);
 		break;
 	case LHCALL_LOAD_IDT_ENTRY:
 		load_guest_idt_entry(cpu, args->arg1, args->arg2, args->arg3);
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 5926826..9c76a06 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -190,7 +190,8 @@ static int balloon(void *_vballoon)
 		try_to_freeze();
 		wait_event_interruptible(vb->config_change,
 					 (diff = towards_target(vb)) != 0
-					 || kthread_should_stop());
+					 || kthread_should_stop()
+					 || freezing(current));
 		if (diff > 0)
 			fill_balloon(vb, diff);
 		else if (diff < 0)

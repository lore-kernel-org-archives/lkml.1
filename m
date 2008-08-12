Return-Path: <linux-kernel-owner+w=401wt.eu-S1753147AbYHLIHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbYHLIHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 04:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYHLIG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 04:06:57 -0400
Received: from ozlabs.org ([203.10.76.45]:56470 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYHLIGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 04:06:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] misc fixes
Date: Tue, 12 Aug 2008 18:06:36 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121806.36553.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Little hard-to-categorize crap, but I'm lazy.  I'll send multiple pull
 requests if you ignore this, so feel free).

The following changes since commit 10fec20ef5eec1c91913baec1225400f0d02df40:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.o-hand.com/linux-mfd

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Arjan van de Ven (1):
      modules: extend initcall_debug functionality to the module loader

Christian Borntraeger (2):
      export virtio_rng.h
      fix spinlock recursion in hvc_console

Li Zefan (1):
      stop_machine: remove unused variable

Rusty Russell (3):
      lguest: don't set MAC address for guest unless specified
      mm: Make generic weak get_user_pages_fast and EXPORT_GPL it
      lguest: use get_user_pages_fast() instead of get_user_pages()

 Documentation/lguest/lguest.c |   23 +----------------------
 arch/powerpc/Kconfig          |    3 ---
 arch/x86/Kconfig              |    1 -
 arch/x86/mm/Makefile          |    3 +--
 drivers/char/hvc_console.c    |    5 ++---
 drivers/lguest/page_tables.c  |   25 +++++++++----------------
 include/linux/Kbuild          |    1 +
 include/linux/init.h          |    1 +
 include/linux/mm.h            |   20 --------------------
 init/main.c                   |    6 ++++--
 kernel/module.c               |    2 +-
 kernel/stop_machine.c         |    1 -
 mm/Kconfig                    |    3 ---
 mm/util.c                     |   15 +++++++++++++++
 14 files changed, 35 insertions(+), 74 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index b88b0ea..6554148 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -1447,21 +1447,6 @@ static void configure_device(int fd, const char *tapif, u32 ipaddr)
 		err(1, "Bringing interface %s up", tapif);
 }
 
-static void get_mac(int fd, const char *tapif, unsigned char hwaddr[6])
-{
-	struct ifreq ifr;
-
-	memset(&ifr, 0, sizeof(ifr));
-	strcpy(ifr.ifr_name, tapif);
-
-	/* SIOC stands for Socket I/O Control.  G means Get (vs S for Set
-	 * above).  IF means Interface, and HWADDR is hardware address.
-	 * Simple! */
-	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
-		err(1, "getting hw address for %s", tapif);
-	memcpy(hwaddr, ifr.ifr_hwaddr.sa_data, 6);
-}
-
 static int get_tun_device(char tapif[IFNAMSIZ])
 {
 	struct ifreq ifr;
@@ -1531,11 +1516,8 @@ static void setup_tun_net(char *arg)
 	p = strchr(arg, ':');
 	if (p) {
 		str2mac(p+1, conf.mac);
+		add_feature(dev, VIRTIO_NET_F_MAC);
 		*p = '\0';
-	} else {
-		p = arg + strlen(arg);
-		/* None supplied; query the randomly assigned mac. */
-		get_mac(ipfd, tapif, conf.mac);
 	}
 
 	/* arg is now either an IP address or a bridge name */
@@ -1547,13 +1529,10 @@ static void setup_tun_net(char *arg)
 	/* Set up the tun device. */
 	configure_device(ipfd, tapif, ip);
 
-	/* Tell Guest what MAC address to use. */
-	add_feature(dev, VIRTIO_NET_F_MAC);
 	add_feature(dev, VIRTIO_F_NOTIFY_ON_EMPTY);
 	/* Expect Guest to handle everything except UFO */
 	add_feature(dev, VIRTIO_NET_F_CSUM);
 	add_feature(dev, VIRTIO_NET_F_GUEST_CSUM);
-	add_feature(dev, VIRTIO_NET_F_MAC);
 	add_feature(dev, VIRTIO_NET_F_GUEST_TSO4);
 	add_feature(dev, VIRTIO_NET_F_GUEST_TSO6);
 	add_feature(dev, VIRTIO_NET_F_GUEST_ECN);
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 63c9caf..587da5e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -42,9 +42,6 @@ config GENERIC_HARDIRQS
 	bool
 	default y
 
-config HAVE_GET_USER_PAGES_FAST
-	def_bool PPC64
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3d0f2b6..ac2fb06 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -22,7 +22,6 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_IOREMAP_PROT
-	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 2977ea3..dfb932d 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,7 +1,6 @@
 obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o
+	    pat.o pgtable.o gup.o
 
-obj-$(CONFIG_HAVE_GET_USER_PAGES_FAST) += gup.o
 obj-$(CONFIG_X86_32)		+= pgtable_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 02aac10..fd64137 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -322,11 +322,10 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 
 	hp->tty = tty;
 
-	if (hp->ops->notifier_add)
-		rc = hp->ops->notifier_add(hp, hp->data);
-
 	spin_unlock_irqrestore(&hp->lock, flags);
 
+	if (hp->ops->notifier_add)
+		rc = hp->ops->notifier_add(hp, hp->data);
 
 	/*
 	 * If the notifier fails we return an error.  The tty layer
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index d93500f..81d0c60 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -108,9 +108,8 @@ static unsigned long gpte_addr(pgd_t gpgd, unsigned long vaddr)
 }
 /*:*/
 
-/*M:014 get_pfn is slow; it takes the mmap sem and calls get_user_pages.  We
- * could probably try to grab batches of pages here as an optimization
- * (ie. pre-faulting). :*/
+/*M:014 get_pfn is slow: we could probably try to grab batches of pages here as
+ * an optimization (ie. pre-faulting). :*/
 
 /*H:350 This routine takes a page number given by the Guest and converts it to
  * an actual, physical page number.  It can fail for several reasons: the
@@ -123,19 +122,13 @@ static unsigned long gpte_addr(pgd_t gpgd, unsigned long vaddr)
 static unsigned long get_pfn(unsigned long virtpfn, int write)
 {
 	struct page *page;
-	/* This value indicates failure. */
-	unsigned long ret = -1UL;
 
-	/* get_user_pages() is a complex interface: it gets the "struct
-	 * vm_area_struct" and "struct page" assocated with a range of pages.
-	 * It also needs the task's mmap_sem held, and is not very quick.
-	 * It returns the number of pages it got. */
-	down_read(&current->mm->mmap_sem);
-	if (get_user_pages(current, current->mm, virtpfn << PAGE_SHIFT,
-			   1, write, 1, &page, NULL) == 1)
-		ret = page_to_pfn(page);
-	up_read(&current->mm->mmap_sem);
-	return ret;
+	/* gup me one page at this address please! */
+	if (get_user_pages_fast(virtpfn << PAGE_SHIFT, 1, write, &page) == 1)
+		return page_to_pfn(page);
+
+	/* This value indicates failure. */
+	return -1UL;
 }
 
 /*H:340 Converting a Guest page table entry to a shadow (ie. real) page table
@@ -174,7 +167,7 @@ static pte_t gpte_to_spte(struct lg_cpu *cpu, pte_t gpte, int write)
 /*H:460 And to complete the chain, release_pte() looks like this: */
 static void release_pte(pte_t pte)
 {
-	/* Remember that get_user_pages() took a reference to the page, in
+	/* Remember that get_user_pages_fast() took a reference to the page, in
 	 * get_pfn()?  We have to put it back now. */
 	if (pte_flags(pte) & _PAGE_PRESENT)
 		put_page(pfn_to_page(pte_pfn(pte)));
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index a26f565..327f606 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -356,6 +356,7 @@ unifdef-y += virtio_balloon.h
 unifdef-y += virtio_console.h
 unifdef-y += virtio_pci.h
 unifdef-y += virtio_ring.h
+unifdef-y += virtio_rng.h
 unifdef-y += vt.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h
diff --git a/include/linux/init.h b/include/linux/init.h
index 11b84e1..93538b6 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -139,6 +139,7 @@ extern initcall_t __con_initcall_start[], __con_initcall_end[];
 extern initcall_t __security_initcall_start[], __security_initcall_end[];
 
 /* Defined in init/main.c */
+extern int do_one_initcall(initcall_t fn);
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
 extern unsigned int reset_devices;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 335288b..fa65160 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -834,7 +834,6 @@ extern int mprotect_fixup(struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
 
-#ifdef CONFIG_HAVE_GET_USER_PAGES_FAST
 /*
  * get_user_pages_fast provides equivalent functionality to get_user_pages,
  * operating on current and current->mm (force=0 and doesn't return any vmas).
@@ -848,25 +847,6 @@ extern int mprotect_fixup(struct vm_area_struct *vma,
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 
-#else
-/*
- * Should probably be moved to asm-generic, and architectures can include it if
- * they don't implement their own get_user_pages_fast.
- */
-#define get_user_pages_fast(start, nr_pages, write, pages)	\
-({								\
-	struct mm_struct *mm = current->mm;			\
-	int ret;						\
-								\
-	down_read(&mm->mmap_sem);				\
-	ret = get_user_pages(current, mm, start, nr_pages,	\
-					write, 0, pages, NULL);	\
-	up_read(&mm->mmap_sem);					\
-								\
-	ret;							\
-})
-#endif
-
 /*
  * A callback you can register to apply pressure to ageable caches.
  *
diff --git a/init/main.c b/init/main.c
index 0bc7e16..f6f7042 100644
--- a/init/main.c
+++ b/init/main.c
@@ -691,7 +691,7 @@ asmlinkage void __init start_kernel(void)
 	rest_init();
 }
 
-static int __initdata initcall_debug;
+static int initcall_debug;
 
 static int __init initcall_debug_setup(char *str)
 {
@@ -700,7 +700,7 @@ static int __init initcall_debug_setup(char *str)
 }
 __setup("initcall_debug", initcall_debug_setup);
 
-static void __init do_one_initcall(initcall_t fn)
+int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	ktime_t t0, t1, delta;
@@ -740,6 +740,8 @@ static void __init do_one_initcall(initcall_t fn)
 		print_fn_descriptor_symbol(KERN_WARNING "initcall %s", fn);
 		printk(" returned with %s\n", msgbuf);
 	}
+
+	return result;
 }
 
 
diff --git a/kernel/module.c b/kernel/module.c
index 61d2121..08864d2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2288,7 +2288,7 @@ sys_init_module(void __user *umod,
 
 	/* Start the module */
 	if (mod->init != NULL)
-		ret = mod->init();
+		ret = do_one_initcall(mod->init);
 	if (ret < 0) {
 		/* Init routine failed: abort.  Try to protect us from
                    buggy refcounters. */
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e446c7c..af3c7ce 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -65,7 +65,6 @@ static void ack_state(void)
 static int stop_cpu(struct stop_machine_data *smdata)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
-	int uninitialized_var(ret);
 
 	/* Simple state machine */
 	do {
diff --git a/mm/Kconfig b/mm/Kconfig
index 446c658..0bd9c2d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -77,9 +77,6 @@ config FLAT_NODE_MEM_MAP
 	def_bool y
 	depends on !SPARSEMEM
 
-config HAVE_GET_USER_PAGES_FAST
-	bool
-
 #
 # Both the NUMA code and DISCONTIGMEM use arrays of pg_data_t's
 # to represent different areas of memory.  This variable allows
diff --git a/mm/util.c b/mm/util.c
index 9341ca7..cb00b74 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -171,3 +171,18 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	mm->unmap_area = arch_unmap_area;
 }
 #endif
+
+int __attribute__((weak)) get_user_pages_fast(unsigned long start,
+				int nr_pages, int write, struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	int ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(current, mm, start, nr_pages,
+					write, 0, pages, NULL);
+	up_read(&mm->mmap_sem);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(get_user_pages_fast);

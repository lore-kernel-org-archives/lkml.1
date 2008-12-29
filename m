Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYL2XHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYL2XHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYL2XGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:06:53 -0500
Received: from ozlabs.org ([203.10.76.45]:54210 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbYL2XGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:06:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio and lguest tree
Date: Tue, 30 Dec 2008 09:36:42 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Hollis Blanchard <hollisb@us.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>,
       Mark McLoughlin <markmc@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812300936.43281.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3c92ec8ae91ecf59d88c798301833d7cf83f2179:    
  Linus Torvalds (1):                                                           
        Merge branch 'next' of git://git.kernel.org/.../paulus/powerpc          

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master                                                                         

Christian Borntraeger (2):
      virtio_console: support console resizing
      kvm-s390: implement config_changed for virtio on s390

Hollis Blanchard (2):
      virtio-pci queue allocation not page-aligned
      virtio: avoid implicit use of Linux page size in balloon interface

Kay Sievers (1):
      virtio: struct device - replace bus_id with dev_name(), dev_set_name()

Mark McLoughlin (2):
      virtio: add PCI device release() function
      lguest: struct device - replace bus_id with dev_name()

Matias Zabaljauregui (1):
      lguest: move the initial guest page table creation code to the host

Randy Dunlap (1):
      virtio_blk: fix type warning

Rusty Russell (8):
      virtio: Don't use PAGE_SIZE in virtio_pci.c
      virtio: rename 'pagesize' arg to vring_init/vring_size
      virtio: Don't use PAGE_SIZE for vring alignment in virtio_pci.
      virtio: use LGUEST_VRING_ALIGN instead of relying on pagesize
      virtio: use KVM_S390_VIRTIO_RING_ALIGN instead of relying on pagesize
      virtio: hand virtio ring alignment as argument to vring_new_virtqueue
      virtio: set max_segment_size and max_sectors to infinite.
      virtio: block: dynamic maximum segments

 Documentation/lguest/lguest.c      |   66 ++++----------------------------
 arch/s390/include/asm/kvm_virtio.h |    4 ++
 arch/x86/lguest/i386_head.S        |   15 -------
 drivers/block/virtio_blk.c         |   41 ++++++++++++++------
 drivers/char/hvc_console.c         |    1 +
 drivers/char/virtio_console.c      |   30 ++++++++++++++-
 drivers/lguest/lg.h                |    2 +-
 drivers/lguest/lguest_device.c     |    8 ++--
 drivers/lguest/lguest_user.c       |   13 ++----
 drivers/lguest/page_tables.c       |   72 +++++++++++++++++++++++++++++++++++-
 drivers/s390/kvm/kvm_virtio.c      |   34 +++++++++++++---
 drivers/virtio/virtio.c            |    2 +-
 drivers/virtio/virtio_balloon.c    |   13 +++++-
 drivers/virtio/virtio_pci.c        |   43 +++++++++++++--------
 drivers/virtio/virtio_ring.c       |    3 +-
 include/linux/lguest_launcher.h    |    6 ++-
 include/linux/virtio_balloon.h     |    3 +
 include/linux/virtio_console.h     |   11 +++++
 include/linux/virtio_pci.h         |    8 ++++
 include/linux/virtio_ring.h        |   13 +++---
 20 files changed, 253 insertions(+), 135 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index 8045206..f2dbbf3 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -481,51 +481,6 @@ static unsigned long load_initrd(const char *name, unsigned long mem)
 	/* We return the initrd size. */
 	return len;
 }
-
-/* Once we know how much memory we have we can construct simple linear page
- * tables which set virtual == physical which will get the Guest far enough
- * into the boot to create its own.
- *
- * We lay them out of the way, just below the initrd (which is why we need to
- * know its size here). */
-static unsigned long setup_pagetables(unsigned long mem,
-				      unsigned long initrd_size)
-{
-	unsigned long *pgdir, *linear;
-	unsigned int mapped_pages, i, linear_pages;
-	unsigned int ptes_per_page = getpagesize()/sizeof(void *);
-
-	mapped_pages = mem/getpagesize();
-
-	/* Each PTE page can map ptes_per_page pages: how many do we need? */
-	linear_pages = (mapped_pages + ptes_per_page-1)/ptes_per_page;
-
-	/* We put the toplevel page directory page at the top of memory. */
-	pgdir = from_guest_phys(mem) - initrd_size - getpagesize();
-
-	/* Now we use the next linear_pages pages as pte pages */
-	linear = (void *)pgdir - linear_pages*getpagesize();
-
-	/* Linear mapping is easy: put every page's address into the mapping in
-	 * order.  PAGE_PRESENT contains the flags Present, Writable and
-	 * Executable. */
-	for (i = 0; i < mapped_pages; i++)
-		linear[i] = ((i * getpagesize()) | PAGE_PRESENT);
-
-	/* The top level points to the linear page table pages above. */
-	for (i = 0; i < mapped_pages; i += ptes_per_page) {
-		pgdir[i/ptes_per_page]
-			= ((to_guest_phys(linear) + i*sizeof(void *))
-			   | PAGE_PRESENT);
-	}
-
-	verbose("Linear mapping of %u pages in %u pte pages at %#lx\n",
-		mapped_pages, linear_pages, to_guest_phys(linear));
-
-	/* We return the top level (guest-physical) address: the kernel needs
-	 * to know where it is. */
-	return to_guest_phys(pgdir);
-}
 /*:*/
 
 /* Simple routine to roll all the commandline arguments together with spaces
@@ -548,13 +503,13 @@ static void concat(char *dst, char *args[])
 
 /*L:185 This is where we actually tell the kernel to initialize the Guest.  We
  * saw the arguments it expects when we looked at initialize() in lguest_user.c:
- * the base of Guest "physical" memory, the top physical page to allow, the
- * top level pagetable and the entry point for the Guest. */
-static int tell_kernel(unsigned long pgdir, unsigned long start)
+ * the base of Guest "physical" memory, the top physical page to allow and the
+ * entry point for the Guest. */
+static int tell_kernel(unsigned long start)
 {
 	unsigned long args[] = { LHREQ_INITIALIZE,
 				 (unsigned long)guest_base,
-				 guest_limit / getpagesize(), pgdir, start };
+				 guest_limit / getpagesize(), start };
 	int fd;
 
 	verbose("Guest: %p - %p (%#lx)\n",
@@ -1030,7 +985,7 @@ static void update_device_status(struct device *dev)
 		/* Zero out the virtqueues. */
 		for (vq = dev->vq; vq; vq = vq->next) {
 			memset(vq->vring.desc, 0,
-			       vring_size(vq->config.num, getpagesize()));
+			       vring_size(vq->config.num, LGUEST_VRING_ALIGN));
 			lg_last_avail(vq) = 0;
 		}
 	} else if (dev->desc->status & VIRTIO_CONFIG_S_FAILED) {
@@ -1211,7 +1166,7 @@ static void add_virtqueue(struct device *dev, unsigned int num_descs,
 	void *p;
 
 	/* First we need some memory for this virtqueue. */
-	pages = (vring_size(num_descs, getpagesize()) + getpagesize() - 1)
+	pages = (vring_size(num_descs, LGUEST_VRING_ALIGN) + getpagesize() - 1)
 		/ getpagesize();
 	p = get_pages(pages);
 
@@ -1228,7 +1183,7 @@ static void add_virtqueue(struct device *dev, unsigned int num_descs,
 	vq->config.pfn = to_guest_phys(p) / getpagesize();
 
 	/* Initialize the vring. */
-	vring_init(&vq->vring, num_descs, p, getpagesize());
+	vring_init(&vq->vring, num_descs, p, LGUEST_VRING_ALIGN);
 
 	/* Append virtqueue to this device's descriptor.  We use
 	 * device_config() to get the end of the device's current virtqueues;
@@ -1941,7 +1896,7 @@ int main(int argc, char *argv[])
 {
 	/* Memory, top-level pagetable, code startpoint and size of the
 	 * (optional) initrd. */
-	unsigned long mem = 0, pgdir, start, initrd_size = 0;
+	unsigned long mem = 0, start, initrd_size = 0;
 	/* Two temporaries and the /dev/lguest file descriptor. */
 	int i, c, lguest_fd;
 	/* The boot information for the Guest. */
@@ -2040,9 +1995,6 @@ int main(int argc, char *argv[])
 		boot->hdr.type_of_loader = 0xFF;
 	}
 
-	/* Set up the initial linear pagetables, starting below the initrd. */
-	pgdir = setup_pagetables(mem, initrd_size);
-
 	/* The Linux boot header contains an "E820" memory map: ours is a
 	 * simple, single region. */
 	boot->e820_entries = 1;
@@ -2064,7 +2016,7 @@ int main(int argc, char *argv[])
 
 	/* We tell the kernel to initialize the Guest: this returns the open
 	 * /dev/lguest file descriptor. */
-	lguest_fd = tell_kernel(pgdir, start);
+	lguest_fd = tell_kernel(start);
 
 	/* We clone off a thread, which wakes the Launcher whenever one of the
 	 * input file descriptors needs attention.  We call this the Waker, and
diff --git a/arch/s390/include/asm/kvm_virtio.h b/arch/s390/include/asm/kvm_virtio.h
index c13568b..0503936 100644
--- a/arch/s390/include/asm/kvm_virtio.h
+++ b/arch/s390/include/asm/kvm_virtio.h
@@ -50,6 +50,10 @@ struct kvm_vqconfig {
 #define KVM_S390_VIRTIO_RESET		1
 #define KVM_S390_VIRTIO_SET_STATUS	2
 
+/* The alignment to use between consumer and producer parts of vring.
+ * This is pagesize for historical reasons. */
+#define KVM_S390_VIRTIO_RING_ALIGN	4096
+
 #ifdef __KERNEL__
 /* early virtio console setup */
 #ifdef CONFIG_S390_GUEST
diff --git a/arch/x86/lguest/i386_head.S b/arch/x86/lguest/i386_head.S
index 5c7cef3..10b9bd3 100644
--- a/arch/x86/lguest/i386_head.S
+++ b/arch/x86/lguest/i386_head.S
@@ -30,21 +30,6 @@ ENTRY(lguest_entry)
 	movl $lguest_data - __PAGE_OFFSET, %edx
 	int $LGUEST_TRAP_ENTRY
 
-	/* The Host put the toplevel pagetable in lguest_data.pgdir.  The movsl
-	 * instruction uses %esi implicitly as the source for the copy we're
-	 * about to do. */
-	movl lguest_data - __PAGE_OFFSET + LGUEST_DATA_pgdir, %esi
-
-	/* Copy first 32 entries of page directory to __PAGE_OFFSET entries.
-	 * This means the first 128M of kernel memory will be mapped at
-	 * PAGE_OFFSET where the kernel expects to run.  This will get it far
-	 * enough through boot to switch to its own pagetables. */
-	movl $32, %ecx
-	movl %esi, %edi
-	addl $((__PAGE_OFFSET >> 22) * 4), %edi
-	rep
-	movsl
-
 	/* Set up the initial stack so we can run C code. */
 	movl $(init_thread_union+THREAD_SIZE),%esp
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 85d79a0..300078b 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -6,7 +6,6 @@
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
 
-#define VIRTIO_MAX_SG	(3+MAX_PHYS_SEGMENTS)
 #define PART_BITS 4
 
 static int major, index;
@@ -26,8 +25,11 @@ struct virtio_blk
 
 	mempool_t *pool;
 
+	/* What host tells us, plus 2 for header & tailer. */
+	unsigned int sg_elems;
+
 	/* Scatterlist: can be too big for stack. */
-	struct scatterlist sg[VIRTIO_MAX_SG];
+	struct scatterlist sg[/*sg_elems*/];
 };
 
 struct virtblk_req
@@ -97,8 +99,6 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	if (blk_barrier_rq(vbr->req))
 		vbr->out_hdr.type |= VIRTIO_BLK_T_BARRIER;
 
-	/* This init could be done at vblk creation time */
-	sg_init_table(vblk->sg, VIRTIO_MAX_SG);
 	sg_set_buf(&vblk->sg[0], &vbr->out_hdr, sizeof(vbr->out_hdr));
 	num = blk_rq_map_sg(q, vbr->req, vblk->sg+1);
 	sg_set_buf(&vblk->sg[num+1], &vbr->status, sizeof(vbr->status));
@@ -130,7 +130,7 @@ static void do_virtblk_request(struct request_queue *q)
 
 	while ((req = elv_next_request(q)) != NULL) {
 		vblk = req->rq_disk->private_data;
-		BUG_ON(req->nr_phys_segments > ARRAY_SIZE(vblk->sg));
+		BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
 
 		/* If this request fails, stop queue and wait for something to
 		   finish to restart it. */
@@ -196,12 +196,22 @@ static int virtblk_probe(struct virtio_device *vdev)
 	int err;
 	u64 cap;
 	u32 v;
-	u32 blk_size;
+	u32 blk_size, sg_elems;
 
 	if (index_to_minor(index) >= 1 << MINORBITS)
 		return -ENOSPC;
 
-	vdev->priv = vblk = kmalloc(sizeof(*vblk), GFP_KERNEL);
+	/* We need to know how many segments before we allocate. */
+	err = virtio_config_val(vdev, VIRTIO_BLK_F_SEG_MAX,
+				offsetof(struct virtio_blk_config, seg_max),
+				&sg_elems);
+	if (err)
+		sg_elems = 1;
+
+	/* We need an extra sg elements at head and tail. */
+	sg_elems += 2;
+	vdev->priv = vblk = kmalloc(sizeof(*vblk) +
+				    sizeof(vblk->sg[0]) * sg_elems, GFP_KERNEL);
 	if (!vblk) {
 		err = -ENOMEM;
 		goto out;
@@ -210,6 +220,8 @@ static int virtblk_probe(struct virtio_device *vdev)
 	INIT_LIST_HEAD(&vblk->reqs);
 	spin_lock_init(&vblk->lock);
 	vblk->vdev = vdev;
+	vblk->sg_elems = sg_elems;
+	sg_init_table(vblk->sg, vblk->sg_elems);
 
 	/* We expect one virtqueue, for output. */
 	vblk->vq = vdev->config->find_vq(vdev, 0, blk_done);
@@ -277,6 +289,13 @@ static int virtblk_probe(struct virtio_device *vdev)
 	}
 	set_capacity(vblk->disk, cap);
 
+	/* We can handle whatever the host told us to handle. */
+	blk_queue_max_phys_segments(vblk->disk->queue, vblk->sg_elems-2);
+	blk_queue_max_hw_segments(vblk->disk->queue, vblk->sg_elems-2);
+
+	/* No real sector limit. */
+	blk_queue_max_sectors(vblk->disk->queue, -1U);
+
 	/* Host can optionally specify maximum segment size and number of
 	 * segments. */
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_SIZE_MAX,
@@ -284,12 +303,8 @@ static int virtblk_probe(struct virtio_device *vdev)
 				&v);
 	if (!err)
 		blk_queue_max_segment_size(vblk->disk->queue, v);
-
-	err = virtio_config_val(vdev, VIRTIO_BLK_F_SEG_MAX,
-				offsetof(struct virtio_blk_config, seg_max),
-				&v);
-	if (!err)
-		blk_queue_max_hw_segments(vblk->disk->queue, v);
+	else
+		blk_queue_max_segment_size(vblk->disk->queue, -1U);
 
 	/* Host can optionally specify the block size of the device */
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_BLK_SIZE,
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index fb57f67..0587b66 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -695,6 +695,7 @@ void hvc_resize(struct hvc_struct *hp, struct winsize ws)
 	hp->ws = ws;
 	schedule_work(&hp->tty_resize);
 }
+EXPORT_SYMBOL_GPL(hvc_resize);
 
 /*
  * This kthread is either polling or interrupt driven.  This is determined by
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 3fb0d2c..ff6f5a4 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -138,12 +138,33 @@ int __init virtio_cons_early_init(int (*put_chars)(u32, const char *, int))
 }
 
 /*
+ * virtio console configuration. This supports:
+ * - console resize
+ */
+static void virtcons_apply_config(struct virtio_device *dev)
+{
+	struct winsize ws;
+
+	if (virtio_has_feature(dev, VIRTIO_CONSOLE_F_SIZE)) {
+		dev->config->get(dev,
+				 offsetof(struct virtio_console_config, cols),
+				 &ws.ws_col, sizeof(u16));
+		dev->config->get(dev,
+				 offsetof(struct virtio_console_config, rows),
+				 &ws.ws_row, sizeof(u16));
+		hvc_resize(hvc, ws);
+	}
+}
+
+/*
  * we support only one console, the hvc struct is a global var
- * There is no need to do anything
+ * We set the configuration at this point, since we now have a tty
  */
 static int notifier_add_vio(struct hvc_struct *hp, int data)
 {
 	hp->irq_requested = 1;
+	virtcons_apply_config(vdev);
+
 	return 0;
 }
 
@@ -234,11 +255,18 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+static unsigned int features[] = {
+	VIRTIO_CONSOLE_F_SIZE,
+};
+
 static struct virtio_driver virtio_console = {
+	.feature_table = features,
+	.feature_table_size = ARRAY_SIZE(features),
 	.driver.name =	KBUILD_MODNAME,
 	.driver.owner =	THIS_MODULE,
 	.id_table =	id_table,
 	.probe =	virtcons_probe,
+	.config_changed = virtcons_apply_config,
 };
 
 static int __init init(void)
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 5faefea..f2c641e 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -164,7 +164,7 @@ void copy_gdt(const struct lg_cpu *cpu, struct desc_struct *gdt);
 void copy_gdt_tls(const struct lg_cpu *cpu, struct desc_struct *gdt);
 
 /* page_tables.c: */
-int init_guest_pagetable(struct lguest *lg, unsigned long pgtable);
+int init_guest_pagetable(struct lguest *lg);
 void free_guest_pagetable(struct lguest *lg);
 void guest_new_pagetable(struct lg_cpu *cpu, unsigned long pgtable);
 void guest_set_pmd(struct lguest *lg, unsigned long gpgdir, u32 i);
diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index a661bbd..915da6b 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -250,7 +250,7 @@ static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
 	/* Figure out how many pages the ring will take, and map that memory */
 	lvq->pages = lguest_map((unsigned long)lvq->config.pfn << PAGE_SHIFT,
 				DIV_ROUND_UP(vring_size(lvq->config.num,
-							PAGE_SIZE),
+							LGUEST_VRING_ALIGN),
 					     PAGE_SIZE));
 	if (!lvq->pages) {
 		err = -ENOMEM;
@@ -259,8 +259,8 @@ static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
 
 	/* OK, tell virtio_ring.c to set up a virtqueue now we know its size
 	 * and we've got a pointer to its pages. */
-	vq = vring_new_virtqueue(lvq->config.num, vdev, lvq->pages,
-				 lg_notify, callback);
+	vq = vring_new_virtqueue(lvq->config.num, LGUEST_VRING_ALIGN,
+				 vdev, lvq->pages, lg_notify, callback);
 	if (!vq) {
 		err = -ENOMEM;
 		goto unmap;
@@ -272,7 +272,7 @@ static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
 	 * the interrupt as a source of randomness: it'd be nice to have that
 	 * back.. */
 	err = request_irq(lvq->config.irq, vring_interrupt, IRQF_SHARED,
-			  vdev->dev.bus_id, vq);
+			  dev_name(&vdev->dev), vq);
 	if (err)
 		goto destroy_vring;
 
diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index e73a000..34bc017 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -146,7 +146,7 @@ static int lg_cpu_start(struct lg_cpu *cpu, unsigned id, unsigned long start_ip)
 	return 0;
 }
 
-/*L:020 The initialization write supplies 4 pointer sized (32 or 64 bit)
+/*L:020 The initialization write supplies 3 pointer sized (32 or 64 bit)
  * values (in addition to the LHREQ_INITIALIZE value).  These are:
  *
  * base: The start of the Guest-physical memory inside the Launcher memory.
@@ -155,9 +155,6 @@ static int lg_cpu_start(struct lg_cpu *cpu, unsigned id, unsigned long start_ip)
  * allowed to access.  The Guest memory lives inside the Launcher, so it sets
  * this to ensure the Guest can only reach its own memory.
  *
- * pgdir: The (Guest-physical) address of the top of the initial Guest
- * pagetables (which are set up by the Launcher).
- *
  * start: The first instruction to execute ("eip" in x86-speak).
  */
 static int initialize(struct file *file, const unsigned long __user *input)
@@ -166,7 +163,7 @@ static int initialize(struct file *file, const unsigned long __user *input)
 	 * Guest. */
 	struct lguest *lg;
 	int err;
-	unsigned long args[4];
+	unsigned long args[3];
 
 	/* We grab the Big Lguest lock, which protects against multiple
 	 * simultaneous initializations. */
@@ -192,14 +189,14 @@ static int initialize(struct file *file, const unsigned long __user *input)
 	lg->mem_base = (void __user *)args[0];
 	lg->pfn_limit = args[1];
 
-	/* This is the first cpu (cpu 0) and it will start booting at args[3] */
-	err = lg_cpu_start(&lg->cpus[0], 0, args[3]);
+	/* This is the first cpu (cpu 0) and it will start booting at args[2] */
+	err = lg_cpu_start(&lg->cpus[0], 0, args[2]);
 	if (err)
 		goto release_guest;
 
 	/* Initialize the Guest's shadow page tables, using the toplevel
 	 * address the Launcher gave us.  This allocates memory, so can fail. */
-	err = init_guest_pagetable(lg, args[2]);
+	err = init_guest_pagetable(lg);
 	if (err)
 		goto free_regs;
 
diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index 81d0c60..576a831 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -14,6 +14,7 @@
 #include <linux/percpu.h>
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
+#include <asm/bootparam.h>
 #include "lg.h"
 
 /*M:008 We hold reference to pages, which prevents them from being swapped.
@@ -581,15 +582,82 @@ void guest_set_pmd(struct lguest *lg, unsigned long gpgdir, u32 idx)
 		release_pgd(lg, lg->pgdirs[pgdir].pgdir + idx);
 }
 
+/* Once we know how much memory we have we can construct simple identity
+ * (which set virtual == physical) and linear mappings
+ * which will get the Guest far enough into the boot to create its own.
+ *
+ * We lay them out of the way, just below the initrd (which is why we need to
+ * know its size here). */
+static unsigned long setup_pagetables(struct lguest *lg,
+				      unsigned long mem,
+				      unsigned long initrd_size)
+{
+	pgd_t __user *pgdir;
+	pte_t __user *linear;
+	unsigned int mapped_pages, i, linear_pages, phys_linear;
+	unsigned long mem_base = (unsigned long)lg->mem_base;
+
+	/* We have mapped_pages frames to map, so we need
+	 * linear_pages page tables to map them. */
+	mapped_pages = mem / PAGE_SIZE;
+	linear_pages = (mapped_pages + PTRS_PER_PTE - 1) / PTRS_PER_PTE;
+
+	/* We put the toplevel page directory page at the top of memory. */
+	pgdir = (pgd_t *)(mem + mem_base - initrd_size - PAGE_SIZE);
+
+	/* Now we use the next linear_pages pages as pte pages */
+	linear = (void *)pgdir - linear_pages * PAGE_SIZE;
+
+	/* Linear mapping is easy: put every page's address into the
+	 * mapping in order. */
+	for (i = 0; i < mapped_pages; i++) {
+		pte_t pte;
+		pte = pfn_pte(i, __pgprot(_PAGE_PRESENT|_PAGE_RW|_PAGE_USER));
+		if (copy_to_user(&linear[i], &pte, sizeof(pte)) != 0)
+			return -EFAULT;
+	}
+
+	/* The top level points to the linear page table pages above.
+	 * We setup the identity and linear mappings here. */
+	phys_linear = (unsigned long)linear - mem_base;
+	for (i = 0; i < mapped_pages; i += PTRS_PER_PTE) {
+		pgd_t pgd;
+		pgd = __pgd((phys_linear + i * sizeof(pte_t)) |
+			    (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER));
+
+		if (copy_to_user(&pgdir[i / PTRS_PER_PTE], &pgd, sizeof(pgd))
+		    || copy_to_user(&pgdir[pgd_index(PAGE_OFFSET)
+					   + i / PTRS_PER_PTE],
+				    &pgd, sizeof(pgd)))
+			return -EFAULT;
+	}
+
+	/* We return the top level (guest-physical) address: remember where
+	 * this is. */
+	return (unsigned long)pgdir - mem_base;
+}
+
 /*H:500 (vii) Setting up the page tables initially.
  *
  * When a Guest is first created, the Launcher tells us where the toplevel of
  * its first page table is.  We set some things up here: */
-int init_guest_pagetable(struct lguest *lg, unsigned long pgtable)
+int init_guest_pagetable(struct lguest *lg)
 {
+	u64 mem;
+	u32 initrd_size;
+	struct boot_params __user *boot = (struct boot_params *)lg->mem_base;
+
+	/* Get the Guest memory size and the ramdisk size from the boot header
+	 * located at lg->mem_base (Guest address 0). */
+	if (copy_from_user(&mem, &boot->e820_map[0].size, sizeof(mem))
+	    || get_user(initrd_size, &boot->hdr.ramdisk_size))
+		return -EFAULT;
+
 	/* We start on the first shadow page table, and give it a blank PGD
 	 * page. */
-	lg->pgdirs[0].gpgdir = pgtable;
+	lg->pgdirs[0].gpgdir = setup_pagetables(lg, mem, initrd_size);
+	if (IS_ERR_VALUE(lg->pgdirs[0].gpgdir))
+		return lg->pgdirs[0].gpgdir;
 	lg->pgdirs[0].pgdir = (pgd_t *)get_zeroed_page(GFP_KERNEL);
 	if (!lg->pgdirs[0].pgdir)
 		return -ENOMEM;
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 3d44244..28c90b8 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -188,11 +188,13 @@ static struct virtqueue *kvm_find_vq(struct virtio_device *vdev,
 	config = kvm_vq_config(kdev->desc)+index;
 
 	err = vmem_add_mapping(config->address,
-			       vring_size(config->num, PAGE_SIZE));
+			       vring_size(config->num,
+					  KVM_S390_VIRTIO_RING_ALIGN));
 	if (err)
 		goto out;
 
-	vq = vring_new_virtqueue(config->num, vdev, (void *) config->address,
+	vq = vring_new_virtqueue(config->num, KVM_S390_VIRTIO_RING_ALIGN,
+				 vdev, (void *) config->address,
 				 kvm_notify, callback);
 	if (!vq) {
 		err = -ENOMEM;
@@ -209,7 +211,8 @@ static struct virtqueue *kvm_find_vq(struct virtio_device *vdev,
 	return vq;
 unmap:
 	vmem_remove_mapping(config->address,
-			    vring_size(config->num, PAGE_SIZE));
+			    vring_size(config->num,
+				       KVM_S390_VIRTIO_RING_ALIGN));
 out:
 	return ERR_PTR(err);
 }
@@ -220,7 +223,8 @@ static void kvm_del_vq(struct virtqueue *vq)
 
 	vring_del_virtqueue(vq);
 	vmem_remove_mapping(config->address,
-			    vring_size(config->num, PAGE_SIZE));
+			    vring_size(config->num,
+				       KVM_S390_VIRTIO_RING_ALIGN));
 }
 
 /*
@@ -295,13 +299,29 @@ static void scan_devices(void)
  */
 static void kvm_extint_handler(u16 code)
 {
-	void *data = (void *) *(long *) __LC_PFAULT_INTPARM;
-	u16 subcode = S390_lowcore.cpu_addr;
+	struct virtqueue *vq;
+	u16 subcode;
+	int config_changed;
 
+	subcode = S390_lowcore.cpu_addr;
 	if ((subcode & 0xff00) != VIRTIO_SUBCODE_64)
 		return;
 
-	vring_interrupt(0, data);
+	/* The LSB might be overloaded, we have to mask it */
+	vq = (struct virtqueue *) ((*(long *) __LC_PFAULT_INTPARM) & ~1UL);
+
+	/* We use the LSB of extparam, to decide, if this interrupt is a config
+	 * change or a "standard" interrupt */
+	config_changed =  (*(int *)  __LC_EXT_PARAMS & 1);
+
+	if (config_changed) {
+		struct virtio_driver *drv;
+		drv = container_of(vq->vdev->dev.driver,
+				   struct virtio_driver, driver);
+		if (drv->config_changed)
+			drv->config_changed(vq->vdev);
+	} else
+		vring_interrupt(0, vq);
 }
 
 /*
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 5b78fd0..018c070 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -176,7 +176,7 @@ int register_virtio_device(struct virtio_device *dev)
 
 	/* Assign a unique device index and hence name. */
 	dev->index = dev_index++;
-	sprintf(dev->dev.bus_id, "virtio%u", dev->index);
+	dev_set_name(&dev->dev, "virtio%u", dev->index);
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 62eab43..5926826 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -56,6 +56,15 @@ static struct virtio_device_id id_table[] = {
 	{ 0 },
 };
 
+static u32 page_to_balloon_pfn(struct page *page)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	BUILD_BUG_ON(PAGE_SHIFT < VIRTIO_BALLOON_PFN_SHIFT);
+	/* Convert pfn from Linux page size to balloon page size. */
+	return pfn >> (PAGE_SHIFT - VIRTIO_BALLOON_PFN_SHIFT);
+}
+
 static void balloon_ack(struct virtqueue *vq)
 {
 	struct virtio_balloon *vb;
@@ -99,7 +108,7 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 			msleep(200);
 			break;
 		}
-		vb->pfns[vb->num_pfns] = page_to_pfn(page);
+		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
 		totalram_pages--;
 		vb->num_pages++;
 		list_add(&page->lru, &vb->pages);
@@ -132,7 +141,7 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 	for (vb->num_pfns = 0; vb->num_pfns < num; vb->num_pfns++) {
 		page = list_first_entry(&vb->pages, struct page, lru);
 		list_del(&page->lru);
-		vb->pfns[vb->num_pfns] = page_to_pfn(page);
+		vb->pfns[vb->num_pfns] = page_to_balloon_pfn(page);
 		vb->num_pages--;
 	}
 
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c7dc37c..265fdf2 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -75,7 +75,7 @@ MODULE_DEVICE_TABLE(pci, virtio_pci_id_table);
  * would make more sense for virtio to not insist on having it's own device. */
 static struct device virtio_pci_root = {
 	.parent		= NULL,
-	.bus_id		= "virtio-pci",
+	.init_name	= "virtio-pci",
 };
 
 /* Convert a generic virtio device to our structure */
@@ -216,7 +216,7 @@ static struct virtqueue *vp_find_vq(struct virtio_device *vdev, unsigned index,
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_vq_info *info;
 	struct virtqueue *vq;
-	unsigned long flags;
+	unsigned long flags, size;
 	u16 num;
 	int err;
 
@@ -237,19 +237,20 @@ static struct virtqueue *vp_find_vq(struct virtio_device *vdev, unsigned index,
 	info->queue_index = index;
 	info->num = num;
 
-	info->queue = kzalloc(PAGE_ALIGN(vring_size(num,PAGE_SIZE)), GFP_KERNEL);
+	size = PAGE_ALIGN(vring_size(num, VIRTIO_PCI_VRING_ALIGN));
+	info->queue = alloc_pages_exact(size, GFP_KERNEL|__GFP_ZERO);
 	if (info->queue == NULL) {
 		err = -ENOMEM;
 		goto out_info;
 	}
 
 	/* activate the queue */
-	iowrite32(virt_to_phys(info->queue) >> PAGE_SHIFT,
+	iowrite32(virt_to_phys(info->queue) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
 		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
 	/* create the vring */
-	vq = vring_new_virtqueue(info->num, vdev, info->queue,
-				 vp_notify, callback);
+	vq = vring_new_virtqueue(info->num, VIRTIO_PCI_VRING_ALIGN,
+				 vdev, info->queue, vp_notify, callback);
 	if (!vq) {
 		err = -ENOMEM;
 		goto out_activate_queue;
@@ -266,7 +267,7 @@ static struct virtqueue *vp_find_vq(struct virtio_device *vdev, unsigned index,
 
 out_activate_queue:
 	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
-	kfree(info->queue);
+	free_pages_exact(info->queue, size);
 out_info:
 	kfree(info);
 	return ERR_PTR(err);
@@ -277,7 +278,7 @@ static void vp_del_vq(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
 	struct virtio_pci_vq_info *info = vq->priv;
-	unsigned long flags;
+	unsigned long flags, size;
 
 	spin_lock_irqsave(&vp_dev->lock, flags);
 	list_del(&info->node);
@@ -289,7 +290,8 @@ static void vp_del_vq(struct virtqueue *vq)
 	iowrite16(info->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
 	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
-	kfree(info->queue);
+	size = PAGE_ALIGN(vring_size(info->num, VIRTIO_PCI_VRING_ALIGN));
+	free_pages_exact(info->queue, size);
 	kfree(info);
 }
 
@@ -305,6 +307,20 @@ static struct virtio_config_ops virtio_pci_config_ops = {
 	.finalize_features = vp_finalize_features,
 };
 
+static void virtio_pci_release_dev(struct device *_d)
+{
+	struct virtio_device *dev = container_of(_d, struct virtio_device, dev);
+	struct virtio_pci_device *vp_dev = to_vp_device(dev);
+	struct pci_dev *pci_dev = vp_dev->pci_dev;
+
+	free_irq(pci_dev->irq, vp_dev);
+	pci_set_drvdata(pci_dev, NULL);
+	pci_iounmap(pci_dev, vp_dev->ioaddr);
+	pci_release_regions(pci_dev);
+	pci_disable_device(pci_dev);
+	kfree(vp_dev);
+}
+
 /* the PCI probing function */
 static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 				      const struct pci_device_id *id)
@@ -328,6 +344,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 
 	vp_dev->vdev.dev.parent = &virtio_pci_root;
+	vp_dev->vdev.dev.release = virtio_pci_release_dev;
 	vp_dev->vdev.config = &virtio_pci_config_ops;
 	vp_dev->pci_dev = pci_dev;
 	INIT_LIST_HEAD(&vp_dev->virtqueues);
@@ -357,7 +374,7 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 
 	/* register a handler for the queue with the PCI device's interrupt */
 	err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, IRQF_SHARED,
-			  vp_dev->vdev.dev.bus_id, vp_dev);
+			  dev_name(&vp_dev->vdev.dev), vp_dev);
 	if (err)
 		goto out_set_drvdata;
 
@@ -387,12 +404,6 @@ static void __devexit virtio_pci_remove(struct pci_dev *pci_dev)
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 
 	unregister_virtio_device(&vp_dev->vdev);
-	free_irq(pci_dev->irq, vp_dev);
-	pci_set_drvdata(pci_dev, NULL);
-	pci_iounmap(pci_dev, vp_dev->ioaddr);
-	pci_release_regions(pci_dev);
-	pci_disable_device(pci_dev);
-	kfree(vp_dev);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 6eb5303..5777196 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -274,6 +274,7 @@ static struct virtqueue_ops vring_vq_ops = {
 };
 
 struct virtqueue *vring_new_virtqueue(unsigned int num,
+				      unsigned int vring_align,
 				      struct virtio_device *vdev,
 				      void *pages,
 				      void (*notify)(struct virtqueue *),
@@ -292,7 +293,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 	if (!vq)
 		return NULL;
 
-	vring_init(&vq->vring, num, pages, PAGE_SIZE);
+	vring_init(&vq->vring, num, pages, vring_align);
 	vq->vq.callback = callback;
 	vq->vq.vdev = vdev;
 	vq->vq.vq_ops = &vring_vq_ops;
diff --git a/include/linux/lguest_launcher.h b/include/linux/lguest_launcher.h
index e7217dc..a53407a 100644
--- a/include/linux/lguest_launcher.h
+++ b/include/linux/lguest_launcher.h
@@ -54,9 +54,13 @@ struct lguest_vqconfig {
 /* Write command first word is a request. */
 enum lguest_req
 {
-	LHREQ_INITIALIZE, /* + base, pfnlimit, pgdir, start */
+	LHREQ_INITIALIZE, /* + base, pfnlimit, start */
 	LHREQ_GETDMA, /* No longer used */
 	LHREQ_IRQ, /* + irq */
 	LHREQ_BREAK, /* + on/off flag (on blocks until someone does off) */
 };
+
+/* The alignment to use between consumer and producer parts of vring.
+ * x86 pagesize for historical reasons. */
+#define LGUEST_VRING_ALIGN	4096
 #endif /* _LINUX_LGUEST_LAUNCHER */
diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
index c30c7bf..8726ff7 100644
--- a/include/linux/virtio_balloon.h
+++ b/include/linux/virtio_balloon.h
@@ -10,6 +10,9 @@
 /* The feature bitmap for virtio balloon */
 #define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
 
+/* Size of a PFN in the balloon interface. */
+#define VIRTIO_BALLOON_PFN_SHIFT 12
+
 struct virtio_balloon_config
 {
 	/* Number of pages host wants Guest to give up. */
diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
index 19a0da0..7615ffc 100644
--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -7,6 +7,17 @@
 /* The ID for virtio console */
 #define VIRTIO_ID_CONSOLE	3
 
+/* Feature bits */
+#define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
+
+struct virtio_console_config {
+	/* colums of the screens */
+	__u16 cols;
+	/* rows of the screens */
+	__u16 rows;
+} __attribute__((packed));
+
+
 #ifdef __KERNEL__
 int __init virtio_cons_early_init(int (*put_chars)(u32, const char *, int));
 #endif /* __KERNEL__ */
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index cdef357..cd0fd5d 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -53,4 +53,12 @@
 
 /* Virtio ABI version, this must match exactly */
 #define VIRTIO_PCI_ABI_VERSION		0
+
+/* How many bits to shift physical queue address written to QUEUE_PFN.
+ * 12 is historical, and due to x86 page size. */
+#define VIRTIO_PCI_QUEUE_ADDR_SHIFT	12
+
+/* The alignment to use between consumer and producer parts of vring.
+ * x86 pagesize again. */
+#define VIRTIO_PCI_VRING_ALIGN		4096
 #endif
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index c4a598f..71e0372 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -83,7 +83,7 @@ struct vring {
  *	__u16 avail_idx;
  *	__u16 available[num];
  *
- *	// Padding to the next page boundary.
+ *	// Padding to the next align boundary.
  *	char pad[];
  *
  *	// A ring of used descriptor heads with free-running index.
@@ -93,19 +93,19 @@ struct vring {
  * };
  */
 static inline void vring_init(struct vring *vr, unsigned int num, void *p,
-			      unsigned long pagesize)
+			      unsigned long align)
 {
 	vr->num = num;
 	vr->desc = p;
 	vr->avail = p + num*sizeof(struct vring_desc);
-	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + pagesize-1)
-			    & ~(pagesize - 1));
+	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + align-1)
+			    & ~(align - 1));
 }
 
-static inline unsigned vring_size(unsigned int num, unsigned long pagesize)
+static inline unsigned vring_size(unsigned int num, unsigned long align)
 {
 	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
-		 + pagesize - 1) & ~(pagesize - 1))
+		 + align - 1) & ~(align - 1))
 		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
 }
 
@@ -115,6 +115,7 @@ struct virtio_device;
 struct virtqueue;
 
 struct virtqueue *vring_new_virtqueue(unsigned int num,
+				      unsigned int vring_align,
 				      struct virtio_device *vdev,
 				      void *pages,
 				      void (*notify)(struct virtqueue *vq),

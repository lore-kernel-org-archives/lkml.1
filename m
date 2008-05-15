Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbYEOPIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbYEOPIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbYEOPGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:06:08 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:57486 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbYEOPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:06:04 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 15 May 2008 17:02:16 +0200
Message-Id: <1210863736.11281.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 Documentation/kernel-parameters.txt |    3 ---
 arch/s390/kernel/debug.c            |   20 ++++++++++----------
 arch/s390/kernel/irq.c              |    3 ++-
 arch/s390/kernel/smp.c              |   16 ++++++++--------
 arch/s390/mm/vmem.c                 |   19 ++++++-------------
 drivers/s390/block/dasd.c           |    5 +++--
 drivers/s390/block/dasd_devmap.c    |   10 +++++-----
 drivers/s390/block/dasd_int.h       |    2 +-
 drivers/s390/char/tape_core.c       |   31 +++++--------------------------
 drivers/s390/char/vmlogrdr.c        |    2 +-
 drivers/s390/cio/blacklist.c        |    1 -
 drivers/s390/cio/device_pgid.c      |   12 +++---------
 include/asm-s390/debug.h            |    4 ++--
 13 files changed, 46 insertions(+), 82 deletions(-)

Cornelia Huck (4):
      [S390] Remove last traces of cio_msg=.
      [S390] dasd: Use const in busid functions.
      [S390] s390dbf: Use const char * for dbf name.
      [S390] tape: Use ccw_dev_id to build cdev_id.

Heiko Carstens (3):
      [S390] sparsemem vmemmap: initialize memmap.
      [S390] smp: __smp_call_function_map vs cpu_online_map fix.
      [S390] show_interrupts: prevent cpu hotplug when walking cpu_online_map.

Huang Weiyi (1):
      [S390] blacklist.c: removed duplicated include

Marcin Slusarz (1):
      [S390] vmlogrdr: module initialization function should return negative errors

Michael Ernst (1):
      [S390] cio: Remove CCW_CMD_SUSPEND_RECONN in front of CCW_CMD_SET_PGID.

Stefan Weinhuber (1):
      [S390] dasd: fix timeout handling in interrupt handler

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cdd5b93..7038a6d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -398,9 +398,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	cio_ignore=	[S390]
 			See Documentation/s390/CommonIO for details.
 
-	cio_msg=	[S390]
-			See Documentation/s390/CommonIO for details.
-
 	clock=		[BUGS=X86-32, HW] gettimeofday clocksource override.
 			[Deprecated]
 			Forces specified clocksource (if available) to be used
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index dff0568..c93d129 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -71,7 +71,7 @@ static ssize_t debug_input(struct file *file, const char __user *user_buf,
 			size_t user_len, loff_t * offset);
 static int debug_open(struct inode *inode, struct file *file);
 static int debug_close(struct inode *inode, struct file *file);
-static debug_info_t*  debug_info_create(char *name, int pages_per_area,
+static debug_info_t *debug_info_create(const char *name, int pages_per_area,
 			int nr_areas, int buf_size, mode_t mode);
 static void debug_info_get(debug_info_t *);
 static void debug_info_put(debug_info_t *);
@@ -234,8 +234,8 @@ fail_malloc_areas:
  */
 
 static debug_info_t*
-debug_info_alloc(char *name, int pages_per_area, int nr_areas, int buf_size,
-		int level, int mode)
+debug_info_alloc(const char *name, int pages_per_area, int nr_areas,
+		 int buf_size, int level, int mode)
 {
 	debug_info_t* rc;
 
@@ -326,8 +326,8 @@ debug_info_free(debug_info_t* db_info){
  */
 
 static debug_info_t*
-debug_info_create(char *name, int pages_per_area, int nr_areas, int buf_size,
-		  mode_t mode)
+debug_info_create(const char *name, int pages_per_area, int nr_areas,
+		  int buf_size, mode_t mode)
 {
 	debug_info_t* rc;
 
@@ -684,9 +684,9 @@ debug_close(struct inode *inode, struct file *file)
  * - Returns handle for debug area
  */
 
-debug_info_t *debug_register_mode(char *name, int pages_per_area, int nr_areas,
-				  int buf_size, mode_t mode, uid_t uid,
-				  gid_t gid)
+debug_info_t *debug_register_mode(const char *name, int pages_per_area,
+				  int nr_areas, int buf_size, mode_t mode,
+				  uid_t uid, gid_t gid)
 {
 	debug_info_t *rc = NULL;
 
@@ -722,8 +722,8 @@ EXPORT_SYMBOL(debug_register_mode);
  * - returns handle for debug area
  */
 
-debug_info_t *debug_register(char *name, int pages_per_area, int nr_areas,
-			     int buf_size)
+debug_info_t *debug_register(const char *name, int pages_per_area,
+			     int nr_areas, int buf_size)
 {
 	return debug_register_mode(name, pages_per_area, nr_areas, buf_size,
 				   S_IRUSR | S_IWUSR, 0, 0);
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index c59a86d..e7c5bfb 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -25,6 +25,7 @@ int show_interrupts(struct seq_file *p, void *v)
 	static const char *intrclass_names[] = { "EXT", "I/O", };
 	int i = *(loff_t *) v, j;
 
+	get_online_cpus();
 	if (i == 0) {
 		seq_puts(p, "           ");
 		for_each_online_cpu(j)
@@ -43,7 +44,7 @@ int show_interrupts(struct seq_file *p, void *v)
                 seq_putc(p, '\n');
 
         }
-
+	put_online_cpus();
         return 0;
 }
 
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 0aeb290..1f42289 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -139,7 +139,6 @@ static void __smp_call_function_map(void (*func) (void *info), void *info,
 	if (wait)
 		data.finished = CPU_MASK_NONE;
 
-	spin_lock(&call_lock);
 	call_data = &data;
 
 	for_each_cpu_mask(cpu, map)
@@ -151,7 +150,6 @@ static void __smp_call_function_map(void (*func) (void *info), void *info,
 	if (wait)
 		while (!cpus_equal(map, data.finished))
 			cpu_relax();
-	spin_unlock(&call_lock);
 out:
 	if (local) {
 		local_irq_disable();
@@ -177,11 +175,11 @@ int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 {
 	cpumask_t map;
 
-	preempt_disable();
+	spin_lock(&call_lock);
 	map = cpu_online_map;
 	cpu_clear(smp_processor_id(), map);
 	__smp_call_function_map(func, info, nonatomic, wait, map);
-	preempt_enable();
+	spin_unlock(&call_lock);
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function);
@@ -202,10 +200,10 @@ EXPORT_SYMBOL(smp_call_function);
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int nonatomic, int wait)
 {
-	preempt_disable();
+	spin_lock(&call_lock);
 	__smp_call_function_map(func, info, nonatomic, wait,
 				cpumask_of_cpu(cpu));
-	preempt_enable();
+	spin_unlock(&call_lock);
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_single);
@@ -228,10 +226,10 @@ EXPORT_SYMBOL(smp_call_function_single);
 int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 			   int wait)
 {
-	preempt_disable();
+	spin_lock(&call_lock);
 	cpu_clear(smp_processor_id(), mask);
 	__smp_call_function_map(func, info, 0, wait, mask);
-	preempt_enable();
+	spin_unlock(&call_lock);
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_mask);
@@ -592,7 +590,9 @@ int __cpuinit start_secondary(void *cpuvoid)
 	pfault_init();
 
 	/* Mark this cpu as online */
+	spin_lock(&call_lock);
 	cpu_set(smp_processor_id(), cpu_online_map);
+	spin_unlock(&call_lock);
 	/* Switch on interrupts */
 	local_irq_enable();
 	/* Print info about this processor */
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index beccacf..ea28048 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -27,19 +27,12 @@ struct memory_segment {
 
 static LIST_HEAD(mem_segs);
 
-static void __ref *vmem_alloc_pages(unsigned int order)
-{
-	if (slab_is_available())
-		return (void *)__get_free_pages(GFP_KERNEL, order);
-	return alloc_bootmem_pages((1 << order) * PAGE_SIZE);
-}
-
-static inline pud_t *vmem_pud_alloc(void)
+static pud_t *vmem_pud_alloc(void)
 {
 	pud_t *pud = NULL;
 
 #ifdef CONFIG_64BIT
-	pud = vmem_alloc_pages(2);
+	pud = vmemmap_alloc_block(PAGE_SIZE * 4, 0);
 	if (!pud)
 		return NULL;
 	clear_table((unsigned long *) pud, _REGION3_ENTRY_EMPTY, PAGE_SIZE * 4);
@@ -47,12 +40,12 @@ static inline pud_t *vmem_pud_alloc(void)
 	return pud;
 }
 
-static inline pmd_t *vmem_pmd_alloc(void)
+static pmd_t *vmem_pmd_alloc(void)
 {
 	pmd_t *pmd = NULL;
 
 #ifdef CONFIG_64BIT
-	pmd = vmem_alloc_pages(2);
+	pmd = vmemmap_alloc_block(PAGE_SIZE * 4, 0);
 	if (!pmd)
 		return NULL;
 	clear_table((unsigned long *) pmd, _SEGMENT_ENTRY_EMPTY, PAGE_SIZE * 4);
@@ -60,7 +53,7 @@ static inline pmd_t *vmem_pmd_alloc(void)
 	return pmd;
 }
 
-static pte_t __init_refok *vmem_pte_alloc(void)
+static pte_t __ref *vmem_pte_alloc(void)
 {
 	pte_t *pte;
 
@@ -214,7 +207,7 @@ int __meminit vmemmap_populate(struct page *start, unsigned long nr, int node)
 		if (pte_none(*pt_dir)) {
 			unsigned long new_page;
 
-			new_page =__pa(vmem_alloc_pages(0));
+			new_page =__pa(vmemmap_alloc_block(PAGE_SIZE, 0));
 			if (!new_page)
 				goto out;
 			pte = pfn_pte(new_page >> PAGE_SHIFT, PAGE_KERNEL);
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index ac6d4d3..8ba3f13 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -925,6 +925,8 @@ static void dasd_handle_killed_request(struct ccw_device *cdev,
 	struct dasd_ccw_req *cqr;
 	struct dasd_device *device;
 
+	if (!intparm)
+		return;
 	cqr = (struct dasd_ccw_req *) intparm;
 	if (cqr->status != DASD_CQR_IN_IO) {
 		MESSAGE(KERN_DEBUG,
@@ -976,17 +978,16 @@ void dasd_int_handler(struct ccw_device *cdev, unsigned long intparm,
 	if (IS_ERR(irb)) {
 		switch (PTR_ERR(irb)) {
 		case -EIO:
-			dasd_handle_killed_request(cdev, intparm);
 			break;
 		case -ETIMEDOUT:
 			printk(KERN_WARNING"%s(%s): request timed out\n",
 			       __func__, cdev->dev.bus_id);
-			//FIXME - dasd uses own timeout interface...
 			break;
 		default:
 			printk(KERN_WARNING"%s(%s): unknown error %ld\n",
 			       __func__, cdev->dev.bus_id, PTR_ERR(irb));
 		}
+		dasd_handle_killed_request(cdev, intparm);
 		return;
 	}
 
diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index f4fb402..d774e79 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -86,10 +86,10 @@ static DEFINE_SPINLOCK(dasd_devmap_lock);
 static struct list_head dasd_hashlists[256];
 int dasd_max_devindex;
 
-static struct dasd_devmap *dasd_add_busid(char *, int);
+static struct dasd_devmap *dasd_add_busid(const char *, int);
 
 static inline int
-dasd_hash_busid(char *bus_id)
+dasd_hash_busid(const char *bus_id)
 {
 	int hash, i;
 
@@ -394,7 +394,7 @@ dasd_parse(void)
  * devices.
  */
 static struct dasd_devmap *
-dasd_add_busid(char *bus_id, int features)
+dasd_add_busid(const char *bus_id, int features)
 {
 	struct dasd_devmap *devmap, *new, *tmp;
 	int hash;
@@ -430,7 +430,7 @@ dasd_add_busid(char *bus_id, int features)
  * Find devmap for device with given bus_id.
  */
 static struct dasd_devmap *
-dasd_find_busid(char *bus_id)
+dasd_find_busid(const char *bus_id)
 {
 	struct dasd_devmap *devmap, *tmp;
 	int hash;
@@ -452,7 +452,7 @@ dasd_find_busid(char *bus_id)
  * Check if busid has been added to the list of dasd ranges.
  */
 int
-dasd_busid_known(char *bus_id)
+dasd_busid_known(const char *bus_id)
 {
 	return IS_ERR(dasd_find_busid(bus_id)) ? -ENOENT : 0;
 }
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 6c624bf..fb2f931 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -598,7 +598,7 @@ struct dasd_device *dasd_device_from_cdev_locked(struct ccw_device *);
 struct dasd_device *dasd_device_from_devindex(int);
 
 int dasd_parse(void);
-int dasd_busid_known(char *);
+int dasd_busid_known(const char *);
 
 /* externals in dasd_gendisk.c */
 int  dasd_gendisk_init(void);
diff --git a/drivers/s390/char/tape_core.c b/drivers/s390/char/tape_core.c
index 7ad8cf1..76e44eb 100644
--- a/drivers/s390/char/tape_core.c
+++ b/drivers/s390/char/tape_core.c
@@ -76,32 +76,9 @@ const char *tape_op_verbose[TO_SIZE] =
 	[TO_KEKL_QUERY] = "KLQ",[TO_RDC] = "RDC",
 };
 
-static int
-busid_to_int(char *bus_id)
+static int devid_to_int(struct ccw_dev_id *dev_id)
 {
-	int	dec;
-	int	d;
-	char *	s;
-
-	for(s = bus_id, d = 0; *s != '\0' && *s != '.'; s++)
-		d = (d * 10) + (*s - '0');
-	dec = d;
-	for(s++, d = 0; *s != '\0' && *s != '.'; s++)
-		d = (d * 10) + (*s - '0');
-	dec = (dec << 8) + d;
-
-	for(s++; *s != '\0'; s++) {
-		if (*s >= '0' && *s <= '9') {
-			d = *s - '0';
-		} else if (*s >= 'a' && *s <= 'f') {
-			d = *s - 'a' + 10;
-		} else {
-			d = *s - 'A' + 10;
-		}
-		dec = (dec << 4) + d;
-	}
-
-	return dec;
+	return dev_id->devno + (dev_id->ssid << 16);
 }
 
 /*
@@ -551,6 +528,7 @@ tape_generic_probe(struct ccw_device *cdev)
 {
 	struct tape_device *device;
 	int ret;
+	struct ccw_dev_id dev_id;
 
 	device = tape_alloc_device();
 	if (IS_ERR(device))
@@ -565,7 +543,8 @@ tape_generic_probe(struct ccw_device *cdev)
 	cdev->dev.driver_data = device;
 	cdev->handler = __tape_do_irq;
 	device->cdev = cdev;
-	device->cdev_id = busid_to_int(cdev->dev.bus_id);
+	ccw_device_get_id(cdev, &dev_id);
+	device->cdev_id = devid_to_int(&dev_id);
 	PRINT_INFO("tape device %s found\n", cdev->dev.bus_id);
 	return ret;
 }
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index d364e0b..e848734 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -858,7 +858,7 @@ static int __init vmlogrdr_init(void)
 	for (i=0; i < MAXMINOR; ++i ) {
 		sys_ser[i].buffer = (char *) get_zeroed_page(GFP_KERNEL);
 		if (!sys_ser[i].buffer) {
-			rc = ENOMEM;
+			rc = -ENOMEM;
 			break;
 		}
 		sys_ser[i].current_position = sys_ser[i].buffer;
diff --git a/drivers/s390/cio/blacklist.c b/drivers/s390/cio/blacklist.c
index 9c21b8f..a4a5f2e 100644
--- a/drivers/s390/cio/blacklist.c
+++ b/drivers/s390/cio/blacklist.c
@@ -19,7 +19,6 @@
 
 #include <asm/cio.h>
 #include <asm/uaccess.h>
-#include <asm/cio.h>
 
 #include "blacklist.h"
 #include "cio.h"
diff --git a/drivers/s390/cio/device_pgid.c b/drivers/s390/cio/device_pgid.c
index ba55905..5cf7be0 100644
--- a/drivers/s390/cio/device_pgid.c
+++ b/drivers/s390/cio/device_pgid.c
@@ -243,16 +243,10 @@ __ccw_device_do_pgid(struct ccw_device *cdev, __u8 func)
 	/* Setup sense path group id channel program. */
 	cdev->private->pgid[0].inf.fc = func;
 	ccw = cdev->private->iccws;
-	if (!cdev->private->flags.pgid_single) {
-		cdev->private->pgid[0].inf.fc |= SPID_FUNC_MULTI_PATH;
-		ccw->cmd_code = CCW_CMD_SUSPEND_RECONN;
-		ccw->cda = 0;
-		ccw->count = 0;
-		ccw->flags = CCW_FLAG_SLI | CCW_FLAG_CC;
-		ccw++;
-	} else
+	if (cdev->private->flags.pgid_single)
 		cdev->private->pgid[0].inf.fc |= SPID_FUNC_SINGLE_PATH;
-
+	else
+		cdev->private->pgid[0].inf.fc |= SPID_FUNC_MULTI_PATH;
 	ccw->cmd_code = CCW_CMD_SET_PGID;
 	ccw->cda = (__u32) __pa (&cdev->private->pgid[0]);
 	ccw->count = sizeof (struct pgid);
diff --git a/include/asm-s390/debug.h b/include/asm-s390/debug.h
index 335baf4..9450ce6 100644
--- a/include/asm-s390/debug.h
+++ b/include/asm-s390/debug.h
@@ -120,10 +120,10 @@ debug_entry_t* debug_exception_common(debug_info_t* id, int level,
 
 /* Debug Feature API: */
 
-debug_info_t* debug_register(char* name, int pages, int nr_areas,
+debug_info_t *debug_register(const char *name, int pages, int nr_areas,
                              int buf_size);
 
-debug_info_t *debug_register_mode(char *name, int pages, int nr_areas,
+debug_info_t *debug_register_mode(const char *name, int pages, int nr_areas,
 				  int buf_size, mode_t mode, uid_t uid,
 				  gid_t gid);
 



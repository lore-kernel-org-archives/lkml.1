Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbZKXGss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbZKXGss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZKXGsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:48:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:59494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbZKXGsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:48:47 -0500
Message-ID: <4B0B81BF.9090306@kernel.org>
Date: Tue, 24 Nov 2009 15:48:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       John Blackwood <john.blackwood@ccur.com>
Subject: [PATCH] percpu: Fix kdump failure if booted with percpu_alloc=page
References: <20091119165327.GD2923@redhat.com>
In-Reply-To: <20091119165327.GD2923@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


o kdump functionality reserves a per cpu area at boot time and exports the
  physical address of that area to user space through sys interface. This
  area stores some dump related information like cpu register states etc
  at the time of crash.

o We were assuming that per cpu area always come from linearly mapped meory
  region and using __pa() to determine physical address.
  With percpu_alloc=page, per cpu area can come from vmalloc region also and
  __pa() breaks.

o This patch implments a new function to convert per cpu address to
  physical address.

Before the patch, crash_notes addresses looked as follows.

cpu0 60fffff49800
cpu1 60fffff60800
cpu2 60fffff77800

These are bogus phsyical addresses.

After the patch, address are following.

cpu0 13eb44000
cpu1 13eb43000
cpu2 13eb42000
cpu3 13eb41000

These look fine. I got 4G of memory and /proc/iomem tell me following.

100000000-13fffffff : System RAM

tj: repositioned per_cpu_ptr_phys() in percpu.c and added comment.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
I've queued this for for-linus and will push it to Linus in a few
days.  If I miss release, I'll push it to -stable.

Thanks.

 drivers/base/cpu.c     |    2 +-
 include/linux/percpu.h |    1 +
 mm/percpu.c            |   21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e62a4cc..69ee5b7 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -97,7 +97,7 @@ static ssize_t show_crash_notes(struct sys_device *dev, struct sysdev_attribute
 	 * boot up and this data does not change there after. Hence this
 	 * operation should be safe. No locking required.
 	 */
-	addr = __pa(per_cpu_ptr(crash_notes, cpunum));
+	addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum));
 	rc = sprintf(buf, "%Lx\n", addr);
 	return rc;
 }
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 878836c..6ac984f 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -154,6 +154,7 @@ struct percpu_data {
 
 extern void *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void *__pdata);
+extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void __init setup_per_cpu_areas(void);
diff --git a/mm/percpu.c b/mm/percpu.c
index 5adfc26..09b9cf6 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1302,6 +1302,27 @@ void free_percpu(void *ptr)
 }
 EXPORT_SYMBOL_GPL(free_percpu);
 
+/**
+ * per_cpu_ptr_to_phys - convert translated percpu address to physical address
+ * @addr: the address to be converted to physical address
+ *
+ * Given @addr which is dereferenceable address obtained via one of
+ * percpu access macros, this function translates it into its physical
+ * address.  The caller is responsible for ensuring @addr stays valid
+ * until this function finishes.
+ *
+ * RETURNS:
+ * The physical address for @addr.
+ */
+phys_addr_t per_cpu_ptr_to_phys(void *addr)
+{
+	if ((unsigned long)addr < VMALLOC_START ||
+			(unsigned long)addr >= VMALLOC_END)
+		return __pa(addr);
+	else
+		return page_to_phys(vmalloc_to_page(addr));
+}
+
 static inline size_t pcpu_calc_fc_sizes(size_t static_size,
 					size_t reserved_size,
 					ssize_t *dyn_sizep)

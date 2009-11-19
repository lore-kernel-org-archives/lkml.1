Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZKSQyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZKSQyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZKSQyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:54:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZKSQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:53:59 -0500
Date: Thu, 19 Nov 2009 11:53:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, John Blackwood <john.blackwood@ccur.com>
Subject: [PATCH] Fix kdump failure if booted with percpu_alloc=page
Message-ID: <20091119165327.GD2923@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
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

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/base/cpu.c     |    2 +-
 include/linux/percpu.h |    2 ++
 mm/percpu.c            |    9 +++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

Index: linux9/mm/percpu.c
===================================================================
--- linux9.orig/mm/percpu.c	2009-11-12 19:46:07.000000000 -0500
+++ linux9/mm/percpu.c	2009-11-19 11:37:12.000000000 -0500
@@ -2069,3 +2069,12 @@ void __init setup_per_cpu_areas(void)
 		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
 }
 #endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
+
+phys_addr_t per_cpu_ptr_to_phys(void *addr)
+{
+	if ((unsigned long)addr < VMALLOC_START ||
+			(unsigned long)addr >= VMALLOC_END)
+		return __pa(addr);
+	else
+		return page_to_phys(vmalloc_to_page(addr));
+}
Index: linux9/include/linux/percpu.h
===================================================================
--- linux9.orig/include/linux/percpu.h	2009-11-12 19:46:07.000000000 -0500
+++ linux9/include/linux/percpu.h	2009-11-19 11:37:27.000000000 -0500
@@ -32,6 +32,8 @@
 	&__get_cpu_var(var); }))
 #define put_cpu_var(var) preempt_enable()
 
+extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
+
 #ifdef CONFIG_SMP
 
 #ifndef CONFIG_HAVE_LEGACY_PER_CPU_AREA
Index: linux9/drivers/base/cpu.c
===================================================================
--- linux9.orig/drivers/base/cpu.c	2009-11-12 19:46:07.000000000 -0500
+++ linux9/drivers/base/cpu.c	2009-11-19 10:57:54.000000000 -0500
@@ -97,7 +97,7 @@ static ssize_t show_crash_notes(struct s
 	 * boot up and this data does not change there after. Hence this
 	 * operation should be safe. No locking required.
 	 */
-	addr = __pa(per_cpu_ptr(crash_notes, cpunum));
+	addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum));
 	rc = sprintf(buf, "%Lx\n", addr);
 	return rc;
 }

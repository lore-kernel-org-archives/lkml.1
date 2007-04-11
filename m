Return-Path: <linux-kernel-owner+w=401wt.eu-S1161364AbXDKWym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161364AbXDKWym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161362AbXDKWyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:54:41 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55516 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161339AbXDKWyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:05 -0400
Date: Wed, 11 Apr 2007 15:51:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Manfred Spraul <manfred@colorfullife.com>, Adrian Bunk <bunk@stusta.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 02/31] i386: fix file_read_actor() and pipe_read() for
	original i386 systems
Message-ID: <20070411225117.GC24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i386-fix-file_read_actor-and-pipe_read-for-original-i386-systems.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

The __copy_to_user_inatomic() calls in file_read_actor() and pipe_read()
are broken on original i386 machines, where WP-works-ok == false, as
__copy_to_user_inatomic() on such systems calls functions which might
sleep and/or contain cond_resched() calls inside of a kmap_atomic()
region.

The original check for WP-works-ok was in access_ok(), but got moved
during the 2.5 series to fix a race vs. swap.

Return the number of bytes to copy in the case where we are in an atomic
region, so the non atomic code pathes in file_read_actor() and
pipe_read() are taken.

This could be optimized to avoid the kmap_atomic by moving the check for
WP-works-ok into fault_in_pages_writeable(), but this is more intrusive
and can be done later.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/lib/usercopy.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/i386/lib/usercopy.c
+++ b/arch/i386/lib/usercopy.c
@@ -10,6 +10,7 @@
 #include <linux/blkdev.h>
 #include <linux/module.h>
 #include <linux/backing-dev.h>
+#include <linux/interrupt.h>
 #include <asm/uaccess.h>
 #include <asm/mmx.h>
 
@@ -719,6 +720,14 @@ unsigned long __copy_to_user_ll(void __u
 #ifndef CONFIG_X86_WP_WORKS_OK
 	if (unlikely(boot_cpu_data.wp_works_ok == 0) &&
 			((unsigned long )to) < TASK_SIZE) {
+		/*
+		 * When we are in an atomic section (see
+		 * mm/filemap.c:file_read_actor), return the full
+		 * length to take the slow path.
+		 */
+		if (in_atomic())
+			return n;
+
 		/* 
 		 * CPU does not honor the WP bit when writing
 		 * from supervisory mode, and due to preemption or SMP,

-- 

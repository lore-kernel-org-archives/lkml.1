Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbXF2Wo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbXF2Wo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 18:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXF2Wot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 18:44:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35205 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752688AbXF2Wos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 18:44:48 -0400
Date: Sat, 30 Jun 2007 00:44:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>, Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] move suspend includes into right place (was Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy))
Message-ID: <20070629224422.GE6732@elf.ucw.cz>
References: <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net> <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz> <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <1177582633.6814.29.camel@johannes.berg> <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz> <1177595124.6814.77.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177595124.6814.77.camel@johannes.berg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> By the way.
> 
> > diff --git a/kernel/power/power.h b/kernel/power/power.h
> > index eb461b8..dc13af5 100644
> > --- a/kernel/power/power.h
> > +++ b/kernel/power/power.h
>         ^^^^^^^^^^^^^^^^^^^^
> 
> Don't these definitions need to be exported to userspace? That
> definitely is not a header file for userspace.

Yes, they do. Does this look like a fix?
									Pavel

--- 

Split userinterface part of power.h into separate file.

Signed-off-by: Pavel Machek <pavel@suse.cz>


diff --git a/include/linux/power.h b/include/linux/power.h
new file mode 100644
index 0000000..37bf890
--- /dev/null
+++ b/include/linux/power.h
@@ -0,0 +1,31 @@
+#ifndef INCLUDE_LINUX_POWER_H
+#define INCLUDE_LINUX_POWER_H
+
+/*
+ * This structure is used to pass the values needed for the identification
+ * of the resume swap area from a user space to the kernel via the
+ * SNAPSHOT_SET_SWAP_AREA ioctl
+ */
+struct resume_swap_area {
+	u_int64_t offset;
+	u_int32_t dev;
+} __attribute__((packed));
+
+#define SNAPSHOT_IOC_MAGIC	'3'
+#define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
+#define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
+#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, u32) /* void * */
+#define SNAPSHOT_ATOMIC_RESTORE		_IO(SNAPSHOT_IOC_MAGIC, 4)
+#define SNAPSHOT_FREE			_IO(SNAPSHOT_IOC_MAGIC, 5)
+#define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, u32) /* unsigned long */
+#define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, u32) /* void * */
+#define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, u32) /* void * */
+#define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
+#define SNAPSHOT_SET_SWAP_FILE		_IOW(SNAPSHOT_IOC_MAGIC, 10, u32) /* unsigned int */
+#define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
+#define SNAPSHOT_PMOPS			_IOW(SNAPSHOT_IOC_MAGIC, 12, u32) /* unsigned int */
+#define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
+							struct resume_swap_area)
+#define SNAPSHOT_IOC_MAXNR	13
+
+#endif
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 41d33eb..e68352b 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -1,5 +1,9 @@
+#ifndef KERNEL_POWER_POWER_H
+#define KERNEL_POWER_POWER_H
+
 #include <linux/suspend.h>
 #include <linux/utsname.h>
+#include <linux/power.h>
 
 struct swsusp_info {
 	struct new_utsname	uts;
@@ -114,33 +118,6 @@ extern int snapshot_write_next(struct sn
 extern void snapshot_write_finalize(struct snapshot_handle *handle);
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
 
-/*
- * This structure is used to pass the values needed for the identification
- * of the resume swap area from a user space to the kernel via the
- * SNAPSHOT_SET_SWAP_AREA ioctl
- */
-struct resume_swap_area {
-	u_int64_t offset;
-	u_int32_t dev;
-} __attribute__((packed));
-
-#define SNAPSHOT_IOC_MAGIC	'3'
-#define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
-#define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
-#define SNAPSHOT_ATOMIC_SNAPSHOT	_IOW(SNAPSHOT_IOC_MAGIC, 3, u32) /* void * */
-#define SNAPSHOT_ATOMIC_RESTORE		_IO(SNAPSHOT_IOC_MAGIC, 4)
-#define SNAPSHOT_FREE			_IO(SNAPSHOT_IOC_MAGIC, 5)
-#define SNAPSHOT_SET_IMAGE_SIZE		_IOW(SNAPSHOT_IOC_MAGIC, 6, u32) /* unsigned long */
-#define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, u32) /* void * */
-#define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, u32) /* void * */
-#define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
-#define SNAPSHOT_SET_SWAP_FILE		_IOW(SNAPSHOT_IOC_MAGIC, 10, u32) /* unsigned int */
-#define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
-#define SNAPSHOT_PMOPS			_IOW(SNAPSHOT_IOC_MAGIC, 12, u32) /* unsigned int */
-#define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
-							struct resume_swap_area)
-#define SNAPSHOT_IOC_MAXNR	13
-
 #define PMOPS_PREPARE	1
 #define PMOPS_ENTER	2
 #define PMOPS_FINISH	3
@@ -165,3 +142,5 @@ extern int suspend_enter(suspend_state_t
 struct timeval;
 extern void swsusp_show_speed(struct timeval *, struct timeval *,
 				unsigned int, char *);
+
+#endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

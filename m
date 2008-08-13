Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYHMUoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYHMUoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYHMUno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:43:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115AbYHMUnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:43:43 -0400
Date: Wed, 13 Aug 2008 13:41:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ebiederm@xmission.com, ying.huang@intel.com, pavel@ucw.cz,
       nigel@nigel.suspend2.net, rjw@sisk.pl, vgoyal@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
 0) in kernel_kexec()
Message-Id: <20080813134118.e1ab1292.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808131328380.3462@nehalem.linux-foundation.org>
References: <1218618760.24951.137.camel@caritas-dev.intel.com>
	<alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org>
	<m1r68shjhb.fsf@frodo.ebiederm.org>
	<20080813124406.21091eae.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0808131247320.3462@nehalem.linux-foundation.org>
	<20080813130749.c406ab6c.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0808131310450.3462@nehalem.linux-foundation.org>
	<20080813132535.6cd4bab6.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0808131328380.3462@nehalem.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 13:31:24 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 13 Aug 2008, Andrew Morton wrote:
> > 
> > #2:
> 
> I thought you said there were things that want to sleep in the region?

be reasonable - that was over five minutes ago.

--- a/kernel/kexec.c~kexec-use-a-bitop-for-locking-rather-than-xchg
+++ a/kernel/kexec.c
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/kexec.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
@@ -924,19 +924,14 @@ static int kimage_load_segment(struct ki
  */
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
-/*
- * A home grown binary mutex.
- * Nothing can wait so this mutex is safe to use
- * in interrupt context :)
- */
-static int kexec_lock;
+
+static DEFINE_MUTEX(kexec_mutex);
 
 asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 				struct kexec_segment __user *segments,
 				unsigned long flags)
 {
 	struct kimage **dest_image, *image;
-	int locked;
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
@@ -972,8 +967,7 @@ asmlinkage long sys_kexec_load(unsigned 
 	 *
 	 * KISS: always take the mutex.
 	 */
-	locked = xchg(&kexec_lock, 1);
-	if (locked)
+	if (!mutex_trylock(&kexec_mutex))
 		return -EBUSY;
 
 	dest_image = &kexec_image;
@@ -1015,8 +1009,7 @@ asmlinkage long sys_kexec_load(unsigned 
 	image = xchg(dest_image, image);
 
 out:
-	locked = xchg(&kexec_lock, 0); /* Release the mutex */
-	BUG_ON(!locked);
+	mutex_unlock(&kexec_mutex);
 	kimage_free(image);
 
 	return result;
@@ -1063,10 +1056,7 @@ asmlinkage long compat_sys_kexec_load(un
 
 void crash_kexec(struct pt_regs *regs)
 {
-	int locked;
-
-
-	/* Take the kexec_lock here to prevent sys_kexec_load
+	/* Take the kexec_mutex here to prevent sys_kexec_load
 	 * running on one cpu from replacing the crash kernel
 	 * we are using after a panic on a different cpu.
 	 *
@@ -1074,8 +1064,7 @@ void crash_kexec(struct pt_regs *regs)
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
 	 */
-	locked = xchg(&kexec_lock, 1);
-	if (!locked) {
+	if (mutex_trylock(&kexec_mutex)) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 			crash_setup_regs(&fixed_regs, regs);
@@ -1083,8 +1072,7 @@ void crash_kexec(struct pt_regs *regs)
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
-		locked = xchg(&kexec_lock, 0);
-		BUG_ON(!locked);
+		mutex_unlock(&kexec_mutex);
 	}
 }
 
@@ -1434,7 +1422,7 @@ int kernel_kexec(void)
 {
 	int error = 0;
 
-	if (xchg(&kexec_lock, 1))
+	if (!mutex_trylock(&kexec_mutex))
 		return -EBUSY;
 	if (!kexec_image) {
 		error = -EINVAL;
@@ -1498,8 +1486,6 @@ int kernel_kexec(void)
 #endif
 
  Unlock:
-	if (!xchg(&kexec_lock, 0))
-		BUG();
-
+	mutex_unlock(&kexec_mutex);
 	return error;
 }
_


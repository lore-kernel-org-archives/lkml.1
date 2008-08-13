Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYHMU03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYHMU03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYHMU0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:26:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861AbYHMU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:26:18 -0400
Date: Wed, 13 Aug 2008 13:25:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ebiederm@xmission.com, ying.huang@intel.com, pavel@ucw.cz,
       nigel@nigel.suspend2.net, rjw@sisk.pl, vgoyal@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
 0) in kernel_kexec()
Message-Id: <20080813132535.6cd4bab6.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808131310450.3462@nehalem.linux-foundation.org>
References: <1218618760.24951.137.camel@caritas-dev.intel.com>
	<alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org>
	<m1r68shjhb.fsf@frodo.ebiederm.org>
	<20080813124406.21091eae.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0808131247320.3462@nehalem.linux-foundation.org>
	<20080813130749.c406ab6c.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0808131310450.3462@nehalem.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 13:13:13 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Used a bitop to preserve the runtime checking in there.  spin_unlock()
> > doesn't return the previous lockedness.
> 
> Umm. spin_unlock does a lot more when you have lock debugging on, and 
> doesn't do useless crap when it isn't.
> 
> > A bitop seems a better fit to me.  We never spin on that lock (it
> > always uses test_and_set), so why use a "spin"lock?
> 
> ..because an atomic bitop is not the same as a lock.
> 
> The memory ordering guarantees are different. Yes, they are sufficient, 
> but that's because we've had to make them so to account for CRAP CODE that 
> uses bit operations as if they were locks.
> 
> Don't continue that. It's WRONG.

#2:

(The xchg(kexec_crash_image) stuff is still in there)

--- a/kernel/kexec.c~kexec-use-a-bitop-for-locking-rather-than-xchg
+++ a/kernel/kexec.c
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
+static DEFINE_SPINLOCK(kexec_lock);
 
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
+	if (!spin_trylock(&kexec_lock))
 		return -EBUSY;
 
 	dest_image = &kexec_image;
@@ -1015,8 +1009,7 @@ asmlinkage long sys_kexec_load(unsigned 
 	image = xchg(dest_image, image);
 
 out:
-	locked = xchg(&kexec_lock, 0); /* Release the mutex */
-	BUG_ON(!locked);
+	spin_unlock(&kexec_lock);
 	kimage_free(image);
 
 	return result;
@@ -1063,9 +1056,6 @@ asmlinkage long compat_sys_kexec_load(un
 
 void crash_kexec(struct pt_regs *regs)
 {
-	int locked;
-
-
 	/* Take the kexec_lock here to prevent sys_kexec_load
 	 * running on one cpu from replacing the crash kernel
 	 * we are using after a panic on a different cpu.
@@ -1074,8 +1064,7 @@ void crash_kexec(struct pt_regs *regs)
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
 	 */
-	locked = xchg(&kexec_lock, 1);
-	if (!locked) {
+	if (spin_trylock(&kexec_lock)) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 			crash_setup_regs(&fixed_regs, regs);
@@ -1083,8 +1072,7 @@ void crash_kexec(struct pt_regs *regs)
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
-		locked = xchg(&kexec_lock, 0);
-		BUG_ON(!locked);
+		spin_unlock(&kexec_lock);
 	}
 }
 
@@ -1434,7 +1422,7 @@ int kernel_kexec(void)
 {
 	int error = 0;
 
-	if (xchg(&kexec_lock, 1))
+	if (!spin_trylock(&kexec_lock))
 		return -EBUSY;
 	if (!kexec_image) {
 		error = -EINVAL;
@@ -1498,8 +1486,6 @@ int kernel_kexec(void)
 #endif
 
  Unlock:
-	if (!xchg(&kexec_lock, 0))
-		BUG();
-
+	spin_unlock(&kexec_lock);
 	return error;
 }
_


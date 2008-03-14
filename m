Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbYCNXaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbYCNXaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbYCNXaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:30:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48970 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbYCNXaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:30:03 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
From: Dave Hansen <haveblue@us.ibm.com>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>, Linus Torvalds <torvalds@osdl.org>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>
In-Reply-To: <47DB013D.3060102@tremplin-utc.net>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>
	 <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>
	 <1205525184.12763.32.camel@nimitz.home.sr71.net>
	 <47DAE55C.3080506@tremplin-utc.net>
	 <1205530551.8167.20.camel@nimitz.home.sr71.net>
	 <47DB013D.3060102@tremplin-utc.net>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 16:29:55 -0700
Message-Id: <1205537395.8167.31.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 23:50 +0100, Eric Piel wrote:
> > It'd be a shame to have to have "super_early_fs_initcall()" logic for
> > every part of the VFS or any other initcall for that matter that you
> > might need.  How do we tell all future VFS hackers that they have to do
> > this so that the next guy doesn't break it?  I certainly missed it. :)
> Well, my point was that actually populate_rootfs() does _very_ little 
> with regard to FS manipulation, acpi_find_dsdt_initrd() even less. The 
> task of checking that everything needed is available beforehand is 
> certainly not the same magnitude as the one of the Danaides as you 
> seemed to implied ;-)

The problem is defining how much "very little" is, and making sure that
all the other kernel developers agree with you on it.

Anyway, I'm sick of too much bitching and too little coding.  Andrew,
here's a patch for -mm that will at least shut up the spinlock warnings.
Al, you'll also need something similar to this for when you get Linus to
pull your git tree that has the r/o bind mount patches. 
It's a hack, but I don't know any better way to do it until the ACPI
mess gets cleaned up.

Arjan, is there a way to statically set lockdep classes for a spinlock
that I'm missing?

I'll leave it to everyone else to describe the evils of calling into
*any* fs code before the fs initcalls have been made. 

-- Dave


I'm not happy with this patch, but I don't see an easier way
to do it.  We can't statically initialize the lockdep classes
as far as I can see.

---

 linux-2.6.git-dave/fs/namespace.c        |    3 +--
 linux-2.6.git-dave/include/linux/mount.h |    1 +
 linux-2.6.git-dave/init/main.c           |    8 ++++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~robind-statically-initialize-locks fs/namei.c
diff -puN fs/namespace.c~robind-statically-initialize-locks fs/namespace.c
--- linux-2.6.git/fs/namespace.c~robind-statically-initialize-locks	2008-03-14 16:12:44.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2008-03-14 16:16:43.000000000 -0700
@@ -158,7 +158,7 @@ struct mnt_writer {
 } ____cacheline_aligned_in_smp;
 static DEFINE_PER_CPU(struct mnt_writer, mnt_writers);
 
-static int __init init_mnt_writers(void)
+int __init init_mnt_writers(void)
 {
 	int cpu;
 	for_each_possible_cpu(cpu) {
@@ -169,7 +169,6 @@ static int __init init_mnt_writers(void)
 	}
 	return 0;
 }
-fs_initcall(init_mnt_writers);
 
 static void unlock_mnt_writers(void)
 {
diff -puN init/main.c~robind-statically-initialize-locks init/main.c
--- linux-2.6.git/init/main.c~robind-statically-initialize-locks	2008-03-14 16:13:02.000000000 -0700
+++ linux-2.6.git-dave/init/main.c	2008-03-14 16:17:33.000000000 -0700
@@ -58,6 +58,7 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
+#include <linux/mount.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -650,6 +651,13 @@ asmlinkage void __init start_kernel(void
 
 	check_bugs();
 
+	/*
+	 * This is a horrible hack.  The ACPI code needs
+	 * to learn how to do "DSDT override" without fs
+	 * access or do it later in boot - Dave Hansen
+	 */
+	init_mnt_writers();
+
 	populate_rootfs(); /* For DSDT override from initramfs */
 	acpi_early_init(); /* before LAPIC and SMP init */
 
diff -puN include/linux/mount.h~robind-statically-initialize-locks include/linux/mount.h
--- linux-2.6.git/include/linux/mount.h~robind-statically-initialize-locks	2008-03-14 16:16:04.000000000 -0700
+++ linux-2.6.git-dave/include/linux/mount.h	2008-03-14 16:16:34.000000000 -0700
@@ -79,6 +79,7 @@ static inline struct vfsmount *mntget(st
 	return mnt;
 }
 
+extern int init_mnt_writers(void);
 extern int mnt_want_write(struct vfsmount *mnt);
 extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mntput_no_expire(struct vfsmount *mnt);
_



Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbYCESDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbYCESDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYCESC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:02:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698AbYCESC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:02:58 -0500
Date: Wed, 5 Mar 2008 10:02:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - PROFILE_LIKELY redux..
Message-Id: <20080305100221.1d7316e6.akpm@linux-foundation.org>
In-Reply-To: <p738x0x5al2.fsf@bingen.suse.de>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<4911.1204701694@turing-police.cc.vt.edu>
	<p738x0x5al2.fsf@bingen.suse.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 18:45:13 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> Valdis.Kletnieks@vt.edu writes:
> >
> > So we're in the same 4K as the VDSO64_* values, but some 0x4fe past the
> > gtod_data.  Anybody got a hint as to what the heck it was doing?
> 
> Try this patch:
> 
> Remove unlikelies in vsyscall path
> 
> Remove unlikely in vsyscall path that conflict with unlikely profiling.
> The unlikelies shouldn't be needed anyways because gcc predicts
> condition leading to early return as unlikely by default and
> for the loops it shouldn't make much difference
> 
> --- linux.orig/arch/x86/kernel/vsyscall_64.c
> +++ linux/arch/x86/kernel/vsyscall_64.c
> ...
> --- linux.orig/arch/x86/vdso/vclock_gettime.c
> +++ linux/arch/x86/vdso/vclock_gettime.c

Yes, but both those files now have:

/*
 * likely and unlikely explode when used in vdso in combination with
 * profile-likely-unlikely-macros.patch
 */
#undef likely
#define likely(x) (x)
#undef unlikely
#define unlikely(x) (x)

at the top, so it'll be something else.  Perhaps a `likely' snuck in via an
inline in a header file.  It would be better to add a #define DONT_DO_THAT
at the top of arch/x86/kernel/vsyscall_64.c and
arch/x86/vdso/vclock_gettime.c, then use that to defeat likely-profiling.

 arch/x86/kernel/vsyscall_64.c  |   11 ++---------
 arch/x86/vdso/vclock_gettime.c |   11 ++---------
 include/linux/compiler.h       |    3 ++-
 3 files changed, 6 insertions(+), 19 deletions(-)

diff -puN arch/x86/kernel/vsyscall_64.c~profile-likely-unlikely-macros-fix arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c~profile-likely-unlikely-macros-fix
+++ a/arch/x86/kernel/vsyscall_64.c
@@ -17,6 +17,8 @@
  *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
  */
 
+#define SUPPRESS_LIKELY_PROFILING
+
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -46,15 +48,6 @@
 #define __syscall_clobber "r11","cx","memory"
 
 /*
- * likely and unlikely explode when used in vdso in combination with
- * profile-likely-unlikely-macros.patch
- */
-#undef likely
-#define likely(x) (x)
-#undef unlikely
-#define unlikely(x) (x)
-
-/*
  * vsyscall_gtod_data contains data that is :
  * - readonly from vsyscalls
  * - written by timer interrupt or systcl (/proc/sys/kernel/vsyscall64)
diff -puN arch/x86/vdso/vclock_gettime.c~profile-likely-unlikely-macros-fix arch/x86/vdso/vclock_gettime.c
--- a/arch/x86/vdso/vclock_gettime.c~profile-likely-unlikely-macros-fix
+++ a/arch/x86/vdso/vclock_gettime.c
@@ -9,6 +9,8 @@
  * Also alternative() doesn't work.
  */
 
+#define SUPPRESS_LIKELY_PROFILING
+
 #include <linux/kernel.h>
 #include <linux/posix-timers.h>
 #include <linux/time.h>
@@ -23,15 +25,6 @@
 
 #define gtod vdso_vsyscall_gtod_data
 
-/*
- * likely and unlikely explode when used in vdso in combination with
- * profile-likely-unlikely-macros.patch
- */
-#undef likely
-#define likely(x) (x)
-#undef unlikely
-#define unlikely(x) (x)
-
 static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
diff -puN include/linux/compiler.h~profile-likely-unlikely-macros-fix include/linux/compiler.h
--- a/include/linux/compiler.h~profile-likely-unlikely-macros-fix
+++ a/include/linux/compiler.h
@@ -51,7 +51,8 @@ extern void __chk_io_ptr(const volatile 
 # include <linux/compiler-intel.h>
 #endif
 
-#if defined(CONFIG_PROFILE_LIKELY) && !(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
+#if defined(CONFIG_PROFILE_LIKELY) && !defined(SUPPRESS_LIKELY_PROFILING) && \
+	!(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
 struct likeliness {
 	const char *func;
 	char *file;
_


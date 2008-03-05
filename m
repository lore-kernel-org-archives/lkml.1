Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbYCERpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbYCERpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbYCERpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:45:17 -0500
Received: from mx1.suse.de ([195.135.220.2]:33227 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbYCERpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:45:16 -0500
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - PROFILE_LIKELY redux..
From: Andi Kleen <andi@firstfloor.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<4911.1204701694@turing-police.cc.vt.edu>
Date: Wed, 05 Mar 2008 18:45:13 +0100
In-Reply-To: <4911.1204701694@turing-police.cc.vt.edu> (Valdis Kletnieks's message of "Wed\, 05 Mar 2008 02\:21\:34 -0500")
Message-ID: <p738x0x5al2.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:
>
> So we're in the same 4K as the VDSO64_* values, but some 0x4fe past the
> gtod_data.  Anybody got a hint as to what the heck it was doing?

Try this patch:

Remove unlikelies in vsyscall path

Remove unlikely in vsyscall path that conflict with unlikely profiling.
The unlikelies shouldn't be needed anyways because gcc predicts
condition leading to early return as unlikely by default and
for the loops it shouldn't make much difference

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux.orig/arch/x86/kernel/vsyscall_64.c
+++ linux/arch/x86/kernel/vsyscall_64.c
@@ -128,7 +128,7 @@ static __always_inline void do_vgettimeo
 		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
 
 		vread = __vsyscall_gtod_data.clock.vread;
-		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
+		if (!__vsyscall_gtod_data.sysctl_enabled || !vread) {
 			gettimeofday(tv,NULL);
 			return;
 		}
@@ -169,7 +169,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 {
 	struct timeval tv;
 	time_t result;
-	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
+	if (!__vsyscall_gtod_data.sysctl_enabled)
 		return time_syscall(t);
 
 	vgettimeofday(&tv, NULL);
Index: linux/arch/x86/vdso/vclock_gettime.c
===================================================================
--- linux.orig/arch/x86/vdso/vclock_gettime.c
+++ linux/arch/x86/vdso/vclock_gettime.c
@@ -48,7 +48,7 @@ static noinline int do_realtime(struct t
 		ts->tv_sec = gtod->wall_time_sec;
 		ts->tv_nsec = gtod->wall_time_nsec;
 		ns = vgetns();
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (read_seqretry(&gtod->lock, seq));
 	timespec_add_ns(ts, ns);
 	return 0;
 }
@@ -77,7 +77,7 @@ static noinline int do_monotonic(struct 
 		ns = gtod->wall_time_nsec + vgetns();
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (read_seqretry(&gtod->lock, seq));
 	vset_normalized_timespec(ts, secs, ns);
 	return 0;
 }
@@ -105,7 +105,7 @@ int __vdso_gettimeofday(struct timeval *
 			     sizeof(*tv) != sizeof(struct timespec));
 		do_realtime((struct timespec *)tv);
 		tv->tv_usec /= 1000;
-		if (unlikely(tz != NULL)) {
+		if (tz != NULL) {
 			/* This relies on gcc inlining the memcpy. We'll notice
 			   if it ever fails to do so. */
 			memcpy(tz, &gtod->sys_tz, sizeof(struct timezone));

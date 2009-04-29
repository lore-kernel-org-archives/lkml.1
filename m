Return-Path: <linux-kernel-owner+w=401wt.eu-S1760616AbZD2UcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbZD2UcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZD2UcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:32:05 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:29331 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbZD2UcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:32:04 -0400
From: John Wright <john.wright@hp.com>
To: x86 Maintainers <x86@kernel.org>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, John Wright <john.wright@hp.com>
Subject: [PATCH] x86: gettimeofday() vDSO: fix segfault when tv == NULL
Date: Wed, 29 Apr 2009 14:32:01 -0600
Message-Id: <1241037121-14805-1-git-send-email-john.wright@hp.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the gettimeofday(2) manual:

       If either tv or tz is NULL, the corresponding structure is not
       set or returned.

Since it is legal to give NULL as the tv argument, the code should make
sure tv is not NULL before trying to dereference it.

This issue manifests itself on x86_64 when vdso=0 is not on the kernel
command-line and libc uses the vDSO for gettimeofday() (e.g. glibc >=
2.7).  A simple reproducer:

  #include <stdio.h>
  #include <sys/time.h>

  int main(void)
  {
      struct timezone tz;

      gettimeofday(NULL, &tz);

      return 0;
  }

See http://bugs.debian.org/466491 for more details.

Signed-off-by: John Wright <john.wright@hp.com>
---
 arch/x86/vdso/vclock_gettime.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index d9d3582..6a40b78 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -104,11 +104,13 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
 	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
-		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
-			     offsetof(struct timespec, tv_nsec) ||
-			     sizeof(*tv) != sizeof(struct timespec));
-		do_realtime((struct timespec *)tv);
-		tv->tv_usec /= 1000;
+		if (likely(tv != NULL)) {
+			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
+				     offsetof(struct timespec, tv_nsec) ||
+				     sizeof(*tv) != sizeof(struct timespec));
+			do_realtime((struct timespec *)tv);
+			tv->tv_usec /= 1000;
+		}
 		if (unlikely(tz != NULL)) {
 			/* Avoid memcpy. Some old compilers fail to inline it */
 			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
-- 
1.6.2.3


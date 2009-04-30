Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbZD3KkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbZD3KkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 06:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZD3KkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 06:40:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:60396 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbZD3KkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 06:40:09 -0400
Date: Thu, 30 Apr 2009 10:39:30 GMT
From: tip-bot for John Wright <john.wright@hp.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       john.wright@hp.com, tglx@linutronix.de, ak@suse.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       john.wright@hp.com, tglx@linutronix.de, ak@suse.de, mingo@elte.hu
In-Reply-To: <1241037121-14805-1-git-send-email-john.wright@hp.com>
References: <1241037121-14805-1-git-send-email-john.wright@hp.com>
Subject: [tip:x86/urgent] x86: gettimeofday() vDSO: fix segfault when tv == NULL
Message-ID: <tip-2f65dd475c6a8a997145ea83cc3d2d5e6dc55af1@git.kernel.org>
Git-Commit-ID: 2f65dd475c6a8a997145ea83cc3d2d5e6dc55af1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 10:39:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f65dd475c6a8a997145ea83cc3d2d5e6dc55af1
Gitweb:     http://git.kernel.org/tip/2f65dd475c6a8a997145ea83cc3d2d5e6dc55af1
Author:     John Wright <john.wright@hp.com>
AuthorDate: Wed, 29 Apr 2009 14:32:01 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Apr 2009 12:31:45 +0200

x86: gettimeofday() vDSO: fix segfault when tv == NULL

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

[ Impact: fix gettimeofday(NULL, &tz) segfault ]

Signed-off-by: John Wright <john.wright@hp.com>
Cc: Andi Kleen <ak@suse.de>
Cc: John Wright <john.wright@hp.com>
LKML-Reference: <1241037121-14805-1-git-send-email-john.wright@hp.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYBEFS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYBEFS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYBEFSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:18:45 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:35236 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYBEFSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:18:45 -0500
Date: Tue, 5 Feb 2008 16:16:48 +1100
To: Sripathi Kodi <sripathik@in.ibm.com>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       john stultz <johnstul@us.ibm.com>
Subject: [PATCH] [POWERPC] Use a sensible default for clock_getres() in the vdso.
Message-ID: <20080205051648.GX6887@bakeyournoodle.com>
References: <200801271932.59823.sripathik@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801271932.59823.sripathik@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 07:32:59PM +0530, Sripathi Kodi wrote:
> Hi Paul,
> 
> On PPC, I see a disparity between clock_getres implementations in the
> vdso and syscall. I am using a IBM Openpower hardware and 2.6.24 kernel
> with CONFIG_HIGH_RES_TIMERS=y. 
> 
> clock_getres call for CLOCK_REALTIME returns 1 millisecond. However,
> when I edit arch/powerpc/kernel/vdso*/gettimeofday.S to force it to use 
> sys_clock_getres, I get 1 nanosecond resolution. The code in vdso seems
> to be returning some pre-defined (incorrect) variables.
> 
> Could you please let me know the reason for this? Is it something that
> should be fixed in vdso?

Can you try the attached patch and see it if works for you?

From: Tony Breeds <tony@bakeyournoodle.com>
Subject: [PATCH] [POWERPC] Use a sensible default for clock_getres() in the vdso.

This ensures that the syscall and the (fast) vdso versions of clock_getres()
will return the same resolution.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 arch/powerpc/kernel/asm-offsets.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index ed083fe..e6e4928 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -22,6 +22,7 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/suspend.h>
+#include <linux/hrtimer.h>
 #ifdef CONFIG_PPC64
 #include <linux/time.h>
 #include <linux/hardirq.h>
@@ -312,7 +313,7 @@ int main(void)
 	DEFINE(CLOCK_REALTIME, CLOCK_REALTIME);
 	DEFINE(CLOCK_MONOTONIC, CLOCK_MONOTONIC);
 	DEFINE(NSEC_PER_SEC, NSEC_PER_SEC);
-	DEFINE(CLOCK_REALTIME_RES, TICK_NSEC);
+	DEFINE(CLOCK_REALTIME_RES, (KTIME_MONOTONIC_RES).tv64);
 
 #ifdef CONFIG_BUG
 	DEFINE(BUG_ENTRY_SIZE, sizeof(struct bug_entry));
-- 
1.5.4


Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!


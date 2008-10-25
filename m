Return-Path: <linux-kernel-owner+w=401wt.eu-S1751969AbYJYTrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbYJYTrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 15:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYJYTre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 15:47:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:43061 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYJYTre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 15:47:34 -0400
Date: Sat, 25 Oct 2008 12:47:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.com
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, tglx@tglx.de, mingo@elte.hu
Subject: [PATCH] select: deal with math overflow from borderline valid
 userland data
Message-ID: <20081025124747.5de4d8e7@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please apply this patch, it fixes a regression in 2.6.28-rc1.



>From fdaacc0a980f5d323a21610f7f75b2e92470172e Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 25 Oct 2008 12:41:41 -0700
Subject: [PATCH] select: deal with math overflow from borderline valid userland data

Some userland apps seem to pass in a "0" for the seconds, and several
seconds worth of usecs to select(). The old kernels accepted this just
fine, so the new kernels must too.
However, due to the upscaling of the microseconds to nanoseconds we had
some cases where we got math overflow, and depending on the GCC version
(due to inlining decisions) that actually resulted in an -EINVAL return.

This patch fixes this by adding the excess microseconds to the seconds field.

Also with thanks to Marcin Slusarz for spotting some implementation bugs
in the diagnostics patches.

Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/compat.c |    5 +++--
 fs/select.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index fe3c9bf..1510879 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1684,8 +1684,9 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 			return -EFAULT;
 
 		to = &end_time;
-		if (poll_select_set_timeout(to, tv.tv_sec,
-					    tv.tv_usec * NSEC_PER_USEC))
+		if (poll_select_set_timeout(to, 
+				tv.tv_sec + (tv.tv_usec / USEC_PER_SEC),
+				(tv.tv_usec % USEC_PER_SEC) * NSEC_PER_USEC))
 			return -EINVAL;
 	}
 
diff --git a/fs/select.c b/fs/select.c
index 448e440..7fc3124 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -519,8 +519,9 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 			return -EFAULT;
 
 		to = &end_time;
-		if (poll_select_set_timeout(to, tv.tv_sec,
-					    tv.tv_usec * NSEC_PER_USEC))
+		if (poll_select_set_timeout(to, 
+				tv.tv_sec + (tv.tv_usec / USEC_PER_SEC),
+				(tv.tv_usec % USEC_PER_SEC) * NSEC_PER_USEC))
 			return -EINVAL;
 	}
 
-- 
1.5.6.5


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

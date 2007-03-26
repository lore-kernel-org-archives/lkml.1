Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbXCZPWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbXCZPWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXCZPWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:22:30 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33933 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXCZPW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:22:29 -0400
Date: Mon, 26 Mar 2007 17:21:19 +0200
From: Pierre Peiffer <Pierre.Peiffer@bull.net>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, drepper@redhat.com, jean-pierre.dion@bull.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm] Fix: timeout not passed anymore to futex_lock_pi
Message-Id: <20070326172119.a7c38bcd.Pierre.Peiffer@bull.net>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/03/2007 17:24:30,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/03/2007 17:24:35,
	Serialize complete at 26/03/2007 17:24:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a fix for a bug introduced by the patch
make-futex_wait-use-an-hrtimer-for-timeout.patch : the timeout value
is not passed anymore to futex_lock_pi.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>

---
 kernel/futex.c        |    8 ++++++--
 kernel/futex_compat.c |    4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

Index: b/kernel/futex.c
===================================================================
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2383,8 +2383,10 @@ sys_futex64(u64 __user *uaddr, int op, u
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
+
+		t = timespec_to_ktime(ts);
 		if (op == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), timespec_to_ktime(ts));
+			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
 	/*
@@ -2413,8 +2415,10 @@ asmlinkage long sys_futex(u32 __user *ua
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
+
+		t = timespec_to_ktime(ts);
 		if (op == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), timespec_to_ktime(ts));
+			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
 	/*
Index: b/kernel/futex_compat.c
===================================================================
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -150,8 +150,10 @@ asmlinkage long compat_sys_futex(u32 __u
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
+
+		t = timespec_to_ktime(ts);
 		if (op == FUTEX_WAIT)
-			t = ktime_add(ktime_get(), timespec_to_ktime(ts));
+			t = ktime_add(ktime_get(), t);
 		tp = &t;
 	}
 	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE


-- 
Pierre Peiffer

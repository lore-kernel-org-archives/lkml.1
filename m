Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbXLHDJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbXLHDJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 22:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbXLHDIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 22:08:15 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:7817 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753362AbXLHDIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 22:08:12 -0500
Message-Id: <20071208025623.144225546@mvista.com>
References: <20071208025620.470633411@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 07 Dec 2007 00:00:03 -0800
Subject: [PATCH 3/4] mcheck mce_64: mce_read_sem to mutex
References: <20071208025608.631609481@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
Content-Disposition: inline; filename=mcheck_semaphore-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted to a mutex, and changed the name to mce_read_mutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>


---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.23/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux-2.6.23.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux-2.6.23/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -564,7 +564,7 @@ static ssize_t mce_read(struct file *fil
 			loff_t *off)
 {
 	unsigned long *cpu_tsc;
-	static DECLARE_MUTEX(mce_read_sem);
+	static DEFINE_MUTEX(mce_read_mutex);
 	unsigned next;
 	char __user *buf = ubuf;
 	int i, err;
@@ -573,12 +573,12 @@ static ssize_t mce_read(struct file *fil
 	if (!cpu_tsc)
 		return -ENOMEM;
 
-	down(&mce_read_sem);
+	mutex_lock(&mce_read_mutex);
 	next = rcu_dereference(mcelog.next);
 
 	/* Only supports full reads right now */
 	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
-		up(&mce_read_sem);
+		mutex_unlock(&mce_read_mutex);
 		kfree(cpu_tsc);
 		return -EINVAL;
 	}
@@ -621,7 +621,7 @@ static ssize_t mce_read(struct file *fil
 			memset(&mcelog.entry[i], 0, sizeof(struct mce));
 		}
 	}
-	up(&mce_read_sem);
+	mutex_unlock(&mce_read_mutex);
 	kfree(cpu_tsc);
 	return err ? -EFAULT : buf - ubuf;
 }

-- 

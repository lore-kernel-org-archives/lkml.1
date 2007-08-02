Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbXHBNxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbXHBNxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbXHBNxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:53:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:20032 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXHBNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=Er3qpvNdVIOrNOmK54/9ssWuhYfwa+M5ORr8ub3C70i9zVF3vBGmD4LoZxnqVohHBkCjnFW1Y+zlneh6e22OC27w0qtEW8jhalXoli+Xt7BSekjW0RHz+Uti6q5lcAn8gQl5yK6tuoB5IlyLSkvOAmzS13mWPfrecnLnyXZiX5s=
Message-ID: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com>
Date: Thu, 2 Aug 2007 15:53:13 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: dd72f6a7d4030619
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Resent with different recipients as nagar@watson.ibm.com bounced with
a User unknown]

Hi,

This patch adds all thread accounting stats for the global tgid stats.
As a shameless plug, this fixes iotop -P (http://guichaz.free.fr/misc/iotop.py).

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

diff -r 22708012ca6e kernel/taskstats.c
--- a/kernel/taskstats.c	Tue Jul 31 21:12:07 2007 -0700
+++ b/kernel/taskstats.c	Wed Aug 01 17:43:54 2007 +0200
@@ -233,6 +233,7 @@ static int fill_tgid(pid_t tgid, struct
 		memset(stats, 0, sizeof(*stats));

 	tsk = first;
+	bacct_add_tsk(stats, first);
 	do {
 		if (tsk->exit_state)
 			continue;
@@ -246,6 +247,7 @@ static int fill_tgid(pid_t tgid, struct

 		stats->nvcsw += tsk->nvcsw;
 		stats->nivcsw += tsk->nivcsw;
+		xacct_add_tsk(stats, tsk);
 	} while_each_thread(first, tsk);

 	unlock_task_sighand(first, &flags);
diff -r 22708012ca6e kernel/tsacct.c
--- a/kernel/tsacct.c	Tue Jul 31 21:12:07 2007 -0700
+++ b/kernel/tsacct.c	Wed Aug 01 17:41:40 2007 +0200
@@ -81,8 +81,8 @@ void xacct_add_tsk(struct taskstats *sta
 	struct mm_struct *mm;

 	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
+	stats->coremem += jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem += jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
@@ -90,18 +90,14 @@ void xacct_add_tsk(struct taskstats *sta
 		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
 		mmput(mm);
 	}
-	stats->read_char	= p->rchar;
-	stats->write_char	= p->wchar;
-	stats->read_syscalls	= p->syscr;
-	stats->write_syscalls	= p->syscw;
+	stats->read_char	+= p->rchar;
+	stats->write_char	+= p->wchar;
+	stats->read_syscalls	+= p->syscr;
+	stats->write_syscalls	+= p->syscw;
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	stats->read_bytes	= p->ioac.read_bytes;
-	stats->write_bytes	= p->ioac.write_bytes;
-	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
-#else
-	stats->read_bytes	= 0;
-	stats->write_bytes	= 0;
-	stats->cancelled_write_bytes = 0;
+	stats->read_bytes	+= p->ioac.read_bytes;
+	stats->write_bytes	+= p->ioac.write_bytes;
+	stats->cancelled_write_bytes += p->ioac.cancelled_write_bytes;
 #endif
 }
 #undef KB

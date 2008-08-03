Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYHCDF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYHCDF5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYHCDAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:00:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbYHCDAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rH82acHsm5DICbH4D0kjBYnMGlXZHlgZocG6hr0lac7r8FYsB3x12Cm8Rq17J5YnzU
         BnGsYJXfi3sXiXWoTfjkpfFkErBwx2VXMJCP1S3L5TUVzCbRsY4fq8UOWaj6TAAKg+s9
         6laIf4sMKnQOKwbzgIS7ecAJvYXUtILF4Pqd4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 16/25] drivers proc to use nr_irqs
Date: Sat,  2 Aug 2008 19:59:16 -0700
Message-Id: <1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-5-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-7-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 fs/proc/proc_misc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index ded9698..1968251 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -503,7 +503,7 @@ static int show_stat(struct seq_file *p, void *v)
 	struct timespec boottime;
 	unsigned int *per_irq_sum;
 
-	per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);
+	per_irq_sum = kzalloc(sizeof(unsigned int)*nr_irqs, GFP_KERNEL);
 	if (!per_irq_sum)
 		return -ENOMEM;
 
@@ -525,7 +525,7 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for (j = 0; j < NR_IRQS; j++) {
+		for (j = 0; j < nr_irqs; j++) {
 			unsigned int temp = kstat_cpu(i).irqs[j];
 			sum += temp;
 			per_irq_sum[j] += temp;
@@ -571,7 +571,7 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		seq_printf(p, " %u", per_irq_sum[i]);
 
 	seq_printf(p,
@@ -625,13 +625,13 @@ static const struct file_operations proc_stat_operations = {
  */
 static void *int_seq_start(struct seq_file *f, loff_t *pos)
 {
-	return (*pos <= NR_IRQS) ? pos : NULL;
+	return (*pos <= nr_irqs) ? pos : NULL;
 }
 
 static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
 	(*pos)++;
-	if (*pos > NR_IRQS)
+	if (*pos > nr_irqs)
 		return NULL;
 	return pos;
 }
-- 
1.5.4.5


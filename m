Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbYLPIXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbYLPIXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYLPIXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:23:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbYLPIXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:23:38 -0500
Date: Tue, 16 Dec 2008 00:22:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [mmotm][PATCH] proc: enclose desc variable of show_stat() in
 CONFIG_SPARSE_IRQ
Message-Id: <20081216002247.100bc362.akpm@linux-foundation.org>
In-Reply-To: <20081216165758.DBB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081216165758.DBB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 17:00:30 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Applied after: linux-next.patch
> ==
> commit 240d367b4e6c6e3c5075e034db14dba60a6f5fa7 moved desc usage point into
> #ifdef CONFIG_SPARSE_IRQ.
> Then, variable declaration also shold be enclosed. otherwise following warning happend.
> 
> fs/proc/stat.c: In function 'show_stat':
> fs/proc/stat.c:31: warning: unused variable 'desc'
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yinghai Lu <yinghai@kernel.org>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  fs/proc/stat.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: b/fs/proc/stat.c
> ===================================================================
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -28,7 +28,9 @@ static int show_stat(struct seq_file *p,
>  	u64 sum_softirq = 0;
>  	struct timespec boottime;
>  	unsigned int per_irq_sum;
> +#ifdef CONFIG_SPARSE_IRQ
>  	struct irq_desc *desc;
> +#endif
>  
>  	user = nice = system = idle = iowait =
>  		irq = softirq = steal = cputime64_zero;
> 

This would be better, no?

--- a/fs/proc/stat.c~proc-enclose-desc-variable-of-show_stat-in-config_sparse_irq
+++ a/fs/proc/stat.c
@@ -28,7 +28,6 @@ static int show_stat(struct seq_file *p,
 	u64 sum_softirq = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
-	struct irq_desc *desc;
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;
@@ -48,8 +47,7 @@ static int show_stat(struct seq_file *p,
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		for_each_irq_nr(j) {
 #ifdef CONFIG_SPARSE_IRQ
-			desc = irq_to_desc(j);
-			if (!desc)
+			if (!irq_to_desc(j))
 				continue;
 #endif
 			sum += kstat_irqs_cpu(j, i);
@@ -103,8 +101,7 @@ static int show_stat(struct seq_file *p,
 	for_each_irq_nr(j) {
 		per_irq_sum = 0;
 #ifdef CONFIG_SPARSE_IRQ
-		desc = irq_to_desc(j);
-		if (!desc) {
+		if (!irq_to_desc(j)) {
 			seq_printf(p, " %u", per_irq_sum);
 			continue;
 		}
_


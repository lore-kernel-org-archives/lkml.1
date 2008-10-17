Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYJQK6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYJQK6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYJQK6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:58:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYJQK6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:58:07 -0400
Subject: Re: [PATCH] sched: fix the wrong mask_len
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: miaox@cn.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1224239584.28131.85.camel@twins>
References: <48F8664A.2000205@cn.fujitsu.com>
	 <20081017192505.E242.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1224239584.28131.85.camel@twins>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 12:58:19 +0200
Message-Id: <1224241099.28131.88.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 12:33 +0200, Peter Zijlstra wrote:
> On Fri, 2008-10-17 at 19:25 +0900, KOSAKI Motohiro wrote:
> > > If the NR_CPUS isn't a multiple of 32, we get a truncated string of sched
> > > domains by catting /proc/schedstat. This is caused by the wrong mask_len.
> > > 
> > > This patch fix it.
> > > 
> > > Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> > > 
> > > ---
> > >  kernel/sched_stats.h |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
> > > index 8385d43..81365b3 100644
> > > --- a/kernel/sched_stats.h
> > > +++ b/kernel/sched_stats.h
> > > @@ -9,7 +9,7 @@
> > >  static int show_schedstat(struct seq_file *seq, void *v)
> > >  {
> > >  	int cpu;
> > > -	int mask_len = NR_CPUS/32 * 9;
> > > +	int mask_len = (NR_CPUS/32 + 1) * 9;
> > >  	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
> > >  
> > 
> > DIV_ROUND_UP() is better?
> 
> Agreed


---
Subject: sched: fix the wrong mask_len
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Oct 17 12:55:57 CEST 2008

If the NR_CPUS isn't a multiple of 32, we get a truncated string of sched
domains by catting /proc/schedstat. This is caused by the wrong mask_len.

Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_stats.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_stats.h
===================================================================
--- linux-2.6.orig/kernel/sched_stats.h
+++ linux-2.6/kernel/sched_stats.h
@@ -9,7 +9,7 @@
 static int show_schedstat(struct seq_file *seq, void *v)
 {
 	int cpu;
-	int mask_len = NR_CPUS/32 * 9;
+	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
 	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
 
 	if (mask_str == NULL)



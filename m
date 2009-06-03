Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZFCE44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZFCE44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZFCE4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:56:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbZFCE4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:56:48 -0400
Date: Tue, 2 Jun 2009 21:56:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: mmotm 2009-06-02-16-11 uploaded (staging)
Message-Id: <20090602215637.c582d66f.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0906022132490.26434@chino.kir.corp.google.com>
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org>
	<4A25F814.7030101@oracle.com>
	<alpine.DEB.2.00.0906022132490.26434@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009 21:45:15 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Tue, 2 Jun 2009, Randy Dunlap wrote:
> 
> > drivers/staging/android/lowmemorykiller.c:106: error: 'struct task_struct' has no member named 'oomkilladj'
> > 
> 
> Thanks Randy.
> 
> This is due to oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch 
> which was merged in mmotm early this morning.
> 
> I had previously fixed this in an earlier version of the patch series, but 
> people didn't agree that an oom killer change should touch staging files 
> even though the Android lowmemorykiller is in both mmotm and git HEAD.  
> See http://marc.info/?l=linux-kernel&m=124200164711314.
> 
> I'm still a little curious about why it was decided like that since it 
> seems to be the simplest way to avoid these failures, which leave you with 
> a broken build, and an unnecessary burden on maintainers to magically fix 
> them up later (which I guess is now?).
> 
> So when I moved oomkilladj from struct task_struct to struct mm_struct and 
> renamed it to something more appropriate, I still think I should have been 
> able to change drivers/staging/android/lowmemorykiller.c for those 
> reasons and avoid all of this hassle.
> 
> Anyway, here's a patch that should work and will hopefully now be 
> accepted.  I know Greg is the maintainer for the staging tree and we're 
> talking about mmotm, but I don't know how else to do it anymore.

I think there's been a miscommunication somewhere.  Fixing the fallout
from a kernel-core change within the same patch is the correct thing to
do.

> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -96,19 +96,21 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>  
>  	read_lock(&tasklist_lock);
>  	for_each_process(p) {
> +		struct mm_struct *mm;
>  		int oom_adj;
>  
>  		task_lock(p);
> -		if (!p->mm) {
> +		mm = p->mm;
> +		if (!mm) {
>  			task_unlock(p);
>  			continue;
>  		}
> -		oom_adj = p->oomkilladj;
> +		oom_adj = mm->oom_adj;
>  		if (oom_adj < min_adj) {
>  			task_unlock(p);
>  			continue;
>  		}
> -		tasksize = get_mm_rss(p->mm);
> +		tasksize = get_mm_rss(mm);
>  		task_unlock(p);
>  		if (tasksize <= 0)
>  			continue;

Thanks.

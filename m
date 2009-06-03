Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbZFCPFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbZFCPFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbZFCPEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:04:54 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:36748 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZFCPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:04:42 -0400
Message-ID: <4A2691AD.9080105@oracle.com>
Date: Wed, 03 Jun 2009 08:07:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: mmotm 2009-06-02-16-11 uploaded (staging)
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org> <4A25F814.7030101@oracle.com> <alpine.DEB.2.00.0906022132490.26434@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0906022132490.26434@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A2690F0.0223:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Tue, 2 Jun 2009, Randy Dunlap wrote:
> 
>> drivers/staging/android/lowmemorykiller.c:106: error: 'struct task_struct' has no member named 'oomkilladj'
>>
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

Ack, that works.  Thanks.

> ---
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


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/

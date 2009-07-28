Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZG1VB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZG1VB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZG1VB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:01:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62316 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZG1VBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:01:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wyUoBC/0oVd1lEeUSrm3ySAhmCQmhUkFac/YTYNmJS7c3v4wDDos8LNWrod2dcmM9
	RZF+Q9EMRG9LFPK0RQMbw==
Date: Tue, 28 Jul 2009 14:01:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Moussa A. Ba" <moussa.a.ba@gmail.com>
cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>, Ying Han <yinghan@google.com>,
       Nick Piggin <npiggin@suse.de>, jaredeh@gmail.com
Subject: Re: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped
 vma clearing
In-Reply-To: <4A6F2AF4.6050505@gmail.com>
Message-ID: <alpine.DEB.2.00.0907281401150.7140@chino.kir.corp.google.com>
References: <4A693122.6060503@gmail.com> <20090724083926.GA6372@cr0.nay.redhat.com> <4A6E0BD6.50102@gmail.com> <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com> <7928e7bd0907271514y699d1de4j54f9c562b94ef0cc@mail.gmail.com>
 <alpine.DEB.2.00.0907271543420.23587@chino.kir.corp.google.com> <7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com> <alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com> <4A6F2AF4.6050505@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009, Moussa A. Ba wrote:

> --- a/fs/proc/task_mmu.c	2009-07-21 14:30:01.000000000 -0700
> +++ b/fs/proc/task_mmu.c	2009-07-27 17:05:25.000000000 -0700
> @@ -462,6 +462,10 @@ static int clear_refs_pte_range(pmd_t *
>  	return 0;
>  }
> 
> +#define CLEAR_REFS_ALL 1
> +#define CLEAR_REFS_ANON 2
> +#define CLEAR_REFS_MAPPED 3
> +
>  static ssize_t clear_refs_write(struct file *file, const char __user * buf,
>  				size_t count, loff_t * ppos)
>  {
> @@ -469,13 +473,15 @@ static ssize_t clear_refs_write(struct f
>  	char buffer[PROC_NUMBUF], *end;
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> +	int type;
> 
>  	memset(buffer, 0, sizeof(buffer));
>  	if (count > sizeof(buffer) - 1)
>  		count = sizeof(buffer) - 1;
>  	if (copy_from_user(buffer, buf, count))
>  		return -EFAULT;
> -	if (!simple_strtol(buffer, &end, 0))
> +	type = simple_strtol(buffer, &end, 0);
> +	if (!type || type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
>  		return -EINVAL;
>  	if (*end == '\n')
>  		end++;

The test for type < CLEAR_REFS_ALL covers !type.

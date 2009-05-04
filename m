Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZEDXNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZEDXNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZEDXNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:13:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZEDXNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:13:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=r6ON5W3XJZQR7d72iMmgCd5nhu5+ACwxuX4dkd00fmvBUYeSu8CEyoz8dXxNG6eI9
	GnKdUbobN2KrGOLbhiAJQ==
Date: Mon, 4 May 2009 16:12:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <greg@kroah.com>
cc: =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
In-Reply-To: <20090504225936.GA9876@kroah.com>
Message-ID: <alpine.DEB.2.00.0905041607170.6073@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com> <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com> <20090504220905.GA29402@kroah.com> <alpine.DEB.2.00.0905041529570.2310@chino.kir.corp.google.com>
 <20090504225936.GA9876@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Greg KH wrote:

> > This patch in the series is really more of a convenience than anything 
> > else since it doesn't change anything functionally.  I had to modify the 
> > lowmemorykiller later because there's a potential for a NULL pointer from 
> > dereferencing p->mm without holding task_lock(p) and also because I moved 
> > oomkilladj from struct task_struct to struct mm_struct.
> 
> Is this still the case on top of Arve's changes?
> 

Yeah, the first of two patches Arve just sent is broken:

> @@ -71,23 +71,30 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
>  	}
>  	if(nr_to_scan > 0)
>  		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
> +	rem = global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
> +	if (nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
> +		lowmem_print(5, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
> +		return rem;
> +	}
> +
>  	read_lock(&tasklist_lock);
>  	for_each_process(p) {
> -		if(p->oomkilladj >= 0 && p->mm) {
> -			tasksize = get_mm_rss(p->mm);
> -			if(nr_to_scan > 0 && tasksize > 0 && p->oomkilladj >= min_adj) {
> -				if(selected == NULL ||
> -				   p->oomkilladj > selected->oomkilladj ||
> -				   (p->oomkilladj == selected->oomkilladj &&
> -				    tasksize > selected_tasksize)) {
> -					selected = p;
> -					selected_tasksize = tasksize;
> -					lowmem_print(2, "select %d (%s), adj %d, size %d, to kill\n",
> -					             p->pid, p->comm, p->oomkilladj, tasksize);
> -				}
> -			}
> -			rem += tasksize;
> +		if (p->oomkilladj < min_adj || !p->mm)
> +			continue;
> +		tasksize = get_mm_rss(p->mm);

You can't do that without holding task_lock(p).

> Right now, people are still arguing that the android low memory driver
> is not needed, but something is, yet no one has proposed a viable
> solution for all parties :(
> 

There was an interest in a low mem userspace notifier that applications 
can poll() on at configurable low mem levels to react accordingly.  This 
would probably address the problem that the Android team is trying to fix.

Regardless, my patchset includes two fixes for current bugs in the oom 
killer: a possible NULL pointer when /proc/sys/vm/oom_dump_tasks is 
enabled and a possible livelock when killing a task that shares memory 
with an OOM_DISABLE task.  I'm not really interested in seeing who can get 
their patches into the staging tree first, I'm more concerned about fixing 
the oom killer.

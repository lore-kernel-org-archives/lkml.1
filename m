Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078Ab0A3Sin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0A3Sin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864Ab0A3Sin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:38:43 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39107 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0A3Sim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:38:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JW+DqOxSDHKqN+RnqsWeEh7Vb+m2dhvs06NX6sQN9gQqVm582w7EXlYZgNE/J6ATe7
         g4HZBI0J+k8uC1Te7+VTRgpHqW8jCQpsgkiNWM4y16PbuZn67mAoBhN2E8ItAaEboapi
         m8MGhFqYq+ccXEnQfxjU9aWWbD1vNoasvYLDQ=
Date: Sat, 30 Jan 2010 19:38:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mahesh Salgaonkar <mahesh@linux.vnet.in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin <schwidefsky@de.ibm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: Re: [patch] HWBKPT: Make bp_len type to u64 generic across the arch
Message-ID: <20100130183835.GA5675@nowhere>
References: <20100130045424.625452081@mars.in.ibm.com> <20100130045518.GA20776@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100130045518.GA20776@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 10:25:18AM +0530, Mahesh Salgaonkar wrote:
> 
> Change 'bp_len' type to __u64 to make it work across the arch.
> The s390 architecture watch point length can be upto 2^64.
> 
> reference:
> 	http://lkml.org/lkml/2010/1/25/212
> 
> Based on commit 6aa41f8b01301199af6c9febb24f3c1f5a0bc9d5
> 
> Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> ---
> 
>  include/linux/hw_breakpoint.h |    2 +-
>  include/linux/perf_event.h    |    6 ++----
>  kernel/hw_breakpoint.c        |    2 +-
>  kernel/perf_event.c           |    2 +-
>  4 files changed, 5 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
> index 41235c9..76e7427 100644
> --- a/include/linux/hw_breakpoint.h
> +++ b/include/linux/hw_breakpoint.h
> @@ -44,7 +44,7 @@ static inline int hw_breakpoint_type(struct perf_event *bp)
>  	return bp->attr.bp_type;
>  }
>  
> -static inline int hw_breakpoint_len(struct perf_event *bp)
> +static inline unsigned long hw_breakpoint_len(struct perf_event *bp)
>  {
>  	return bp->attr.bp_len;
>  }



This should return a u64, or gcc will warn us about loosing
informations in 32 bits arch?



> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 1438463..30c78bd 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -211,11 +211,9 @@ struct perf_event_attr {
>  		__u32		wakeup_watermark; /* bytes before wakeup   */
>  	};
>  
> -	__u32			__reserved_2;
> -
> -	__u64			bp_addr;
>  	__u32			bp_type;
> -	__u32			bp_len;
> +	__u64			bp_addr;
> +	__u64			bp_len;
>  };



Peter, what do you think about this new layout?
Putting the bp_type right after the wakeup_* fields
is going to remove the padding difference between
64 and 32 archs. That looks better than the __reserved_2
we had.

If this patch can make it for .33, it would be nice.



>  
>  /*
> diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
> index 50dbd59..a1f511f 100644
> --- a/kernel/hw_breakpoint.c
> +++ b/kernel/hw_breakpoint.c
> @@ -324,8 +324,8 @@ EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
>  int modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr)
>  {
>  	u64 old_addr = bp->attr.bp_addr;
> +	u64 old_len = bp->attr.bp_len;
>  	int old_type = bp->attr.bp_type;
> -	int old_len = bp->attr.bp_len;
>  	int err = 0;
>  
>  	perf_event_disable(bp);
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 8f8f7aa..1473cc9 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4720,7 +4720,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
>  	if (attr->type >= PERF_TYPE_MAX)
>  		return -EINVAL;
>  
> -	if (attr->__reserved_1 || attr->__reserved_2)
> +	if (attr->__reserved_1)
>  		return -EINVAL;
>  
>  	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
> 


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


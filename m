Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZHaJEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZHaJEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 05:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZHaJEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 05:04:09 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53820 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZHaJEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 05:04:08 -0400
Date: Mon, 31 Aug 2009 18:04:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] kmemleak: Inform kmemleak about kernel stack allocation
Message-ID: <20090831090406.GA29228@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com> <20090827170253.27901.33997.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827170253.27901.33997.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 06:02:53PM +0100, Catalin Marinas wrote:
> Traversing all the tasks in the system for scanning the kernel stacks
> requires locking which increases the kernel latency considerably. This
> patch informs kmemleak about newly allocated or freed stacks so that
> they are treated as any other allocated object. Subsequent patch will
> remove the explicit stack scanning from mm/kmemleak.c.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  arch/x86/include/asm/thread_info.h |    7 ++++++-
>  arch/x86/kernel/process.c          |    2 ++
>  kernel/fork.c                      |    7 ++++++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> index fad7d40..f26432a 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -162,7 +162,12 @@ struct thread_info {
>  #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
>  
>  #define alloc_thread_info(tsk)						\
> -	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
> +({									\
> +	struct thread_info *ti = (struct thread_info *)			\
> +		__get_free_pages(THREAD_FLAGS, THREAD_ORDER);		\
> +	kmemleak_alloc(ti, THREAD_SIZE, 1, THREAD_FLAGS);		\
> +	ti;								\
> +})
>
This looks like something that every __HAVE_ARCH_THREAD_INFO_ALLOCATOR
user is going to want to implement. Does it make sense to make this
addition prior to your removal of explicit scanning, or should folks hold
off on this until later in 2.6.32? In any event, this would probably be
worthwhile Cc'ing linux-arch on if you are posting an updated version,
given that there are 9 other architectures that will probably want to do
this, too. 

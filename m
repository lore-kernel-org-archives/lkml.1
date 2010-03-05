Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab0CETwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:52:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:54549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab0CETwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:52:46 -0500
Message-ID: <4B9160BF.3060104@kernel.org>
Date: Fri, 05 Mar 2010 11:51:27 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: do not free zero sized per cpu areas
References: <4B914A61.20409@kernel.org> <1267818583-5627-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1267818583-5627-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 11:49 AM, Ian Campbell wrote:
> This avoids an infinite loop in free_early_partial().
> 
> Add a warning to free_early_partial to catch future problems.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/setup_percpu.c |    3 ++-
>  kernel/early_res.c             |    5 +++++
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
> index ef6370b..89a3205 100644
> --- a/arch/x86/kernel/setup_percpu.c
> +++ b/arch/x86/kernel/setup_percpu.c
> @@ -140,7 +140,8 @@ static void __init pcpu_fc_free(void *ptr, size_t size)
>  #ifdef CONFIG_NO_BOOTMEM
>  	u64 start = __pa(ptr);
>  	u64 end = start + size;
> -	free_early_partial(start, end);
> +	if (start < end)
> +		free_early_partial(start, end);
>  #else
>  	free_bootmem(__pa(ptr), size);
>  #endif
> diff --git a/kernel/early_res.c b/kernel/early_res.c
> index 3cb2c66..f3a861b 100644
> --- a/kernel/early_res.c
> +++ b/kernel/early_res.c
> @@ -333,6 +333,11 @@ void __init free_early_partial(u64 start, u64 end)
>  	struct early_res *r;
>  	int i;
>  
> +	if (WARN_ONCE(start >= end,
> +		      "free_early_partial got wrong start/end %#llx/%#llx\n",
> +		      start, end))
> +		return;
> +
>  try_next:
>  	i = find_overlapped_early(start, end);
>  	if (i >= max_early_res)

Acked-by: Yinghai Lu <yinghai@kernel.org>

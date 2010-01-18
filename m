Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573Ab0ARQlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab0ARQlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639Ab0ARQlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:41:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:54283 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0ARQle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eXgQE+er+9Q/pDz9nmW30V4k3qTt6h/+t22oXUVMOcY8yCYI3/+kQ5O27uiQiRZulC
         inmS8O4rM6rHXW+Chyz4Hq0H/qd4c/IPddh4sK6w5rwqZ+TamoOPszw8dW7B4wYhdY5x
         CUxKyYqQ+F2rcbQDo5u66rlhN6Q5ZcK8FnJrA=
Date: Mon, 18 Jan 2010 17:41:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf_event: fix race in
	perf_swevent_get_recursion_context()
Message-ID: <20100118164128.GI10364@nowhere>
References: <4B54654A.4090601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B54654A.4090601@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 09:42:34PM +0800, Xiao Guangrong wrote:
> It only disable preemption in perf_swevent_get_recursion_context()
> it can't avoid race of hard-irq and NMI
> 
> In this patch, we use atomic operation to avoid it and reduce
> cpu_ctx->recursion size, it also make this patch no need diable
> preemption
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>



I don't understand what is racy in what we have currently.



>  int perf_swevent_get_recursion_context(void)
>  {
> -	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
> +	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
>  	int rctx;
>  
>  	if (in_nmi())
> @@ -3933,13 +3933,8 @@ int perf_swevent_get_recursion_context(void)
>  	else
>  		rctx = 0;
>  
> -	if (cpuctx->recursion[rctx]) {
> -		put_cpu_var(perf_cpu_context);
> +	if (test_and_set_bit(rctx, &cpuctx->recursion))
>  		return -1;



This looks broken. We don't call back perf_swevent_put_recursion_context
in fail case, so the bit won't ever be cleared once we recurse.


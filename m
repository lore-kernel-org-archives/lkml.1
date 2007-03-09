Return-Path: <linux-kernel-owner+w=401wt.eu-S1767248AbXCINHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767248AbXCINHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767273AbXCINHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:07:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:48177 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767248AbXCINHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:07:21 -0500
Subject: Re: [PATCH] Fix atomicity of TIF update in flush_thread() for
	powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, mbligh@google.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
In-Reply-To: <20070309024525.GB9462@Krystal>
References: <20070309024525.GB9462@Krystal>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:06:39 +0100
Message-Id: <1173445599.24454.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 .../...

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Nice catch !

> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -476,8 +476,13 @@ void flush_thread(void)
>  #ifdef CONFIG_PPC64
>  	struct thread_info *t = current_thread_info();
>  
> -	if (t->flags & _TIF_ABI_PENDING)
> -		t->flags ^= (_TIF_ABI_PENDING | _TIF_32BIT);
> +	if (test_tsk_thread_flag(tsk, TIF_ABI_PENDING)) {
> +		clear_tsk_thread_flag(tsk, TIF_ABI_PENDING);
> +		if (test_tsk_thread_flag(tsk, TIF_32BIT))
> +			clear_tsk_thread_flag(tsk, TIF_32BIT);
> +		else
> +			set_tsk_thread_flag(tsk, TIF_32BIT);
> +	}
>  #endif
>  
>  	discard_lazy_cpu_state();


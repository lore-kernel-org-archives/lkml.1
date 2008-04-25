Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbYDYIY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbYDYIY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbYDYIYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:24:38 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:51923 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760669AbYDYIYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:24:35 -0400
Subject: Re: [git pull] scheduler/misc fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, tglx@linutronix.de
In-Reply-To: <20080425.005738.114887644.davem@davemloft.net>
References: <20080424225530.GA8717@elte.hu>
	 <20080424.204620.88617191.davem@davemloft.net>
	 <1209109710.7115.400.camel@twins>
	 <20080425.005738.114887644.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 10:24:18 +0200
Message-Id: <1209111858.7115.405.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 00:57 -0700, David Miller wrote:

> diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
> index 524b889..bf4ef84 100644
> --- a/arch/sparc64/kernel/smp.c
> +++ b/arch/sparc64/kernel/smp.c
> @@ -866,14 +866,21 @@ void smp_call_function_client(int irq, struct pt_regs *regs)
>  	void *info = call_data->info;
>  
>  	clear_softint(1 << irq);
> +
> +	irq_enter();
> +
> +	if (!call_data->wait) {
> +		/* let initiator proceed after getting data */
> +		atomic_inc(&call_data->finished);
> +	}
> +
> +	func(info);
> +
> +	irq_exit();
> +
>  	if (call_data->wait) {
>  		/* let initiator proceed only after completion */
> -		func(info);
> -		atomic_inc(&call_data->finished);
> -	} else {
> -		/* let initiator proceed after getting data */
>  		atomic_inc(&call_data->finished);
> -		func(info);
>  	}
>  }


FWIW I do think this is a valid 'bug' fix in that the called user func()
can now see its from interrupt context. in_interrupt() would have
reported false due to the missing irq_enter()/irq_exit() - not sure if
any smp_call_function() relies on it though.




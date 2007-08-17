Return-Path: <linux-kernel-owner+w=401wt.eu-S1764174AbXHQM7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764174AbXHQM7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 08:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759049AbXHQM7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 08:59:43 -0400
Received: from il.qumranet.com ([82.166.9.18]:59439 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbXHQM7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 08:59:43 -0400
Message-ID: <46C59BBD.6050204@qumranet.com>
Date: Fri, 17 Aug 2007 15:59:41 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH/RFC 3/4,	second shot]Introduce "account_guest_time"
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>		<46C4725A.4070607@bull.net> <46C4740F.2050701@bull.net>		<1187303955.6449.7.camel@localhost.localdomain>	<46C54FB8.7050504@bull.net>	<1187339450.6449.115.camel@localhost.localdomain>	<46C56774.2030009@bull.net> <46C58BD5.3090207@bull.net>
In-Reply-To: <46C58BD5.3090207@bull.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Fri, 17 Aug 2007 15:59:41 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> This is another way to compute guest time... I remove the "account modifiers"
> mechanism and call directly account_guest_time() from account_system_time().
> account_system_time() computes user, system and guest times according value
> accumulated in vtime (a ktime_t) in task_struct by the virtual machine.
>   


> @@ -3246,6 +3277,10 @@
>  	struct rq *rq = this_rq();
>  	cputime64_t tmp;
>  
> +#ifdef CONFIG_GUEST_ACCOUNTING
> +	cputime = account_guest_time(p, cputime);
> +#endif
> +
>  	p->stime = cputime_add(p->stime, cputime);
>  
>  	/* Add system time to cpustat. */


In order to reduce the impact on whatever function this is in (use diff
-p please), you can always have a definition of account_guest_time:

#else

static cputime_t account_guest_time(struct task_struct *p, cputime_t cputime)
{
        return cputime;
}

#endif


This way the #ifdef/#endif is not necessary when calling it.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


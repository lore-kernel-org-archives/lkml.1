Return-Path: <linux-kernel-owner+w=401wt.eu-S934775AbXKPCow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775AbXKPCow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbXKPCol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:44:41 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:36979 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662AbXKPCok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:44:40 -0500
Message-ID: <473D03CB.4020409@cosmosbay.com>
Date: Fri, 16 Nov 2007 03:43:23 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv2 1/4] actual sys_indirect code
References: <200711151822.lAFIMVxP028587@devserv.devel.redhat.com>
In-Reply-To: <200711151822.lAFIMVxP028587@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 16 Nov 2007 03:43:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> This is the actual architecture-independent part of the system call
> implementation.
> 

> +
> +long sys_indirect(struct indirect_registers __user *userregs,
> +		  void __user *userparams, size_t paramslen)
> +{
> +	struct indirect_registers regs;
> +	long result;
> +
> +	if (copy_from_user(&regs, userregs, sizeof(regs)))
> +		return -EFAULT;
> +
> +	switch (INDIRECT_SYSCALL (&regs))
> +	{
> +#ifdef __NR_accept
> +	case __NR_accept:
> +#endif
> +#ifdef __NR_socketpair
> +	case __NR_socketpair:
> +#endif
> +#ifdef __NR_socket
> +	case __NR_socket:
> +#endif
> +#ifdef __NR_socketcall
> +	case __NR_socketcall:
> +#endif
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (paramslen > sizeof(union indirect_params))
> +		return -EINVAL;
> +	if (copy_from_user(&current->indirect_params, userparams, paramslen))

Here, you should clear current->indirect_params before returning -EFAULT
                 {
                 memset(&current->indirect_params, 0, paramslen);
> +		return -EFAULT;
                 }
copy_from_user could do a partial copy (so dirty first bytes of 
indirect_params) and all furthers calls to socket()/open() and so on could be 
broken.

> +
> +	result = CALL_INDIRECT(&regs);
> +
> +	memset(&current->indirect_params, '\0', paramslen);
> +
> +	return result;
> +}
> -


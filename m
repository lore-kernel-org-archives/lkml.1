Return-Path: <linux-kernel-owner+w=401wt.eu-S965941AbXGSTXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965941AbXGSTXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXGSTWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:22:53 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56861 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbXGSTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:22:52 -0400
Message-ID: <469FB9FC.4050005@us.ibm.com>
Date: Thu, 19 Jul 2007 12:22:36 -0700
From: "David J. Wilder" <wilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Fix a use after free bug in kernel->userspace relay file
 support
References: <200707182311.10538.jesper.juhl@gmail.com>
In-Reply-To: <200707182311.10538.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK
Thanks for catching this. Your patch looks fine. I tested for 
regression, no problems. I also tested the error path and had the 
expected results.
Thanks
Dave

Jesper Juhl wrote:
> Hi,
>
> Coverity spotted what looks like a real possible case of using a 
> variable after it has been freed.
> The problem is in kernel/relay.c::relay_open_buf()
>
> If the code hits "goto free_buf;" it ends up in this code :
>
>   free_buf:
>     	relay_destroy_buf(buf);	<--- calls kfree() on 'buf'.
>   free_name:
>    	kfree(tmpname);
>   end:
>   	return buf;		<-- use after free of 'buf'.
>
> I read through the callers and they all handle a NULL return 
> from this function as an error (and hitting the 'free_buf' label 
> only happens on failure to chan->cb->create_buf_file(), so that 
> looks like a clear error to me). 
>
> The patch simply sets 'buf' to NULL after the call to 
> relay_destroy_buf(buf); - as far as I can see that should take 
> care of the problem.
>
> The patch also corrects a reference to a documentation file while 
> I was at it.
>
> Warning: I don't know this code at all and I've only read through 
> it quickly to try and work out what to do here, so I'd really 
> apreciate it if someone who actually knows how this code should 
> behave could ACK or NACK the patch before it gets merged anywhere 
> since I did this pretty blind.
>
> Patch has been compile tested only.
>
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
>
> diff --git a/kernel/relay.c b/kernel/relay.c
> index a615a8f..c55e399 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -1,7 +1,7 @@
>  /*
>   * Public API and common code for kernel->userspace relay file support.
>   *
> - * See Documentation/filesystems/relayfs.txt for an overview of relayfs.
> + * See Documentation/filesystems/relay.txt for an overview.
>   *
>   * Copyright (C) 2002-2005 - Tom Zanussi (zanussi@us.ibm.com), IBM Corp
>   * Copyright (C) 1999-2005 - Karim Yaghmour (karim@opersys.com)
> @@ -427,6 +427,7 @@ static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
>
>  free_buf:
>   	relay_destroy_buf(buf);
> + 	buf = NULL;
>  free_name:
>   	kfree(tmpname);
>  end:
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   


Return-Path: <linux-kernel-owner+w=401wt.eu-S965322AbXGSTh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322AbXGSTh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940108AbXGSThG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:37:06 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:33139 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932190AbXGSThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:37:01 -0400
Date: Thu, 19 Jul 2007 15:36:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Fix a use after free bug in kernel->userspace relay file support
Message-ID: <20070719193658.GA24942@Krystal>
References: <200707182311.10538.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200707182311.10538.jesper.juhl@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:33:32 up 2 days, 14:07,  3 users,  load average: 1.27, 1.36, 0.70
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesper Juhl (jesper.juhl@gmail.com) wrote:
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

Yes, the fix seems good. Thanks.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

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

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

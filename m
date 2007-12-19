Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXLSAMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXLSAMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXLSAMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:12:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbXLSAMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:12:05 -0500
Date: Tue, 18 Dec 2007 16:06:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org, matthltc@us.ibm.com, Nadia.Derbey@bull.net
Subject: Re: [RFC PATCH 1/2] Scaling msgmni to the system memory
Message-Id: <20071218160603.31888f29.akpm@linux-foundation.org>
In-Reply-To: <20071211154143.964066000@bull.net>
References: <20071211153845.766147000@bull.net>
	<20071211154143.964066000@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 16:38:46 +0100
Nadia.Derbey@bull.net wrote:

> [PATCH 01/02]
> 
> This patch computes msg_ctlmni to make it scale with system memory.
> msg_ctlmni is now set to make the message queues occupy 1/32 of the available
> memory.
> 
> Some cleaning has also been done in the MSGXXX constants:
>   . MSGPOOL: the msgctl man page says it's not used, but it also defines it as
>              a size in bytes (the code expresses it in Kbytes).
>   . MSGSEG definition has been removed since it used only once in msgctl().
> 

The objective seems reasonable.

> 
> ===================================================================
> --- linux-2.6.24-rc4.orig/include/linux/msg.h	2007-12-11 11:57:53.000000000 +0100
> +++ linux-2.6.24-rc4/include/linux/msg.h	2007-12-11 12:10:01.000000000 +0100
> @@ -49,17 +49,17 @@ struct msginfo {
>  	unsigned short  msgseg; 
>  };
>  
> +#define MSG_MEM_SCALE 32    /* Scaling factor to compute msgmni */
> +
>  #define MSGMNI    16   /* <= IPCMNI */     /* max # of msg queue identifiers */
>  #define MSGMAX  8192   /* <= INT_MAX */   /* max size of message (bytes) */
>  #define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
>  
>  /* unused */
> -#define MSGPOOL (MSGMNI*MSGMNB/1024)  /* size in kilobytes of message pool */
> +#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */
>  #define MSGTQL  MSGMNB            /* number of system message headers */
>  #define MSGMAP  MSGMNB            /* number of entries in message map */
>  #define MSGSSZ  16                /* message segment size */
> -#define __MSGSEG ((MSGPOOL*1024)/ MSGSSZ) /* max no. of segments */
> -#define MSGSEG (__MSGSEG <= 0xffff ? __MSGSEG : 0xffff)
>  
>  #ifdef __KERNEL__
>  #include <linux/list.h>
> Index: linux-2.6.24-rc4/ipc/msg.c
> ===================================================================
> --- linux-2.6.24-rc4.orig/ipc/msg.c	2007-12-11 11:57:58.000000000 +0100
> +++ linux-2.6.24-rc4/ipc/msg.c	2007-12-11 12:12:32.000000000 +0100
> @@ -27,6 +27,7 @@
>  #include <linux/msg.h>
>  #include <linux/spinlock.h>
>  #include <linux/init.h>
> +#include <linux/mm.h>
>  #include <linux/proc_fs.h>
>  #include <linux/list.h>
>  #include <linux/security.h>
> @@ -81,10 +82,25 @@ static int sysvipc_msg_proc_show(struct 
>  
>  static void __msg_init_ns(struct ipc_namespace *ns, struct ipc_ids *ids)
>  {
> +	struct sysinfo i;
> +	unsigned long allowed;
> +
>  	ns->ids[IPC_MSG_IDS] = ids;
>  	ns->msg_ctlmax = MSGMAX;
>  	ns->msg_ctlmnb = MSGMNB;
> -	ns->msg_ctlmni = MSGMNI;
> +
> +	/*
> +	 * Scale msgmni with the available memory size: the memory dedicated
> +	 * to msg queues should occupy 1/32 of the available memory:
> +	 * up to 8MB       : msgmni = 16 (MSGMNI)
> +	 * 4 GB            : msgmni = 8K
> +	 * more than 16 GB : msgmni = 32K (IPCMNI)
> +	 */
> +	si_meminfo(&i);
> +	allowed = ((i.totalram / MSG_MEM_SCALE) * i.mem_unit) / MSGMNB;
> +	ns->msg_ctlmni = min((unsigned long) IPCMNI,
> +			max((unsigned long) MSGMNI, allowed));

The space after the (typecast) isn't useful IMO.

Please use min_t rather than the open-coded casts.

Even better would be to sort out the types so that neither casts nor min_t
are needed.

What about highmem machines?  For those we usually want to scale data
structures according to the amount of direct-addressable memory (ie:
lowmem) rather than acording to total physical memory.  I haven't a clue
how this consideration would be addressed when ipc-namespaces is taken into
consideration.

I'd suggest the addition of a printk telling people what value the kernel
calculated.

We should ensure that the calculated value is never _less_ than what the
kernel was previously giving - to avoid breaking existing things.

It's a bit of a concern that a change like this can cause an application to
work OK on machine A but then fail when it is taken over to (smaller)
machine B.


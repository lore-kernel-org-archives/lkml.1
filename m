Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbZFWRBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbZFWRBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760664AbZFWRA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:00:57 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:27418 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760933AbZFWRAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:00:54 -0400
Message-ID: <4A410A02.5060008@oracle.com>
Date: Tue, 23 Jun 2009 09:59:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, avi@redhat.com,
       kvm@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A410A06.00AF:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> The following patch changes the eventfd interface to de-couple the eventfd 
> memory context, from the file pointer instance.
> Without such change, there is no clean way to racely free handle the 
> POLLHUP event sent when the last instance of the file* goes away.
> Also, now the internal eventfd APIs are using the eventfd context instead 
> of the file*.
> Another cleanup this patch does, is making AIO select EVENTFD, instead of 
> adding a bunch of empty function stubs inside eventfd.h.
> 
> Andrew, this better go via Avi and the KVM tree, since they have patches 
> that will be based on the new interface.
> 
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> 
> - Davide
> 
> 
> ---
>  drivers/lguest/lg.h          |    2 
>  drivers/lguest/lguest_user.c |    4 -
>  fs/aio.c                     |   24 ++--------
>  fs/eventfd.c                 |  101 ++++++++++++++++++++++++++++++++++++++-----
>  include/linux/aio.h          |    4 -
>  include/linux/eventfd.h      |   17 ++-----
>  init/Kconfig                 |    1 
>  7 files changed, 108 insertions(+), 45 deletions(-)
> 
> Index: linux-2.6.mod/fs/eventfd.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/eventfd.c	2009-06-21 16:54:15.000000000 -0700
> +++ linux-2.6.mod/fs/eventfd.c	2009-06-23 09:34:42.000000000 -0700
> @@ -17,32 +17,38 @@

> -/*
> - * Adds "n" to the eventfd counter "count". Returns "n" in case of
> - * success, or a value lower then "n" in case of coutner overflow.
> - * This function is supposed to be called by the kernel in paths
> - * that do not allow sleeping. In this function we allow the counter
> - * to reach the ULLONG_MAX value, and we signal this as overflow
> - * condition by returining a POLLERR to poll(2).
> +/**
> + * eventfd_signal - Adds @n to the eventfd counter. This function is
> + *                  supposed to be called by the kernel in paths that do not
> + *                  allow sleeping. In this function we allow the counter
> + *                  to reach the ULLONG_MAX value, and we signal this as
> + *                  overflow condition by returining a POLLERR to poll(2).
> + *

kernel-doc syntax requires the function name + short description on one line,
followed by parameters.  Any longer function description then comes after
the parameters.

See Documentation/kernel-doc-nano-HOWTO.txt for more info,
or ask me.

> + * @ctx: [in] Pointer to the eventfd context.
> + * @n: [in] Value of the counter to be added to the eventfd internal counter.
> + *
> + * Returns: In case of success, it returns @n, otherwise (in case of overflow
> + *          of the eventfd 64bit internal counter) a value lower than @n.
>   */
> -int eventfd_signal(struct file *file, int n)
> +int eventfd_signal(struct eventfd_ctx *ctx, int n)
>  {
> -	struct eventfd_ctx *ctx = file->private_data;
>  	unsigned long flags;
>  
>  	if (n < 0)

> +/**
> + * eventfd_ctx_put - Releases a reference to the internal eventfd context
> + *                   (previously acquired either with eventfd_ctx_get() or
> + *                   eventfd_ctx_fdget()).
> + *
> + * @ctx: [in] Pointer to eventfd context.
> + *
> + * Returns: Nothing.
> + */
> +void eventfd_ctx_put(struct eventfd_ctx *ctx)
> +{
> +	kref_put(&ctx->kref, eventfd_free);
> +}
> +EXPORT_SYMBOL_GPL(eventfd_ctx_put);
> +
>  static int eventfd_release(struct inode *inode, struct file *file)
>  {
> -	kfree(file->private_data);
> +	struct eventfd_ctx *ctx = file->private_data;
> +
> +	wake_up_poll(&ctx->wqh, POLLHUP);
> +	eventfd_ctx_put(ctx);
>  	return 0;
>  }

>  
> +/**
> + * eventfd_ctx_fdget - Acquires a reference to the internal eventfd context
> + *                     given an eventfd file descriptor.
> + *
> + * @fd: [in] Eventfd file descriptor.
> + *
> + * Returns: In case of success, it returns a pointer to the internal eventfd
> + *          context, otherwise a proper error code.
> + */
> +struct eventfd_ctx *eventfd_ctx_fdget(int fd)
> +{
> +	struct file *file;
> +	struct eventfd_ctx *ctx;
> +
> +	file = eventfd_fget(fd);
> +	if (IS_ERR(file))
> +		return (struct eventfd_ctx *) file;
> +	ctx = eventfd_ctx_get(file->private_data);
> +	fput(file);
> +
> +	return ctx;
> +}
> +EXPORT_SYMBOL_GPL(eventfd_ctx_fdget);


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/

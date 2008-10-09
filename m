Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbYJIToJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbYJIToJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYJITnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:43:55 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54284 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbYJITnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:43:55 -0400
Date: Thu, 9 Oct 2008 14:43:50 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       arnd@arndb.de
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
Message-ID: <20081009194350.GA31214@us.ibm.com>
References: <20081009190405.13A253CB@kernel> <20081009190406.1B257119@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009190406.1B257119@kernel>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> 
> These are just a few simple examples of things we know we can't
> checkpoint now.  There are plenty more, but this should give
> everyone an idea how this will look in practice.
> 
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/fs/aio.c     |    7 +++++++
>  linux-2.6.git-dave/ipc/mqueue.c |    3 +++
>  linux-2.6.git-dave/net/socket.c |    5 +++++
>  3 files changed, 15 insertions(+)
> 
> diff -puN fs/aio.c~no-checkpointing-for-sockets fs/aio.c
> --- linux-2.6.git/fs/aio.c~no-checkpointing-for-sockets	2008-10-09 11:56:58.000000000 -0700
> +++ linux-2.6.git-dave/fs/aio.c	2008-10-09 11:56:58.000000000 -0700
> @@ -19,6 +19,7 @@
> 
>  #define DEBUG 0
> 
> +#include <linux/checkpoint.h>
>  #include <linux/sched.h>
>  #include <linux/fs.h>
>  #include <linux/file.h>
> @@ -1663,6 +1664,8 @@ asmlinkage long sys_io_submit(aio_contex
>  	if (unlikely(!access_ok(VERIFY_READ, iocbpp, (nr*sizeof(*iocbpp)))))
>  		return -EFAULT;
> 
> +	process_deny_checkpointing(current);
> +
>  	ctx = lookup_ioctx(ctx_id);
>  	if (unlikely(!ctx)) {
>  		pr_debug("EINVAL: io_submit: invalid context id\n");
> @@ -1742,6 +1745,8 @@ asmlinkage long sys_io_cancel(aio_contex
>  	if (unlikely(!ctx))
>  		return -EINVAL;
> 
> +	process_deny_checkpointing(current);
> +
>  	spin_lock_irq(&ctx->ctx_lock);
>  	ret = -EAGAIN;
>  	kiocb = lookup_kiocb(ctx, iocb, key);
> @@ -1796,6 +1801,8 @@ asmlinkage long sys_io_getevents(aio_con
>  	struct kioctx *ioctx = lookup_ioctx(ctx_id);
>  	long ret = -EINVAL;
> 
> +	process_deny_checkpointing(current);

Hmm, I don't know too much about aio, but is it possible to succeed with
io_getevents if we didn't first do a submit?  It looks like the contexts
are looked up out of current->mm, so I don't think we need this call
here.

Otherwise, this is neat.

-serge

> +
>  	if (likely(ioctx)) {
>  		if (likely(min_nr <= nr && min_nr >= 0 && nr >= 0))
>  			ret = read_events(ioctx, min_nr, nr, events, timeout);
> diff -puN ipc/mqueue.c~no-checkpointing-for-sockets ipc/mqueue.c
> --- linux-2.6.git/ipc/mqueue.c~no-checkpointing-for-sockets	2008-10-09 11:56:58.000000000 -0700
> +++ linux-2.6.git-dave/ipc/mqueue.c	2008-10-09 11:56:58.000000000 -0700
> @@ -14,6 +14,7 @@
>   */
> 
>  #include <linux/capability.h>
> +#include <linux/checkpoint.h>
>  #include <linux/init.h>
>  #include <linux/pagemap.h>
>  #include <linux/file.h>
> @@ -655,6 +656,8 @@ asmlinkage long sys_mq_open(const char _
>  	char *name;
>  	int fd, error;
> 
> +	process_deny_checkpointing(current);
> +
>  	error = audit_mq_open(oflag, mode, u_attr);
>  	if (error != 0)
>  		return error;
> diff -puN net/socket.c~no-checkpointing-for-sockets net/socket.c
> --- linux-2.6.git/net/socket.c~no-checkpointing-for-sockets	2008-10-09 11:56:58.000000000 -0700
> +++ linux-2.6.git-dave/net/socket.c	2008-10-09 11:56:58.000000000 -0700
> @@ -87,6 +87,7 @@
>  #include <linux/audit.h>
>  #include <linux/wireless.h>
>  #include <linux/nsproxy.h>
> +#include <linux/checkpoint.h>
> 
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -1236,6 +1237,8 @@ asmlinkage long sys_socket(int family, i
>  	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
>  		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
> 
> +	process_deny_checkpointing(current);
> +
>  	retval = sock_create(family, type, protocol, &sock);
>  	if (retval < 0)
>  		goto out;
> @@ -2130,6 +2133,8 @@ asmlinkage long sys_socketcall(int call,
>  	a0 = a[0];
>  	a1 = a[1];
> 
> +	process_deny_checkpointing(current);
> +
>  	switch (call) {
>  	case SYS_SOCKET:
>  		err = sys_socket(a0, a1, a[2]);
> _
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

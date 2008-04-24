Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYDXWH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYDXWH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYDXWHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:07:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:16675 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYDXWHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:07:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=r9QVIJPvkyRNZKlEWdERSQOrp4epYRXy4Q1/YOPQ1FqUbHFqNaco09YysbB6gWi1EoDBNB8wDC0XiIY85bFWYIhRqNgoPUFmLfeoh1R6yKVkBACbXlNOkAPpqvGXjImhZzrQIN7NTV/au6Lsjqa8XLJLx0ZtSx35k9RLKjeaH0Y=
Date: Fri, 25 Apr 2008 03:02:38 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 34/37] LTTng instrumentation ipc
Message-ID: <20080424230238.GA11699@martell.zuzino.mipt.ru>
References: <20080424150324.802695381@polymtl.ca> <20080424151407.622943449@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424151407.622943449@polymtl.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 11:03:58AM -0400, Mathieu Desnoyers wrote:
> Interprocess communication, core events.
> 
> Added markers :
> 
> ipc_msg_create
> ipc_sem_create
> ipc_shm_create

> --- linux-2.6-lttng.orig/ipc/shm.c
> +++ linux-2.6-lttng/ipc/shm.c
> @@ -39,6 +39,7 @@
>  #include <linux/nsproxy.h>
>  #include <linux/mount.h>
>  #include <linux/ipc_namespace.h>
> +#include <linux/marker.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -482,6 +483,7 @@ asmlinkage long sys_shmget (key_t key, s
>  	struct ipc_namespace *ns;
>  	struct ipc_ops shm_ops;
>  	struct ipc_params shm_params;
> +	long err;
>  
>  	ns = current->nsproxy->ipc_ns;
>  
> @@ -493,7 +495,9 @@ asmlinkage long sys_shmget (key_t key, s
>  	shm_params.flg = shmflg;
>  	shm_params.u.size = size;
>  
> -	return ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
> +	err = ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
> +	trace_mark(ipc_shm_create, "id %ld flags %d", err, shmflg);
> +	return err;
>  }

OK, finally the meat of markers facility was posted and we can actually
see the end result. And the end result is unwieldy and limited.

Today I was debugging some SysV shmem stuff and only 0.5 of marker
above would be useful. I ended up with the following:

	rv = ipcget(...);
	if (rv < 0)
		printk("%s: rv = %d\n", __func__, rv);
	return rv;

because I knew app was doing a lot of shmget/IPC_RMID and only -E events
were interesting. The rest was inserted deeply in mm/shmem.c internals
which these patches avoid for some reason :^)

Can I write

	if (rv < 0)
		trace_mark(foo, "rv %d", rv);

		?

Looks like i could. But people want also want to see success, so what?
Two markers per exit?

	rv = ipc_get(...);
	if (rv < 0)
		trace_marker(foo_err, ...);
	trace_marker(foo_all, ...);


Also everything inserted so far is static. Sometimes only one bit in
mask is interesting and to save time to parse nibbles people do:

	printk("foo = %d\n", !!(mask & foo));

And interesting bits vary.

Again, all events aren't interesting:

	if (file && file->f_op == &shm_file_operations)
		printk("%s: file = %p: START\n", __func__, file);

Can I write this with markers?

And finally, if we are talking by debugging by printks (which to me, markers
essentially are), they come in generations: you insert some initial
stuff, get information, narrow search area, insert some more in places
that are dependent from what you've seen in step 1, and whoila, bug is
understood.

So what is proposed? Insert markers at places that look strategic? Feed
me with data I DO NOT care and DO NOT want to see?

mm/ patch is full if "file %p". Do you realize that pointers are
only sometimes interesting and sometimes you want dentry (not pointer,
but name!):

	printk("file = '%s'\n", file->f_dentry->d_name.name);

You seem to place _one_ marker at the very end of error path, but,
c'mon, information _which_ "goto" exactly came to the error path is
also interesting!

Should I preventively insert marker when writing new code?



So, let me say even more explicitly. Looking at proposed places elite
enough to be blessed with marker...

Those which are close enough to system call boundary are essentially
strace(1).

Markers are very visible and distract attention from real code.
Markers steal critical vertical space (80 x only _25_ ).

Markers fmt strings are unconditional and can't take prior information
about the problem into account.

Markers points won't be removed, only accumulated -- somebody _might_ be
interested in this information.

Developers want to see wildly different information. Marker is one for
everyone.

Said that, markers are lame and should be fully removed until too late.


P.S.: I probably miss some obvious things and look only from specific
debugging perspective. Let someone speak up from another angle. It's very
good moment now because ipc/ kernel/ mm/ net/ patches show CRYSTALLY CLEAR
the end result. (and futex patch earlier).


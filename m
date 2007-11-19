Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbXKSPnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbXKSPnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXKSPnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:43:32 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:43808 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbXKSPnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:43:31 -0500
Date: Mon, 19 Nov 2007 16:43:29 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
Message-Id: <20071119164329.5a580b84.dada1@cosmosbay.com>
In-Reply-To: <4741A7DD.1030407@redhat.com>
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com>
	<20071119145224.31ee5242.dada1@cosmosbay.com>
	<4741A7DD.1030407@redhat.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 07:12:29 -0800
Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Eric Dumazet wrote:
> >>   union indirect_params i;
> >>   i.file_flags.flags = O_CLOEXEC;
> > 
> > This setup forbids future addons to file_flags
> > 
> > In three years, when we want to add a new indirect feature to socket() 
> > call, do we need a new indirect2() syscall ?
> 
> No, it doesn't.  The setup is indefinitely expandable.
> 
> All you need to do, if it becomes necessary to have more than an int, is
> to define a little structure for the system call and then use it.  The
> only requirement is that the code has to assume a value of zero is what
> is used today.  That's the whole point.

Yes, this is what I understood.

> 
> union indirect_params {
>   struct {
>     int flags;
>   } file_flags;
>   struct {
>     int flags;
>     int new_syscall_data1;
>     sigset_t and_a_sigmask;
>   } new_data;
> };

Yes, so now, if you take this new definition of indirect_params,
its size is 12 bytes at least.

So when you recompile your old program (as you post it and as I commented on),
it will pass a >= 12 bytes data to kernel, with only first 4 bytes set to O_CLOEXEC.

Other bytes will contain junk (automatic variables are not set to 0 by compiler), 
and your program possibly break - if kernel socket() call was
extended to use new_data struct. (ie wanting O_CLOEXEC features +
 new ones with new_syscall_data1)

You have to take care of binary compatibility, but also that an old program
 (unaware of the new fields) will be re-compiled with new headers.

> 
> Old programs will set only the 'flags' member of 'new_data' while new
> once can also set the new elements.  New programs on old kernels will
> eithe have failing calls since the structure is too big or the call will
> not have all the desired effects.  The latter can be tested for.
> 
> 
> > Or better, you could avoid using 'union indirect_params' in user code, and 
> > only use the substructs for each function.
> 
> There is no overhead introduced through the union.  The only reason the
> union is there in the first place is to allocate sufficient data in
> task_struct to cover all cases.

Yes, sure, but it should be a kernel issue, not a user space one at all,
as long as user provides the size of the data he want to pass to kernel (
and your patch does this already)


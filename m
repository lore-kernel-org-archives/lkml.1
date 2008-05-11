Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbYEKT4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbYEKT4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYEKT4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:56:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:30561 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYEKT4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WikaNC7MLgG2ZtPGuMAmLEOau2r+4lm0Zn7zplrES0FRwm+C3zuwyCv6vGrgm06pq9I7Qt+jX2bX8vC0aSd4qE1/vb9PtddxoyxZzHc6TkgliW56mhmLJD1UPDujoE0FCT99d66CHFMI7vKaJxTq+uMpaLwDfYonFhJaUxqRboA=
Message-ID: <19f34abd0805111256q29055475leb329179034df20c@mail.gmail.com>
Date: Sun, 11 May 2008 21:56:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: Error in save_stack_trace() on x86_64?
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48274C9E.3020608@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0805110609lf3180dm3b1078e373983ad7@mail.gmail.com>
	 <48274C9E.3020608@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 9:44 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> Vegard Nossum wrote:
>
> > Hi,
> >
> > I am having a problem with v2.6.26-rc1 on x86_64. It seems that
> > save_stack_trace() is not able to follow page fault boundaries, since
> > all my saved traces look like this:
> >
> > RIP: 0010:[<ffffffff8039b004>]  [<ffffffff8039b004>]
> add_uevent_var+0xb4/0x160
> >    ...
> >  [<ffffffff80221f97>] kmemcheck_read+0x127/0x1e0
> >  [<ffffffff80222269>] kmemcheck_access+0x179/0x1d0
> >  [<ffffffff8022231f>] kmemcheck_fault+0x5f/0x80
> >  [<ffffffff8061cd1e>] do_page_fault+0x4de/0x8d0
> >  [<ffffffff8061a7d9>] error_exit+0x0/0x51
> >  [<ffffffffffffffff>] 0xffffffffffffffff
> >
> > I have this in my .config:
> >
> > CONFIG_STACKTRACE_SUPPORT=y
> > CONFIG_STACKTRACE=y
> > ...
> > CONFIG_FRAME_POINTER=y
> > ...
> > CONFIG_DEBUG_INFO=y
> >
> >
> > On 32-bit, I am able to see the calls leading up to the page fault as
> > well. Did I miss something here?
> >
>
>  can you give an example?

This is a similarly saved 32-bit backtrace:

 [<c0119101>] kmemcheck_read+0xd1/0x160
 [<c01192c6>] kmemcheck_access+0x136/0x1a0
 [<c04bb206>] do_page_fault+0x5e6/0x690
 [<c04b925a>] error_code+0x72/0x78
 [<c012d751>] sysctl_set_parent+0x21/0x40
 [<c012d751>] sysctl_set_parent+0x21/0x40
 [<c012d751>] sysctl_set_parent+0x21/0x40
 [<c012d751>] sysctl_set_parent+0x21/0x40
 [<c012e9c8>] __register_sysctl_paths+0xb8/0x120
 [<c0497cdf>] register_net_sysctl_table+0x4f/0x60
 [<c040ba36>] neigh_sysctl_register+0x1a6/0x290
 [<c0695734>] arp_init+0x54/0x60
 [<c0695ba7>] inet_init+0x107/0x340
 [<c066f5c7>] kernel_init+0x127/0x290
 [<c0104cc7>] kernel_thread_helper+0x7/0x10
 [<ffffffff>] 0xffffffff

>
>  if a pagefault happens in userspace this trace looks correct.

No, it is happening from kernel code. As you can see from the original
backtrace, the regs->ip (RIP) (regs taken from the very same
do_page_fault()) points at add_uevent_var, which is a kernel function.

>
>  if it happens in kernel space... I wonder if the separate exception stack
> thing
>  is hurting us with the stacks not being properly connected...
>  (but oopses and the like seem to come out just fine so I kinda doubt you're
> hitting that)
>

Thanks for looking into this.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

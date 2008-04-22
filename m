Return-Path: <linux-kernel-owner+w=401wt.eu-S1762929AbYDVTTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762929AbYDVTTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYDVTTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:19:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:17147 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYDVTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UnQE1B4yJiRHD6V4DhRcZJ//fOvNZ8bOHe1pQ1wnMnntyD83PIam47LjNWBQm6/XeThOtDxeg/p+V5u4B53ivmheK/AzaCo+bX5oGV5bfmuhXY8NwRSX3QOeeuhIhYSQ3z562ZOVM0YAsisuofPwOhNcUMutOlsxac+QMRwCYrE=
Message-ID: <ba7d8f720804221219wc1f04ecp3df0ec627dbc6c8e@mail.gmail.com>
Date: Tue, 22 Apr 2008 15:19:33 -0400
From: "Dan Upton" <upton.dan.linux@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: migration thread and active_load_balance
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0804211339h6220489dt94f4c982204d7a3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ba7d8f720804201121h6c024dcrabd301c8b4be7a4@mail.gmail.com>
	 <b647ffbd0804201426r3bb55daw2899f6045b78fa51@mail.gmail.com>
	 <ba7d8f720804201744m10cfa1b7n1a37b9d7c52b3622@mail.gmail.com>
	 <b647ffbd0804210403g1fe02f2pb653eafd704ad624@mail.gmail.com>
	 <ba7d8f720804211238q114c2ffal902e8b5e3dccd881@mail.gmail.com>
	 <b647ffbd0804211339h6220489dt94f4c982204d7a3d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 4:39 PM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> On 21/04/2008, Dan Upton <upton.dan.linux@gmail.com> wrote:
>  > On Mon, Apr 21, 2008 at 7:03 AM, Dmitry Adamushko
>  >
>  > <dmitry.adamushko@gmail.com> wrote:
>  >
>  > > On 21/04/2008, Dan Upton <upton.dan.linux@gmail.com> wrote:
>  >  >  > [ ... ]
>  >  >
>  >  > >
>  >  >  >  kernel BUG at kernel/sched.c:2103
>  >  >
>  >  >  and what's this line in your patched sched.c?
>  >  >
>  >  >  is it -- BUG_ON(!irqs_disabled());  ?
>  >  >
>  >  >  anything in your unposted code (e.g. find_coolest_cpu()) that might
>  >  >  re-enable the interrupts before __migration_task() is called?
>  >  >
>  >  >  If you post your modifications as a patch
>  >  >  (Documentation/applying-patches.txt) that contains _all_ relevant
>  >  >  modifications, it'd be easier to guess what's wrong.
>  >
>  >
>  > Yes, that's the line.  I don't recall ever reenabling interrupts,
>
>  migration_thread() -> find_coolest_cpu() -> get_temperature() ->
>  rdmsr_on_cpu() -> [ if your configuration is SMP ] ->
>  smp_call_function_single() ->
>
>  (arch/x86/kernel/smpcommon.c)
>  ...
>         if (cpu == me) {
>                 local_irq_disable();
>                 func(info);
>                 local_irq_enable();   <----------- REENABLES the interrupts
>                 put_cpu();
>                 return 0;
>         }
>  ...
>
>  as a result, __migrate_task() -> double_rq_lock() -> BUG_ON(!irqs_disabled())
>  gives you an "oops".
>

Ah, how about that.  Thanks, I at least fixed the oops by caching
return values from get_temperature() and then using those instead of
calling rdmsr_on_cpu when calling from migration_thread().  Everything
works up to the point of uncommenting the new call to
active_load_balance, which again yields a deadlock.  (Man, I love
working in the scheduler...) Anyway, I'll keep trying to debug that on
my own again, but did anybody notice anything I'm doing that might
lead to deadlock?

-dan

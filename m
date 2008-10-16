Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbYJPKjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbYJPKjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYJPKjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:39:40 -0400
Received: from ozlabs.org ([203.10.76.45]:53515 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYJPKjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:39:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH/RFC v2 0/6] Convert stop_machine to use a workqueue
Date: Thu, 16 Oct 2008 21:38:42 +1100
User-Agent: KMail/1.9.9
Cc: jens.axboe@oracle.com, mingo@elte.hu, akpm@linux-foundation.org,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
References: <20081013215007.634620563@de.ibm.com>
In-Reply-To: <20081013215007.634620563@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810162138.43304.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 October 2008 08:50:07 Heiko Carstens wrote:
> Version 2: This is version 2 which converts stop_machine to a workqueue
> based implementation as suggested by Rusty instead of trying to extend the
> current kernel thread approach.
>
> This patch series would allow to convert s390 to the generic IPI interface.
> We can't to that currently since our etr/stp code relies on the old
> semantics of smp_call_function that guarantee that the function only
> returns after all receiving cpus have acknowledged the IPI. That way it is
> known that all other cpus are running in an interrupt handler with
> interrupts disabled. This is not true anymore with the generic IPI
> infrastructure.
>
> So one idea was to use stop_machine in order to synchronize all cpus. Rusty
> was kind enough to extend it so that it is now possible to run a function
> on several cpus, instead of just one.
> However we need to be able to do that without allocating any memory. That's
> what this patch set is about: it changes the current stop_machine code to
> use a workqueue instead of kernel threads to synchronize all cpus.
> This has the advantage that all per cpu workqueue threads are already
> running when stop_machine gets called and therefore no memory needs to be
> allocated. In addition stop_machine cant't fail anymore (free_module()
> relies on that).
>
> A few things that need to be addressed:
> - stop_machine gets called from initcalls, so we need to make sure that it
>   is already initialized and has its workqueue started before that. For
> that a pre_smp initcall (early_initcall) is used to initialize it.
> - the stop_machine kernel threads used to be rt kernel threads. Workqueues
>   are normal threads. To get high priority threads a new interface
>   create_rt_workqueue is introduced.
>
> Patch 1 Moves the call to init_workqueue before pre smp initcalls
> Patch 2 introduces create_rt_workqueue
> Patch 3 converts stop_machine to use an rt workqueue

OK, I've taken 1-3.  Hope for Ingo's ack on 1 and 2.  I'm holding out on 4, 
and hopefully s390 can merge after this is done.

Thanks!
Rusty.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZKMPnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZKMPnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZKMPnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:43:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbZKMPnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:43:46 -0500
Date: Fri, 13 Nov 2009 16:38:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32-rc6] workqueue: fix race condition in
	schedule_on_each_cpu()
Message-ID: <20091113153827.GA6475@redhat.com>
References: <4AFD26F5.809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFD26F5.809@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13, Tejun Heo wrote:
>
> Commit 65a64464349883891e21e74af16c05d6e1eeb4e9 which allows
> schedule_on_each_cpu() to be called from keventd added a race
> condition.  schedule_on_each_cpu() may race with cpu hotplug and end
> up executing the function twice on a cpu.
>
> Fix it by moving direct execution into the section protected with
> get/put_online_cpus().  While at it, update code such that direct
> execution is done after works have been scheduled for all other cpus
> and drop unnecessary cpu != orig test from flush loop.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
> Andi, Oleg, this patch tested fine on my machine but it would be great
> if you guys can ack it.  Ingo, upon ack, can you please route this
> patch?

Thanks, I think this is correct.

A very minor nit, schedule_on_each_cpu() still checks "orig" twice,
perhaps it makes sense to do

	for_each_online_cpu(cpu) {
		struct work_struct *work = per_cpu_ptr(works, cpu);

		INIT_WORK(work, func);

		if (likely(cpu != orig))
			schedule_work_on(cpu, work);
		else
			func(work);
	}

instead and simplify the code a little bit.

But this is minor and up to you.

Acked-by: Oleg Nesterov <oleg@redhat.com>


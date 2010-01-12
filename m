Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176Ab0ALKum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0ALKum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 05:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079Ab0ALKum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 05:50:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:54086 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab0ALKul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 05:50:41 -0500
Subject: Re: [PATCH] sched: Move level 'again' after get_cpu() in
 sched_exec.
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <b9df5fa11001120242p46fa3d07rc005cf314bf0fd32@mail.gmail.com>
References: <b9df5fa11001120242p46fa3d07rc005cf314bf0fd32@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jan 2010 11:50:38 +0100
Message-ID: <1263293438.4244.141.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 16:42 +0600, Rakib Mullick wrote:
> sched: move level again after get_cpu().
> 
>  We can get this_cpu by calling get_cpu() once and it remains
> same. We don't need to call it again.

Yes we do... get_cpu() needs to be paired with put_cpu() and they
disable/enable preemption.

Since there's an unconditional put_cpu() before the goto again, we need
to do the get_cpu().

Plenty of kernel debug options would have informed you of this if you'd
tried running it.

> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> --- linus/kernel/sched.c	2010-01-06 20:11:10.000000000 +0600
> +++ rakib/kernel/sched.c	2010-01-12 16:01:54.000000000 +0600
> @@ -3143,8 +3143,8 @@ void sched_exec(void)
>  	unsigned long flags;
>  	struct rq *rq;
> 
> -again:
>  	this_cpu = get_cpu();
> +again:
>  	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
>  	if (dest_cpu == this_cpu) {
>  		put_cpu();



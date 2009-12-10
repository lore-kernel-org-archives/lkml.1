Return-Path: <linux-kernel-owner+w=401wt.eu-S932734AbZLJFOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbZLJFOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 00:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932703AbZLJFOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 00:14:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:35739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbZLJFOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 00:14:00 -0500
Subject: Re: [PATCH] perf_event: fix perf_swevent_hrtimer()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B2075B0.10805@cn.fujitsu.com>
References: <4B2075B0.10805@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Dec 2009 06:15:35 +0100
Message-ID: <1260422135.4165.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 12:14 +0800, Xiao Guangrong wrote:
> fix:
>  [<c0477471>] ? printk+0x1d/0x24
>  [<c01c98f9>] ? perf_prepare_sample+0x269/0x280
>  [<c0149231>] warn_slowpath_common+0x71/0xd0
>  [<c01c98f9>] ? perf_prepare_sample+0x269/0x280
>  [<c01492aa>] warn_slowpath_null+0x1a/0x20
>  [<c01c98f9>] perf_prepare_sample+0x269/0x280
>  [<c016e9f3>] ? cpu_clock+0x53/0x90
>  [<c01cc368>] __perf_event_overflow+0x2a8/0x300
>  [<c01ccc3b>] perf_event_overflow+0x1b/0x30
>  [<c01ccccf>] perf_swevent_hrtimer+0x7f/0x120
> 
> This is because 'data' variable not initialize.

Nope, please just initialize the missing variable. Which from a quick
glance is data.raw.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/perf_event.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 0bd0f67..41c2dde 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4009,7 +4009,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
>  	event	= container_of(hrtimer, struct perf_event, hw.hrtimer);
>  	event->pmu->read(event);
>  
> -	data.addr = 0;
> +	memset(&data, 0, sizeof(data));
>  	data.period = event->hw.last_period;
>  	regs = get_irq_regs();
>  	/*


Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbXLMVym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbXLMVym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762459AbXLMVye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:54:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56866 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbXLMVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:54:33 -0500
Subject: Re: [PATCH]Avoid the overflow when calculate the proportion of bdi
	quota
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: zhejiang <zhe.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
In-Reply-To: <1197516632.18076.5.camel@localhost.localdomain>
References: <1197516632.18076.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 22:54:31 +0100
Message-Id: <1197582871.3430.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 11:30 +0800, zhejiang wrote:
> __percpu_counter_add() cache the result in percpu variable until it
> exceeds the batch.
> The prop_norm_percpu() use the percpu_counter_read(&pl->events) to read
> the counter ,and use percpu_counter_add(&pl->events, -half) to half the
> counter.
> 
> There are potential problems:
> 1.The counter may be negative 
> 2.After some calculation, it may be converted to a big positive number.
> 
> 1.
> For example, the batch is 32, when the bdi add 32 to the pl->events,
> the pl->events->count will be 32.Suppose one of the percpu counter is 1.
> 
> In the prop_norm_percpu(),the half will be 16.Because it is under the
> batch, the pl->events->count won't be modified and one of the percpu
> counter may be -15. If call the prop_norm_percpu() again, the half will
> still be 16,though it should be 8.The percpu counter may be -31.
> Now, there pl->events->count is still 32.
> If do the third calculation, the percpu counter will be -47, it will
> be merged into the pl->evnets->count.Then pl->events->count will be
> negative.
> 
> 2.When the pl->events->count is negative,
> unsigned long val = percpu_counter_read(&pl->events);
> This statement may return a negative number, so the val would be a big
> number.Because of the overflow, the pl->events->count will be converted
> into a big positive number after some calculation.
> 
> Because of the overflow, I catch some very big numerators when call the
> prop_fraction_percpu().
> 
> I think that it should use percpu_counter_sum() instead of the
> percpu_counter_read() to be more robust.
> 
> diff -Nur a/proportions.c b/proportions.c
> --- a/proportions.c     2007-12-12 11:05:59.000000000 +0800
> +++ b/proportions.c     2007-12-13 11:05:40.000000000 +0800
> @@ -241,7 +241,7 @@
>          * can never result in a negative number.
>          */
>         while (pl->period != global_period) {
> -               unsigned long val = percpu_counter_read(&pl->events);
> +               unsigned long val = percpu_counter_sum(&pl->events);
>                 unsigned long half = (val + 1) >> 1;
>  
>                 /*
> 

_sum is unacceptably slow here. I'm thinking something like
bdi_stat_error() as used in balance_dirty_pages() would also solve this
issue, no?



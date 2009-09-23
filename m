Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZIWInB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZIWInB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZIWInA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:43:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:44967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbZIWInA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:43:00 -0400
Subject: Re: [PATCH 2/2] perf_counter: optimize for perf_event_init_task()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB9D8B1.4020000@cn.fujitsu.com>
References: <4AB88F06.10900@cn.fujitsu.com>
	 <19128.39768.149110.673711@cargo.ozlabs.ibm.com>
	 <4AB98BB0.6020202@cn.fujitsu.com>
	 <19129.38627.94363.857137@cargo.ozlabs.ibm.com>
	 <4AB9D7FA.5040707@cn.fujitsu.com>  <4AB9D8B1.4020000@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Sep 2009 10:43:09 +0200
Message-Id: <1253695389.7695.124.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 16:13 +0800, Xiao Guangrong wrote:
> We can traverse ctx->group_list to get all group leader, it should be safe
> since we hold ctx->mutex

I don't think we need that WARN_ON_ONCE there.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/perf_event.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 9ca975a..4e6e822 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -4786,9 +4786,8 @@ int perf_event_init_task(struct task_struct *child)
>  	 * We dont have to disable NMIs - we are only looking at
>  	 * the list, not manipulating it:
>  	 */
> -	list_for_each_entry_rcu(event, &parent_ctx->event_list, event_entry) {
> -		if (event != event->group_leader)
> -			continue;
> +	list_for_each_entry(event, &parent_ctx->group_list, group_entry) {
> +		WARN_ON_ONCE(event != event->group_leader);
>  
>  		if (!event->attr.inherit) {
>  			inherited_all = 0;

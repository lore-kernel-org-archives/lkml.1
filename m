Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbZHaLM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbZHaLM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZHaLMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:12:55 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57785 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZHaLMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:12:54 -0400
Date: Mon, 31 Aug 2009 07:12:46 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       David Miller <davem@davemloft.net>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] drop_monitor: fix trace_napi_poll_hit()
Message-ID: <20090831111245.GA2105@hmsreliant.think-freely.org>
References: <4A9B6963.5090207@cn.fujitsu.com> <4A9B6E57.7090703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A9B6E57.7090703@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -4.8 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 08:31:51AM +0200, Eric Dumazet wrote:
> Xiao Guangrong a écrit :
> > The net_dev of backlog napi is NULL, like below:
> > 
> > __get_cpu_var(softnet_data).backlog.dev == NULL
> > 
> > So, we should check it in napi tracepoint's probe function
> > 
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> > ---
> >  net/core/drop_monitor.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> > index 9d66fa9..d311202 100644
> > --- a/net/core/drop_monitor.c
> > +++ b/net/core/drop_monitor.c
> > @@ -182,7 +182,8 @@ static void trace_napi_poll_hit(struct napi_struct *napi)
> >  	/*
> >  	 * Ratelimit our check time to dm_hw_check_delta jiffies
> >  	 */
> > -	if (!time_after(jiffies, napi->dev->last_rx + dm_hw_check_delta))
> > +	if (!napi->dev ||
> > +	    !time_after(jiffies, napi->dev->last_rx + dm_hw_check_delta))
> >  		return;
> >  
> >  	rcu_read_lock();
> 
> 
> This reminds me dev->last_rx is not anymore updated, unless special conditions
> are met.
> 
I still see a large number of drivers that update dev->last_rx, although its
not all as I look through the list, so something definately seems amiss.

If its not going to be consistently updated, why are still carrying that field
in dev?  Are we just waiting on someone to do the janitorial work to remove it?
If so, I can, and I'll fix up the drop monitor in the process, to use a private
timestamp.

Neil

> Test done in trace_napi_poll_hit() is probably not good, even with a non null napi->dev
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

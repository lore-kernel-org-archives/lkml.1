Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbYJJE0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbYJJE0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 00:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYJJE0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 00:26:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45918 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYJJE0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 00:26:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] markers: bit-field is not thread-safe nor smp-safe
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <48EEC6AD.4010606@cn.fujitsu.com>
References: <48EEC6AD.4010606@cn.fujitsu.com>
Message-Id: <20081010132354.B35F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 10 Oct 2008 13:26:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai-san,

> 
> bit-field is not thread-safe nor smp-safe.
> 
> struct marker_entry.rcu_pending is not protected by any lock
> in rcu-callback free_old_closure().
> so we must turn it into a safe type.

hmmm
however, char also doesn't smp-safe because some architecture doesn't have
any byte load/store instruction.

It seems bogus solution to me ;)


> detail:
> 
> I suppose rcu_pending and ptype are store in struct marker_entry.tmp1
> 
> free_old_closure() side:           change ptype side:
> 
>                                 |  load struct marker_entry.tmp1
> --------------------------------|--------------------------------
>                                 |  change ptype bit in tmp1
> load struct marker_entry.tmp1   |
> change rcu_pending bit in tmp1  |
> store tmp1                      |
> --------------------------------|--------------------------------
>                                 |  store tmp1
> 
> now this result equals that free_old_closure() do not change rcu_pending bit, bug.
> 
> see also: http://en.wikipedia.org/wiki/Bit_field
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/marker.c b/kernel/marker.c
> index 7d1faec..4777218 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -62,7 +62,7 @@ struct marker_entry {
>  	int refcount;	/* Number of times armed. 0 if disarmed. */
>  	struct rcu_head rcu;
>  	void *oldptr;
> -	unsigned char rcu_pending:1;
> +	unsigned char rcu_pending;
>  	unsigned char ptype:1;
>  	char name[0];	/* Contains name'\0'format'\0' */
>  };




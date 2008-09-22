Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYIVOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYIVOY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYIVOYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:24:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38894 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbYIVOYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:24:19 -0400
Subject: Re: [PATCH 4/13] memcg: force_empty moving account
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080922200025.49ea6d70.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922200025.49ea6d70.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 16:23:40 +0200
Message-Id: <1222093420.16700.2.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 20:00 +0900, KAMEZAWA Hiroyuki wrote:

> +		/* For avoiding race with speculative page cache handling. */
> +		if (!PageLRU(page) || !get_page_unless_zero(page)) {
> +			list_move(&pc->lru, list);
> +			spin_unlock_irqrestore(&mz->lru_lock, flags);
> +			yield();

Gah, no way!

> +			spin_lock_irqsave(&mz->lru_lock, flags);
> +			continue;
> +		}
> +		if (!trylock_page(page)) {
> +			list_move(&pc->lru, list);
>  			put_page(page);
> -			if (--count <= 0) {
> -				count = FORCE_UNCHARGE_BATCH;
> -				cond_resched();
> -			}
> -		} else
> -			cond_resched();
> -		spin_lock_irqsave(&mz->lru_lock, flags);
> +			spin_unlock_irqrestore(&mz->lru_lock, flags);
> +			yield();

Seriously?!

> +			spin_lock_irqsave(&mz->lru_lock, flags);
> +			continue;
> +		}
> +		if (mem_cgroup_move_account(page, pc, mem, &init_mem_cgroup)) {
> +			/* some confliction */
> +			list_move(&pc->lru, list);
> +			unlock_page(page);
> +			put_page(page);
> +			spin_unlock_irqrestore(&mz->lru_lock, flags);
> +			yield();

Inflicting pain..

> +			spin_lock_irqsave(&mz->lru_lock, flags);
> +		} else {
> +			unlock_page(page);
> +			put_page(page);
> +		}
> +		if (atomic_read(&mem->css.cgroup->count) > 0)
> +			break;
>  	}
>  	spin_unlock_irqrestore(&mz->lru_lock, flags);

do _NOT_ use yield() ever! unless you know what you're doing, and
probably not even then.

NAK!


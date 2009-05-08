Return-Path: <linux-kernel-owner+w=401wt.eu-S1761459AbZEHLj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761459AbZEHLj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbZEHLjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:39:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42935 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZEHLjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:39:15 -0400
Date: Fri, 8 May 2009 13:38:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] memcg fix stale swap cache account leak v6
Message-ID: <20090508113820.GL11596@elte.hu>
References: <20090508140528.c34ae712.kamezawa.hiroyu@jp.fujitsu.com> <20090508140910.bb07f5c6.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508140910.bb07f5c6.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x
* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +struct swapio_check {
> +	spinlock_t	lock;
> +	void		*swap_bio_list;
> +	struct delayed_work work;
> +} stale_swap_check;

Small nit. It's nice that you lined up the first two fields, but it 
would be nice to line up the third one too:

struct swapio_check {
	spinlock_t		lock;
	void			*swap_bio_list;
	struct delayed_work	work;
} stale_swap_check;

> +	while (nr--) {
> +		cond_resched();
> +		spin_lock_irq(&sc->lock);
> +		bio = sc->swap_bio_list;

> @@ -66,6 +190,7 @@ static void end_swap_bio_write(struct bi
>  				(unsigned long long)bio->bi_sector);
>  		ClearPageReclaim(page);
>  	}
> +	mem_cgroup_swapio_check_again(bio, page);

Hm, this patch adds quite a bit of scanning overhead to 
end_swap_bio_write(), to work around artifacts of a global LRU not 
working well with a partitioned system's per-partition LRU needs.

Isnt the right solution to have a better LRU that is aware of this, 
instead of polling around in the hope of cleaning up stale entries?

	Ingo

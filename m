Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYKLEyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYKLEyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 23:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYKLEyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 23:54:41 -0500
Received: from rcpt-mqugw.biglobe.ne.jp ([133.205.19.69]:50025 "EHLO
	rcpt-mqugw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYKLEyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 23:54:40 -0500
X-Greylist: delayed 2248 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2008 23:54:39 EST
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Wed, 12 Nov 2008 13:17:01 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC][PATCH 4/6] memcg: swap cgroup for remembering account
Message-Id: <20081112131701.dbb7d003.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20081112122949.d17bbc7f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081112122606.76051530.kamezawa.hiroyu@jp.fujitsu.com>
	<20081112122949.d17bbc7f.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * lookup_swap_cgroup - lookup mem_cgroup tied to swap entry
> + * @ent: swap entry to be looked up.
> + *
> + * Returns pointer to mem_cgroup at success. NULL at failure.
> + */
> +struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
> +{
> +	int type = swp_type(ent);
> +	unsigned long flags;
> +	unsigned long offset = swp_offset(ent);
> +	unsigned long idx = offset / SC_PER_PAGE;
> +	unsigned long pos = offset & SC_POS_MASK;
> +	struct swap_cgroup_ctrl *ctrl;
> +	struct page *mappage;
> +	struct swap_cgroup *sc;
> +	struct mem_cgroup *ret;
> +
> +	if (!do_swap_account)
> +		return NULL;
> +
> +	ctrl = &swap_cgroup_ctrl[type];
> +
> +	mappage = ctrl->map[idx];
> +
> +	spin_lock_irqsave(&ctrl->lock, flags);
> +	sc = kmap_atomic(mappage, KM_USER0);
> +	sc += pos;
> +	ret = sc->val;
> +	kunmap_atomic(mapppage, KM_USER0);
s/mapppage/mappage

I don't know why I didn't notice this while testing previous version.


Thanks,
Daisuke Nishimura.

> +	spin_unlock_irqrestore(&ctrl->lock, flags);
> +	return ret;
> +}
> +

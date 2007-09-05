Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbXIEWun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbXIEWun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 18:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbXIEWuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 18:50:35 -0400
Received: from barikada.upol.cz ([158.194.242.200]:59456 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbXIEWue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 18:50:34 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Paul McKenney <paulmck@us.ibm.com>
Subject: Fast path efficiency (Re: [rfc][patch] dynamic data structure switching)
In-Reply-To: <20070902183618.GB13145@wotan.suse.de>
References: <20070902182738.GA13145@wotan.suse.de> <20070902183618.GB13145@wotan.suse.de>
Date: Thu, 6 Sep 2007 01:05:40 +0200
Message-Id: <E1IT3wK-0006Bh-22@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sun, 2 Sep 2007 20:36:19 +0200
>

I see, that in many places all pre-checks are done in negative form
with resulting return or jump out. In this case, if function was called,
what likely() path is?

> +static void resize_pid_hash(void)
> +{
> +	unsigned int old_shift, new_shift;
> +
> +	if (system_state != SYSTEM_RUNNING)
> +		return;
> +
> +	old_shift = cur_pid_hash->shift;
> +	new_shift = ilog2(nr_pids * 2 - 1);
> +	if (new_shift == old_shift)
> +		return;
> +
> +	if (!mutex_trylock(&dyn_pidhash.resize_mutex))
> +		return;

that one or this?

==
	if (system_state == SYSTEM_RUNNING) {
		old_shift = cur_pid_hash->shift;
		new_shift = ilog2(nr_pids * 2 - 1);
		if (new_shift != old_shift && mutex_trylock(&dyn_pidhash.resize_mutex)) {
==
		> +	old_shift = cur_pid_hash->shift;
		> +	new_shift = ilog2(nr_pids * 2 - 1);

/* hope this repetition is needed by design */

		...
		
		> +	mutex_unlock(&dyn_pidhash.resize_mutex);
		}

What is more efficient in general sense,
as opposed to s,3,2,1,0 Optimized?

> +	if (new_shift != old_shift) {
> +		struct pid_hash *ph, *ret;
> +		unsigned int idx = ph_cur_idx ^ 1;
> +		ph = &pid_hashes[idx];
> +		if (!init_pid_hash(ph, new_shift)) {
> +			ph_cur_idx = idx;
> +
> +			ret = dyn_data_replace(&dyn_pidhash, dd_transfer_pids, ph);
> +			BUG_ON(ret == ph);
> +			BUG_ON(ret != &pid_hashes[idx ^ 1]);
> +			/* XXX: kfree(ret->table) */
> +			ret->shift = -1;
> +			ret->table = NULL;
> +		}
> +	}
> +	mutex_unlock(&dyn_pidhash.resize_mutex);
> +}
> +

Thanks.
____

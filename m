Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZDUDnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZDUDnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 23:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZDUDnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 23:43:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54911 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZDUDnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 23:43:10 -0400
Message-ID: <49ED406F.2040401@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 11:41:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Eric Dumazet <dada1@cosmosbay.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       David Miller <davem@davemloft.net>, kaber@trash.net,
       torvalds@linux-foundation.org, jeff.chua.linux@gmail.com, mingo@elte.hu,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
References: <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain>	<49E72E83.50702@trash.net>	<20090416.153354.170676392.davem@davemloft.net>	<20090416234955.GL6924@linux.vnet.ibm.com>	<20090417012812.GA25534@linux.vnet.ibm.com>	<20090418094001.GA2369@ioremap.net>	<20090418141455.GA7082@linux.vnet.ibm.com>	<20090420103414.1b4c490f@nehalam>	<49ECBE0A.7010303@cosmosbay.com>	<18924.59347.375292.102385@cargo.ozlabs.ibm.com>	<20090420215827.GK6822@linux.vnet.ibm.com>	<18924.64032.103954.171918@cargo.ozlabs.ibm.com> <20090420160121.268a8226@nehalam>
In-Reply-To: <20090420160121.268a8226@nehalam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> +/**
> + * xt_table_info_rdlock_bh - recursive read lock for xt table info
> + *
> + * Table processing calls this to hold off any changes to table
> + * (on current CPU). Always leaves with bottom half disabled.
> + * If called recursively, then assumes bh/preempt already disabled.
> + */
> +void xt_info_rdlock_bh(void)
> +{
> +	struct xt_info_lock *lock;
> +
> +	preempt_disable();
> +	lock = &__get_cpu_var(xt_info_locks);
> +	if (likely(++lock->depth == 0))

Maybe I missed something. I think softirq may be still enabled here.
So what happen when xt_info_rdlock_bh() called recursively here?

> +		spin_lock_bh(&lock->lock);
> +	preempt_enable_no_resched();
> +}
> +EXPORT_SYMBOL_GPL(xt_info_rdlock_bh);
> +

Is this OK for you:

void xt_info_rdlock_bh(void)
{
	struct xt_info_lock *lock;

	local_bh_disable();
	lock = &__get_cpu_var(xt_info_locks);
	if (likely(++lock->depth == 0))
		spin_lock(&lock->lock);
}

Lai.


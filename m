Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZDRJk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZDRJk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 05:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZDRJkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 05:40:09 -0400
Received: from genesysrack.ru ([195.178.208.66]:42818 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZDRJkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 05:40:07 -0400
Date: Sat, 18 Apr 2009 13:40:01 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>, kaber@trash.net,
       torvalds@linux-foundation.org, shemminger@vyatta.com,
       dada1@cosmosbay.com, jeff.chua.linux@gmail.com, paulus@samba.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
Message-ID: <20090418094001.GA2369@ioremap.net>
References: <20090415170111.6e1ca264@nehalam> <alpine.LFD.2.00.0904151705120.4042@localhost.localdomain> <49E72E83.50702@trash.net> <20090416.153354.170676392.davem@davemloft.net> <20090416234955.GL6924@linux.vnet.ibm.com> <20090417012812.GA25534@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417012812.GA25534@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, Apr 16, 2009 at 06:28:12PM -0700, Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> +/* Single bit for grace-period index, low-order bits are nesting counter. */
> +#define RCU_FGP_COUNT		1UL
> +#define RCU_FGP_PARITY		(1UL << (sizeof(long) << 2))
> +#define RCU_FGP_NEST_MASK	(RCU_FGP_PARITY - 1)
> +
> +extern long rcu_fgp_ctr;
> +DECLARE_PER_CPU(long, rcu_fgp_active_readers);
> +
> +static inline void rcu_read_lock_fgp(void)
> +{
> +	long tmp;
> +	long *uarp;
> +
> +	preempt_disable();
> +	uarp = &__get_cpu_var(rcu_fgp_active_readers);
> +	tmp = *uarp;
> +	if (likely(!(tmp & RCU_FGP_NEST_MASK)))
> +		*uarp = rcu_fgp_ctr;  /* Outermost rcu_read_lock(). */
> +	else
> +		*uarp = tmp + RCU_FGP_COUNT;  /* Nested rcu_read_lock(). */
> +	barrier();
> +}
> +
> +static inline void rcu_read_unlock_fgp(void)
> +{
> +	barrier();
> +	__get_cpu_var(rcu_fgp_active_readers)--;

Shouldn't it be rcu_fgp_active_readers - RCU_FGP_COUNT?
Although it is 1 by definition, it is more clear when understanding
what's going on here.

-- 
	Evgeniy Polyakov

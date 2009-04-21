Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZDUFtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZDUFtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbZDUFsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:48:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64611 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZDUFsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:48:53 -0400
Message-ID: <49ED5DA8.4080206@cn.fujitsu.com>
Date: Tue, 21 Apr 2009 13:46:16 +0800
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


My silly opinion about lockdep in this patch:

> +
> +struct xt_info_lock {
> +	spinlock_t 	   lock;

+	struct lock_class_key key;

> +	int   	   	   depth;	/* # readers - 1 */
> +};
> +static DEFINE_PER_CPU(struct xt_info_lock, xt_info_locks);
> +
> +
> +static inline void xt_info_lock_init(struct xt_info_lock *lock)
> +{
> +	spin_lock_init(&lock->lock);

+	lockdep_set_class(&lock->lock, &lock->key);

> +	lock->depth = -1;
> +}
> +

And remove lockdep_xxx()s.



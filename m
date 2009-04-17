Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbZDQRXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbZDQRXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbZDQRXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:23:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927AbZDQRXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:23:37 -0400
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, dada1@cosmosbay.com, shemminger@vyatta.com,
       kaber@trash.net, torvalds@linux-foundation.org,
       jeff.chua.linux@gmail.com, paulus@samba.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org,
       mathieu.desnoyers@polymtl.ca
In-Reply-To: <20090417.010710.59150850.davem@davemloft.net>
References: <20090416215033.3e648a7a@nehalam>
	 <49E810B0.9000906@cosmosbay.com> <20090417054032.GD6885@linux.vnet.ibm.com>
	 <20090417.010710.59150850.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 19:22:59 +0200
Message-Id: <1239988979.23397.4841.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 01:07 -0700, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Thu, 16 Apr 2009 22:40:32 -0700
> 
> > I completely agree that this RCU is absolutely -not- 2.6.30 material.  ;-)
> 
> I don't understand why we're writing such complicated code.
> 
> Oh I see why, it's because not every arch uses the generic SMP helpers
> yet :-)
> 
> Because if they did universally, we could solve this problem so
> simply, by merely sending a remote softirq to every online cpu.  Once
> those all complete we have enough of a quiesce period, every cpu must
> have exited any netfilter packet processing code path they were in.
> 
> And we could know they complete using an atomic counter or something.

Since its a full broadcast, we can do that _today_ using on_each_cpu().
But whatever way we turn this, this will be a very expensive operation.
Imagine doing that on your 256-way for every iptables rules change.




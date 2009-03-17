Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZCQE1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZCQE1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZCQE1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:27:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34166
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbZCQE1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:27:31 -0400
Date: Mon, 16 Mar 2009 21:27:17 -0700 (PDT)
Message-Id: <20090316.212717.233062381.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, jwboyer@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Subject: Re: cli/sti vs local_cmpxchg and local_add_return
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090317041016.GA26748@Krystal>
References: <20090317013220.GA22474@Krystal>
	<20090316.203705.218202510.davem@davemloft.net>
	<20090317041016.GA26748@Krystal>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Tue, 17 Mar 2009 00:10:16 -0400

> Thanks for running those tests. Actually, I did not expect good results
> for sparc64 because the local_t primitives map to atomic_t. Looking at
> sparc atomic_64.h, I notice that all atomic operations except cmpxchg
> are done through function calls even when those functions only contain
> few instructions.  Is there any particular reason for that ? These
> function calls can be quite costly. We could easily inline those.

With all the memory barriers, cpu bug workarounds, et al.
it's way too much to expand inline.

> And to "unleash" the full power of local_t, we should see if there are
> variants of the atomic operations which are safe only on UP and if there
> are some memory barriers currently embedded in the atomic_t ops we could
> remove in a local_t version. Actually, all the
> BACKOFF_SETUP/BACKOFF_SPIN is specific to SMP, and therefore the local_t
> version probably does not need that because it touches specifically
> per-cpu data. That could give very interesting results.
> 
> The reason why the results shows 0 cycles per loop is just because there
> is less that a bus clock cycle per loop. But the total time (in bus
> cycles) for the whole 20000 cycles gives us equivalent information.

I don't think it's worth it.  Rusty made similar tests not too long
ago.

IRQ disabling/enabling on sparc64 is 9 cycles (each) and the atomic
operation on the other hand is at least 35 cycles.

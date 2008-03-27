Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbYC0LDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbYC0LDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYC0LDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:03:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57782
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754998AbYC0LDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:03:35 -0400
Date: Thu, 27 Mar 2008 04:03:34 -0700 (PDT)
Message-Id: <20080327.040334.25440988.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: akpm@linux-foundation.org, jarkao2@gmail.com, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, marcus@better.se,
       shemminger@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
 net_rx_action
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206615379.8514.502.camel@twins>
References: <20080327085542.GA2778@ami.dom.local>
	<20080327021812.601776b8.akpm@linux-foundation.org>
	<1206615379.8514.502.camel@twins>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 27 Mar 2008 11:56:19 +0100

> How about this:
> 
> <irqs disabled>
> 
>   netpoll_poll()
>     poll_napi()
>       spin_trylock(&napi->poll_lock)
>       poll_one_napi()
>         napi->poll() := sky2_poll()
>           napi_complete()
>             local_irq_disable()
>             local_irq_enable() <--- *BUG*
> 
>   <irq>
>     irq_exit()
>       do_softirq()
>         net_rx_action()
>           spin_lock(&napi->poll_lock) <--- Deadlock!
> 
> Because we still hold the lock....

Yep, that will deadlock.

Can some test if using local_irq_{save,restore}() in
napi_complete() cures this lockdep warning?

Thanks.

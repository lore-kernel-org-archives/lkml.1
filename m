Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbYDWGvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbYDWGvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbYDWGvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:51:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42343 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYDWGvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:51:43 -0400
Subject: Re: Second soft lockup regression in yesterday's sched.git merge
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       guichaz@yahoo.fr
In-Reply-To: <20080422.233935.37053549.davem@davemloft.net>
References: <20080422.233935.37053549.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 08:51:39 +0200
Message-Id: <1208933499.7115.324.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 23:39 -0700, David Miller wrote:
> Two changets after the buggy cpu_clock() changes, we have:
> 
> commit 15934a37324f32e0fda633dc7984a671ea81cd75
> Author: Guillaume Chazarain <guichaz@yahoo.fr>
> Date:   Sat Apr 19 19:44:57 2008 +0200
> 
>     sched: fix rq->clock overflows detection with CONFIG_NO_HZ
>     
>     When using CONFIG_NO_HZ, rq->tick_timestamp is not updated every TICK_NSEC.
>     We check that the number of skipped ticks matches the clock jump seen in
>     __update_rq_clock().
>     
>     Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Which also causes softlockup warnings on my Niagara systems.
> 
> Note this is with the cpu_clock() change reverted, and the
> usual test case kernel build after a delay:
> 
> 	sleep 10m; time make -j64 >build.log 2>&1; make -j64 image

The effect of this one is that it should properly account idle time in
rq->clock when waking from nohz.

This 'extra' idle time would then propagate through cpu_clock() into the
softlockup code.

Could it be we touch the soft watchdog before we correct all these idle
times?


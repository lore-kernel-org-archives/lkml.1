Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbZE1UUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbZE1UUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZE1UTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:19:55 -0400
Received: from www.tglx.de ([62.245.132.106]:34216 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZE1UTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:19:54 -0400
Date: Thu, 28 May 2009 22:19:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 1/2] idle profile hits with NOHZ
In-Reply-To: <20090528150502.044210490@de.ibm.com>
Message-ID: <alpine.LFD.2.00.0905282204130.3397@localhost.localdomain>
References: <20090528150447.152019714@de.ibm.com> <20090528150502.044210490@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Martin Schwidefsky wrote:
> --- quilt-2.6.orig/kernel/time/tick-sched.c
> +++ quilt-2.6/kernel/time/tick-sched.c
> @@ -166,6 +166,7 @@ static void tick_nohz_stop_idle(int cpu)
>  		ts->idle_lastupdate = now;
>  		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
>  		ts->idle_active = 0;
> +		ts->idle_pc = profile_pc(get_irq_regs());

  Hmm, tick_nohz_stop_idle() is called from
  tick_nohz_restart_sched_tick() as well in the context of the idle
  task.

  I think there is no guarantee that get_irq_regs() will return
  anything useful in thread context.

  So get_irq_regs() might return a NULL pointer which will explode
  some of the profile_pc() implementations. If not it can still feed
  total nonsense to the profile_hits() call.

Thanks,

	tglx

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZHMWPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZHMWPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbZHMWPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:15:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42993 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZHMWPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:15:40 -0400
Subject: Re: [patch 02/14] remove clocksource inline functions
From: john stultz <johnstul@us.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>
In-Reply-To: <20090813154159.634291990@de.ibm.com>>
References: <20090813154034.613706651@de.ibm.com> >
	  <20090813154159.634291990@de.ibm.com>>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 15:14:34 -0700
Message-Id: <1250201674.7149.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 17:40 +0200, Martin Schwidefsky wrote:
> plain text document attachment (clocksource-inline.diff)
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> The three inline functions clocksource_read, clocksource_enable
> and clocksource_disable are simple wrappers of an indirect call
> plus the copy from and to the mult_orig value. The functions
> are exclusively used by the timekeeping code which has intimate
> knowledge of the clocksource anyway. Therefore remove the inline
> functions. No functional change.
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Acked-by: John Stultz <johnstul@us.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>  include/linux/clocksource.h |   58
> --------------------------------------------
>  kernel/time/timekeeping.c   |   42 +++++++++++++++++++++----------
>  2 files changed, 28 insertions(+), 72 deletions(-)
> 
> Index: linux-2.6/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6.orig/kernel/time/timekeeping.c
> +++ linux-2.6/kernel/time/timekeeping.c
[snip]
> @@ -477,8 +492,7 @@ static int timekeeping_resume(struct sys
>  	}
>  	update_xtime_cache(0);
>  	/* re-base the last cycle value */
> -	clock->cycle_last = 0;
> -	clock->cycle_last = clocksource_read(clock);
> +	clock->cycle_last = clock->read(clock);

Minor bug here, the clearing of cycle_last has a side-effect of making
sure the TSC doesn't trip over its own cycle_last checking in the read()
function. This is part of the uglyness of the TSC pulling this internal
timeekping state to avoid minor inconsistencies, but until we find a
better way, we have to live with it.

So you'll need to preserve the cycle_last = 0 line.

thanks
-john





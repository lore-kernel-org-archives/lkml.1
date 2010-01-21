Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519Ab0AURTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0AURTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 12:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810Ab0AURTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 12:19:25 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38122 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab0AURTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 12:19:24 -0500
Subject: Re: [PATCH] kernel/timekeeping:  move xtime_cache to be in the
 same cache line as the lock
From: john stultz <johnstul@us.ibm.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264088361.2082.45.camel@localhost>
References: <1264088361.2082.45.camel@localhost>
Content-Type: text/plain
Date: Thu, 21 Jan 2010 09:19:19 -0800
Message-Id: <1264094359.3253.11.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 15:39 +0000, Richard Kennedy wrote:
> move xtime_cache to be in the same cache line as the lock
>     
> allowing current_kernel_time() to access only one cache line
> 
> when running fio write tests on a 2 core machine, on some of the runs
> 'perf record -e cache_misses' shows current_kernel_time near the top of
> the list of cache_misses with 5.5%.
> On the other runs it's down at 0.05% so I'm assuming that the difference
> is just down to which core the test client get run on.
> 
> This patch moves the xtime_cache variable near to the lock so that it
> only need to access one cache line.
> With this applied it drops the current_kernel_time cache_misses in the
> slow case to 4.5%
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Hrm.. I'm hoping to kill off the xtime_cache at some point soon, so I'm
not sure if this patch will do much for long. That said, I'm not opposed
to it in the mean time, and when xtime_cache does get yanked, I'd
appreciate similar performance review to make sure we're not regressing.

> ---
> patch against v2.6.33-rc4
> compiled & tested on AMD64X2 x86_64
> 
> 
> BTW on 64 bit timespec is a 16 byte structure so the aligned 16 doesn't
> do much, and on 32bit timepec is 8bytes so this just seems to spread
> these variables across more cache lines than necessary. Any ideas what
> this is here for?

I think it was a copy-paste from the xtime and wall_to_monotonic
definitions, which both have the same alignment. 

thanks
-john


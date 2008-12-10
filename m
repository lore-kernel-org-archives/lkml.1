Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbYLJAYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbYLJAYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 19:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYLJAYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 19:24:32 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51120 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYLJAYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 19:24:31 -0500
Subject: Re: [Patch] Fix sys_time to handle intra-tick correction
From: john stultz <johnstul@us.ibm.com>
To: Vinay Sridhar <vinay@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1228823938.11639.7.camel@localhost.localdomain>
References: <1228823938.11639.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 16:24:27 -0800
Message-Id: <1228868667.6758.176.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-09 at 17:28 +0530, Vinay Sridhar wrote:
> Hi All,
> 
> This fix changes sys_time to use do_gettimeofday instead of get_seconds.
> Running the stime01 test from LTP triggers this error. Calling sys_stime
> and then calling sys_time causes this. "do_settimeofday" subtracts the
> nsec offset from the nsec value(0 in this case) passed to it.
> Subsequently, "set_normalized_timespec" modifies sec and nsec
> accordingly. This compensation is handled in the do_gettimeofday path.
> However, sys_time does not handle this case and reports an incorrect
> seconds value.
> 
> 
> signed-off by : Vinay Sridhar <vinay@linux.vnet.ibm.com>

This does fix the symmetry by using the same interfaces on both sides,
so it seems reasonable to me. However, since do_gettimeofday reads the
clocksource hardware, this may have a slight performance impact to
time() users.

I know privately I said this patch looked fine earlier, so sorry for the
mixed messages, but I really think we should be able to use
get_seconds() without this problem.

Looking more carefully at the code in do_settimeofday(), we should
accumulate the left over cycles, then we set the current time to the
specified time and update the xtime_cache.

So I'm not sure if we're really fixing the right issue here. Further,
running on the x86_64 system, I don't see this issue crop up at all (for
either 64 or 32 bit binaries). I think you mentioned privately that this
was seen on i386, so maybe we need to dig just a bit deeper before going
with this fix.

And sorry again for running hot then cold on this patch. I just didn't
look deeply enough at the issue the first time around. :(

thanks
-john




> --- time.c.orig	2008-12-04 06:30:12.000000000 -0600
> +++ time.c	2008-12-04 06:31:25.000000000 -0600
> @@ -61,7 +61,12 @@ EXPORT_SYMBOL(sys_tz);
>   */
>  asmlinkage long sys_time(time_t __user * tloc)
>  {
> -	time_t i = get_seconds();
> +	struct timeval t;	
> +	time_t i;
> +
> +	do_gettimeofday(&t);
> +
> +	i = t.tv_sec;
> 
>  	if (tloc) {
>  		if (put_user(i,tloc))
> 
> 


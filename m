Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYILCzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYILCzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 22:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYILCzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 22:55:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34151 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbYILCzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 22:55:03 -0400
Date: Thu, 11 Sep 2008 16:54:58 -1000
From: j_kernel@hoblitt.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080912025458.GF27054@hoblitt.com>
References: <bug-11543-10286@http.bugzilla.kernel.org/> <20080911170258.aa0bea0d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911170258.aa0bea0d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 05:02:58PM -0700, Andrew Morton wrote:
> Is this a regression?  Was 2.6.26 OK, for example?

It might be a regression. ;) The last build we were running on this
hardware was 2.6.24.2 and NMI watchdog support was not enabled.  We were
however experiencing random deadlocks, which I had been attributing to
problems with forcedeth.c (which causes the NIC to totally crap out
but not deadlock the machine) but I am now of the mind that there are
multiple problems with distinct failure modes.

> I can't work out who called panic(), nor why.

One more data point.  We booted this kernel on 14 machines this morning
and only one has had this panic thus far...

> The panic code called the kexec code which called mutex_trylock() which
> called spin_lock_mutex() which then stupidly went and blurted a load of
> debug stuff because of in_interrupt().
> 
> Something like this:
> 
> --- a/include/linux/debug_locks.h~a
> +++ a/include/linux/debug_locks.h
> @@ -17,7 +17,7 @@ extern int debug_locks_off(void);
>  ({									\
>  	int __ret = 0;							\
>  									\
> -	if (unlikely(c)) {						\
> +	if (!oops_in_progress && unlikely(c)) {				\
>  		if (debug_locks_off() && !debug_locks_silent)		\
>  			WARN_ON(1);					\
>  		__ret = 1;						\
> _
> 
> might prevent the debugging code from preventing us from finding bugs :(

Do you want me to give that patch a try or sit tight for a bit?

-J

--

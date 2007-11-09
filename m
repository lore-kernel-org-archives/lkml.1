Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbXKIUXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbXKIUXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 15:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXKIUXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 15:23:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbXKIUW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 15:22:58 -0500
Date: Fri, 9 Nov 2007 12:22:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-arch@vger.kernel.org, bernd@bzed.de,
       joy@entuzijast.net, fabbione@ubuntu.com, arnd@arndb.de,
       stable@kernel.org
Subject: Re: Fix for sparc64 cpu hangs.
Message-Id: <20071109122208.5b6794ea.akpm@linux-foundation.org>
In-Reply-To: <20071106.211356.60087540.davem@davemloft.net>
References: <20071106.203433.144763156.davem@davemloft.net>
	<20071106.211356.60087540.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Nov 2007 21:13:56 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Tue, 06 Nov 2007 20:34:33 -0800 (PST)
> 
> > [FUTEX]: Fix address computation in compat code.
> 
> Sorry, I just noticed there is a second handle_futex_death()
> call in compat_exit_robust_list() which has the same
> address computation bug.
> 
> Here is an updated patch:
> 
> [FUTEX]: Fix address computation in compat code.
> 
> compat_exit_robust_list() computes a pointer to the
> futex entry in userspace as follows:
> 
> 	(void __user *)entry + futex_offset
> 
> 'entry' is a 'struct robust_list __user *', and
> 'futex_offset' is a 'compat_long_t' (typically a 's32').
> 
> Things explode if the 32-bit sign bit is set in futex_offset.
> 
> Type promotion sign extends futex_offset to a 64-bit value before
> adding it to 'entry'.
> 
> This triggered a problem on sparc64 running 32-bit applications which
> would lock up a cpu looping forever in the fault handling for the
> userspace load in handle_futex_death().
> 
> Compat userspace runs with address masking (wherein the cpu zeros out
> the top 32-bits of every effective address given to a memory operation
> instruction) so the sparc64 fault handler accounts for this by
> zero'ing out the top 32-bits of the fault address too.
> 
> Since the kernel properly uses the compat_uptr interfaces, kernel side
> accesses to compat userspace work too since they will only use
> addresses with the top 32-bit clear.
> 
> Because of this compat futex layer bug we get into the following loop
> when executing the get_user() load near the top of handle_futex_death():
> 
> 1) load from address '0xfffffffff7f16bd8', FAULT
> 2) fault handler clears upper 32-bits, processes fault
>    for address '0xf7f16bd8' which succeeds
> 3) goto #1
> 
> I want to thank Bernd Zeimetz, Josip Rodin, and Fabio Massimo Di Nitto
> for their tireless efforts helping me track down this bug.
> 

I tagged this as needed-in-2.6.23.x.  Please let me know if that is not
appropriate.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXKHCJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXKHCJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbXKHCJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:09:20 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33046
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbXKHCJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:09:19 -0500
Date: Wed, 07 Nov 2007 18:09:18 -0800 (PST)
Message-Id: <20071107.180918.263752219.davem@davemloft.net>
To: paulus@samba.org
Cc: akpm@linux-foundation.org, lkml@davidb.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <18226.27701.782268.375231@cargo.ozlabs.ibm.com>
References: <20071107152833.6f302c2a.akpm@linux-foundation.org>
	<20071107161853.044b6e8f.akpm@linux-foundation.org>
	<18226.27701.782268.375231@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Thu, 8 Nov 2007 12:53:57 +1100

> Andrew Morton writes:
> 
> > Given all this stuff, the return value from sys_times() doesn't seem a
> > particularly useful or reliable kernel interface.
> 
> I think the best thing would be to ignore any error from copy_to_user
> and always return the number of clock ticks.  We should call
> force_successful_syscall_return, and glibc on x86 should be taught not
> to interpret negative values as an error.
> 
> POSIX doesn't require us to return an EFAULT error if the buf argument
> is bogus.  If userspace does supply a bogus buf pointer, then either
> it will dereference it itself and get a segfault, or it won't
> dereference it, in which case it obviously didn't care about the
> values we tried to put there.
> 
> If we try to return an error under some circumstances, then there is
> at least one 32-bit value for the number of ticks that will cause
> confusion.  We can either change that value (or values) to some other
> value, which seems pretty bogus, or we can just decide not to return
> any errors.  The latter seems to me to have no significant downside
> and to be the simplest solution to the problem.

I agree with this analysis.

The Linux man page for times() explicitly lists (clock_t) -1 as a
return value meaning error.

So even if we did make some effort to return errors "properly" (via
force_successful_syscall_return() et al.) userspace would still be
screwed because (clock_t) -1 would be interpreted as an error.

Actually I think this basically proves we cannot return (clock_t) -1
ever because all existing userland (I'm not talking about inside
glibc, I'm talking about inside of applications) will see this as an
error.

User applications have no other way to check for error.

This API is definitely very poorly designed, no matter which way we
"fix" this some case will remain broken.

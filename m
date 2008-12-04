Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbYLDRDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbYLDRDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYLDRDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:03:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50681
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751775AbYLDRDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:03:45 -0500
Date: Thu, 04 Dec 2008 09:03:45 -0800 (PST)
Message-Id: <20081204.090345.138944783.davem@davemloft.net>
To: mingo@elte.hu
Cc: paulus@samba.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Joakim.Tjernlund@transmode.se
Subject: Re: [PATCH] Allow times and time system calls to return small
 negative values
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081204154044.GC18293@elte.hu>
References: <20081204075751.GA32594@elte.hu>
	<18743.46549.833800.667962@cargo.ozlabs.ibm.com>
	<20081204154044.GC18293@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 4 Dec 2008 16:40:44 +0100

> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > Ingo Molnar writes:
> > 
> > > > +	force_successful_syscall_return();
> > > >  	return compat_jiffies_to_clock_t(jiffies);
> > > 
> > > just curious: what code does force_successful_syscall_return() actually 
> > > run in the powerpc case - those bits are missing from this patch. I 
> > > suspect it sets some sort of flag?
> > 
> > It sets the TIF_NOERROR thread flag, which is tested in the syscall 
> > exit path along with various other thread flags.
> > 
> > force_successful_syscall_return() is defined for powerpc in 
> > arch/powerpc/include/asm/ptrace.h.  It's nothing new, it has existed 
> > for ages and is used in a few other places already.  It has existing 
> > non-null definitions on alpha, ia64, powerpc, and sparc64.
> 
> ok, was just curious. To make this code nicer, we could keep the time 
> syscalls from returning small negative numbers.
> 
> the core issue is probably:
> 
>  jiffies.h:#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> 
> the thing is, we did INITIAL_JIFFIES to find _in kernel_ jiffies 
> wraparoudn bugs (hung timers, broken drivers, etc.) - we did not want to 
> confuse userspace with it.
> 
> So how about adding INITIAL_JIFFIES to the sys_times() return value?

I can't believe people are still making suggestions which just paper
over this issue. :-)

This thing is going to wrap eventually, so wouldn't it be nice to wrap
IMMEDIATELY so that you can trigger the problem and get it really
fixed now?  And that's exactly how things work at the moment.

On another note, this wouldn't be an issue if x86 did some condition
code thing to indicate errors.  We all know this.  So why don't we put
some kind of condition code setting support into the x86 syscall
return path now and perhaps 5 years from now the userspace on most
Linux machines will understand it and this bug will be essentially gone?


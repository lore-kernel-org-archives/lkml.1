Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYLDPm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYLDPm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbYLDPlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:41:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51291 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104AbYLDPk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:40:59 -0500
Date: Thu, 4 Dec 2008 16:40:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Joakim.Tjernlund@transmode.se
Subject: Re: [PATCH] Allow times and time system calls to return small
	negative values
Message-ID: <20081204154044.GC18293@elte.hu>
References: <18743.25968.602602.875295@drongo.ozlabs.ibm.com> <20081204075751.GA32594@elte.hu> <18743.46549.833800.667962@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18743.46549.833800.667962@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > > +	force_successful_syscall_return();
> > >  	return compat_jiffies_to_clock_t(jiffies);
> > 
> > just curious: what code does force_successful_syscall_return() actually 
> > run in the powerpc case - those bits are missing from this patch. I 
> > suspect it sets some sort of flag?
> 
> It sets the TIF_NOERROR thread flag, which is tested in the syscall 
> exit path along with various other thread flags.
> 
> force_successful_syscall_return() is defined for powerpc in 
> arch/powerpc/include/asm/ptrace.h.  It's nothing new, it has existed 
> for ages and is used in a few other places already.  It has existing 
> non-null definitions on alpha, ia64, powerpc, and sparc64.

ok, was just curious. To make this code nicer, we could keep the time 
syscalls from returning small negative numbers.

the core issue is probably:

 jiffies.h:#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

the thing is, we did INITIAL_JIFFIES to find _in kernel_ jiffies 
wraparoudn bugs (hung timers, broken drivers, etc.) - we did not want to 
confuse userspace with it.

So how about adding INITIAL_JIFFIES to the sys_times() return value?

	Ingo

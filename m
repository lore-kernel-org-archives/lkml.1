Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYCUNwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYCUNwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbYCUNwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:52:11 -0400
Received: from www.tglx.de ([62.245.132.106]:57083 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbYCUNwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:52:08 -0400
Date: Fri, 21 Mar 2008 14:50:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 6/8] ptrace: arch_ptrace -ENOSYS return
In-Reply-To: <20080320081658.0B23826F995@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0803211441180.3781@apollo.tec.linutronix.de>
References: <20080319211714.8B14226F995@magilla.localdomain> <20080319212024.EA03126F995@magilla.localdomain> <alpine.LFD.1.00.0803191935080.3020@woody.linux-foundation.org> <20080320081658.0B23826F995@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008, Roland McGrath wrote:
> > Wouldn't it be nicer to just let "arch_ptrace()" return a flag saying 
> > whether it handled things or not?
> 
> It would certainly be nicer.  I would prefer:
> 
> extern int arch_ptrace(struct task_struct *child, long request,
>        	    	       long addr, long data, long *retval);
> 
> where it returns an error code or it returns 0 and *retval is the value
> or it returns 1 and it didn't do anything.
>
> So this ugliness seemed like a better bet than waiting for 20 more
> arch sign-offs before any of it could go in.  You are certainly in a
> position to just change the generic signature and make every arch do
> the update (or fix your typos if you just tweak them all blind), and
> let them grumble.  I did not presume to do so.

What about adding a CONFIG_ARCH_HAS_PTRACE2, which is set by the archs
which are converted. For those which are not you add a fallback
implementation:

#ifndef CONFIG_ARCH_HAS_PTRACE2
static int arch_ptrace2(whatever your favourite interface)
{
	ret = arch_ptrace();
	return do_ugly_fixups(ret);
}
#endif

That way you introduce the new interface and convert one or two archs
initialy without breaking the other 22.

At the same time you mark arch_ptrace() deprecated so it will get the
attention of the arch maintainers pretty fast. Once all archs are
converted we can remove the config flag and the fallback quirk.

Thanks,
	tglx

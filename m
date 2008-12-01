Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbYLAWsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYLAWsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 17:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYLAWry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 17:47:54 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45164 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYLAWrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 17:47:53 -0500
Date: Mon, 1 Dec 2008 22:47:13 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: penberg@cs.helsinki.fi, rjw@sisk.pl, miles.lane@gmail.com,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       htejun@gmail.com, vegard.nossum@gmail.com, rostedt@goodmis.org,
       arjan@infradead.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
 at ffff8800be8b0019
In-Reply-To: <20081201125103.db4c026f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0812012240080.18893@blonde.anvils>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>
 <200811270026.37941.rjw@sisk.pl> <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
 <Pine.LNX.4.64.0811271349040.21910@blonde.site>
 <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
 <Pine.LNX.4.64.0811271643250.9618@blonde.site> <20081201125103.db4c026f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Andrew Morton wrote:
> On Thu, 27 Nov 2008 17:34:27 +0000 (GMT)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > --- 2.6.28-rc6/include/linux/ftrace.h	2008-11-02 23:17:56.000000000 +0000
> > +++ linux/include/linux/ftrace.h	2008-11-27 16:39:26.000000000 +0000
> > @@ -231,7 +231,7 @@ ftrace_init_module(unsigned long *start,
> >  
> >  struct boot_trace {
> >  	pid_t			caller;
> > -	char			func[KSYM_NAME_LEN];
> > +	char			func[KSYM_SYMBOL_LEN];
> >  	int			result;
> >  	unsigned long long	duration;		/* usecs */
> >  	ktime_t			calltime;
> 
> The ftrace.h change causes this:
> 
> In file included from arch/x86/kernel/machine_kexec_64.c:14:
> include/linux/ftrace.h:234: error: 'MODULE_NAME_LEN' undeclared here (not in a function)

Damn, I'm very sorry for landing you with that discovery.

> 
> The fault really lies with include/linux/kallsyms.h, I think:
> 
> #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
>                          2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)

MODULE_NAME_LEN is a big clue I completely ignored.

> 
> but it doesn't include module.h, so it requires that users of this
> header perform the include.
> 
> But I'm a bit reluctant to include module.h from kallsyms.h because
> kallsyms.h is a simple low-level thing:

Yes, I'd be a bit reluctant too, particularly at this stage.

> 
> #include <linux/errno.h>
> #include <linux/kernel.h>
> #include <linux/stddef.h>
> 
> and it wouldn't surprise me if module.h was including kallsyms.h by
> some means.
> 
> So for now I'll try including module.h from ftrace.c.  It would be nice
> to fix the kallsyms.h dependency..

You ended up choosing ftrace.h, which seems more to the point.

Thank you for doing the work I should never have given you.

Hugh

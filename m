Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYKGRsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYKGRsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbYKGRsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:48:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:12082 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYKGRsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qjLJt5ZU8a5G6QEJM/FgelQOFE3fmR9txyp6SeTuzonC8+VOv0x4Ga82TiLjqFH1pi
         l8IJNvYNF5gGZ1W0FTg22RMGM7AX4QFITBW1ytLUsLq7j10unNBw/nxWN0HIUIInId4y
         IfVOPAVRRwpMlhtlMTIowR/FwlWRSnB27QR34=
Date: Fri, 7 Nov 2008 20:51:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081107175157.GB3469@x200.localdomain>
References: <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <20081107084943.GA16147@x200.localdomain> <20081107085352.GA27245@elte.hu> <20081107090304.GA30540@elte.hu> <20081107011659.98d3788a.akpm@linux-foundation.org> <20081107092902.GB7787@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107092902.GB7787@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 10:29:02AM +0100, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 7 Nov 2008 10:03:04 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > task running on this CPU:
> > > 
> > >  # cat /proc/self/stack
> > >  [<ffffffff80216f79>] save_stack_trace_tsk+0x26/0x44
> > >  [<ffffffff802f59a5>] proc_pid_stack+0x6e/0xd3
> > >  [<ffffffff802f6da3>] proc_info_read+0x68/0xba
> > >  [<ffffffff802b2f17>] vfs_read+0xa9/0xe3
> > >  [<ffffffff802b301f>] sys_read+0x4c/0x73
> > >  [<ffffffff8020c23b>] system_call_fastpath+0x16/0x1b
> > >  [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > So we provide a means by which process A can sample process B's 
> > instruction pointer?  Even if it's in random.c or crypto code?  
> > There's a little project for someone.
> 
> yes - like "echo p > /proc/sysrq-trigger" and sysrq-t. Although unlike 
> sysrq-p, the IP itself isnt printed, just the stack trace - but 
> there's indeed a correlation.
> 
> > I guess the 0400 mode on that file will suffice...
> 
> correct, 0400 is used already in the present patch:
> 
>  phoenix:~> cat /proc/1/stack
>  cat: /proc/1/stack: Permission denied
> 
> but that is _not_ enough, it should be narrowed even more, to the 
> boundaries that i pointed out in my first review feedback mail, and 
> which is not implemented yet:
> 
>  1) only root should be allowed to do this - i.e. file needs to be 
>     root-owned.
>
>  2) there also needs to be a .config entry for folks to be able to
>     turn it off altogether - just like folks can turn off sysrq-t 
>     dumping via the .config.

In the name of everything holy, don't add another config option.
It's a _tiny_ piece of code and you have select STACKTRACE via
fault injection, latencytop or lockdep before that.

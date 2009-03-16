Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbZCPWmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbZCPWmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZCPWmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:42:08 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:52659 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbZCPWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:42:07 -0400
Subject: Re: VMI broken on tip/master...
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49BC4196.3070204@goop.org>
References: <1236966968.14680.15.camel@alok-dev1>
	 <49BC4196.3070204@goop.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 16 Mar 2009 15:42:04 -0700
Message-Id: <1237243324.5906.13.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 16:45 -0700, Jeremy Fitzhardinge wrote:
> Alok Kataria wrote:
> > Hi Peter, 
> >
> > I was seeing a early fault when running tip/master with VMI enabled on
> > VMware platform. 
> > This early fault was in the vmi_patch code where we are applying
> > paravirt_alternatives. After some trials i noticed that this is
> > reproducible only with CONFIG_TRACING. With that disabled my VM boots
> > again. 
> >
> > I started a git bisect after that, and git pointed to this as the bad
> > commit
> >
> > commit 6cc3c6e12bb039047974ad2e7e2d46d15a1b762f
> >     trace_clock: fix preemption bug
> >
> > I then reverted that commit from tip/master and the system did boot. 
> > But I fail to understand how this simple patch would be causing things
> > to fail in VMI. Any ideas ?
> >   
> 
> Nope.  My first guess is that this is a misbisection, but the fact that 
> reverting helps tends to undermine that diagnosis.
> 
> What crash are you seeing?  What kind of fault?  At what instruction?  

It being a early fault, nothing is printed on the console the system
just stays stuck in this early_fault code in arch/x86/kernel/head_32.S

I don't understand why is this not printing anything at this early fault
though, the system just enters the hlt_loop and stays there.

> Doing what?  It's a bit hard to tell what you're actually seeing.
I did some more debugging and I think i know what the problem is 
The objdump for trace_clock_local looks like this

c1070c24 <trace_clock_local>:
c1070c24:       55                      push   %ebp
c1070c25:       89 e5                   mov    %esp,%ebp
c1070c27:       53                      push   %ebx
c1070c28:       83 ec 08                sub    $0x8,%esp
c1070c2b:       ff 15 5c 87 3d c1       call   *0xc13d875c
c1070c31:       ba 64 87 3d c1          mov    $0xc13d8764,%edx
c1070c36:       89 45 f4                mov    %eax,0xfffffff4(%ebp)
c1070c39:       ff 12                   call   *(%edx)		<<=====*
c1070c3b:       e8 cd 68 f9 ff          call   c100750d <sched_clock>
c1070c40:       89 c1                   mov    %eax,%ecx
c1070c42:       8b 45 f4                mov    0xfffffff4(%ebp),%eax
c1070c45:       ff 15 60 87 3d c1       call   *0xc13d8760

Notice instruction on c1070c39 we have "call *(edx)",
edx was just loaded with the address for the paravirt call.
when we try to replace that to a call to vmi specific function, maybe we
hit a BUG_ON(len < 5) in vmi's patch_internal code, because now the
instruction length is less than 5.

Is there is a way to get GCC to not do such fancy tricks, and instead do
a direct "call 0xc13d8764"  ?

Thanks,
Alok
> 
> Does reverting the text_poke() changes make a difference?
> 
>     J


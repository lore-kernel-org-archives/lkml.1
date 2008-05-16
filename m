Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYEPNiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYEPNiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbYEPNiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:38:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbYEPNiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:38:05 -0400
Date: Fri, 16 May 2008 09:36:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec based hibernation: a prototype of kexec
	multi-stage load
Message-ID: <20080516133658.GE6926@redhat.com>
References: <20080513053408.GA5870@redhat.com> <1210730266.23707.50.camel@caritas-dev.intel.com> <20080514025607.GA19944@redhat.com> <1210736275.23707.62.camel@caritas-dev.intel.com> <m1lk2c4l4i.fsf@frodo.ebiederm.org> <1210827473.23707.133.camel@caritas-dev.intel.com> <20080516020043.GC6926@redhat.com> <1210904374.23707.178.camel@caritas-dev.intel.com> <m1tzgzez4f.fsf@frodo.ebiederm.org> <1210913568.23707.230.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210913568.23707.230.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 12:52:48PM +0800, Huang, Ying wrote:
> On Thu, 2008-05-15 at 19:55 -0700, Eric W. Biederman wrote:
> > "Huang, Ying" <ying.huang@intel.com> writes:
> > 
> > > The disadvantage of this solution is that kernel B must know it is
> > > original kernel (A) or kexeced kernel (B). Different code should be used
> > > by kernel A and kernel B. And after jump from A to B, jump from B to A,
> > > when jump from A to B again, kernel A must use different code from the
> > > first time.
> > 
> > I don't know what the case is for keeping two kernels in memory and switching
> > between them.
> 
> This can be used to save the memory image of kernel B and accelerate the
> hibernation. The real boot of kernel B is only needed first time.
> 
> > I suspect a small piece of trampoline code between the two kernels could
> > handle the case. (i.e. purgatory pays attention).
> > 
> > That is a fundamental aspect of the design.  A general purpose infrastructure
> > with trampoline code to adapt it to whatever situation comes up.
> 
> It is possible to use purgatory to deal with this problem.
> 
> Jump from kernel A to kernel B
>     Jump to entry of purgatory (purgatory_entry)
>     purgatory save the return address (kexec_jump_back_entry_A)
>     Purgatory set kexec_jump_back_entry for kernel B to a code
>         segment in purgatory, say kexec_jump_back_entry_A_for_B
>     Purgatory jump to entry point of kernel B
> Jump from kernel B to kernel A
>     Jump to purgatory (kexec_jump_back_entry_A_for_B)
>     Purgatory save the return address (kexec_jump_back_entry_B)
>     Purgatory return to kernel A (kexec_jump_back_entry_A)
> Jump from kernel A to kernel B again
>     Jump to entry of purgatory (purgatory_entry)
>     Purgatory save the return address (kexec_jump_back_entry_A)
>     Purgatory jump to kexec_jump_back_entry_B
> 
> The disadvantage of this solution is that some information is saved in
> purgatory (kexec_jump_back_entry_A, kexec_jump_back_entry_B). So,
> purgatory must be saved too when save the memory image of kernel A or
> kernel B. Purgatory can be seen as a part of kernel B. But it is a
> little tricky to think it as a part of kernel A too.

That's a good point. Remembering the actual return points in purgatory
will require purgatory to be saved along with core file.

I think, purgatory is a good infrastructure for transitions between the
kernels but at the same time, here it is a matter of just making a "call"
and then inspecting the stack in kexec_jump_back_entry. IMHO, we can keep it
simple and not involving purgatory in later transitions.

Thanks
Vivek

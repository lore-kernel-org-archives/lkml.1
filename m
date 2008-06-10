Return-Path: <linux-kernel-owner+w=401wt.eu-S1751234AbYFJIBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbYFJIBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYFJIBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:01:45 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37067 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbYFJIBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:01:44 -0400
Date: Tue, 10 Jun 2008 17:01:43 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com,
       Samuel Thibault <samuel.thibault@eu.citrix.com>
Subject: Re: [PATCH] xen: Use wmb instead of rmb in xen_evtchn_do_upcall().
Message-ID: <20080610080143.GJ24381%yamahata@valinux.co.jp>
References: <20080610073532.GG24381%yamahata@valinux.co.jp> <200806101741.39871.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806101741.39871.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 05:41:39PM +1000, Nick Piggin wrote:
> On Tuesday 10 June 2008 17:35, Isaku Yamahata wrote:
> > This patch is ported one from 534:77db69c38249 of linux-2.6.18-xen.hg.
> > Use wmb instead of rmb to enforce ordering between
> > evtchn_upcall_pending and evtchn_pending_sel stores
> > in xen_evtchn_do_upcall().
> 
> There are a whole load of places in the kernel that should be using
> smp_ variants of memory barriers. This seemed to me like one of them,
> but I could be wrong.

Thank you for your comment.
Non smp_ version is intentionally used.
Because here the synchronization is done between other guest kernel
which might be running on another physical cpu. So non smp version is
really necessary even if this kernel is build for UP.


> Also, if you do that can you get rid of the ifdef? If it really *really*
> mattered, we could introduce smp_mb before/after xchg... but if you
> use smp_wmb anyway then it definitely does not matter because that is a
> noop on x86.

To be honest, I don't know whether the overhead of mb here matters
on x86 or not. I'm wondering Jeremy might have an idea.


>
> 
> Thanks,
> Nick
> 
> >
>  Cc: Samuel Thibault <samuel.thibault@eu.citrix.com>
> > Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
> > ---
> >  drivers/xen/events.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 73d78dc..332dd63 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -529,7 +529,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
> >
> >  #ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86.
> > */ /* Clear master flag /before/ clearing selector flag. */
> > -		rmb();
> > +		wmb();
> >  #endif
> >  		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
> >  		while (pending_words != 0) {
> 

-- 
yamahata

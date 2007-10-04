Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbXJDNul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbXJDNul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 09:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXJDNud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 09:50:33 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:52071 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbXJDNud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 09:50:33 -0400
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, akpm@linux-foundation.org, wfg@mail.ustc.edu.cn,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-reply-to: <1191504186.22357.20.camel@twins> (message from Peter Zijlstra on
	Thu, 04 Oct 2007 15:23:06 +0200)
Subject: Re: [PATCH] remove throttle_vm_writeout()
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	 <1191501626.22357.14.camel@twins>
	 <E1IdQJn-0002Cv-00@dorka.pomaz.szeredi.hu> <1191504186.22357.20.camel@twins>
Message-Id: <E1IdR58-0002Fq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Oct 2007 15:49:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Which can only happen when it is larger than 10% of dirty_thresh.
> > > 
> > > Which is even more unlikely since it doesn't account nr_dirty (as I
> > > think it should).
> > 
> > I think nr_dirty is totally irrelevant.  Since we don't care about
> > case 1), and in case 2) nr_dirty doesn't play any role.
> 
> Ah, but its correct to have since we compare against dirty_thresh, which
> is defined to be a unit of nr_dirty + nr_unstable + nr_writeback. if we
> take one of these out, then we get an undefined amount of space extra.

Yeah, I guess the point of the function was to limit nr_write to
_anything_ smaller than the total memory.

> > > As for 2), yes I think having a limit on the total number of pages in
> > > flight is a good thing.
> > 
> > Why?
> 
> for my swapping over network thingies I need to put a bound on the
> amount of outgoing traffic in flight because that bounds the amount of
> memory consumed by the sending side.

I guess you will have some request queue with limited length, no?

The main problem seems to be if devices use up all the reserved memory
for queuing write requests.  Limiting the in-flight pages is a very
crude way to solve this, the assumptions are:

O: overhead as a fraction of the request size
T: total memory
R: reserved memory
T-R: may be full of anon pages

so if (T-R)*O > R  we are in trouble.

if we limit the writeback memory to L and L*O < R we are OK.  But we
don't know O (it's device dependent).  We can make an estimate
calculate L based on that, but that will be a number totally
independent of the dirty threshold.

> > > But that said, there might be better ways to do that.
> > 
> > Sure, if we do need to globally limit the number of under-writeback
> > pages, then I think we need to do it independently of the dirty
> > accounting.
> 
> It need not be global, it could be per BDI as well, but yes.

For per-bdi limits we have the queue length.

Miklod

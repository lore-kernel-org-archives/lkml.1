Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZJIHr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZJIHr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZJIHr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:47:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbZJIHr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:47:57 -0400
Date: Fri, 9 Oct 2009 09:47:19 +0200
From: Nick Piggin <npiggin@suse.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091009074719.GE2983@wotan.suse.de>
References: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain> <20091007164622.GX30316@wotan.suse.de> <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> <87eipfymcv.fsf@basil.nowhere.org> <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain> <20091007210651.GB1656@one.firstfloor.org> <alpine.LFD.2.01.0910071417300.3432@localhost.localdomain> <alpine.LFD.2.01.0910071450510.3432@localhost.localdomain> <1158166a0910080612h29d93d50y875d5305cd4d985f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1158166a0910080612h29d93d50y875d5305cd4d985f@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 03:12:08PM +0200, Denys Vlasenko wrote:
> On Wed, Oct 7, 2009 at 11:57 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > This, btw, is exactly the kind of thing we saw with some of the
> > non-temporal work, when we used nontemporal stores to copy pages on COW
> > faults, or when doing pre-zeroing of pages. You get rid of some of the
> > hot-spots in the kernel, and you then replace them with user space taking
> > the cache misses in random spots instead. The kernel profile looks better,
> > and system time may go down, but actual performace never went down - you
> > just moved your cache miss cost from one place to another.
> 
> A few years ago when K7s were not ancient yet, after hearing
> argument for and against non-temporal stores,
> I decided to finally figure it for myself.
> 
> I tested kernel build workload on two kernels with the only
> one difference - clear_page with and without non-temporal stores.
> 
> "Non-temporal stores" kernel was faster, not slower. Just a little bit,
> but reproducibly.

It is going to be highly dependent on architecture and workload and
exactly where you use the nontemporal stores of course. I would say
with non-temporal stores in clear_page (a case where we can often
expect the memory to be used again quickly because it is anonymous
process memory), then we are quite likely to cause _more_ activity
on the memory controller and dimms which cost far more power than
cache access.


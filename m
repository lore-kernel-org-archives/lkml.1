Return-Path: <linux-kernel-owner+w=401wt.eu-S1762625AbYD3LfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762625AbYD3LfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbYD3LfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:35:03 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5285 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbYD3LfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:35:01 -0400
Date: Wed, 30 Apr 2008 13:34:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080430113456.GY12774@kernel.dk>
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com> <1209453990-7735-2-git-send-email-jens.axboe@oracle.com> <20080429135936.GC12390@linux.vnet.ibm.com> <20080430112934.GA23203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430112934.GA23203@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30 2008, Paul E. McKenney wrote:
> On Tue, Apr 29, 2008 at 06:59:36AM -0700, Paul E. McKenney wrote:
> > On Tue, Apr 29, 2008 at 09:26:21AM +0200, Jens Axboe wrote:
> > > This adds kernel/smp.c which contains helpers for IPI function calls. In
> > > addition to supporting the existing smp_call_function() in a more efficient
> > > manner, it also adds a more scalable variant called smp_call_function_single()
> > > for calling a given function on a single CPU only.
> > > 
> > > The core of this is based on the x86-64 patch from Nick Piggin, lots of
> > > changes since then. "Alan D. Brunelle" <Alan.Brunelle@hp.com> has
> > > contributed lots of fixes and suggestions as well.
> > 
> > Looks much better, but there still appears to be a potential deadlock
> > with a CPU spinning waiting (indirectly) for a grace period to complete.
> > Such spinning can prevent the grace period from ever completing.
> > 
> > See "!!!".
> 
> One additional question...  Why not handle memory allocation failure
> by pretending that the caller to smp_call_function() had specified
> "wait"?  The callee is in irq context, so cannot block, right?

(BTW a lot of thanks for your comments, I've read and understood most of
it, I'll reply in due time - perhaps not until next week, I'll be gone
from this afternoon and until monday).

We cannot always fallback to wait, unfortunately. If irqs are disabled,
you could deadlock between two CPUs each waiting for each others IPI
ack.

So the good question is how to handle the problem. The easiest would be
to return ENOMEM and get rid of the fallback, but the fallback deadlocks
are so far mostly in the theoretical realm since it PROBABLY would not
occur in practice. But still no good enough, so I'm still toying with
ideas on how to make it 100% bullet proof.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYIBO5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYIBO5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYIBO5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:57:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46670 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYIBO5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:57:30 -0400
Date: Tue, 2 Sep 2008 17:00:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Message-ID: <20080902150031.GN18288@one.firstfloor.org>
References: <20080902349.573187695@firstfloor.org> <20080902134923.9A7EF3E6A01@basil.firstfloor.org> <1220365683.8609.58.camel@twins> <20080902144051.GM18288@one.firstfloor.org> <1220366717.8609.65.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220366717.8609.65.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 04:45:17PM +0200, Peter Zijlstra wrote:
> On Tue, 2008-09-02 at 16:40 +0200, Andi Kleen wrote:
> > On Tue, Sep 02, 2008 at 04:28:03PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2008-09-02 at 15:49 +0200, Andi Kleen wrote:
> > > > panic calls smp_send_stop which eventually calls smp_call_function_*.
> > > > smp_call_function warns about disabled interrupts. But it's legal
> > > > to call panic in this case. When this happens panic() prints
> > > > several ugly backtraces. So don't check for disabled interrupts
> > > > in panic state.
> > > 
> > > While it might be legal for panic to be called from such contexts, I
> > > understand those warnings are there to warn of deadlocks.
> > > 
> > > So with the below patch you allow panic to deadlock if I understand
> > > things correctly.
> > 
> > Please describe the deadlock exactly.  I don't think it can deadlock 
> > in this case. 
> 
> Then why are those warnings there? The deadlock is for the CSD_FLAG_WAIT
> case, which can always happen due to the static csd data fallback.
> 
> The deadlock scenario is long the lines of two such smp_call_function*()
> both under irq disabled calling each other with CSD_FLAG_WAIT set.
> Neither remote cpu will handle the IPI due to irqs being disabled, so
> we'll wait at-infinitum for completion.

First smp_send_stop does not wait (or at least not pass the 
wait flag, it will still wait for the first ack like everyone else)

I don't claim to understand the new kernel/smp.c code (it seems to me quite
overdesigned and complicated and I admit I got lost in it somewhere), 
but I think your scenario would rely on a global lock and presumably there 
is none in the new code? 

> 
> > Besides do you prefer to not allow panic from interrupts/machine
> > checks etc. anymore? 
> 
> However did I imply that, I just said your fix looked iffy.

Well it would be the only alternative. Or have a timeout (I had
such a hack a long time ago) but that has also other issues.

In fact for smp_send_stop() it would be far better to just use an NMI,
but we unfortunately have a few BIOS that do not support NMI properly.

I think for 2.6.27 at least this is the best fix. At least keeping
panic that broken is no option I would say.

-Andi

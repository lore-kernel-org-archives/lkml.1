Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYIBOpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYIBOpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYIBOpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:45:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:39165 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYIBOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:45:22 -0400
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the
	system has paniced
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20080902144051.GM18288@one.firstfloor.org>
References: <20080902349.573187695@firstfloor.org>
	 <20080902134923.9A7EF3E6A01@basil.firstfloor.org>
	 <1220365683.8609.58.camel@twins>
	 <20080902144051.GM18288@one.firstfloor.org>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 16:45:17 +0200
Message-Id: <1220366717.8609.65.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 16:40 +0200, Andi Kleen wrote:
> On Tue, Sep 02, 2008 at 04:28:03PM +0200, Peter Zijlstra wrote:
> > On Tue, 2008-09-02 at 15:49 +0200, Andi Kleen wrote:
> > > panic calls smp_send_stop which eventually calls smp_call_function_*.
> > > smp_call_function warns about disabled interrupts. But it's legal
> > > to call panic in this case. When this happens panic() prints
> > > several ugly backtraces. So don't check for disabled interrupts
> > > in panic state.
> > 
> > While it might be legal for panic to be called from such contexts, I
> > understand those warnings are there to warn of deadlocks.
> > 
> > So with the below patch you allow panic to deadlock if I understand
> > things correctly.
> 
> Please describe the deadlock exactly.  I don't think it can deadlock 
> in this case. 

Then why are those warnings there? The deadlock is for the CSD_FLAG_WAIT
case, which can always happen due to the static csd data fallback.

The deadlock scenario is long the lines of two such smp_call_function*()
both under irq disabled calling each other with CSD_FLAG_WAIT set.
Neither remote cpu will handle the IPI due to irqs being disabled, so
we'll wait at-infinitum for completion.

> Besides do you prefer to not allow panic from interrupts/machine
> checks etc. anymore? 

However did I imply that, I just said your fix looked iffy.


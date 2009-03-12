Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZCLLAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZCLLAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZCLLAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:00:11 -0400
Received: from www.tglx.de ([62.245.132.106]:41124 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZCLLAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:00:09 -0400
Date: Thu, 12 Mar 2009 11:58:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/6] futex: add double_unlock_hb()
In-Reply-To: <20090312101028.GA7157@elte.hu>
Message-ID: <alpine.LFD.2.00.0903121153300.29264@localhost.localdomain>
References: <20090312075349.9856.83687.stgit@Aeon> <20090312075552.9856.48021.stgit@Aeon> <1236852455.5090.105.camel@laptop> <20090312101028.GA7157@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2009-03-12 at 00:55 -0700, Darren Hart wrote:
> > > The futex code uses double_lock_hb() which locks the hb->lock's in pointer
> > > value order.  There is no parallel unlock routine, and the code unlocks them
> > > in name order, ignoring pointer value.  This opens up a window for an ABBA
> > > deadlock.  This patch adds double_unlock_hb() to remove the window as well
> > > as refactor the duplicated code segments.
> > 
> > While I don't mind the patch per-se, I'm hard pressed to see 
> > any deadlock potential in the unordered unlock.
> > 
> > All sites (at least those in the patch) always release both 
> > locks without taking another in between, therefore one would 
> > think there's no deadlock possible.
> 
> yeah.

I can't see a deadlock either.
 
> The patch is still nice (as you mention), it factors out the 
> unlock sequence. I'll change the commit message accordingy.

We do not need the comparison magic. Can we just put the code into
double_unlock_hb() which gets replaced ?

i.e:

        spin_unlock(&hb1->lock);
        if (hb1 != hb2)
                spin_unlock(&hb2->lock);

This code is confusing enough.

Thanks,

	tglx

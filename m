Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYKTJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYKTJO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYKTJOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:14:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40985
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbYKTJON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:14:13 -0500
Date: Thu, 20 Nov 2008 01:14:13 -0800 (PST)
Message-Id: <20081120.011413.02371461.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: nickpiggin@yahoo.com.au, mingo@elte.hu, dada1@cosmosbay.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       shemminger@vyatta.com
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0811180731480.18283@nehalem.linux-foundation.org>
References: <20081117.125826.193693115.davem@davemloft.net>
	<200811182044.11055.nickpiggin@yahoo.com.au>
	<alpine.LFD.2.00.0811180731480.18283@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Nov 2008 07:58:49 -0800 (PST)

> There is obviously one very special indirect jump: "ret". That's the one 
> that is common, and that tends to have a special branch target buffer that 
> is a pure stack. And for that, there is usually a special branch target 
> register that needs to be set up 'x' cycles before the ret in order to 
> avoid the stall (then the predition is checking that register against the 
> branch target stack, which is somewhat akin to a regular conditional 
> branch comparison).

Yes, UltraSPARC has a RAS or Return Address Stack.  I think it has
effectively zero latency (ie. you can call some function, immediately
"ret" and it hits the RAS).  This is probably because, due to delay slots,
there is always going to be one instruction in between anyways. :)

> So I strongly suspect that an indirect (non-ret) branch flushes the 
> pipeline on sparc. It is possible that there is a "prepare to jump" 
> instruction that prepares the indirect branch stack (kind of a "push 
> prediction information").

It doesn't flush the pipeline, it just stalls it waiting for the
address computation.

Branches are predicted and can execute in the same cycle as the
condition-code setting instruction they depend upon.

> I suspect Java sees a lot more indirect branches than traditional
> Unix loads, so maybe Sun did do that.

There really isn't anything special done here for indirect jumps,
other than pushing onto the RAS.  Indirects just suck :)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1030772AbXCGAYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030772AbXCGAYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030775AbXCGAYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:24:16 -0500
Received: from gw.goop.org ([64.81.55.164]:54220 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030772AbXCGAYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:24:15 -0500
Message-ID: <45EE0628.1080108@goop.org>
Date: Tue, 06 Mar 2007 16:24:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Dan Hecht <dhecht@vmware.com>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com> <1173225182.24738.507.camel@localhost.localdomain>
In-Reply-To: <1173225182.24738.507.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> All paravirt users probably want to have NO_HZ, so PARAVIRT might simply
> depend on NO_HZ. Of course I might be wrong :)
>   

Xen can deal either way, but tickless is certainly preferred.

> OTOH the stolen time accounting should be fixed in general and not rely
> on it happens to work now assumptions. And it should be done for _ALL_
> hypervisors in the same way, i.e. in the generic code.
>   

Yep.  We'll need to come up with a common story for that. 

>>  This is probably something the Xen folks will want 
>> also, since I think Xen itself only gets 100hz hard timer, and so it can 
>> implement at best a oneshot virtual timer with 100hz resolution.  Any 
>> objections to us doing something like this?
>>     

Xen has a nanosecond resolution one-shot timer which I'm using for
this.  There's also a 100Hz tick which gets in the way a bit (it will
appear as a stream of spurious timeouts), but we'll turn that off soon.

>> 3) clockevent set_next_event interface is suboptimal for paravirt (and 
>> probably realtime-ish uses).  The problem is that the expiry is passed 
>> as a relative time.  On paravirt, an arbitrary amount of (stolen) time 
>> may have passed since the delta was computed and when the timer device 
>> is programmed, causing that next interrupt to be too far out in the 
>> future.  It seems a better interface for set_next_event would be to pass 
>> the current time and the absolute expiry.  Actually, I sent email to 
>> Thomas and Ingo about this (and some other clockevents/hrtimer feedback) 
>> in July 2006, but never heard back.  Thoughts?
>>     
>
> There is no problem for realtime uses, as the reprogramming path is
> running with local interrupts disabled. I can see the point for paravirt
> and I'm not opposed to change / expand the interface for that. It might
> be done by an extra clockevents feature flag, which requests absolute
> time instead of relative time.
>   

I'm not sure how much different it makes overall.  It's true that
absolute time would be a more useful interface, but because the guest
vcpu can be preempted at any time, we could miss the timeout
regardless.  In Xen if you set a timeout for the past you get an
immediate interrupt; I presume the clockevent code can deal with that?

    J

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZCLPNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZCLPNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbZCLPN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:13:27 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37429 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbZCLPN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:13:26 -0400
Message-ID: <49B92691.3010100@us.ibm.com>
Date: Thu, 12 Mar 2009 08:13:21 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/6] futex: add double_unlock_hb()
References: <20090312075349.9856.83687.stgit@Aeon> <20090312075552.9856.48021.stgit@Aeon> <1236852455.5090.105.camel@laptop> <20090312101028.GA7157@elte.hu> <alpine.LFD.2.00.0903121153300.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903121153300.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 12 Mar 2009, Ingo Molnar wrote:
>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Thu, 2009-03-12 at 00:55 -0700, Darren Hart wrote:
>>>> The futex code uses double_lock_hb() which locks the hb->lock's in pointer
>>>> value order.  There is no parallel unlock routine, and the code unlocks them
>>>> in name order, ignoring pointer value.  This opens up a window for an ABBA
>>>> deadlock.  This patch adds double_unlock_hb() to remove the window as well
>>>> as refactor the duplicated code segments.
>>> While I don't mind the patch per-se, I'm hard pressed to see 
>>> any deadlock potential in the unordered unlock.
>>>
>>> All sites (at least those in the patch) always release both 
>>> locks without taking another in between, therefore one would 
>>> think there's no deadlock possible.
>> yeah.
> 
> I can't see a deadlock either.
> 

Right, sorry, it's the double_lock that requires the test.  Duh.  I need 
to find a way to do some of this work during more regular hours I guess 
;-)  Thanks for the catch everyone.

Ingo shall I resubmit?  Or did you already clean it up?

Thanks,

Darren

>> The patch is still nice (as you mention), it factors out the 
>> unlock sequence. I'll change the commit message accordingy.
> 
> We do not need the comparison magic. Can we just put the code into
> double_unlock_hb() which gets replaced ?
> 
> i.e:
> 
>         spin_unlock(&hb1->lock);
>         if (hb1 != hb2)
>                 spin_unlock(&hb2->lock);
> 
> This code is confusing enough.
> 
> Thanks,
> 
> 	tglx


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

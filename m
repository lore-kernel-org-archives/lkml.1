Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYJWE7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYJWE7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 00:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYJWE7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 00:59:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:44221 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYJWE7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 00:59:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,468,1220252400"; 
   d="scan'208";a="454645094"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andi Kleen <ak@linux.intel.com>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Henroid, Andrew D" <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "paulmck@us.ibm.com" <paulmck@us.ibm.com>
Date: Wed, 22 Oct 2008 21:59:30 -0700
Subject: RE: [PATCH 2/2] i7300_idle driver v1.55
Thread-Topic: [PATCH 2/2] i7300_idle driver v1.55
Thread-Index: Ack0rDLx89tMeyejQQmTqPmMzd2LKgAH98SA
Message-ID: <7E82351C108FA840AB1866AC776AEC4637D389DB@orsmsx505.amr.corp.intel.com>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
 <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>
 <20081011083347.GA31918@elte.hu>
 <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain>
 <48FE07AE.4010203@linux.intel.com>
 <7E82351C108FA840AB1866AC776AEC4637CD27F3@orsmsx505.amr.corp.intel.com>
 <48FED3FA.6040703@linux.intel.com>
 <20081022234006.GB28775@linux-os.sc.intel.com>
 <48FFCF28.3070604@linux.intel.com>
In-Reply-To: <48FFCF28.3070604@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Andi Kleen [mailto:ak@linux.intel.com]
>Sent: Wednesday, October 22, 2008 6:11 PM
>To: Pallipadi, Venkatesh
>Cc: Len Brown; Ingo Molnar; linux-acpi@vger.kernel.org; Linux
>Kernel Mailing List; Henroid, Andrew D; Linus Torvalds; Thomas
>Gleixner; H. Peter Anvin; paulmck@us.ibm.com
>Subject: Re: [PATCH 2/2] i7300_idle driver v1.55
>
>>>>> ;
>>>>>> +static void __exit i7300_idle_exit(void)
>>>>>> +{
>>>>>> +     idle_notifier_unregister(&i7300_idle_nb);
>>>>> I still think this needs some kind of idle synchronization.
>>>> This unregister uses atomic_notifier_chain_unregister() which
>>>> uses RCU and handles the race conditions that way.
>>> I didn't do a full analysis, but I didn't think RCU protects
>>> against the idle handler itself.  At least not standard RCU.
>>> You would need to go through at least two quiescent periods,
>>> not one as standard code.
>>>
>>> There used to be an older
>>> idle synchronization interface for this case (which was removed
>>> at some point), perhaps it needs to be readded.
>>>
>>> Or just use stop_machine(). That protects against idle too
>>> and while it's a big hammer for unloading it should be ok.
>>>
>>
>> stop_machine() for unregistering idle callback will deadlock
>due to RCU.
>>
>> I am not sure why we need two cycles. RCU in the unregister makes
>> sure that no CPU is executing the callback handler
>> and only then unregister
>> returns. So, that will mean no one can be in the callback
>rountine and we are
>> safe to remove the module. Correct?
>
>Perhaps I'm confused, but I thought with noidlehz the RCU code
>got changed to take out idle CPUs out of the rcu masks. This makes
>normally sense because you don't want to delay the grace period
>for potentially very long sleeping CPUs.
>
>But it means it won't work for code inside the idle loop. Ok maybe
>if you're very careful with the ordering, but I'm not sure that's
>the case currently.
>
>Yes two cycles won't work either, sorry was confused earlier,
>because even the second cycle wouldn't force the CPU out of idle.
>
>The old idle sync code was more a thread that just cycled through
>all the CPus. That would work.
>

This should not matter as we can safely remove the module even when
one or more CPUs are idle. As long as one CPU is running, we are sure
that throttling is not in effect. And as long as we make sure no one
is executing the notifier that is going to be rmmoded, we should
be OK. Say one CPU comes out of the idle later, it wont see the notifier
in the notifier list anymore, because of RCU in atomic notifier
and things will work fine. I mean we are not rmmoding the routine
that enters the idle state. We are just rmmoding the routine that
Can get called before and after idle routine.

Thanks,
Venki

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZEKO7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZEKO7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZEKO7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:59:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47274 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017AbZEKO7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:59:22 -0400
Date: Mon, 11 May 2009 16:59:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
	SVM
Message-ID: <20090511145903.GB737@elte.hu>
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu> <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu> <4A083B69.6010702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A083B69.6010702@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

>> And only do it if there's other tasks running on this CPU or so.
>
> What would happen if there weren't?  I'd guess the task would 
> continue running (but with a warped vruntime)?

We dont want that warping to occur - we just want to go back and 
burn CPU time in VM context. The problem is (as Peter pointed it 
out) that this hw facility is incomplete and does not give us any 
event (interrupt) and does not give us any event key (address we are 
waiting for) either.

So the next best thing to do is to go back to the guest, because 
that is where we make the most progress, more likely, and that is 
where we want to be to make progress immediately, with the shortest 
latency.

( Perhaps we could also increase vruntime beyond the standard 
  latency value to make sure any freshly woken task gets executed 
  first if we are still looping. )

>> _That_ would be pretty efficient, and would do the right thing when  
>> two (or more) vcpus run on the same CPU, and it would also do the  
>> right thing if there are repeated VM-exits due to pause filtering.
>>
>> Please dont even think about using yield for this though - that will  
>> just add a huge hit to this task and wont result in any sane behavior - 
>> and yield is bound to some historic user-space behavior as well.
>>
>> A gradual and linear back-off from the current timeline is more of a  
>> fair negotiation process between vcpus and results in more or less  
>> sane (and fair) scheduling, and no unnecessary looping.
>>
>> You could even do an exponential backoff up to a limit of 1-10 msecs  
>> or so, starting at 100 usecs.
>>   
>
> Good idea, it eliminates another variable to be tuned.

It could be made fully self-tuning, if the filter threshold can be 
tuned fast enough. (an MSR write? A VM context field update?)

I.e. the 3000 cycles value itself could be eliminated as well. (with 
just a common-sense max of say 100,000 cycles enforced)

	Ingo

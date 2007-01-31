Return-Path: <linux-kernel-owner+w=401wt.eu-S964827AbXAaPKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827AbXAaPKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964899AbXAaPKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:10:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50083 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964827AbXAaPKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:10:15 -0500
Date: Wed, 31 Jan 2007 20:40:00 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Eric Piel <Eric.Piel@tremplin-utc.net>
Cc: Kirill Korotaev <dev@sw.ru>, riel@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fair-user scheduler
Message-ID: <20070131151000.GB14145@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070126060142.GA2487@in.ibm.com> <45BA0B7C.1090304@sw.ru> <45BA4E01.6050303@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA4E01.6050303@tremplin-utc.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 07:52:49PM +0100, Eric Piel wrote:
> >>		 	user "vatsa"		    user "guest"
> >>		    (make -s -j4 bzImage)      (make -s -j20 bzImage)
> >>
> >>2.6.20-rc5		472.07s (real)		   257.48s (real)
> >>2.6.20-rc5+fairsched	766.74s (real)		   766.73s (real)
> >
> >1. If I interpret these numbers correctly, then your scheduler is not 
> >work-conservative,
> >i.e. 766.74 + 766.73 >> 472.07 + 257.48
> >why does it slow down users so much?

Ok, I investigated this a bit. The "1-sec" control window was the
killer. I guess it was causing too much of thrashing. I increased the
control window to 10 sec [1] and I get decent results now.

NOTE : Since the patches don't support SMP load-balancing currently, 
all benchmarks were run on only ONE cpu (using cpuset's cpu_exclusive
feature) and hence the numbers are indicative of UP performance.

First, results of kernel compilation:


-------------------------------------------------------------------------------
					vatsa			 guest
				  (make -j4 bzImage)	  (make -j20 bzImage)
-------------------------------------------------------------------------------

2.6.20-rc5 			       767.16s (real)	       495.98s (real)
2.6.20-rc5 + fairsched (W=10s) 	       765.89s (real)	       764.89s (real)

-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
					vatsa			 guest
			          (make -j4 bzImage)    (nice make -j20 bzImage)
-------------------------------------------------------------------------------

2.6.20-rc5 				767.16s (real)	       636.51s (real)
2.6.20-rc5 + fairsched (W=10s) 		761.19s (real)	       766.51s (real)

-------------------------------------------------------------------------------

Second, results of volanomark benchmark [2].

Both users, vatsa and guest, ran a copy of volano server on different ports. 
Each user then launched the volano client on respective ports and
throughput of the client was measured. Ideally we want the throughput to
be same for both user.


-------------------------------------------------------------------------------
					vatsa			guest	
				(volano server/client)   (volano server/client)
-------------------------------------------------------------------------------

2.6.20-rc5			  400000 msg in 39.495s    400000 msg in 39.528s
				      (10128 msg/sec)	      (10119 msg/sec)

2.6.20-rc5 + fairsched (W=10s)    400000 msg in 39.662s    400000 msg in 39.646s
				      (10085 msg/sec)	      (10089 msg/sec)
				
-------------------------------------------------------------------------------


Here we dont see much difference between vanilla kernel and the patch
because number of threads spawned by both users are same. 

Kirill, did you have any other specific volano configuration in mind?

> Actually, I'd be very interested by a "fairness number" and believe so 
> far no one as proposed such thing. Probably needs to take into account 
> the loss of CPU power and the variance of execution time in between the 
> sets of tasks which are supposed to be fair.

Yeah, in my patch, I dont account/limit execution time of root tasks at
all. That needs to be factored in when we distribute left over cycles to
non-root users (which I dont think I have addressed in my current
patch).

> >2. compilation of kernel is quite CPU-bound task. So it's not that hard to 
> >be fair :)
> >   Can you please try some other applications?
> >   e.g. pipe-based context switching, java Volano benchmark etc.

Kirill, I have provided volano numbers above. Did you have any specific
volano configuration in mind to be tested?

Also do you have a pointer to a ready pipe-based benchmark I can use?

> Another worthy benchmark would be :
> (make -s -j4 bzImage) vs (nice make -s -j20 bzImage)
>                           ^^^^

I have provide the result of above benchmark also.


References:

1. http://lkml.org/lkml/2007/01/31/138

2. Volanomark benchmark configuration details:

java.vendor        = IBM Corporation
java.vendor.url    = http://www.ibm.com/
java.version       = 1.4.2
java.class.version = 48.0
java.compiler      = j9jit22
os.name            = Linux
os.version         = 2.6.20-rc5-1k
os.arch            = amd64

VolanoMark version = 2.5.0.9
Messages sent      = 20000
Messages received  = 380000
Total messages     = 400000





-- 
Regards,
vatsa

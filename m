Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbZCSTcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbZCSTcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZCSTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:31:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35094 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759401AbZCSTbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:31:51 -0400
Message-ID: <49C29DA2.2050605@linux.vnet.ibm.com>
Date: Thu, 19 Mar 2009 12:31:46 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC 1/2] perfcounters: provide a way to read the current
 value of interrupting counters
References: <18879.14425.221429.861838@drongo.ozlabs.ibm.com> <1237275169.5189.58.camel@laptop> <18879.21884.162961.690031@cargo.ozlabs.ibm.com> <1237279060.5189.141.camel@laptop> <18879.27296.307613.67496@cargo.ozlabs.ibm.com>
In-Reply-To: <18879.27296.307613.67496@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
>>> It was specifically requested by people porting PAPI to PCL, and it
>>> seems like a reasonable request.
>> OK, then why didn't the changelog say so :-)
> 
> Fair point. :)
> 
>> Could you ask them why though, if they need it I won't object too much,
>> but I'd like to know the use case.
> 
> PAPI has the concept of "overflowing" counters, apparently, which
> generate a signal every N counts, about which they said: "One thing to
> keep in mind, you should always be able to read a live counter,
> regardless of whether or not it's set to overflow..."
> 
> I assume the PAPI interface lets you do everything with overflowing
> counters that you can do with non-overflowing counters, and that's why
> they want it, but I don't know much about PAPI myself.
> 
>> As to the method proposed, I think Ingo and I talked about 'abusing'
>> non-blocking reads for this purpose, would that work? Then if you need
>> two fds you could dup() and flip one to non-blocking.
> 
> The non-blocking flag is one of the "file status" flags, which are
> shared between all fds pointing at the same struct file.  So if you
> dup() and set one to non-blocking, the other one becomes non-blocking
> too.  So that doesn't fly.
> 
>> The non-blocking read would either output whatever is already pending,
>> but in case there is no data, it would generate some on the spot.
> 
> The difficulty then is how userspace does know what it ended up
> getting?  It may not always be possible to distinguish based on the
> value you get.
> 
> The other idea I had was to use the file position, and say that
> positions greater than some threshold read the event queue, and less
> than the threshold read the counter value.  That way you can read the
> event queue with read() and the counter value with pread(..., 0).
> 
> The objection to that is that the threshold is a bit artificial, and
> would need to be different between interrupting and counting
> counters.  Also we may need to do strange things to file->f_pos like
> initializing it to the (non-zero) threshold when opening an
> interrupting counter.
> 

This could be a reason for getting rid of the purely interrupting 
counter record type.  That way, you always read at the [artificial] 
offset to read the event queue for counters with a non-zero irq_period, 
and always at offset zero to read the current counter value.

It would work similarly well for the other idea of creating a cloned fd. 
  The fd returned from the initial open is always used for reading the 
current value, and the cloned one is for reading the event queue.

Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com


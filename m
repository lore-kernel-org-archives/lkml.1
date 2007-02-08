Return-Path: <linux-kernel-owner+w=401wt.eu-S1423268AbXBHWwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423268AbXBHWwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423315AbXBHWwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:52:10 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:60467 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423268AbXBHWwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:52:06 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
	patch
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, Milton Miller <miltonm@bga.com>,
       linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net
In-Reply-To: <200702081821.57358.arnd@arndb.de>
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com>
	 <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com>
	 <b682962303654f4958a6c2c50d805907@bga.com>
	 <200702081821.57358.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 14:51:59 -0800
Message-Id: <1170975119.5204.99.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 18:21 +0100, Arnd Bergmann wrote:
> On Thursday 08 February 2007 15:18, Milton Miller wrote:
>  
> > 1) sample rate setup
> > 
> >     In the current patch, the user specifies a sample rate as a time 
> > interval.
> >     The kernel is (a) calling cpufreq to get the current cpu frequency, 
> > (b)
> >     converting the rate to a cycle count, (c) converting this to a 24 bit
> >     LFSR count, an iterative algorithm (in this patch, starting from
> >     one of 256 values so a max of 2^16 or 64k iterations), (d) 
> > calculating
> >     an trace unload interval.   In addition, a cpufreq notifier is 
> > registered
> >     to recalculate on frequency changes.

No.  The user issues the command opcontrol --event:N  where N is the
number of events (cycles, l2 cache misses, instructions retired etc)
that are to elapse between collecting the samples.  The OProfile passes
the value N to the kernel via the variable ctr[i].count.  Where i is the
performance counter entry for that event.  Specifically with SPU
profiling, we do not use performance counters because the CELL HW does
not allow the normal the PPU to read the SPU PC when a performance
counter interrupt occurs.  We are using some additional hw support in
the chip that allows us to periodically capture the SPU PC.  There is an
LFSR hardware counter that can be started at an arbitrary LFSR value.
When the last LFSR value in the sequence is reached, a sample is taken
and stored in the trace buffer.  Hence, the value of N specified by the
user must get converted to the LFSR value that is N from the end of the
sequence.  The same clock that the processor is running at is used to
control the LFSR count.  Hence the LFSR counter increments once per CPU
clock cycle regardless of the CPU frequency or changes in the frequency.
There is no calculation for the LFSR value that is a function of the
processor frequency.  There is no need to adjust the LFSR when the
processor frequency changes.  

Milton had a comment about the code 

 if (ctr[0].event == SPU_CYCLES_EVENT_NUM) {
> +             spu_cycle_reset = ctr[0].count;
> +             return;
> +     }

Well, given the above description, it is clear that if you are doing SPU
event profiling, the value N is put into the cntr[0].cnt entry since
there is only one event.  Thus in cell_global_start_spu() you use
spu_cycle_reset as the argument to the lfsr calculation routine to get
the LFSR value that is N from the end of the sequence.

> > 
> >     The obvious problem is step (c), running a loop potentially 64 
> > thousand
> >     times in kernel space will have a noticeable impact on other threads.
> > 
> >     I propose instead that user space perform the above 4 steps, and 
> > provide
> >     the kernel with two inputs: (1) the value to load in the LFSR and (2)
> >     the periodic frequency / time interval at which to empty the hardware
> >     trace buffer, perform sample analysis, and send the data to the 
> > oprofile
> >     subsystem.
> > 
> >     There should be no security issues with this approach.   If the LFSR 
> > value
> >     is calculated incorrectly, either it will be too short, causing the 
> > trace
> >     array to overfill and data to be dropped, or it will be too long, and
> >     there will be fewer samples.   Likewise, the kernel periodic poll 
> > can be
> >     too long, again causing overflow, or too frequent, causing only timer
> >     execution overhead.
> > 
> >     Various data is collected by the kernel while processing the 
> > periodic timer,
> >     this approach would also allow the profiling tools to control the
> >     frequency of this collection.   More frequent collection results in 
> > more
> >     accurate sample data, with the linear cost of poll execution 
> > overhead.
> > 
> >     Frequency changes can be handled either by the profile code setting
> >     collection at a higher than necessary rate, or by interacting with 
> > the
> >     governor to limit the speeds.
> > 
> >     Optionally, the kernel can add a record indicating that some data was
> >     likely dropped if it is able to read all 256 entries without 
> > underflowing
> >     the array.  This can be used as hint to user space that the kernel 
> > time
> >     was too long for the collection rate.
>  
> Moving the sample rate computation to user space sounds like the right
> idea, but why not have a more drastic version of it:

No, I do not agree.  The user/kernel API pass N where N is the number of
events between samples.  We are not at liberty to just change the API.
We we did do this, we fully expect that John Levon will push back saying
why make an architecture specific API change when it isn't necessary.  

Please define "drastic" in this context.  Do you mean make the table
bigger i.e. more then 256 precomputed elements?  I did 256 since Arnd
seemed to think that would be a reasonable size. Based on his example
How much kernel space are we willing to use to same some computation?
Keep in mind only one of the entries in the table will ever be used.

I think if we found the LFSR that was with in 2^10 of the desired value
that would be good enough. It would be within 1% of the minimum N the
user can specify.  That would require a table with 2^14 entries.  That
seems unreasonably large.

Anyway, the user controls how often sampling is done by setting N. 

>  
                Carl Love
> [cut]


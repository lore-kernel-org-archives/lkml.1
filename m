Return-Path: <linux-kernel-owner+w=401wt.eu-S1946025AbXBICrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946025AbXBICrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946027AbXBICrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:47:14 -0500
Received: from mercury.realtime.net ([205.238.132.86]:40564 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946025AbXBICrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:47:13 -0500
In-Reply-To: <1170975119.5204.99.camel@dyn9047021078.beaverton.ibm.com>
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com> <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com> <b682962303654f4958a6c2c50d805907@bga.com> <200702081821.57358.arnd@arndb.de> <1170975119.5204.99.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <e03c784bc3aff642ef10d0e2ed8eab45@bga.com>
Content-Transfer-Encoding: 7bit
Cc: cbe-oss-dev@ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net
From: Milton Miller <miltonm@bga.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Thu, 8 Feb 2007 20:46:48 -0600
To: Carl Love <cel@us.ibm.com>
X-Mailer: Apple Mail (2.624)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8, 2007, at 4:51 PM, Carl Love wrote:

> On Thu, 2007-02-08 at 18:21 +0100, Arnd Bergmann wrote:
>> On Thursday 08 February 2007 15:18, Milton Miller wrote:
>>
>>> 1) sample rate setup
>>>
>>>     In the current patch, the user specifies a sample rate as a time
>>> interval.
>>>     The kernel is (a) calling cpufreq to get the current cpu 
>>> frequency,
>>> (b)
>>>     converting the rate to a cycle count, (c) converting this to a 
>>> 24 bit
>>>     LFSR count, an iterative algorithm (in this patch, starting from
>>>     one of 256 values so a max of 2^16 or 64k iterations), (d)
>>> calculating
>>>     an trace unload interval.   In addition, a cpufreq notifier is
>>> registered
>>>     to recalculate on frequency changes.
>
> No.  The user issues the command opcontrol --event:N  where N is the
> number of events (cycles, l2 cache misses, instructions retired etc)
> that are to elapse between collecting the samples.

So you are saying that b and c are primary, and a is used to calculate
a safe value for d.   All of the above work is dont, just from a
different starting point?


> The OProfile passes
> the value N to the kernel via the variable ctr[i].count.  Where i is 
> the
> performance counter entry for that event.

Ok I haven't looked a the api closely.

> Specifically with SPU
> profiling, we do not use performance counters because the CELL HW does
> not allow the normal the PPU to read the SPU PC when a performance
> counter interrupt occurs.  We are using some additional hw support in
> the chip that allows us to periodically capture the SPU PC.  There is 
> an
> LFSR hardware counter that can be started at an arbitrary LFSR value.
> When the last LFSR value in the sequence is reached, a sample is taken
> and stored in the trace buffer.  Hence, the value of N specified by the
> user must get converted to the LFSR value that is N from the end of the
> sequence.

Ok so its arbitray load count to max vs count and compare.   A critical
detail when computing the value to load, but the net result is the
same; the value for the count it hard to determine.

> The same clock that the processor is running at is used to
> control the LFSR count.  Hence the LFSR counter increments once per CPU
> clock cycle regardless of the CPU frequency or changes in the 
> frequency.
> There is no calculation for the LFSR value that is a function of the
> processor frequency.  There is no need to adjust the LFSR when the
> processor frequency changes.



Oh, so the lfsr doesn't have to be recomputed, only the time
between unloads.

>
> Milton had a comment about the code
>
>  if (ctr[0].event == SPU_CYCLES_EVENT_NUM) {
>> +             spu_cycle_reset = ctr[0].count;
>> +             return;
>> +     }
>
> Well, given the above description, it is clear that if you are doing 
> SPU
> event profiling, the value N is put into the cntr[0].cnt entry since
> there is only one event.  Thus in cell_global_start_spu() you use
> spu_cycle_reset as the argument to the lfsr calculation routine to get
> the LFSR value that is N from the end of the sequence.

I was looking at the patch and the context was not very good.   You
might consider adding -p to your diff command, it provides the function
name after the @@.

However, in this case, I think I just need to see the final result.

>
>>>
>>>     The obvious problem is step (c), running a loop potentially 64
>>> thousand
>>>     times in kernel space will have a noticeable impact on other 
>>> threads.
>>>
>>>     I propose instead that user space perform the above 4 steps, and
>>> provide
>>>     the kernel with two inputs: (1) the value to load in the LFSR 
>>> and (2)
>>>     the periodic frequency / time interval at which to empty the 
>>> hardware
>>>     trace buffer, perform sample analysis, and send the data to the
>>> oprofile
>>>     subsystem.
>>>
>>>     There should be no security issues with this approach.   If the 
>>> LFSR
>>> value
>>>     is calculated incorrectly, either it will be too short, causing 
>>> the
>>> trace
>>>     array to overfill and data to be dropped, or it will be too 
>>> long, and
>>>     there will be fewer samples.   Likewise, the kernel periodic poll
>>> can be
>>>     too long, again causing overflow, or too frequent, causing only 
>>> timer
>>>     execution overhead.
>>>
>>>     Various data is collected by the kernel while processing the
>>> periodic timer,
>>>     this approach would also allow the profiling tools to control the
>>>     frequency of this collection.   More frequent collection results 
>>> in
>>> more
>>>     accurate sample data, with the linear cost of poll execution
>>> overhead.
>>>
>>>     Frequency changes can be handled either by the profile code 
>>> setting
>>>     collection at a higher than necessary rate, or by interacting 
>>> with
>>> the
>>>     governor to limit the speeds.
>>>
>>>     Optionally, the kernel can add a record indicating that some 
>>> data was
>>>     likely dropped if it is able to read all 256 entries without
>>> underflowing
>>>     the array.  This can be used as hint to user space that the 
>>> kernel
>>> time
>>>     was too long for the collection rate.
>>
>> Moving the sample rate computation to user space sounds like the right
>> idea, but why not have a more drastic version of it:
>
> No, I do not agree.  The user/kernel API pass N where N is the number 
> of
> events between samples.  We are not at liberty to just change the API.
> We we did do this, we fully expect that John Levon will push back 
> saying
> why make an architecture specific API change when it isn't necessary.

[So you have not asked.]

<Kludge> If you want to overlaod the existing array, one
event could be the lfsr sample rate, and another event be
the collection time.  That would stay within the framework.
But that is a kludge. </Kludge>

[Me goes and reads kernel profile driver and skims powerpc code].

You are confusing the user interface (what the user specifies on the
command line) with the kernel API.

It is somewhat hidden by the PowerPC specific common code in
arch/powerpc/oprofile/common.c.  That is where the counter
array is exposd.

The user to kernel api is not fill out an array of counter
event names and sampling intervals.

The user to kernel interface is a file system that contains a
heirachy of files.  Each file consists of the hex ascii
represntation of a unsigned long.   The filesystem interfaces
to the kernel by provding an API to create directorys and files,
specifing the name of the directory or file.  Theere are helper
routines to connect a file to a ulong and read access to an atomic_t.
The common driver (in drivers/oprofile) creates the file system
and some common files that implement the control interface, which
interfaces to the architecture specific driver through the ops
array.

The powerpc common driver creates a heiarchy exposing the
values to be placed in the performance monitor registers,
and directory of counters with the event selection.

Since this architeture code does not seem to match the
capabilitys of the hardware, it would seem that this is
the area to change.   This driver does not seem to use
the actual PMU interrput or sprs.   Lets make it its
own directory with its own controls.

I don't see how exposing the sample collection to
rate and the computation of the LFSR create a userspace
api change;  I think its totally within the framework.

> Please define "drastic" in this context.  Do you mean make the table
> bigger i.e. more then 256 precomputed elements?  I did 256 since Arnd
> seemed to think that would be a reasonable size. Based on his example
> How much kernel space are we willing to use to same some computation?
> Keep in mind only one of the entries in the table will ever be used.
>
> I think if we found the LFSR that was with in 2^10 of the desired value
> that would be good enough. It would be within 1% of the minimum N the
> user can specify.  That would require a table with 2^14 entries.  That
> seems unreasonably large.

Why does the table have to be linear?  Compute samples at various
logrimathic staring points.   Determine how many significant bits
you want to keep, and have an array for each sample length.

ie for 3 bits of significance, you could have
F00000, E00000, ... 800000,   0F0000, ......
this would take (24-n) * 2^(n-1) slots, while maintaing user
control of the range.

>
> Anyway, the user controls how often sampling is done by setting N.

When calling a user space program.   The events are converted to
a series of control register values that are communicated to the
kernel by writing to files in the file system.   The writes are
interpreted (converted from ascii hex to binary longs) and stored
until the control files are written, at which point callbacks
copy and interpret the controls and start the hardware collection.

Frankly, I would expect a lot more resistance to the event data
stream generation changes and duplicaton.


milton


Return-Path: <linux-kernel-owner+w=401wt.eu-S1946601AbXBIQSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946601AbXBIQSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946606AbXBIQSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:18:17 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49631 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946601AbXBIQSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:18:15 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
	patch
From: Carl Love <cel@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: cbe-oss-dev@ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net
In-Reply-To: <e03c784bc3aff642ef10d0e2ed8eab45@bga.com>
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com>
	 <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com>
	 <b682962303654f4958a6c2c50d805907@bga.com>
	 <200702081821.57358.arnd@arndb.de>
	 <1170975119.5204.99.camel@dyn9047021078.beaverton.ibm.com>
	 <e03c784bc3aff642ef10d0e2ed8eab45@bga.com>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 08:17:48 -0800
Message-Id: <1171037869.5204.143.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 20:46 -0600, Milton Miller wrote:
>  On Feb 8, 2007, at 4:51 PM, Carl Love wrote:
>  
> > On Thu, 2007-02-08 at 18:21 +0100, Arnd Bergmann wrote:
> >> On Thursday 08 February 2007 15:18, Milton Miller wrote:
> >>
> >>> 1) sample rate setup
> >>>
> >>>     In the current patch, the user specifies a sample rate as a time
> >>> interval.
> >>>     The kernel is (a) calling cpufreq to get the current cpu 
> >>> frequency,
> >>> (b)
> >>>     converting the rate to a cycle count, (c) converting this to a 
> >>> 24 bit
> >>>     LFSR count, an iterative algorithm (in this patch, starting from
> >>>     one of 256 values so a max of 2^16 or 64k iterations), (d)
> >>> calculating
> >>>     an trace unload interval.   In addition, a cpufreq notifier is
> >>> registered
> >>>     to recalculate on frequency changes.
> >
> > No.  The user issues the command opcontrol --event:N  where N is the
> > number of events (cycles, l2 cache misses, instructions retired etc)
> > that are to elapse between collecting the samples.
>  
> So you are saying that b and c are primary, and a is used to calculate
> a safe value for d.   All of the above work is dont, just from a
> different starting point?

There are two things 1) setup the LFSR to control how often the Hardware
puts samples into the trace buffer.  2) setup the kernel timer to read
the trace buffer (your d, d is a function of the cpu freq) and process
the samples.  

(c is nonsense)

The kernel timer was set with the goal the the hardware trace buffer
would not get more then half full to ensure we would not lose samples
even for the maximum rate that the hardware would be adding samples to
the trace buffer (user specified N=100,000).  

>  
> 
> > The OProfile passes
> > the value N to the kernel via the variable ctr[i].count.  Where i is 
> > the
> > performance counter entry for that event.
>  
> Ok I haven't looked a the api closely.
>  
> > Specifically with SPU
> > profiling, we do not use performance counters because the CELL HW does
> > not allow the normal the PPU to read the SPU PC when a performance
> > counter interrupt occurs.  We are using some additional hw support in
> > the chip that allows us to periodically capture the SPU PC.  There is 
> > an
> > LFSR hardware counter that can be started at an arbitrary LFSR value.
> > When the last LFSR value in the sequence is reached, a sample is taken
> > and stored in the trace buffer.  Hence, the value of N specified by the
> > user must get converted to the LFSR value that is N from the end of the
> > sequence.
>  
> Ok so its arbitray load count to max vs count and compare.   A critical
> detail when computing the value to load, but the net result is the
> same; the value for the count it hard to determine.

The above statement makes no sense to me.  

Determining the initial LFSR value that is N values from the last value
in the sequence is not easy to do.  

>  
> > The same clock that the processor is running at is used to
> > control the LFSR count.  Hence the LFSR counter increments once per CPU
> > clock cycle regardless of the CPU frequency or changes in the 
> > frequency.
> > There is no calculation for the LFSR value that is a function of the
> > processor frequency.  There is no need to adjust the LFSR when the
> > processor frequency changes.
>  
> 
> 
> Oh, so the lfsr doesn't have to be recomputed, only the time
> between unloads.

The LFSR value is computed ONCE when you start OProfile.  The value is
setup in the hardware once when OProfile starts.  The hardware will
always restart with the value given to it after it reaches the last
value in the sequence.  What you call the "time between unloads" is the
time at which you schedule the kernel routine to empty the trace buffer.
It is calculated once.  It would only need to be recomputed if the cpu
frequency changed.

>  
> >
> > Milton had a comment about the code
> >
> >  if (ctr[0].event == SPU_CYCLES_EVENT_NUM) {
> >> +             spu_cycle_reset = ctr[0].count;
> >> +             return;
> >> +     }
> >
> > Well, given the above description, it is clear that if you are doing 
> > SPU
> > event profiling, the value N is put into the cntr[0].cnt entry since
> > there is only one event.  Thus in cell_global_start_spu() you use
> > spu_cycle_reset as the argument to the lfsr calculation routine to get
> > the LFSR value that is N from the end of the sequence.
>  
> I was looking at the patch and the context was not very good.   You
> might consider adding -p to your diff command, it provides the function
> name after the @@.
>  
> However, in this case, I think I just need to see the final result.
>  
> >
> >>>
> >>>     The obvious problem is step (c), running a loop potentially 64
> >>> thousand
> >>>     times in kernel space will have a noticeable impact on other 
> >>> threads.
> >>>
> >>>     I propose instead that user space perform the above 4 steps, and
> >>> provide
> >>>     the kernel with two inputs: (1) the value to load in the LFSR 
> >>> and (2)
> >>>     the periodic frequency / time interval at which to empty the 
> >>> hardware
> >>>     trace buffer, perform sample analysis, and send the data to the
> >>> oprofile
> >>>     subsystem.
> >>>
> >>>     There should be no security issues with this approach.   If the 
> >>> LFSR
> >>> value
> >>>     is calculated incorrectly, either it will be too short, causing 
> >>> the
> >>> trace
> >>>     array to overfill and data to be dropped, or it will be too 
> >>> long, and
> >>>     there will be fewer samples.   Likewise, the kernel periodic poll
> >>> can be
> >>>     too long, again causing overflow, or too frequent, causing only 
> >>> timer
> >>>     execution overhead.
> >>>
> >>>     Various data is collected by the kernel while processing the
> >>> periodic timer,
> >>>     this approach would also allow the profiling tools to control the
> >>>     frequency of this collection.   More frequent collection results 
> >>> in
> >>> more
> >>>     accurate sample data, with the linear cost of poll execution
> >>> overhead.
> >>>
> >>>     Frequency changes can be handled either by the profile code 
> >>> setting
> >>>     collection at a higher than necessary rate, or by interacting 
> >>> with
> >>> the
> >>>     governor to limit the speeds.
> >>>
> >>>     Optionally, the kernel can add a record indicating that some 
> >>> data was
> >>>     likely dropped if it is able to read all 256 entries without
> >>> underflowing
> >>>     the array.  This can be used as hint to user space that the 
> >>> kernel
> >>> time
> >>>     was too long for the collection rate.
> >>
> >> Moving the sample rate computation to user space sounds like the right
> >> idea, but why not have a more drastic version of it:
> >
> > No, I do not agree.  The user/kernel API pass N where N is the number 
> > of
> > events between samples.  We are not at liberty to just change the API.
> > We we did do this, we fully expect that John Levon will push back 
> > saying
> > why make an architecture specific API change when it isn't necessary.
>  
> [So you have not asked.]
>  
> <Kludge> If you want to overlaod the existing array, one
> event could be the lfsr sample rate, and another event be
> the collection time.  That would stay within the framework.
> But that is a kludge. </Kludge>
>  
> [Me goes and reads kernel profile driver and skims powerpc code].
>  
> You are confusing the user interface (what the user specifies on the
> command line) with the kernel API.
>  
> It is somewhat hidden by the PowerPC specific common code in
> arch/powerpc/oprofile/common.c.  That is where the counter
> array is exposd.
>  
> The user to kernel api is not fill out an array of counter
> event names and sampling intervals.
>  
> The user to kernel interface is a file system that contains a
> heirachy of files.  Each file consists of the hex ascii
> represntation of a unsigned long.   The filesystem interfaces
> to the kernel by provding an API to create directorys and files,
> specifing the name of the directory or file.  Theere are helper
> routines to connect a file to a ulong and read access to an atomic_t.
> The common driver (in drivers/oprofile) creates the file system
> and some common files that implement the control interface, which
> interfaces to the architecture specific driver through the ops
> array.
>  
> The powerpc common driver creates a heiarchy exposing the
> values to be placed in the performance monitor registers,
> and directory of counters with the event selection.
>  
> Since this architeture code does not seem to match the
> capabilitys of the hardware, it would seem that this is
> the area to change.   This driver does not seem to use
> the actual PMU interrput or sprs.   Lets make it its
> own directory with its own controls.
>  
> I don't see how exposing the sample collection to
> rate and the computation of the LFSR create a userspace
> api change;  I think its totally within the framework.

I was being a bit simplistic in my explination.  I am well aware of the
file system.  The point is the USER specifies the rate (every N events)
that they want to have sampling done.  We are using the existing
mechanism to pass the value of N to the kernel.  So from that
standpoint, we are trying to be consistent in how it is done with the
PPU. I feel that this is best to try to handle the N value in the same
way rather then having a completely different way.  

If we were to put the LFSR into the user space, you would pass the N
into the kernel for the PPU profiling case.  To make the API clean, you
would have to create a new file entry to pass the LFSR value.  For SPU
profiling you would not pass N instead you would pass LFSR.  I think it
is a bad idea to have these two different things for PPU versus SPU
profiling.  I really feel it is best to consistent to use pass N for PPU
and SPU.  Then deal with converting N to the LFSR for the special case
of SPU profiling.  

Unlike POWER 4/5 support where we absolutely had to add entries to the
API to pass the three values for the control registers.  We already have
an established mechanism for passing N from user to kernel.  Just use
it.  We are very sure that John Levon, the OProfile user maintainer,
will say the same thing and refuse to accept adding to the API to pass
the LFSR when the whole thing can be handled in a more consistent way
that does not require an architecture specific change.  And I also feel
that we really don't need or want an additional architecture specific
API change. 

>  
> > Please define "drastic" in this context.  Do you mean make the table
> > bigger i.e. more then 256 precomputed elements?  I did 256 since Arnd
> > seemed to think that would be a reasonable size. Based on his example
> > How much kernel space are we willing to use to same some computation?
> > Keep in mind only one of the entries in the table will ever be used.
> >
> > I think if we found the LFSR that was with in 2^10 of the desired value
> > that would be good enough. It would be within 1% of the minimum N the
> > user can specify.  That would require a table with 2^14 entries.  That
> > seems unreasonably large.
>  
> Why does the table have to be linear?  Compute samples at various
> logrimathic staring points.   Determine how many significant bits
> you want to keep, and have an array for each sample length.
>  
> ie for 3 bits of significance, you could have
> F00000, E00000, ... 800000,   0F0000, ......
> this would take (24-n) * 2^(n-1) slots, while maintaing user
> control of the range.
>  

I don't see any advantage in this log approach.  If we do this with a
linear table with a reasonable number of pre calculated values.  I think
that a table with no more then 1024 entries would be reasonable.  The
overhead for calculating the desired LFSR value would be going through
the for loop 16K times, for 1024 entries in the table, is not
unreasonable.  I think this whole discussion of moving the LFSR to the
user space is not needed.  The overhead of the for loop does not justify
pushing the LFSR determination to user space.  But that is just my
opinion.  I am open to suggestions on how big to make the lookup table
in the kernel.  But I really am apposed to putting the LFSR into the
user space.

> >
> > Anyway, the user controls how often sampling is done by setting N.
>  
> When calling a user space program.   The events are converted to
> a series of control register values that are communicated to the
> kernel by writing to files in the file system.   The writes are
> interpreted (converted from ascii hex to binary longs) and stored
> until the control files are written, at which point callbacks
> copy and interpret the controls and start the hardware collection.
>  
> Frankly, I would expect a lot more resistance to the event data
> stream generation changes and duplicaton.

I don't agree.  But that is just my opinion based on my experience
working on OProfile.

>  
> 
> milton
>  


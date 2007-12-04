Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXLDWnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXLDWnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbXLDWnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:43:46 -0500
Received: from 1wt.eu ([62.212.114.60]:2544 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbXLDWno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:43:44 -0500
Date: Tue, 4 Dec 2007 23:43:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: Avi Kivity <avi@argo.co.il>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071204224307.GB10983@1wt.eu>
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com> <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de> <47539030.10600@argo.co.il> <20071203095022.GA28560@one.firstfloor.org> <4753ECA5.2010604@argo.co.il> <20071203211353.GA4009@1wt.eu> <4755C179.8050101@argo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4755C179.8050101@argo.co.il>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Tue, Dec 04, 2007 at 11:07:05PM +0200, Avi Kivity wrote:
> Willy Tarreau wrote:
> >>>>   
> >>>>        
> >>>With 10Gbit/s ethernet working you start to care about every cycle.
> >>> 
> >>>      
> >>If you have 10M packets/sec no amount of cycle-saving will help you.  
> >>You need high level optimizations like TSO.  I'm not saying we should 
> >>sacrifice cycles like there's no tomorrow, but the big wins are elsewhere.
> >>    
> >
> >Huh? At 4 GHz, you have 400 cycles to process each packet. If you need to
> >route those packets, those cycles may just be what you need to lookup a
> >forwarding table and perform a few MMIO on an accelerated chip which will
> >take care of the transfer. But you need those cycles. If you start to waste
> >them 30 by 30, the performance can drop by a critical factor.
> >
> >  
> 
> I really doubt Linux spends 400 cycles routing a packet.  Look what an 
> skbuff looks like.

That's not what I wrote. I just wrote about doing forwarding table lookup
and MMIO so that dedicated hardware NICs can process the recv/send to the
correct ends. If you just need to scan a list of DMAed packets, look at
their destination IP address, lookup that IP in a table to find the output
NIC and destination MAC address, link them into an output list and waking
the output NIC up, there's nothing which requires more than 400 cycles
here. I never said that it was a requirement to pass through the existing
network stack.

> A flood ping to localhost on a 2GHz system takes 8 microseconds, that's 
> 16,000 cycles.  Sure it involves userspace, but you're about two orders 
> of magnitude off.

I don't see where you see a userspace (or I don't understand your test).
On traffic generation I often do from user space, I can send 630 k raw
ethernet packets per second from userspace on a 1.8 GHz opteron and PCI-e
NICs. That's 2857 cycles per packet, including the (small amount of)
userspace work. That's quite cheap.

> And the localhost interface is nicely cached in L1 without mmio at all,
> unlike real devices.

(...)
> This happens very often in HPC, and when it does, it is often worthwhile 
> to invest in manual optimizations or even assembly coding.  
> Unfortunately it is very rare in the kernel (memcmp, raid xor, what 
> else?).  Loops with high iteration counts are very rare, so any 
> attention you give to the loop body is not amortized over a large number 
> of executions.

Well, in my example above, everythin in the path of the send() syscall down
to the bare metal NIC is under high pressure in a fast loop. 30 cycles
already represent 1% of the performance! In fact, to modulate speed, I
use a busy loop with a volatile int and small values.

> >And such poorly efficient code may happen very often when you blindly rely
> >on function pointers instead of explicit calls.
> >  
> 
> Using an indirect call where a direct call is sufficient will also 
> reduce the compiler's optimization opportunities.

That's true.

> However, I don't see 
> anyone recommending it in the context of systems programming.
> 
> It is not true that the number of indirect calls necessarily increases 
> if you use a language other than C.
> 
> (Actually, with templates you can reduce the number of indirect calls)
> 
> >>Here, it's scheduling that matters, avoiding large transfers, and 
> >>avoiding ping-pongs, not some cycles on the unix domain socket.  You 
> >>already paid 150 cycles or so by issuing the syscall and thousands for 
> >>copying the data, 50 more won't be noticeable except in nanobenchmarks.
> >>    
> >
> >You are forgetting something very important : once you start stacking
> >functions to perform the dirty work for you, you end up with so much
> >abstraction that even new stupid code cannot be written at all without
> >relying on them, and it's where the problem takes its roots, because
> >when you need to write a fast function and you notice that you cannot
> >touch a variable without passing through a slow pinhole, your fast
> >function will remain slow whatever you do, and the worst of all is that
> >you will think that it is normally fast and that it cannot be written
> >faster.
> >
> >  
> 
> I don't understand.  Can you give an example?

Yes, the most common examples found today involve applications reading
data from databases. For instance, let's say that one function in your
program must count the number of unique people with the name starting
with an "A". It is very common to see "low-level" primitives to abstract
the database for portability purposes. One of such primitives will
generally be consist in retrieving a list of people with their names,
age and sex in one well-formated 3-column array. Many lazy people will
not see any problem in calling this one from the function described
above. Basically, what they would do is :

 count_people_with_name_starting_with_a()
    -> array[name,age,sex] = get_list_of_people()
         -> while read_one_people_entry() {
               alloc(one_line_of_3_columns)
               read then parse the 3 fields
               format_them_appropriately
            }
    -> create a new array "name2" by duplicating the "name" column
    -> name3 = sort_unique(name2)
    -> name4 = name3.grep("^A")
    -> return name4.count

Don't laugh, I've recently read such a horrible thing. It was done
that way just because it was easier. Without the abstraction layer,
the coder would have been forced to access the base anyway and would
have seen an added value into just counting from the inner while
loop, saving lots of copies, greps, sort, etc... :

 count_people_with_name_starting_with_a() {
      count = 0;
      while read_one_people_entry() {
         read the 3 fields into a statically-allocated buffer
         if (name[0] == 'A') count++;
      }
      return count;
 }

I'm not saying that the above was not possible, just that it's
1000% easier to do the former without even having to think that
the final code uses such horrible things. And yes, I can confirm
that when you see this, you want to shoot the author !

> There are two cases where abstraction hurts performance: the first is 
> where the mechanisms used to achieve the abstraction (functions instead 
> of direct access to variables, function pointers instead of duplicating 
> the caller) introduce performance overhead.  I don't think C has any 
> advantage here -- actually a disadvantage as it lacks templates and is 
> forced to use function pointers for nontrivial cases.  Usually the 
> abstraction penalty is nil with modern compilers.
> 
> The second case is where too much abstraction clouds the programmer's 
> mind.  But this is independent of the programming language.

Agreed. But most often, the abstraction prevents the user from accessing
some information directly and that becomes nasty. I remember when I was
a teen, I wrote a program designed to inventory what you had in your PC,
and run a few performance tests. It ran in those semi-graphical DOS mode
where you use graphics characters to draw boxes. I initially wrote all
the windowing code myself and it ran perfectly. I once decided to rewrite
it using TurboVision, the windowing framework from Borland (it was written
in TurboPascal). I made intensive use of the equivalent of a putchar()
function to write text in a window. You cannot imagine my pain when I
ran it on my old 8088, it wrote at the speed of a 1200 bps terminal. I
then tried to find how to write faster, even by accessing the window
buffer directly. I couldn't. I had to reverse-engineer the internal
structures by debugging memory contents in order to find the pointers
to the window buffer to write to them directly. After this disastrous
experience with abstraction, I thought "never that crap again".

> >Every cycle burned is definitely lost. The time cannot go backwards. So
> >for each cycle that you lose to laziness, you have to become more and more
> >clever to find out how to write an alternative. Lazy people simply put
> >caches everywhere and after that they find normal that "hello world" 
> >requires
> >2 Gigs of RAM to be displayed. 
> 
> A 100 byte program will print "hello world" on a UART and stop.  A 
> modern program will load a vector description of a font, scale it to the 
> desired size, render it using anti aliasing and sub-pixel positioning, 
> lay it out according to the language rules of whereever you live, and 
> place it on a multi-megabyte frame buffer.  Yes it needs hundreds of 
> megabytes and lots of nasty algorithms to do that.

What I'm complaining about is that when you don't want those fancy things,
you still have them to justify the hundreds of megs. And even if you manage
to print to stdout, you still have a huge runtime just in case you'd like
to use the fancy features.

> >The only true solution is to create better
> >algorithms, but you will find even less people capable of creating 
> >efficient
> >algorithms than you will find capable of coding correctly.
> 
> That is true, that is why we see a lot more microoptimizations than 
> algorithmic progress.

Also, algorithmic research is very little rewarding. You can work for
months or years thinking you found the nice algo for the job, then
finally discover a limitation you did not expect and throw that amount
of work to the bin in a few minutes.

> But if you want a fast streaming filesystem you choose XFS over ext3, 
> even though the latter is much smaller and easier to optimize.  If you 
> write a network server you choose epoll() instead of trying to optimize 
> select() somehow.

That's interesting that you cite epoll() vs select(). I measured the
break-even point around 1000 FDs. Below, select() is faster. Above,
epoll() is faster. On small number of entries (less than 100), a select
based proxy can be 20-30% faster than the same one running on epoll()
because select() while dumber is cheaper to set up.

> True algorithmic improvements are rare but they are the ones that are
> actually measurable.

I generally agree with this.

> >>>For example there are some CPUs who are relatively slow at indirect
> >>>function calls and there are actually cases where this can be measured.
> >>>      
> >>That is true.  But any self-respecting systems language will let you 
> >>choose between direct and indirect calls.
> >>
> >>If adding an indirect call allows you to avoid even 1% of I/O, you save 
> >>much more than you lose, so again the high level optimizations win.
> >>    
> >
> >It depends which type of I/O. If the I/O is non-blocking, you end up doing
> >something else instead of actively burning cycles.
> >
> >  
> 
> Unless you are I/O bound, which is usually the case when you have 2GHz 
> cpus driving 200Hz disks.

That's true when you seek a lot. When you manage to mostly perform sequential
reads (such as what you do when processing large files such as logs), you can
easily achieve 80 MB/s, which is 20000 pages/s, or 100 times faster.

> >>Nanooptimizations are fun (I do them myself, I admit) but that's not 
> >>where performance as measured by the end user lies.
> >>    
> >
> >I do not agree. It's not uncommon to find 2- or 3-fold performance factors
> >between equivalent components when one is carefully optimized and the other
> >one is not. Granted it takes an awful lot of time doing all those nano-opts
> >at the beginning, but the more you learn about how the hardware reacts to
> >your code, the more efficiently you write future code, with the fewest 
> >bloat.
> >End users notice bloat a lot (especially when CPU and RAM are excessively
> >wasted).
> >  
> 
> Can you give an example of a 2- or 3- fold factor on an end-user 
> workload achieved by microopts?

Oh there are many primitives which are generally optimized in assembly for
this reason. What randomly comes to my mind :
  - graphics libraries. Saving 1 cycle per pixel in a rectangle drawing
    primitive can have an important impact in animated graphics for
    instance.

  - video/audio and generally multimedia code. I remember a specially
    written version of mpg123 about 10 years ago, which was optimized
    for i486 and which was the only one able to run on a 486 without
    skipping.

  - crypto code. It's common to find CPU-specific DES or AES functions.
    Take a look at John The Ripper. I don't know if it still exists,
    but there was an Alpha-optimized DES function which was something
    like 5 times faster than the generic C one. It changes a lot of
    things when you have 1 day to check your users passwords.

I also wrote a netfilter log analyzer which parses 300000 lines per
second on my 1.7 GHz notebook. That's 5600 cycles to read a full
line, lookup the field names, extract the values, parse them (atoi,
aton) save them in a structure, apply a filter, insert the result
in a tree containing up to 12 millions of them, and dump a report
of the counts by any creteria. That saved me a lot of time working
on log analysis. But to achieve such a speed, I had to optimize at
every level, including rewriting a faster atoi() equivalent, a
faster aton() equivalent (with no multiplies), and playing with
likely/unlikely a lot. The code slowly improved from about 75k
lines/s to 300k lines/s with no algorithmic change. Just by the
way of careful code placement and ordering.

In fact, you could say that micro-optimizations are not important
if you are doing them in a crappy environment where the fast path
is already wasted by a big dirty function. But when you have the
ability to master all the environment, every single cycle counts
because there's almost no waste.

I find it essential not to be the first one bringing crap somewhere
and serving as an excuse for others not to care about their code.
If everyone cares, you can still produce very good software, and
that's what I care about.

Cheers,
Willy


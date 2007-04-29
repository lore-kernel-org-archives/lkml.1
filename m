Return-Path: <linux-kernel-owner+w=401wt.eu-S933277AbXD2P2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277AbXD2P2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXD2P2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:28:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:11327 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbXD2P2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DGVtsEcsHVk3qOK3IQUjBfHgYccl4JOrZbOa+y5xI6smUbiVdZnPOEGZ+I3+TYhLqVGjPZoWoFVZtqLJ18DbvdqOz5CmbY1z+tfkELPoLimQkg+X+hxdp+R9VmN6xm7VcBLp/pog7ihWCAbKrZoZGtUjCkHOAI/WfePO6h9BawA=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [patch] CFS scheduler, -v6
Date: Sun, 29 Apr 2007 11:28:02 -0400
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
References: <20070425214704.GA32572@elte.hu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu>
In-Reply-To: <20070429071627.GC23638@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291128.03300.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2007, Willy Tarreau wrote:
>On Sun, Apr 29, 2007 at 08:59:01AM +0200, Ingo Molnar wrote:
>> * Willy Tarreau <w@1wt.eu> wrote:
>> > I don't know if Mike still has problems with SD, but there are now
>> > several interesting reports of SD giving better feedback than CFS on
>> > real work. In my experience, CFS seems smoother on *technical* tests,
>> > which I agree that they do not really simulate real work.
>>
>> well, there are several reports of CFS being significantly better than
>> SD on a number of workloads - and i know of only two reports where SD
>> was reported to be better than CFS: in Kasper's test (where i'd like to
>> know what the "3D stuff" he uses is and take a good look at that
>> workload), and another 3D report which was done against -v6. (And even
>> in these two reports the 'smoothness advantage' was not dramatic. If you
>> know of any other reports then please let me know!)
>
>There was Caglar Onur too but he said he will redo all the tests. I'm
>not tracking all tests nor versions, so it might be possible that some
>of the differences vanish with v7.
>
>In fact, what I'd like to see in 2.6.22 is something better for everybody
>and with *no* regression, even if it's not perfect. I had the feeling
>that SD matched that goal right now, except for Mike who has not tested
>recent versions. Don't get me wrong, I still think that CFS is a more
>interesting long-term target. But it may require more time to satisfy
>everyone. At least with one of them in 2.6.22, we won't waste time
>comparing to current mainline.
>
>> 	Ingo
>
>Willy

In the FWIW category, I haven't built and tested a 'mainline' since at least 
2-3 weeks ago.  That's how dramatic the differences are here.  Here, my main 
notifier of scheduling fubar artifacts is usually kmail, which in itself 
seems to have a poor threading model, giving the composer pauses whenever its 
off sorting incoming mail, or compacting a folder, all the usual stuff that 
it needs to do in the background.  Those lags were from 10 to 30 seconds 
long, and I could type whole sentences before they showed up on screen with 
mainline.

The best either of these schedulers can do is hold that down to 3 or 4 words, 
but that's an amazing difference in itself.  With either of these schedulers, 
having a running gzip session that amanda launched in the background cause 
kmail to display a new message 5-30 seconds after the + key has been tapped 
is now into the sub 4 second range & often much less.  SD seems to, as it 
states, give everyone a turn at the well, so the slowdowns when gzip is 
running are somewhat more noticeable, whereas with CFS, gzip seems to be 
pretty well preempted long enough to process most user keypresses.  Not all, 
because tapping the + key to display the next message can at times be a 
pretty complex operation.

For my workload, CFS seems to be a marginally better solution, but either is 
so much better than mainline that there cannot be a reversion to mainline 
performance here without a lot of kicking and screaming.

'vmstat -n 1' results show that CFS uses a lot less time doing context 
switches, which as IUI, is to be counted against OS overhead as it does no 
productive work while the switch is being done.  For CFS, that's generally 
less than 500/second, and averageing around 350, which compared to SD046's 
average of about 18,000/second, it would appear that CFS allows more REAL 
work to get done by holding down on the non-productive time a context switch 
requires.

FWIW, amanda runtimes tend to back that up, most CFS runs are sub 2 hours, SD 
runs are seemingly around 2h:10m.  But that again is not over a sufficiently 
large sample to be a benchmark tool either, just one persons observation.  I 
should have marked the amdump logs so I could have determined that easier by 
tracking which scheduler was running for that dump.  amplot can be 
informative, but one must also correlate, and a week ago is ancient history 
as I have no way to verify which I was running then.

The X86's poor register architecture pretty well chains us to the 'context 
switch' if we want multitasking.

I'm reminded of how that was handled on a now largely dead architecture some 
here may never have seen an example of, TI's 99xx chips, where all 
accumulators and registers were actually stored in memory, and a context 
switch was a simply matter of reloading the register that pointed into this 
memory array with a new address so a context switch was just a matter of 
reading the next processes address and storing it in the address register, 
itself also just a location in memory.  The state image of the process 
being 'put to sleep' was therefore maintained indefinitely as long as the 
memory was refreshed.  Too bad we can't do that on the x86 but I assume TI 
has patent lawyers standing by ready to jump on that one.  However, with 
today's L1 cache being the speed and size that it is, it sure looks like a 
doable thing even at 2GHZ+ clocks.

Yup, we've tried lots of very productive ways to get that job done over the 
last 40 years, and everytime somebody has a really good idea, the patent 
prevents its application.  And they call that progress...  SIGH..  Just 
imagine how much money TI would have today if the royalty asked had only been 
a dime a chip...  And to a very limited extent, one could do that on an 
RCA-180x too, using its plethora of internal registers, any of which could be 
made the PC or SP (or DMA pointer too IIRC) with a one byte command.

Anyway, in my mind CFS wins this round, but its a smallish margin, like 
judging ice skaters, a 9.7 vs 9.5 rating.  Not a huge difference, until 
mainlines 0.0 score is thrown into the pot for a reality check comparison.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
And on the eighth day, we bulldozed it.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbYGIXa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbYGIXa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 19:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYGIXaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 19:30:18 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59514 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751851AbYGIXaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:30:17 -0400
Message-ID: <48754A08.1060302@sgi.com>
Date: Wed, 09 Jul 2008 16:30:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>	<m17ibxxytj.fsf@frodo.ebiederm.org> <4873B016.8010404@sgi.com>	<m1r6a4c5im.fsf@frodo.ebiederm.org> <4874CD22.20502@sgi.com> <m1k5fuof7p.fsf@frodo.ebiederm.org>
In-Reply-To: <m1k5fuof7p.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
> 
...  (I have been using the trick
>> to replace printk with early_printk so messages come out immediately instead
>> of from the log buf.)
> 
> Just passing early_printk=xxx on the command line should have that effect.
> Although I do admit you have to be a little bit into the boot before early_printk
> is setup.

What I meant was using early_printk in place of printk, which seems to stuff the
messages into the log buf until the serial console is setup fairly late in start_kernel.
I did this by removing printk() and renaming early_printk() to be printk (and a couple
other things like #define early_printk printk ...

> 
>> I've been able to make some more progress.  I've gotten to a point where it
>> panics from stack overflow.  I've verified this by bumping THREAD_ORDER and
>> it boots fine.  Now tracking down stack usages.  (I have found a couple of new
>> functions using set_cpus_allowed(..., CPU_MASK_ALL) instead of
>> set_cpus_allowed_ptr(... , CPU_MASK_ALL_PTR).  But these are not in the calling
>> sequence so subsequently are not the cause.
> 
> Is stack overflow the only problem you are seeing or are there still other mysteries?

I'm not entirely sure it's a stack overflow, the fault has a NULL dereference and
then the stack overflow message.

> 
>> One weird thing is early_idt_handler seems to have been called and that's one
>> thing our simulator does not mimic for standard Intel FSB systems - early
>> pending
>> interrupts.  (It's designed after all to mimic our h/w, and of course it's been
>> booting fine under that environment.) 
> 
> That usually indicates you are taking an exception during boot not that you
> have received an external interrupt.  Something like a page fault or a
> division by 0 error.

I was thinking maybe an RTC interrupt?  But a fault does sound more likely.

> 
>> Only a few of these though I would think might get called early in
>> the boot, that might also be contributing to the stack overflow.
> 
> Still the call chain depth shouldn't really be changing.  So why should it
> matter?  Ah.  The high cpu count is growing cpumask_t so when you put
> it on the stack.  That makes sense.  So what stars out as a 4 byte
> variable on the stack in a normal setup winds up being a 1k variable
> with 4k cpus.

Yes, it's definitely the three related:

NR_CPUS Patch_Applied THREAD_ORDER Results
  256        NO           1        works (obviously ;-)
  256        YES          1        works
 4096        NO           1        works
 4096        YES          1        panics
 4096        YES          3        works (just happened to pick 3,
					  2 probably will work as well.)

> Reasonable.  The practical problem is you are mixing a lot of changes
> simultaneously and it confuses things.  Compiling with NR_CPUS=4096
> and working out the bugs from a growing cpumask_t, putting the per cpu
> area in a zero based segment, and putting putting the pda into the
> per cpu area all at the same time.

I've been testing NR_CPUS=4096 for quite a while and it's been very
reliable.  It's just weird that this config fails with this new patch
applied.  (default configs and some fairly normal distro configs also
work fine.)  And with the zillion config straws we now have, spotting
the arbitrary needle is proving difficult. ;-) 

> Who knows maybe the only difference between 4.2.0 and 4.2.4 is that
> 4.2.4 optimizes it's stack usage a little better and you don't see
> a stack overflow.

I haven't tried the THREAD_ORDER=3 (or 2) under 4.2.0, but that would
seem to indicate this may be true.

> It would be very very good if we could separate out these issues
> especially the segment for the per cpu variables.  We need something
> like that.

One reason I've been sticking with 4.2.4.

Thanks again for your help.

Mike

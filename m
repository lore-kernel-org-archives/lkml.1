Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYEPOXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYEPOXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYEPOWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:22:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYEPOWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:22:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Carl Love <cel@us.ibm.com>
Subject: Re: [PATCH] Updated: Reworked Cell OProfile: SPU mutex lock fix
Date: Fri, 16 May 2008 16:22:44 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
References: <1209652994.17842.1.camel@carll-linux-desktop> <200805151739.26392.arnd@arndb.de> <1210878305.20791.109.camel@carll-linux-desktop>
In-Reply-To: <1210878305.20791.109.camel@carll-linux-desktop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161622.46232.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/89XaU6NO695dnrnngXYl6vFjPTPtaIJinPyQ
 vxfXo/FwYELFQlPepFg6ctBdMCpiAJ+bvpMaIatxpHzk9ksgZo
 3XJXuEP8Rf6ST2W5AjG5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2008, Carl Love wrote:
> On Thu, 2008-05-15 at 17:39 +0200, Arnd Bergmann wrote:
> > 
> > I noticed now that you are indexing arrays by SPU number. This is not
> > a good idea, because you make assumptions about the system that may
> > not be true. Better pass around 'struct spu' pointers and put those
> > values in there if you need them. 
> 
> Hmm, well, we have arrays for last_guard_val[], spu_info[] as well that
> are indexed by spu number.  So this would seem to be a more general
> issue then just spu_ctx_seen[].  Not sure exactly what you are
> suggesting with passing around 'struct spu' as a solution.  Are you
> suggesting that a field be added to the structure for the spu context
> seen flag?  Not sure that is a good idea.  We will need to clarify how
> you propose to fix this not only for spu_ctx_sw_seen but the other
> arrays as well that are already being indexed by spu number.

I'd suggest you add fields to struct spu, either directly to it, if
it's short, or a pointer to your own struct.

As I said, let's not do that now.

>                                                 So, you can either add
> a context switch sequence to a given CPU buffer or you can add an SPU
> program counter to the CPU buffer not both at the same time.  The lock
> is held until the entire SPU context switch entry is added to the CPU
> queue to make sure entries are not intermingled.

My point was that oprofile collecting samples for the CPU could possibly
add entries to the same queue, which would race with this.

> When the trace buffer is read, each 128 bit entry contains the 16 bit
> SPU PC for each of the eight SPUs on the node.  Secondly, we really want
> to keep the timing of the context switches and storing the SPU PC values
> as close as possible.  Clearly there is some noise as the switch will
> occur while the trace buffer is filling.

can't you just empty the trace buffer every time you encounter a context
switch, even in the absence of a timer interrupt? That would prevent
all of the noise.

> Storing the all of the SPU PC 
> values, into the current CPU buffer causes two issues.  One is that one
> of the buffers will be much fuller then the rest increasing the
> probability of overflowing the CPU buffer and dropping data.  As it is,
> in user land, I have to increase the size of the CPU buffers to
> accommodate four SPUs worth of data in a given CPU buffer.  Secondly,
> the SPU context switch info for a given SPU would be going to a
> different CPU buffer then the data. 

In practice, the calling CPUs should be well spread around by the way
that spufs works, so I don't think it's a big problem.
Did you observe this problem, or just expect it to happen?

> Depending on the timing of the CPU 
> buffer syncs to the kernel buffer you might get the trace buffer emptied
> multiple times before an SPU context switch event was sync'd to the
> kernel buffer. Thus causing undesired additional skew in the data.

good point. would this also get solved if you flush the trace buffer
on a context switch? I suppose you need to make sure that the samples
still end up ordered correctly throughout the CPU buffers. Is that
possible?

> Any thoughts about moving oprofile_add_value() to buffer_sync.c and
> having it grab the buffer_mutex lock while it inserts values directly
> into the kernel buffer?  At the moment it looks the easiest.  

That would mean that again you can't call it from interrupt context,
which is the problem you were trying to solve with the work queue
in the previous version of your patch.
 
> I can see a few other solutions but they involve creating per SPU arrays
> for initially storing the switch info and SPU data and then having each
> CPU flush a subset of the SPU data to its CPU buffer.  A lot more
> storage and overhead we want.

It might work if you do a per SPU buffer and generalize the way
that per-CPU buffers are flushed to the kernel buffer so it works
with either one.

> > > +	/* The SPU_PROFILING_CODE escape sequence must proceed
> > > +	 * the SPU context switch info.
> > > +	 */
> > > +	for_each_online_cpu(cpu) {
> > > +		oprofile_add_value(ESCAPE_CODE, cpu);
> > > +		oprofile_add_value(SPU_PROFILING_CODE, cpu);
> > > +		oprofile_add_value((unsigned long int)
> > > +					    num_spu_nodes, cpu);
> > > +	}
> > >  
> > 
> > You are no longer holding a lock while adding the events, which
> > may be correct as long as no switch_events come in, but it's
> > still inconsistent. Do you mind just adding the spinlock here
> > as well?
> > 
> 
> The claim is that the lock is not needed because we have not yet
> registered for notification of the context switches as mentioned above.
> Hence there is no race to worry about.  Registration for the switch
> event notification happens right after this loop.  

Right, that's what I understood as well. My point was that it's more
consistent if you always call the function with the same locks held,
in case somebody changes or tries to understand your code.
 	
	Arnd <><

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYFRMZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYFRMZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbYFRMZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:25:47 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:21502 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYFRMZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:25:46 -0400
Message-Id: <4858C68C.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 18 Jun 2008 06:25:48 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi-suse@firstfloor.org>,
       "Clark Williams" <clark.williams@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Marin Mitov" <mitov@issp.bas.bg>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, <akpm@osdl.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-rt-users" <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
References: <200805252108.25011.mitov@issp.bas.bg>
 <200806091911.21850.mitov@issp.bas.bg> <20080609161606.GA24841@elte.hu>
 <200806152058.17142.mitov@issp.bas.bg> <20080618075518.GD4135@elte.hu>
 <4858C286.BA47.005A.0@novell.com> <1213791416.16944.222.camel@twins>
In-Reply-To: <1213791416.16944.222.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Jun 18, 2008 at  8:16 AM, in message
<1213791416.16944.222.camel@twins>, Peter Zijlstra <peterz@infradead.org>
wrote: 
> On Wed, 2008-06-18 at 06:08 -0600, Gregory Haskins wrote:
>> >>> On Wed, Jun 18, 2008 at  3:55 AM, in message <20080618075518.GD4135@elte.hu>,
>> Ingo Molnar <mingo@elte.hu> wrote: 
>> 
>> > * Marin Mitov <mitov@issp.bas.bg> wrote:
>> > 
>> >> Why not something like that (do keep in mind I am not an expert :-):
>> >> 
>> >> static void delay_tsc(unsigned long loops)
>> >> {
>> >> 	get and store the mask of allowed cpus;
>> >> 	/*     prevent the migration   */
>> >> 	set the mask of allowed cpus to the current cpu only;
>> >> 	/*     is it possible? could it be guaranteed?    */
>> >> 	loop for the delay;
>> >> 	restore the old mask of allowed cpus;
>> >> }
>> >> 
>> >> You have got the idea. Could it be realized? Is it more expensive than 
>> >> the current realization? So, comments, please.
>> > 
>> > hm, changing/saving/restorig cpus_allowed is really considered a 'heavy' 
>> > operation compared to preempt_disable(). On a 4096 CPUs box cpus_allowed 
>> > is 4096 bits which is half a kilobyte ...
>> > 
>> > preempt_disable()/enable() on the other hand only touches a single 
>> > variable, (thread_info->preempt_count which is an u32)
>> > 
>> > 	Ingo
>> 
>> FWIW:  I had submitted some "migration disable" patches a while back
>> that would solve this without the cpus_allowed manipulations described
>> here.  Its more expensive than a preempt-disable (but its
>> preemptible), yet its way cheaper (and more correct / less racy) than
>> chaning cpus_allowed.  I could resubmit if there was any interest,
>> though I think Ingo said he didnt like the concept on the first pass.
>> Anyway, FYI.
> 
> (please teach your mailer to wrap text)

Sorry...I know its really annoying, but I have no control over it in groupwise :(

Its a server side / MTA setting.  Go figure.  I will try to wrap manually.

> 
> Yeah - migrate_disable() has been proposed several times. The reason I
> don't like it is that is creates scheduling artefacts like latencies by
> not being able to load-balance (and thereby complicates all that, and
> you know we don't need more complication there).

True, and good point.  But this concept would certainly be useful to avoid 
the heavyweight (w.r.t. latency) preempt-disable() in quite a few different
areas, so if we can make it work with reasonable visibility, it might be nice
to have.

> 
> Things like preempt latency and irq off latency are rather easy to
> notice and debug in general. migrate_disable() would be fully
> preemptable/schedulable which makes it much much harder to instrument or
> even detect we have an issue. Which in turn makes it much harder to find
> abuse.

I wonder if we can come up with any creative instrumentation to get coverage
in this case.  I will think about it and add it to the migration-disable queue I
have to be submitted together (unless Ingo et. al. feel strongly that it will
never be accepted even with good instrumentation...then I will not waste
any effort on it).

Regards,
-Greg

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



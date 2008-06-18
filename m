Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbYFRMRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbYFRMRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYFRMRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:17:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48596 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbYFRMRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:17:30 -0400
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Marin Mitov <mitov@issp.bas.bg>,
       Andi Kleen <andi-suse@firstfloor.org>,
       Clark Williams <clark.williams@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <4858C286.BA47.005A.0@novell.com>
References: <200805252108.25011.mitov@issp.bas.bg>
	 <200806091911.21850.mitov@issp.bas.bg> <20080609161606.GA24841@elte.hu>
	 <200806152058.17142.mitov@issp.bas.bg> <20080618075518.GD4135@elte.hu>
	 <4858C286.BA47.005A.0@novell.com>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 14:16:56 +0200
Message-Id: <1213791416.16944.222.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 06:08 -0600, Gregory Haskins wrote:
> >>> On Wed, Jun 18, 2008 at  3:55 AM, in message <20080618075518.GD4135@elte.hu>,
> Ingo Molnar <mingo@elte.hu> wrote: 
> 
> > * Marin Mitov <mitov@issp.bas.bg> wrote:
> > 
> >> Why not something like that (do keep in mind I am not an expert :-):
> >> 
> >> static void delay_tsc(unsigned long loops)
> >> {
> >> 	get and store the mask of allowed cpus;
> >> 	/*     prevent the migration   */
> >> 	set the mask of allowed cpus to the current cpu only;
> >> 	/*     is it possible? could it be guaranteed?    */
> >> 	loop for the delay;
> >> 	restore the old mask of allowed cpus;
> >> }
> >> 
> >> You have got the idea. Could it be realized? Is it more expensive than 
> >> the current realization? So, comments, please.
> > 
> > hm, changing/saving/restorig cpus_allowed is really considered a 'heavy' 
> > operation compared to preempt_disable(). On a 4096 CPUs box cpus_allowed 
> > is 4096 bits which is half a kilobyte ...
> > 
> > preempt_disable()/enable() on the other hand only touches a single 
> > variable, (thread_info->preempt_count which is an u32)
> > 
> > 	Ingo
> 
> FWIW:  I had submitted some "migration disable" patches a while back
> that would solve this without the cpus_allowed manipulations described
> here.  Its more expensive than a preempt-disable (but its
> preemptible), yet its way cheaper (and more correct / less racy) than
> chaning cpus_allowed.  I could resubmit if there was any interest,
> though I think Ingo said he didnt like the concept on the first pass.
> Anyway, FYI.

(please teach your mailer to wrap text)

Yeah - migrate_disable() has been proposed several times. The reason I
don't like it is that is creates scheduling artefacts like latencies by
not being able to load-balance (and thereby complicates all that, and
you know we don't need more complication there).

Things like preempt latency and irq off latency are rather easy to
notice and debug in general. migrate_disable() would be fully
preemptable/schedulable which makes it much much harder to instrument or
even detect we have an issue. Which in turn makes it much harder to find
abuse.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbYFARSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbYFARSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 13:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYFARS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 13:18:26 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:43969 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYFARSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 13:18:25 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
Date: Sun, 1 Jun 2008 20:17:57 +0300
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200805252108.25011.mitov@issp.bas.bg> <200806011901.23619.mitov@issp.bas.bg> <20080601162517.GH20824@one.firstfloor.org>
In-Reply-To: <20080601162517.GH20824@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806012017.57703.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2008 07:25:17 pm Andi Kleen wrote:
> >  static void delay_tsc(unsigned long loops)
> >  {
> > -	unsigned long bclock, now;
> > +	unsigned prev, prev_1, now;
> > +	unsigned left = loops;
> > +	unsigned prev_cpu, cpu;
> > +
> > +	preempt_disable();
> > +	rdtscl(prev);
> 
> 
> The unsigneds should be probably u64  and the rdtsc rdtscll.
> Otherwise this will all overflow for longer waits on a very
> fast systems (e.g. a 5Ghz system wraps 32bit in ~1.1 seconds)
> Normally such delays shouldn't be that long, but why risk
> overflow even in extreme cases?

Yes in principles, but the overflow (that could happen between
rdtscl(prev) and rdtscl(now) is taken into account the same way 
as in time_after()/time_before() macros, (differences only) see:

+		left -= now - prev;
.........
+	} while ((now-prev) < left);

If more than one overflow happen between rdtscl(prev) and 
rdtscl(now) (the task is suspended for a long time between two 
readings) all overflows after the first one will be lost. But the 
patch was submitted to guaranty minimum udelay() initially.
Sure, I could change to u64 if we reach a concensus.

Best regards.

Marin Mitov

> 
> -Andi
> 

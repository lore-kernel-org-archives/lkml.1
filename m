Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab0CEJUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 04:20:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0CEJUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 04:20:14 -0500
Subject: Re: [PATCH 06/14] perf, x86: PEBS infrastructure
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, eranian@google.com,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <20100305061942.GF27606@brick.ozlabs.ibm.com>
References: <20100304140046.596569763@chello.nl>
	 <20100304140100.392111285@chello.nl>
	 <20100305061942.GF27606@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 10:20:10 +0100
Message-ID: <1267780810.16716.51.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 17:19 +1100, Paul Mackerras wrote:
> On Thu, Mar 04, 2010 at 03:00:52PM +0100, Peter Zijlstra wrote:
> 
> > Implement a simple PEBS model that always takes a single PEBS event at
> > a time. This is done so that the interaction with the rest of the
> > system is as expected (freq adjust, period randomization, lbr).
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <new-submission>
> > ---
> 
> ...
> 
> > @@ -203,8 +203,9 @@ struct perf_event_attr {
> >  				enable_on_exec :  1, /* next exec enables     */
> >  				task           :  1, /* trace fork/exit       */
> >  				watermark      :  1, /* wakeup_watermark      */
> > +				precise        :  1, /* OoO invariant counter */
> 
> Could you explain in a bit more detail what this means?  
> 
> Also, it would be good to mention the ABI addition in the patch
> description, and explain it briefly there.

Quite so, my bad.

So on Intel regular PMIs can happen several instructions later than the
actual event due to out-of-order processing of the instruction stream,
that is, it doesn't keep the IP of the actual instruction that triggered
the event, so all we have is the IP of where the interrupt happened (the
difference between these IPs is called skid).

Now Intel came up with something called Precise Event Based Sampling
(PEBS) which stores a (partial) register set in some memory buffer at
event time (trap like for some daft reason).

So from that we can obtain the IP of the instruction _after_ the
instruction that caused the event. This is reliably so (mostly [*]) and
does not contain out-of-order artifacts (0-skid).

So the ->precise flag tells us to use a more precise sampling method if
available on the hardware (AMD could be using IBS to implement this for
their instruction counter).

If you look at patch 9/14 you'll see we use the Last Branch Recording
(LBR) facility of the Intel cpus (patch 8/14) to find the last basic
block in the instruction stream and use that to rewind the instruction
stream to get the actual instruction that triggered the event. In case
that works I also set PERF_RECORD_MISC_EXACT to indicate we got the IP
dead on (mostly [*]).

I suspect CPUs that are strictly in-order, like Atom, might always have
it right, but I need to validate that.

Does that clarify stuff?

[*] there are CPU errata that may delay the PEBS recording, mostly with
instructions like MOV SS, STI and things like SMM.


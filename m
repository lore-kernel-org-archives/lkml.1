Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbXB0R0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbXB0R0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 12:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXB0R0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 12:26:36 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:36072 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXB0R0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 12:26:35 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: Daniel Walker <dwalker@mvista.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, mbligh@google.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070227160206.GA2391@Krystal>
References: <1172340369.24216.31.camel@imap.mvista.com>
	 <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com>
	 <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com>
	 <20070227035456.GA15444@Krystal>
	 <1172550161.5517.210.camel@imap.mvista.com> <20070227062913.GC1259@elte.hu>
	 <20070227073815.GA25894@Krystal>
	 <1172571535.5517.222.camel@imap.mvista.com> <20070227160206.GA2391@Krystal>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 09:24:15 -0800
Message-Id: <1172597055.5517.233.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 11:02 -0500, Mathieu Desnoyers wrote:
> * Daniel Walker (dwalker@mvista.com) wrote:
> > On Tue, 2007-02-27 at 02:38 -0500, Mathieu Desnoyers wrote:
> > 
> > > 
> > > I am concerned about the automatic fallback to the PIT when no other
> > > clock source is available. A clocksource read would be atomic when TSC
> > > or HPET are available, but would fall back on PIT otherwise. There
> > > should be some way to specify that a caller is only interested in atomic
> > > clock sources (if none are available, the call should simply return an
> > > error, or 0).
> > > 
> > I'm not sure what you mean by using the RCU
> 
> The original proposal of this thread uses a RCU (read-copy-update) style
> update of the previous 64 bits counter : it swaps a pointer (atomically)
> upon update by incrementing a word-sized counter that is used, by the
> reader, to get the offest in the array (with a modulo operation) for the
> current readable data and as a way to detect incorrect reads of
> overwritten information (we re-read the word-sized counter after having
> read the data structure to make sure is has not been incremented. If we
> detect an increment, we redo the whole operation).

I didn't see RCU at all in your original message, so I'm not sure how
you propose to use it .. My understanding of the RCU was that it
couldn't be used from interrupt context, that could be totally wrong so
I'll let you explain how you planed to use it.

> > > I still think that an RCU style update mechanism would be a good way  to
> > > fix the current clocksource read issue. Another, slower and non NMI
> > > safe way to do this would be with a read seqlock and with IRQ disabling.
> > 
> > , but the pit clocksource
> > does disable interrupts with a spin_lock_irqsave().
> > 
> 
> When I say "clocksource read issue", I am talking about
> race between the function you proposed earlier, which you say is used in
> -rt kernels for latency tracing (get_monotonic_cycles), and HPET and TSC
> "last cycles" updates.

Right .. You said that regular interrupts would cause this non-atomic
64-bit update race , but the pit disabled interrupts, and the
last_cycles update is done with interrupts off .. So I think we're back
to only the NMI case ..

Did you have another scenario ?

Daniel


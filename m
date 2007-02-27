Return-Path: <linux-kernel-owner+w=401wt.eu-S933069AbXB0QCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069AbXB0QCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbXB0QCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:02:14 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:58615 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933070AbXB0QCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:02:13 -0500
Date: Tue, 27 Feb 2007 11:02:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, mbligh@google.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI handler
Message-ID: <20070227160206.GA2391@Krystal>
References: <1172340369.24216.31.camel@imap.mvista.com> <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com> <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com> <20070227035456.GA15444@Krystal> <1172550161.5517.210.camel@imap.mvista.com> <20070227062913.GC1259@elte.hu> <20070227073815.GA25894@Krystal> <1172571535.5517.222.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1172571535.5517.222.camel@imap.mvista.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 10:44:06 up 25 days,  5:52,  3 users,  load average: 1.31, 1.69, 1.66
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Walker (dwalker@mvista.com) wrote:
> On Tue, 2007-02-27 at 02:38 -0500, Mathieu Desnoyers wrote:
> 
> > 
> > I am concerned about the automatic fallback to the PIT when no other
> > clock source is available. A clocksource read would be atomic when TSC
> > or HPET are available, but would fall back on PIT otherwise. There
> > should be some way to specify that a caller is only interested in atomic
> > clock sources (if none are available, the call should simply return an
> > error, or 0).
> > 
> I'm not sure what you mean by using the RCU

The original proposal of this thread uses a RCU (read-copy-update) style
update of the previous 64 bits counter : it swaps a pointer (atomically)
upon update by incrementing a word-sized counter that is used, by the
reader, to get the offest in the array (with a modulo operation) for the
current readable data and as a way to detect incorrect reads of
overwritten information (we re-read the word-sized counter after having
read the data structure to make sure is has not been incremented. If we
detect an increment, we redo the whole operation).

> > I still think that an RCU style update mechanism would be a good way  to
> > fix the current clocksource read issue. Another, slower and non NMI
> > safe way to do this would be with a read seqlock and with IRQ disabling.
> 
> , but the pit clocksource
> does disable interrupts with a spin_lock_irqsave().
> 

When I say "clocksource read issue", I am talking about
race between the function you proposed earlier, which you say is used in
-rt kernels for latency tracing (get_monotonic_cycles), and HPET and TSC
"last cycles" updates.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

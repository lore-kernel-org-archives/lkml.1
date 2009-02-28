Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZB1Nrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZB1Nrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 08:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZB1Nrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 08:47:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42620 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZB1Nrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 08:47:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A94032.9010105@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 14:46:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jonathan@jonmasters.org
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
References: <20090226131336.423054348@linutronix.de> <20090226131719.760899560@linutronix.de> <20090226153216.5db66bc3.akpm@linux-foundation.org> <20090226212752.332ba546@infradead.org> <20090226214514.f8a58731.akpm@linux-foundation.org> <1235719113.4948.1252.camel@laptop> <20090226234800.4977fca5.akpm@linux-foundation.org> <1235721910.4948.1321.camel@laptop> <20090227070633.2c3fc04e@infradead.org> <alpine.DEB.2.00.0902271024160.25593@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0902271024160.25593@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> The way softirqs are currently designed, you can not run them from
> the irq thread. We discovered this (the hard way) in the preempt-rt 
> kernel. The issue is that each softirq (threaded in preempt-rt, with a 
> thread for every CPU. ie. net-rx/0 net-rx/1 net-rx/2 net-rx/3 for a 4 CPU 
> box) is bound to a specific CPU. The design is to modify per cpu data. If 
> a IRQ thread were to run the softirq code and migrate to another CPU, you 
> will have very hard to debug crashes on your hands.

I presume that a lot of tasklet users rely on the fact that tasklets are
executed on the CPU which scheduled them.  (E.g. the firewire stack's
low level currently does.)

> We also tried to bind the IRQ thread to the CPU if it were to run a 
> softirq. But that too had issues. If the IRQ thread was bound to a CPU and 
> a higher priority process preempted it, that IRQ handler could not migrate 
> to another CPU to finish the work. Now the IRQ handler would need to wait 
> for that high priority process to give up the CPU in order to continue.
> 
> The solution is to redesign the softirq code to handle migration.

Do you mean "redesign the softirq framework" or "redesign the softirq
framework users"?

(In the particular case of firewire, the latter should be just fine.)
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbXKOJA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbXKOJA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 04:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbXKOJAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 04:00:48 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:63878 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbXKOJAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 04:00:47 -0500
Date: Thu, 15 Nov 2007 00:53:35 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: dean gaudet <dean@arctic.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071115085335.GB8603@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <18234.41652.199520.31261@cargo.ozlabs.ibm.com> <20071114103805.GA16652@infradead.org> <18234.53558.883970.87414@cargo.ozlabs.ibm.com> <20071114110009.GA17833@infradead.org> <p734pfp6lyp.fsf@bingen.suse.de> <alpine.DEB.0.9999.0711142006020.7260@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.9999.0711142006020.7260@twinlark.arctic.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 14, 2007 at 08:20:22PM -0800, dean gaudet wrote:
> On Wed, 14 Nov 2007, Andi Kleen wrote:
> 
> > Later a syscall might be needed with event multiplexing, but that seems
> > more like a far away non essential feature.
> 
> actually multiplexing is the main feature i am in need of. there are an 
> insufficient number of counters (even on k8 with 4 counters) to do 
> complete stall accounting or to get a general overview of L1d/L1i/L2 cache 
> hit rates, average miss latency, time spent in various stalls, and the 
> memory system utilization (or HT bus utilization).  this runs out to 
> something like 30 events which are interesting... and re-running a 
> benchmark over and over just to get around the lack of multiplexing is a 
> royal pain in the ass.
> 
> it's not a "far away non-essential feature" to me.  it's something i would 
> use daily if i had all the pieces together now (and i'm constrained 
> because i cannot add an out-of-tree patch which adds unofficial syscalls 
> to the kernel i use).
> 

Multiplexing in the context of perfmon2 means that you can measure more events
than there are counters. To make this work, we create the notion of an event set
or more precisely a register set. Each set encapsulates the full PMU state. Then
the kernel multiplexes the sets onto the actual PMU hardware.

Why do we need this?

As Dean pointed out, that are many important metrics which do require more events
than there are counters. Making multiple runs can be difficult with some workloads.

But there are also other, less known, reasons why you'd want to do this. This is
not because you have lots of counters that you can necessarily measure lots of
related events simultaneously. Take pentium 4 for instance, it has 18 counters, but
for most interesting metrics, you cannot measure all the events at once. Why? Because
there are important hardware constraints which translate into event combination 
constraints. It is not uncommon to have constraints such as:
	- event A and B cannot be measured together
	- event A can only be measured by counter X
	- if event A is measured, then only events B, C, D can be measured

This is not just on Itanium. Power has limitations, Intel Core 2 has limitations,
AMD Opterons also have limitations.

When you combine limited number of counters with strong constraints, it can quickly
become difficult to make measurements in one run.

Multiplexing is, of course, not as good as measuring all events continuously but
if you run for long enough and with a reasonable switching periods, the *estimates*
you get by scaling the obtained counts can be very close to what they would have
been had you measured all events all the time. You have to balance precision with
overhead.

Why do this in the kernel?

One might argue that there is nothing preventing tools from multiplexing at the user
level. That's true and we do support this as well. You have to:
		- stop monitoring
		- read out current counter
		- reprogram config and data registers
		- restart monitoring

But there are some important benefits for doing this in the kernel especially for
per-thread monitoring. When you are not self-monitoring, you would need to stop the
other thread first, then issue a minimum of 4 system calls and incur a couple of
context switches. By doing it in the kernel, you guaranteed that switching always occur
in the context of the monitored thread.

Furthermore it can be integrated with kernel-level sampling. Adding the notion
of event set is fairly pervasive and you need to make sure that it fits well with
the other parts of the interface.

-- 
-Stephane

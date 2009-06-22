Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZFVMQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZFVMQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750731AbZFVMQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:16:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZFVMQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:16:19 -0400
Date: Mon, 22 Jun 2009 14:16:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: eranian@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: IV.4 - Intel PEBS
Message-ID: <20090622121616.GB6760@one.firstfloor.org>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622120052.GS24366@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622120052.GS24366@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 02:00:52PM +0200, Ingo Molnar wrote:
> Having said that, PEBS is a hardware sampling feature that is
> definitely saner than AMD's IBS. There's two immediate incremental
> uses of it in perfcounters:
> 
>  - it makes flat sampling lower overhead by avoiding an NMI for all
>    sample points.
> 
>  - it makes flat sampled data more precise. (I.e. it can avoid the
>    1-2 instructions 'skidding' of a sample position, for a handful

There are realistic examples where the non pebs "shadow" can be far more
than that, even giving systematic error and hiding complete basic blocks.

>    of PEBS-capable events.)

There are a more reasons, especially on Nehalem there are some useful things
you can only measure with PEBS. e.g. memory latency or address
histograms (although the later is quite complicated). Also it 
has a lot more PEBS capable events than older parts.

Long term the trend is likely that more and more advanced PMU features
will require PEBS.

> Regarding demultiplexing on Nehalem: PEBS goes into the DS (Data
> Store), and indeed on Nehalem all PEBS counters 'mix' their PEBS
> records in the same stream of data. One possible model to support
> them is to set the PEBS threshold to one, and hence generate an
> interrupt for each PEBS record. At offset 0x90 of the PEBS record we

Then you would need the NMIs again, the NMI avoidance in PEBS only
works with higher thresholds.

> As to enabling PEBS with the (CPU-)global latency recording filters,
> we can do this transparantly for every PEBS supported event, or can
> mandate PEBS scheduling when a PEBS only feature like load latency
> is requested.
> 
> This means that for most purposes PEBS will be transparant.

One disadvantage here is that you're giving away a lot of measuring 
overhead: interrupts are always much more costly than a PEBS event directly
written by the CPU.

But when you support batching multiple PEBS events I suspect the consumer
needs to be aware of the limitations,  e.g. no precise time stamps.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

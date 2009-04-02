Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbZDBCUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbZDBCUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbZDBCUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:20:40 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:49104 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbZDBCUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:20:39 -0400
Date: Wed, 1 Apr 2009 22:15:29 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
In-Reply-To: <20090401190113.GA734@elte.hu>
Message-ID: <alpine.DEB.1.10.0904012210130.32656@qirst.com>
References: <20090325150035.541e707a@skybase> <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org>
 <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Apr 2009, Ingo Molnar wrote:

> > __read_mostly should be packed as tightly as possible to increase
> > the chance that one cacheline includes multiple of the critical
> > variables for the hot code paths. Too much __read_mostly defeats
> > its purpose.
>
> That stance is a commonly held but quite wrong and harmful IMHO.

Well that is the reason I introduced __read_mostly.

> It stiffles the proper identification of read-mostly variables _AND_
> it hurts the proper identification of critical write-often variables
> as well. Not good.

Well then lets create another way of annotating variables that does not
move them into a separate section.

> The solution for critical write-often variables is what we always
> used: to identify them explicitly and to place them consciously into
> separate cachelines. (Or to per-cpu-ify or object-ify them where
> possible/sensible.)

Right. But there are none here.

> Then annotate everything that is read-mostly and accessed-frequently
> with the __read_mostly attribute.

None of that is the case here. These are rarely used variables for
allocation and free of percpu variables.

>  - Thinking that this solves false cacheline sharing reliably is
>    wrong: there's nothing that guarantees and enforces that slapping
>    a few variables between two critical variables puts them on
>    separate cachelines:

__read_mostly reduces cacheline bouncing problems significantly by saying
that these variables are rarely updated and frequently used in critical
paths. Thus the special placement.

>  - It actually prevents true read-mostly variables from being
>    annotated properly. (In such a case a true read-mostly variable
>    bouncing around with a frequently-written variable cache line is
>    almost as bad in terms of MESI latencies and costs as false
>    cacheline sharing between two write-mostly variables.)

What I often thought we need is another per cpu read mostly section that
is always local NUMA wise. This means the percpu read mostly section would
be replicated per node. The update of such a read mostly variable would
then take a loop over all these per node segments which would be more
expensive. However, reads would always be local and thus it would be an
advantage.


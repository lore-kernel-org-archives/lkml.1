Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbXIZPl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbXIZPl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXIZPlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:41:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41802 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbXIZPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:41:20 -0400
Date: Wed, 26 Sep 2007 08:40:35 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926084035.0bda3eed@fujitsu-loaner>
In-Reply-To: <20070926133138.GA23187@elte.hu>
References: <20070926112919.GN3337@deprecation.cyrius.com>
	<MDEHLPKNGKAHNMBLJOLKCEPKHAAC.davids@webmaster.com>
	<20070926133138.GA23187@elte.hu>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 15:31:38 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * David Schwartz <davids@webmaster.com> wrote:
> 
> > > > I think the real fix would be for iperf to use blocking network
> > > > IO though, or maybe to use a POSIX mutex or POSIX semaphores.
> > >
> > > So it's definitely not a bug in the kernel, only in iperf?
> > 
> > Martin:
> > 
> > Actually, in this case I think iperf is doing the right thing
> > (though not the best thing) and the kernel is doing the wrong
> > thing. [...]
> 
> it's not doing the right thing at all. I had a quick look at the
> source code, and the reason for that weird yield usage was that
> there's a locking bug in iperf's "Reporter thread" abstraction and
> apparently instead of fixing the bug it was worked around via a
> horrible yield() based user-space lock.
> 
> the (small) patch below fixes the iperf locking bug and removes the 
> yield() use. There are numerous immediate benefits of this patch:
> 
>  - iperf uses _much_ less CPU time. On my Core2Duo test system,
> before the patch it used up 100% CPU time to saturate 1 gigabit of
> network traffic to another box. With the patch applied it now uses 9%
> of CPU time.
> 
>  - sys_sched_yield() is removed altogether
> 
>  - i was able to measure much higher bandwidth over localhost for 
>    example. This is the case for over-the-network measurements as
> well.
> 
>  - the results are also more consistent and more deterministic, hence 
>    more reliable as a benchmarking tool. (the reason for that is that
>    more CPU time is spent on actually delivering packets, instead of
>    mindlessly polling on the user-space "lock", so we actually max out
>    the CPU, instead of relying on the random proportion the workload
> was able to make progress versus wasting CPU time on polling.)
> 
> sched_yield() is almost always the symptom of broken locking or other 
> bug. In that sense CFS does the right thing by exposing such bugs =B-)
>  
> 	Ingo

A similar patch has already been submitted, since BSD wouldn't work
without it.

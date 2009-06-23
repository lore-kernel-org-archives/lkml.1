Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZFWIT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZFWIT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZFWITP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:19:15 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:51571 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbZFWITK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=XXMPI6EECOAhu4UskhFVjAKilSVSEyc9xF1pExrzZJNO6McyZTWWQf0j/S63Pm3VIT
         odFactxQTOenul5weUExPW0EADhsdZPjMteU0hyg8amGV6z/e3Ea+TFpFUofBxUDHKJc
         T+u3u9oS654wTChSZdRxzDimX5ZP0r4f2Q99k=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1245737987.19816.1477.camel@twins>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622120018.GR24366@elte.hu> <4A3F9062.6000303@renci.org>
	 <1245737987.19816.1477.camel@twins>
Date: Tue, 23 Jun 2009 10:19:12 +0200
Message-ID: <7c86c4470906230119g6df76304xbec11dc682176b09@mail.gmail.com>
Subject: Re: [perfmon2] IV.3 - AMD IBS
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rob Fowler <rjf@renci.org>, Ingo Molnar <mingo@elte.hu>,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 8:19 AM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>
> The 'problem' I have with IBS is that its basically a cycle counter
> coupled with a pretty arbitrary number of output dimensions separated
> into two groups, ops and fetches.
>
Well, that's your view. Mine is different.

You have 2 independent cycle counters (one for fetch, one for op),
each is coupled with a value. it is just that the value does not fit
into 64 bits. the cycle count is not hosted in a generic counter but
in its own register. The captured data for fetch is constructed with
IBSFETCHCTL, IBSFETCHLINAD, IBSFETCHPHYSAD. The 3
registers are tied together. The values they contain represent the
same fetch event. Same thing with IBS op. I don't see the problem
because your API is able to cope with variable length output data.
The sampling buffer certainly can. Of course, internally you'd have
to manage it in a special way, but you already do this for fixed
counters, don't you?

> This is a very weird configuration in that it has a miss-match with the
> traditional one value per counter thing.
>
This is not the universal model. I can give lots of examples on Itanium
where you have one config register and multiple data registers
to capture the event: branch trace buffer (1 config, 33 data), Data EAR
(cache/TLB miss sampling, 1 config 3 data),Instruction-EAR
(cache/TLB miss sampling, 1 config, 2 data).

> The most natural way to support IBS would be to have a special sampling
> cycle counter and use that as group lead and add non sampling siblings
> to that group to get individual elements.
>
As discussed in my message, I think the way to support IBS is to create two
pseudo-events (like your perf_hw_event_ids), one for fetch and one for op
(because they could be measured simultaneously). The sample_period field
would be used to express the IBS*CTL maxcnt, subject to the verification
that the bottom 4 bits must be 0. And then, you add  two new sampling formats
PERF_SAMPLE_IBSFETCH, PERF_SAMPLE_IBSOP. Those would only work
with IBS pseudo events. Once you have the randomize option in perf_counter_attr,
you could even enable IBSFETCH randomization.

What is wrong with this approach?

Another question is: how do you present the values contained in the IBS data
registers:
   1 - leave it as raw (tool parses the raw register values)
   2 - decode it in the kernel and expose your own format

With 1/, you'd pick up automatically new fields if AMD adds some.
With 2/, you'd have to change your format if AMD change theirs.



> This is however quite cumbersome.
>
> One thing to consider when building an IBS interface is its future
> extensibility. In which fashion would IBS be extended?, additional
> output dimensions or something else all-together?
>
I don't know but it would be nice to provide better filtering capabilities
but for that, they can use some of the reserved bits they have, no
need to add more data registers.

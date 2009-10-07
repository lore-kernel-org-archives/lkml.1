Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbZJGMci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbZJGMci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbZJGMci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:32:38 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:54064 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741AbZJGMch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=APr1DBYj0VKNwHMWnKY71gSGPRDdRn6AYwuBRuDjhetgnU9AfIzKezjCwW+047gnJw
         hdvQe1M+0p/HFR71UO5yABzqUokqyfL0mbx7gO+N/0msALR45ymR0eHkv/an8BBUe1rh
         sBWG7t3T/sHKb+JH2FO5iHlTqFNRJpSbN48S8=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <19148.30773.350036.411105@cargo.ozlabs.ibm.com>
References: <1254840129-6198-1-git-send-email-eranian@gmail.com>
	 <1254840129-6198-2-git-send-email-eranian@gmail.com>
	 <1254840129-6198-3-git-send-email-eranian@gmail.com>
	 <1254846544.21044.298.camel@laptop>
	 <7c86c4470910061026o247c182dwdea7fa7296027@mail.gmail.com>
	 <1254911461.26976.239.camel@twins>
	 <19148.30773.350036.411105@cargo.ozlabs.ibm.com>
Date: Wed, 7 Oct 2009 14:31:58 +0200
Message-ID: <7c86c4470910070531s8ff0d54xb29c22dd982aa387@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for Intel 
	processors
From: stephane eranian <eranian@googlemail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Wed, Oct 7, 2009 at 1:15 PM, Paul Mackerras <paulus@samba.org> wrote:
> Peter Zijlstra writes:
>
>> > By design of this API, the user should never be concerned about
>> > ordering the events
>> > in a group a certain way to get a successful assignment to counters.
>> > This should all
>> > be handled by the kernel.
>>
>> Agreed, the POWER implementation actually does this quite nicely, maybe
>> we should borrow some of its code for scheduling groups.
>
> Yeah, I'm quite pleased with how that code turned out, and I'd be
> happy to help adapt it for other architectures.  The one design
> handles all the POWER PMUs from POWER4 with multiple layers of event
> multiplexers feeding an event bus (and some events available through
> more than one multiplexer) through to the much simpler and more
> straightforward POWER7.
>
I am not an expert on PPC PMU register constraints but I took a quick look
at the code and in particular hw_perf_enable() where the action seems to be.

Given that in kernel/perf_events.c, the PMU specific layer is invoked on a per
event basis in event_sched_in(), you need to have a way to look at the registers
you have already assigned. I think this is what PPC does. it stops the PMU and
re-runs the assignment code. But for that it needs to maintains a
per-cpu structure
which has the current event -> counter assignment.

What PPC does is probably the only way to do this given the interface between
generic and machine-specific code. The one advantage I see is that it works
inside an event group but also across event groups because that code does not
look at group boundary, it only looks at the events and the number of available
registers. The downside is that you duplicate state.

Did I get this right, Paul?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0BSNV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 08:21:56 -0500
Received: from mga06.intel.com ([134.134.136.21]:39971 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752062Ab0BSNVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 08:21:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,503,1262592000"; 
   d="scan'208";a="493829569"
Message-ID: <4B7E906D.8050501@linux.intel.com>
Date: Fri, 19 Feb 2010 14:21:49 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
References: <20100123113359.GA29555@one.firstfloor.org> <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu> <4B7B1C40.8070208@linux.intel.com> <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain> <20100219121734.GA8300@basil.fritz.box> <20100219124540.GC30243@aftab>
In-Reply-To: <20100219124540.GC30243@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav,

> <snip all the perf analysis>
>
> I think you're missing the point - it doesn't have to be
> perf. It could just as well be some other tool which _shares_

That was one of my points, but there were others too about
the suitability of the kernel infra structure and the interfaces.

I don't think the perf syscall interface (nor the internal
implement) in its current form is good for errors and also see no clear
path to make it so (without basically adding another different interface)

> functionality with perf. See this last mail from Ingo:
> http://marc.info/?l=linux-kernel&m=126635420607236 on which you were
> also CCed, by the way, where he suggests that we could have a tool
> called 'hw' which reuses functionality with perf but concentrates on
> error handling and all that RAS functionality in modern CPUs. It should
> also have a daemon component etc...

So you would have different interfaces: you don't really
need new syscalls for this (read/write is fine) and perf_counter_open()
in its current form is completely unsuitable for errors
(unless your error reporting registers look like a x86 PMU --
mine doesn't at least) And different userland. And the kernel internal
requirements are very different too (see previous email)

Where is the commonality with perf?

On the tool side:

I'm working on such a tool already for quite some time. It's
called mcelog. Now it uses an older interface today, but at some
point I would expect it to move to other interfaces too
(e.g. next step for that would be APEI errors)

If you only knew mcelog from a few years ago: it's quite
different today than it was and please look again.

That is the end result will be likely called different
(it doesn't make much sense to call something that handles
all kinds of errors "mcelog") and also some stuff needs
to be more generic, but I suspect it'll share quite some
concepts.

If the only problem is the naming we can probably work something
out? In principle it could be called "hw", but the name
seems awfully generic, especially for a daemon. I was more
tending something like "errord" or so.

On the topology: I was not trying to replace existing
topology tools (like lscpu, lspci etc.). I don't see any
major problems (apart from some details that don't
deserve a redesign) with them.

>
>>> year. You are refusing to work with other people on a well designed
>
> Sorry, but from our last discussion on attempting to work towards such
> an infrastructure solution I got the same impression as Thomas and Ingo
> that you're simply not willing to work together on getting a real thing
> done. That's why I stopped bothering - it simply made no sense to me to
> waste time in fruitless discussions.

Well I keep ignoring suggestions to put more stuff into EDAC,
mostly because I think the EDAC design needs to be thrown out
instead of extended. Are you referring to that?

My impression was that you  got to the same conclusion (at least
for parts of current EDAC like the events) based on your earlier emails.

The current issue is less in enumeration/topology anyways but more
in event handling I would say. In the end topology/enumeration is
the easier part, and most of it is already working quite well.

I'm trying to do things step by step, including for short term
problems extending current interfaces if possible and then longer
term moving to new better interfaces.

-Andi


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbXCEQ21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbXCEQ21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbXCEQ21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:28:27 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:21921 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXCEQ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:28:26 -0500
X-IronPort-AV: i="4.14,251,1170651600"; 
   d="scan'208"; a="29987352:sNHT29353219"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Paul Mundt" <lethal@linux-sh.org>
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Date: Mon, 5 Mar 2007 11:29:19 -0500
User-Agent: KMail/1.9.5
Cc: "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Wu, Bryan" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <200703050826.56966.rgetz@blackfin.uclinux.org> <20070305140048.GA14149@linux-sh.org>
In-Reply-To: <20070305140048.GA14149@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051129.19234.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 05 Mar 2007 16:28:22.0393 (UTC) FILETIME=[4AB14E90:01C75F43]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 5 Mar 2007 09:00, Paul Mundt pondered:
> On Mon, Mar 05, 2007 at 08:26:56AM -0500, Robin Getz wrote:
> > On Mon 5 Mar 2007 07:39, Paul Mundt pondered:
> > > On Mon, Mar 05, 2007 at 01:32:07PM +0100, Bernd Schmidt wrote:

> >
> > That is what this does - it is just a easy to use knob.
>
> This is hardly a knob, you're adding one config option per function to
> relocate in to the L1 memory, leaving it up to the user to decide what's
> best positioned there from the kernel point of view and what's left with
> userspace to play with. This is simply _not_ how you want to do this
> sort
> of interface, rather than making any sort of usability decisions, you've
> pushed it all on the user under the label of flexibility.
>
> What happens now if you suddenly start having other blocks of SRAM in
> future parts that are either shared across CPUs or just more buffer
> space
> for a single CPU? Do you start to repeat the config options for that
> space, too?
>
> There are things that will be a win to have located in on-chip SRAM, and
> others that will be less important. If you're concerned about this, you
> should simply pinpoint the hot paths that benefit the most from being
> relocated and weight that against a build-time configuration of how much
> room the user wants to play with. This way you can figure out all of
> your
> limits directly at link time, as you're arguably looking at an
> effectively static configuration anyways.
>
> If you really want to break it down on priority, use something similar
> to
> initcall levels. Start with the most critical bits, and stash as much as
> possible in whatever on-chip memory you have available (while heeding
> the
> user constraints) and then spill the rest to system memory.
>
> Throwing this all at the user simply shows that the functions being
> relocated haven't been profiled adequately with real workloads. 

Actually - that is not true at all - we have profiled these extensively across 
many workloads on various real world applications from fax machine to bar 
code scanner, to software radio, to internet radio - and that is the point - 
it all depends on what the user application/drivers that are loaded are 
doing. I can't decided what is best for the user, because I don't know what 
they are doing.

> You can't seriously expect your users to define what's the most timing
> critical and hope to get useful result.

Yeah, we do - and the users who want to get the best performance - spend the 
effort in doing so - the others live with the defaults.

> These are simply not things the user should ever _care_ about.

Maybe users on Blackfin are more sophisticated than ones using SH?

The reason we did this - is because we saw many end users doing the same 
thing, and wanted to give people a standard way to do it - that we could 
test/stand behind and give people support.

> If a user 
> wants to use on-chip memory, presumably they have a target application
> in mind, and they know how much space they need. Beyond that, they expect
> the kernel to do the best it can with the space that's left over for it
> to play with. 

And that is the problem - the kernel doesn't know how much on chip memory an 
application which will be loaded in the future might need. The user needs to 
be able to control the amount of on-chip memory that the kernel uses - hence 
the knobs.

> If a user has to sit around profiling their workload to 
> figure out what config options to set to chew through the rest of the L1
> memory, you've completely lost at intuitive design.

Embedded has never been intuitive.

Normally, the majority of end users leave things set by the default, meaning 
their application doesn't use the on-chip memory, and the kernel is allowed 
to. If they want to start using on-chip memory, they are forced to do a 
re-compile, with the kernel functions using off-chip memory, and see how much 
of on-chip memory their application uses. They calculate the difference, and 
do a little system level profiling, and put the most used kernel functions 
back.

Although this isn't intuitive., it is pretty straight forward and mechanical. 
People do it all the time.

> This is like taking the KDE approach to UI design and applying it to the
> kernel, exposing every possible setting as a user-settable option and
> avoiding setting any sort of sane default in the hope that user knows
> best. This simply doesn't work.

There is a certain level of user sophistication expected when designing a 
deeply embedded application. I don't think this is a good comparison. 
Besides - I like (and use) all the knobs in KDE.

You are asking me to try to decide what is best for all the potential end 
users, with out knowing what the end user is doing. What ends up happening is 
that people make modifications (normally poor ones) and then still ask for 
help when their modifications break.

I would rather give them a supported (but arguablely confusing) method of 
customisation. (This is why it was added - end users were asking for it, and 
when we didn't have it, they would try to make the modifications themselves, 
break it, and report a bug. After telling 8 different people the same thing, 
when do you decide this is a feature you need to support?)

-Robin

-Robin

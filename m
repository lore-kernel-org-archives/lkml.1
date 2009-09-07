Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZIGXUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZIGXUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 19:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZIGXUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 19:20:17 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45497 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZIGXUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 19:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WejHdjmgEhcSjgYYol+wIpbIJ2r/+XOXCVzeMTVYnqowvGGKnOU8NdtbM5LUhSJO+r
         KYsXLOEOQZkhYo7evtbfvWhV9z/tO9rJVq/LO6OfWizqKxs8Og/25qJk2GsO0aO+8nWa
         nOFqzQaFgemtmu3JgwaJPHezMCPI//uZaJx9s=
Date: Tue, 8 Sep 2009 01:20:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: HW breakpoints vs. KVM context switches
Message-ID: <20090907232010.GA6312@nowhere>
References: <4AA54150.3000101@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA54150.3000101@siemens.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 07:22:24PM +0200, Jan Kiszka wrote:
> Hi,
> 
> as we currently face some abstraction issue around hardware breakpoints
> in kvm, I had a look again at the state of your work. I assume it's on a
> good way towards mainline, right?


Well, I'm about to post a patchset that refactores the breakpoint API
on top of perf counter instances.

If the approach is agreed and that hits mainline, that may make it
easier for you (more explanations follow).

 
> So far kvm (on x86) switches debug registers between host and guest
> fairly conservatively: If the guest has some breakpoint in use, the host
> registers are read from the hardware and restored to it on return. This
> is not really optimal, specifically as dr6/dr7 are currently touched
> unconditionally.


Indeed.


> Now Avi's idea is to skip saving the registers as we could also restore
> them from current->thread.debugregX whenever required. IIUC this will no
> longer be true when hw-breakpoints hit mainline. It is already wrong for
> kgdb as that breakpoint user touches the registers without asking anyone
> (or at least informing others).



Yeah in the current implementation in -tip, we have user breakpoints and
kernel breakpoints. The former records debug registers in the thread_struct
across sched switch events, so the approach is correct for them, but the latter
doesn't need to do that as it deals with global wide breakpoints, so it induces
some corner cases.

 
> My question is now if we could extend the hw-breakpoint interface in a
> way, either arch-specific or even generic, that kvm could easily use it
> to restore the host's debug register state if required.


So, if the new implementation on top of perfcounter makes its way, you won't
anymore need to deal with the various possible breakpoints context in use
(kernel wide and user), instead you'll need to check the current active
perf counter context in a given cpu and list its breakpoint counters to disable
their pmu.

Well, actually I think this is something that should be handled by perfcounter
itself. It should be able to handle the hardware register scheduling while
switching between host and guest. The problem then overlaps the single
breakpoint circle and also involves every kind of counters that handle
hardware registers.

I'm not sure but, perf already handles that right? If it does, then the
breakpoints save/restore issue won't be a problem anymore.


> 
> Moreover, I think we also need some interface extension for kgdb. I
> guess it wants ultimate access to the registers on all CPUs, and it
> likely don't want to debate about this with the kernel (==acquire
> locks). Still the hw-breakpoint layer would likely want to know if kgdb
> is claiming the hardware so that it can step back from touching them.
> Also kvm would like to hear about this + access to their (cached)
> content for proper restoration.
> 
> So far the theory. Before starting to craft any prototypes, I would like
> to hear your opinion on this.


It depends if perf already supports the switches between guest/host using
tunable parameters in its counters. IIRC, it can, but I don't know much
about this perf area.

Ingo, Peter?


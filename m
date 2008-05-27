Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbYE0N2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbYE0N2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbYE0N2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:28:16 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:47969 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290AbYE0N2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:28:15 -0400
Date: Tue, 27 May 2008 18:59:09 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080527132909.GC5181@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	balbir@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
	Michael Neuling <mikey@neuling.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <483AF25B.6090806@linux.vnet.ibm.com> <20080526110040.5ddc4656@infradead.org> <483B0348.2000204@linux.vnet.ibm.com> <20080526115108.6a19e2c0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080526115108.6a19e2c0@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2008-05-26 11:51:08]:

> On Tue, 27 May 2008 00:06:56 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > Arjan van de Ven wrote:
> > > On Mon, 26 May 2008 22:54:43 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > >> Arjan,
> > >>
> > >>
> > >> These problems exist anyway, irrespective of scaled accounting (I'd
> > >> say that they are exceptions)
> > >>
> > >> 1. The management tool does have access to the current frequency
> > >> and maximum frequency, irrespective of scaled accounting. The
> > >> decision could still be taken on the data that is already
> > >> available and management tools can already use them 
> > > 
> > > it's sadly not as easy as you make it sound. From everything you
> > > wrote you're making the assumption "if we're not at maximum
> > > frequency, we have room to spare", which is very much not a correct
> > > assumption
> > > 
> > 
> > That's true in general. If the CPUs are throttled due to overheating,
> > the system management application will figure out that it cannot
> > change the frequency. 
> 
> It's not the system management application but the kernel (and the
> hardware! Esp in case of IDA) that manage the frequency. 
> 
> > How do I interpret my CPU frequency applet's
> > data when it says that the system is running at 46%?
> 
> That is a very good question. The answer is "uhh badly". Sad but true.
> I'm not arguing against that.
> The problem I have is that what you're doing does not make it better!
> 
> > 
> > >> 2. With IDA, we'd have to
> > >> document that APERF/MPERF can be greater than 100% if the system is
> > >> overclocked.
> > >>
> > >> Scaled accounting only intends to provide data already available.
> > >> Interpretation is left to management tools and we'll document the
> > >> corner cases that you just mentioned.
> > > 
> > > IDA is not overclocking, nor is it a corner case *at all*. It's the
> > > common case in fact on more modern systems. Having the kernel
> > > present "raw" data to applications that then have no idea how to
> > > really use it to be honest isn't very attractive to me as idea:
> > > you're presenting a very raw hardware interface that will keep
> > > changing over time in terms of how to interpret the data... the
> > > kernel needs to abstract such hard stuff from applications, not
> > > fully expose them to it. Especially since these things *ARE* tricky
> > > and *WILL* change. Future x86 hardware will have behavior that
> > > makes the "oh we'll document the corner cases" extremely
> > > unpractical. Heck, even todays hardware (but arguably not yet the
> > > server hardware) behaves like that. "Documenting the common case as
> > > corner case" is not the right thing to do when introducing some new
> > > behavior/interface. Sorry.
> > 
> > Before I argue against that, I would like to ask
> > 
> > 1. How are APERF/MPERF be meant to be utilized?
> 
> It's meant to be used by the cpu frequency governors to figure out how
> many actual cycles are actually used (esp needed in case of IDA).
> 
> > 2. The CPU frequency driver/governer uses APERF/MPERF as well - we
> > could argue and say that it should not be using/exposing that data to
> > user space or using that data to make decisions.
> 
> that's a case where it really makes sense; it's the case where the
> thing that controls the cpu P-state actually learns about how much work
> was done to reevaluate what the cpu frequency should be going forward.
> Eg it's a case of comparing actual frequency (APERF/MPERF) to see
> what's useful to set next.
> IDA makes this all needed due to the dynamic nature of the concept of
> "frequency".

Scaled statistics relative to maximum CPU capacity is just a method of
exposing the actual CPU utilisation of applications independent of CPU
frequency changes.

Reason behind the metric is same as the above fact that you have
mentioned.  The CPU frequency governors cannot make decisions only
based on idle time ratio.  It needs to know current utilisation (used
cycles) relative to maximum capacity so that the frequency can be
changed to next higher level.

Higher level management software that wants to control CPU capacity
externally will need similar information.

> 
> > 3. How do I answer the following problem
> > 
> > My CPU utilization is 50% at all frequencies (since utilization is
> > time based), does it mean that frequency scaling does not impact my
> > workload?
> 
> without knowing anything else than this, then yes that would be a
> logical conclusion: the most likely cause would be because your cpu is
> memory bound. In fact, you could then scale down your cpu
> frequency/voltage to be lower, and save some power without losing
> performance. 
> It's a weird workload though, its probably a time based thing where you
> alternate between idle and fully memory bound loads.
> 
> (which is another case where your patches would then expose idle time
> even though your cpu is fully utilized for the 50% of the time it's
> running)
> 
> 
> 
> -- 
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org

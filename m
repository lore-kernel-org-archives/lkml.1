Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbXLGPze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbXLGPze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 10:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbXLGPz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 10:55:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbXLGPzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 10:55:25 -0500
Date: Fri, 7 Dec 2007 10:53:31 -0500
From: Neil Horman <nhorman@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Ben Woodard <woodard@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071207155331.GC10389@hmsendeavour.rdu.redhat.com>
References: <20071128190525.GD3192@redhat.com> <474F7177.7050306@redhat.com> <20071130144250.GC23810@redhat.com> <20071130145131.GB5822@hmsendeavour.rdu.redhat.com> <20071206213951.GB28898@hmsreliant.think-freely.org> <20071206221143.GC2863@redhat.com> <20071207001023.GA7312@hmsendeavour.rdu.redhat.com> <20071207143944.GF2863@redhat.com> <20071207145315.GB10389@hmsendeavour.rdu.redhat.com> <20071207151623.GG2863@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207151623.GG2863@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 10:16:23AM -0500, Vivek Goyal wrote:
> On Fri, Dec 07, 2007 at 09:53:15AM -0500, Neil Horman wrote:
> > On Fri, Dec 07, 2007 at 09:39:44AM -0500, Vivek Goyal wrote:
> > > On Thu, Dec 06, 2007 at 07:10:23PM -0500, Neil Horman wrote:
> > > > On Thu, Dec 06, 2007 at 05:11:43PM -0500, Vivek Goyal wrote:
> > > > > On Thu, Dec 06, 2007 at 04:39:51PM -0500, Neil Horman wrote:
> > > > > > On Fri, Nov 30, 2007 at 09:51:31AM -0500, Neil Horman wrote:
> > > > > > > On Fri, Nov 30, 2007 at 09:42:50AM -0500, Vivek Goyal wrote:
> > > > > > <snip>
> > > > > > > 
> > > > > > > Thats what I'm doing at the moment.  I'm working on a RHEL5 patch at the moment
> > > > > > > (since thats whats on the production system thats failing), and will forward
> > > > > > > port it once its working
> > > > > > > 
> > > > > > > And not to split hairs, but techically thats not our _only_ choice.  We could
> > > > > > > force kdump boots on cpu0 as well ;)
> > > > > > > 
> > > > > > > Thanks
> > > > > > > Neil
> > > > > > > 
> > > > > > > > Thanks
> > > > > > > > Vivek
> > > > > > > 
> > > > > > 
> > > > > > 
> > > > > > Sorry to have been quiet on this issue for a few days. Interesting news to
> > > > > > report, though.  So I was working on a patch to do early apic enabling on
> > > > > > x86_64, and had something working for the old 2.6.18 kernel that we were
> > > > > > origionally testing on.  Unfortunately while it worked on 2.6.18 it failed
> > > > > > miserably on 2.6.24-rc3-mm2, causing check_timer to consistently report that the
> > > > > > timer interrupt wasn't getting received (even though we could successfully run
> > > > > > calibrate_delay).  Vivek and I were digging into this, when I ran accross the
> > > > > > description of the hypertransport configuration register in the opteron
> > > > > > specification.  It contains a bit that, suprise, configures the ht bus to either
> > > > > > unicast interrupts delivered accross the ht bus to a single cpu, or to broadcast
> > > > > > it to all cpus.  Since it seemed more likely that the 8259 in the nvidia
> > > > > > southbridge was transporting legacy mode interrupts over the ht bus than
> > > > > > directly to cpu0 via an actual wire, I wrote the attached patch to add a quirk
> > > > > > for nvidia chipsets, which scanned for hypertransport controllers, and ensured
> > > > > > that that broadcast bit was set.  Test results indicate that this solves the
> > > > > > problem, and kdump kernels boot just fine on the affected system.
> > > > > > 
> > > > > 
> > > > > Hi Neil,
> > > > > 
> > > > > Should we disable this broadcasting feature once we are through? Otherwise
> > > > > in normal systems it might mean extra traffic on hypertransport. There
> > > > > is no need for every interrupt to be broadcasted in normal systems?
> > > > > 
> > > > > Thanks
> > > > > Vivek
> > > > 
> > > > No, I don't think thats necessecary.  Once the apics are enabled, interrupts
> > > > shouldn't travel accross the hypertransport bus anyway, opting instead to use
> > > > the dedicated apic bus (at least thats my understanding).
> > > 
> > > I think all interrupt message travel on hypertransport. Even after APICS
> > > have been enabled.
> > > 
> > > Look at the following document.
> > > 
> > > http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24674.pdf
> > > 
> > > Have a look at figure 1, figure 2 and section 3.4.2.2 and 3.4.2.3
> > > 
> > > That's a different thing that once IOAPIC has formed the vectored message,
> > > Hypertransport might not touch the destination field.
> > >  
> > Ok, that might be the case then.
> > 
> > > Having said that, I am wondering what will happen if a system continues
> > > to operate the timer through IOAPIC in ExtInt mode. Will hypertransport
> > > keep on broadcasting that interrupt to every cpu? And every cpu will 
> > > process that interrupt.
> > > 
> > I don't think so.  IIRC once the other cpus are started they all disable the
> > timer interrupt, except for one cpu, opting instead to get the timer tick via
> > ipi, So while they all might see the interrupt packet on the ht bus, only one
> > cpu will process it.
> > 
> 
> Does LAPIC allow to disable a specific vector and not accept interrupts? I
> don't think so. If a timer interrupt is broadcasted to every cpu I think
> everybody will accept it (like broadcast IPI). That's why intelligence
> is built into IOAPIC and direct interrupts to a cpu or group of cpu.
> 
See disable_APIC_timer().  It seems to set the mask bit in the APIC_LVTT entry.

> I am just trying to understand the functionality better. Can somebody help me
> understand how do we make sure that same timer interrupt is not processed by
> all cpus (assuming hypertransport is broadcasting it)?
> 
I understand your desire, but clearly, something prevents it.  Note our earlier
conversation, this bit doesn't actually force a unicast of an interrupt packet,
but simply masks the destination field.  When set to zero, it simply means that
the ht interrupt packet destination field is restricted to 4 bits rather than 8.
So its not like when its set to zero we are guaranteed that it is forced to a
single processor anyway.  All setting this bit does is ensure that if any apics
out on a system are addresed using an extended apic id, that interrupts can
reach them.  Thats why it was suggested that this bit only be forcibly set if
bit 18 is also set.

> > > Hence, I feel it is safe to restore the broadcast bit back to BIOS value once
> > > we are through calibrate_delay().
> > > 
> > I disagree.  Looking at what Yinghai said, the default setting for the broadcast
> > bit isn't actually to unicast the interrupt, its just to set the broadcast mask
> > to 0xF, or to 0xFF.  Its use is actually to allow cpus with an extended 8 bit
> > apic id see interrupts.  So its not so much to direct interrupts to cpu0, but
> > rather to the first 16 cpus rather than to all 255 available cpus.  From what
> > I've seen in my testing, systems that 'work' already have this bit set by bios,
> > and my quirk patch above does nothing to them.  Disabling this bit after
> > calibrate_dealy is going to introduce more uncertainty in systems that have been
> > proven to work.
> 
> Again for my understanding, I got few questions.
> 
> - Why does nvidia choose not to broadcast the interrupts and still works
>   fine? Does that mean nvidia chipse will not work the extended cpu apic
>   ids?
> 
It doesn't! When booting normally getting interrupts to apics that use 4 bit
apic ids is sufficient since cpu0 is in that set, but if we crash on a cpu with
an extended id, we hang.

> - IOW, why do other chipsets choose to broadcast the interrupts and 
>   nvidia chooses not to and still works well.
> 
It doesnt!  It hangs in the kdump kernel.  It works well normally because
interrupts are delivered to cpus who's apic ids fit into 4 bits.


> - Why do I need to broadcast the interrupts and not target specific cpus?
> 
Its not a forced broadcast, its a mask on the apic id.  The IOAPIC still
addresses specific cpus.

> - If I am broadcasting interrupts, how do I make sure only one cpu
>   picks it up.
> 
The IOAPIC handles that.

Regards
Neil

> 
> Thanks
> Vivek

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/

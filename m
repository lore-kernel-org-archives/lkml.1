Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbXLGALr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbXLGALr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXLGALk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:11:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXLGALj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:11:39 -0500
Date: Thu, 6 Dec 2007 19:10:23 -0500
From: Neil Horman <nhorman@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, Neil Horman <nhorman@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071207001023.GA7312@hmsendeavour.rdu.redhat.com>
References: <20071127222408.GH24223@one.firstfloor.org> <474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com> <20071128160206.GA21286@hmsendeavour.rdu.redhat.com> <20071128190525.GD3192@redhat.com> <474F7177.7050306@redhat.com> <20071130144250.GC23810@redhat.com> <20071130145131.GB5822@hmsendeavour.rdu.redhat.com> <20071206213951.GB28898@hmsreliant.think-freely.org> <20071206221143.GC2863@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206221143.GC2863@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 05:11:43PM -0500, Vivek Goyal wrote:
> On Thu, Dec 06, 2007 at 04:39:51PM -0500, Neil Horman wrote:
> > On Fri, Nov 30, 2007 at 09:51:31AM -0500, Neil Horman wrote:
> > > On Fri, Nov 30, 2007 at 09:42:50AM -0500, Vivek Goyal wrote:
> > <snip>
> > > 
> > > Thats what I'm doing at the moment.  I'm working on a RHEL5 patch at the moment
> > > (since thats whats on the production system thats failing), and will forward
> > > port it once its working
> > > 
> > > And not to split hairs, but techically thats not our _only_ choice.  We could
> > > force kdump boots on cpu0 as well ;)
> > > 
> > > Thanks
> > > Neil
> > > 
> > > > Thanks
> > > > Vivek
> > > 
> > 
> > 
> > Sorry to have been quiet on this issue for a few days. Interesting news to
> > report, though.  So I was working on a patch to do early apic enabling on
> > x86_64, and had something working for the old 2.6.18 kernel that we were
> > origionally testing on.  Unfortunately while it worked on 2.6.18 it failed
> > miserably on 2.6.24-rc3-mm2, causing check_timer to consistently report that the
> > timer interrupt wasn't getting received (even though we could successfully run
> > calibrate_delay).  Vivek and I were digging into this, when I ran accross the
> > description of the hypertransport configuration register in the opteron
> > specification.  It contains a bit that, suprise, configures the ht bus to either
> > unicast interrupts delivered accross the ht bus to a single cpu, or to broadcast
> > it to all cpus.  Since it seemed more likely that the 8259 in the nvidia
> > southbridge was transporting legacy mode interrupts over the ht bus than
> > directly to cpu0 via an actual wire, I wrote the attached patch to add a quirk
> > for nvidia chipsets, which scanned for hypertransport controllers, and ensured
> > that that broadcast bit was set.  Test results indicate that this solves the
> > problem, and kdump kernels boot just fine on the affected system.
> > 
> 
> Hi Neil,
> 
> Should we disable this broadcasting feature once we are through? Otherwise
> in normal systems it might mean extra traffic on hypertransport. There
> is no need for every interrupt to be broadcasted in normal systems?
> 
> Thanks
> Vivek

No, I don't think thats necessecary.  Once the apics are enabled, interrupts
shouldn't travel accross the hypertransport bus anyway, opting instead to use
the dedicated apic bus (at least thats my understanding).  The only systems what
you are suggesting would help with are systems that have no apic at all, which I
can only imagine on 64 bit systems is rare, to say the least.  The affected
domain is further reduced by the fact that this quirk is only currently being
applied to systems with nvidia PCI bridges, since those are the only systems
that this problem has manifested on.  That seems like a rather small subset, if
it exists at all.  I suppose we could only optionally enable the quirk if we
are booting a kdump kernel (implying that we would need to do something like
detect the reset_devices command line option), but I think given the limited
affect this patch, its not really needed.

Regards
Neil

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@redhat.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/

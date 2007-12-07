Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXLGIu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXLGIu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 03:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbXLGIus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 03:50:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:37874 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbXLGIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 03:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=twnC8Xp70i5agg7qbfxtLalKSF7JcY43ELcjfb+2FJM/xpaRVY+JUs/DlMElzge0r222UrNnzuo6y50sIePXmsaEb/aYwTxBkeJfyE/sqMI+hpz8iHU6SYnNHuAssLltKDVqSee0PL/KVk1NVv/27opjXud6oqdG3153N7JmqNI=
Message-ID: <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com>
Date: Fri, 7 Dec 2007 00:50:45 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Cc: "Vivek Goyal" <vgoyal@redhat.com>, "Neil Horman" <nhorman@tuxdriver.com>,
       "Neil Horman" <nhorman@redhat.com>, "Ben Woodard" <woodard@redhat.com>,
       "Andi Kleen" <andi@firstfloor.org>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       hbabu@us.ibm.com
In-Reply-To: <m1bq93s5r8.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071127200011.GA3703@redhat.com>
	 <20071128153649.GC3192@redhat.com>
	 <20071128160206.GA21286@hmsendeavour.rdu.redhat.com>
	 <20071128190525.GD3192@redhat.com> <474F7177.7050306@redhat.com>
	 <20071130144250.GC23810@redhat.com>
	 <20071130145131.GB5822@hmsendeavour.rdu.redhat.com>
	 <20071206213951.GB28898@hmsreliant.think-freely.org>
	 <20071206221143.GC2863@redhat.com>
	 <m1bq93s5r8.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 6, 2007 4:33 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
>
>
> > On Thu, Dec 06, 2007 at 04:39:51PM -0500, Neil Horman wrote:
> >> On Fri, Nov 30, 2007 at 09:51:31AM -0500, Neil Horman wrote:
> >> > On Fri, Nov 30, 2007 at 09:42:50AM -0500, Vivek Goyal wrote:
> >> <snip>
> >> >
> >> > Thats what I'm doing at the moment.  I'm working on a RHEL5 patch at the
> > moment
> >> > (since thats whats on the production system thats failing), and will forward
> >> > port it once its working
> >> >
> >> > And not to split hairs, but techically thats not our _only_ choice.  We
> > could
> >> > force kdump boots on cpu0 as well ;)
> >> >
> >> > Thanks
> >> > Neil
> >> >
> >> > > Thanks
> >> > > Vivek
> >> >
> >>
> >>
> >> Sorry to have been quiet on this issue for a few days. Interesting news to
> >> report, though.  So I was working on a patch to do early apic enabling on
> >> x86_64, and had something working for the old 2.6.18 kernel that we were
> >> origionally testing on.  Unfortunately while it worked on 2.6.18 it failed
> >> miserably on 2.6.24-rc3-mm2, causing check_timer to consistently report that
> > the
> >> timer interrupt wasn't getting received (even though we could successfully run
> >> calibrate_delay).  Vivek and I were digging into this, when I ran accross the
> >> description of the hypertransport configuration register in the opteron
> >> specification.  It contains a bit that, suprise, configures the ht bus to
> > either
> >> unicast interrupts delivered accross the ht bus to a single cpu, or to
> > broadcast
> >> it to all cpus.  Since it seemed more likely that the 8259 in the nvidia
> >> southbridge was transporting legacy mode interrupts over the ht bus than
> >> directly to cpu0 via an actual wire, I wrote the attached patch to add a quirk
> >> for nvidia chipsets, which scanned for hypertransport controllers, and ensured
> >> that that broadcast bit was set.  Test results indicate that this solves the
> >> problem, and kdump kernels boot just fine on the affected system.
> >>
> >
> > Hi Neil,
> >
> > Should we disable this broadcasting feature once we are through? Otherwise
> > in normal systems it might mean extra traffic on hypertransport. There
> > is no need for every interrupt to be broadcasted in normal systems?
>
> My feel is that if it is for legacy interrupts only it should not be a problem.
> Let's investigate and see if we can unconditionally enable this quirk
> for all opteron systems.

i checked that bit

http://www.openbios.org/viewvc/trunk/LinuxBIOSv2/src/northbridge/amd/amdk8/coherent_ht.c?revision=2596&view=markup

static void enable_apic_ext_id(u8 node)
{
#if ENABLE_APIC_EXT_ID==1
#warning "FIXME Is the right place to enable apic ext id here?"

      u32 val;

        val = pci_read_config32(NODE_HT(node), 0x68);
        val |= (HTTC_APIC_EXT_SPUR | HTTC_APIC_EXT_ID | HTTC_APIC_EXT_BRD_CST);
        pci_write_config32(NODE_HT(node), 0x68, val);
#endif
}

that bit only be should be set when apic id is lifted and cpu apid is
using 8 bits and that mean broadcast is 0xff instead 0x0f.
for example 8 socket dual core system or 4 socket quad core
system,that you should make BSP start from 0x04, so cpus apic id will
be [0x04, 0x13)


So if you want to enable that in early_quirk, you need to
make sure apic id is using 8 bits by check if the bit 16 (HTTC_APIC_ID) is set.

most BIOS already did that. You may ask Supermicro fix their broken
BIOS instead.

YH

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbXLGOYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbXLGOYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXLGOYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:24:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbXLGOYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:24:30 -0500
Date: Fri, 7 Dec 2007 09:21:44 -0500
From: Neil Horman <nhorman@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Neil Horman <nhorman@redhat.com>, Ben Woodard <woodard@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>, hbabu@us.ibm.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Message-ID: <20071207142144.GA10389@hmsendeavour.rdu.redhat.com>
References: <20071128160206.GA21286@hmsendeavour.rdu.redhat.com> <20071128190525.GD3192@redhat.com> <474F7177.7050306@redhat.com> <20071130144250.GC23810@redhat.com> <20071130145131.GB5822@hmsendeavour.rdu.redhat.com> <20071206213951.GB28898@hmsreliant.think-freely.org> <20071206221143.GC2863@redhat.com> <m1bq93s5r8.fsf@ebiederm.dsl.xmission.com> <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com> <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2007 at 01:22:04AM -0800, Yinghai Lu wrote:
> On Dec 7, 2007 12:50 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> > On Dec 6, 2007 4:33 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> ...
> > >
> > > My feel is that if it is for legacy interrupts only it should not be a problem.
> > > Let's investigate and see if we can unconditionally enable this quirk
> > > for all opteron systems.
> >
> > i checked that bit
> >
> > http://www.openbios.org/viewvc/trunk/LinuxBIOSv2/src/northbridge/amd/amdk8/coherent_ht.c?revision=2596&view=markup
> >
> > static void enable_apic_ext_id(u8 node)
> > {
> > #if ENABLE_APIC_EXT_ID==1
> > #warning "FIXME Is the right place to enable apic ext id here?"
> >
> >       u32 val;
> >
> >         val = pci_read_config32(NODE_HT(node), 0x68);
> >         val |= (HTTC_APIC_EXT_SPUR | HTTC_APIC_EXT_ID | HTTC_APIC_EXT_BRD_CST);
> >         pci_write_config32(NODE_HT(node), 0x68, val);
> > #endif
> > }
> >
> > that bit only be should be set when apic id is lifted and cpu apid is
> > using 8 bits and that mean broadcast is 0xff instead 0x0f.
> > for example 8 socket dual core system or 4 socket quad core
> > system,that you should make BSP start from 0x04, so cpus apic id will
> > be [0x04, 0x13)
> >
> >
> > So if you want to enable that in early_quirk, you need to
> > make sure apic id is using 8 bits by check if the bit 16 (HTTC_APIC_ID) is set.
> 
> it should be bit 18 (HTTC_APIC_EXT_ID)
> 
> 
> YH

this seems reasonable, I can reroll the patch for this.  As I think about it I'm
also going to update the patch to make this check occur for any pci class 0600
device from vendor AMD, since its possible that more than just nvidia chipsets
can be affected.

I'll repost as soon as I've tested, thanks!
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

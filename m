Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXLLBH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXLLBH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXLLBHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:07:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:58602 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbXLLBHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:07:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H6P77SE48W91lA53dzglAEHkv+f0AsyVoTEQG/0Kwol/i9ZlPRItbzpIlfW3ZjoLLUZPltTTyx7rK8mvCfcfHdg7Dr7oIWCLJln9iMlWCS3krtVwZ7Lhfk+xhCn2ncNQyncFoWmmwuLhEDoAfLXteZGYNY5PoA9IH4zrvNh2RBk=
Message-ID: <86802c440712111707s2a7d0a1dy684b093e64c9f398@mail.gmail.com>
Date: Tue, 11 Dec 2007 17:07:18 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Neil Horman" <nhorman@tuxdriver.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Cc: "Ben Woodard" <woodard@redhat.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071212005202.GA19016@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071211034349.GA3635@localhost.localdomain>
	 <20071211143910.GA10999@hmsreliant.think-freely.org>
	 <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com>
	 <20071211182254.GB10999@hmsreliant.think-freely.org>
	 <m1ejdtysqd.fsf@ebiederm.dsl.xmission.com>
	 <20071211192434.GD10999@hmsreliant.think-freely.org>
	 <86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com>
	 <20071211205955.GF10999@hmsreliant.think-freely.org>
	 <475F2860.2080203@redhat.com>
	 <20071212005202.GA19016@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11, 2007 4:52 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Dec 11, 2007 at 04:16:32PM -0800, Ben Woodard wrote:
> > We may need to go back and do some additional work on this. It doesn't
> > seem to be quite as cut and dried as we initially thought.
> >
> > This quirk doesn't appear to work on virtually the same motherboard with
> > the barcelona processors in it. It also may be sensitive to the firmware
> > version.  More extensive testing on a larger number of pre-production is
> > not showing it to be as effective as it appeared to be initially on the
> > testbed.
> >
> > I'm doing some retesting to figure out what exact situations and
> > collection of patches were able to make it work before.
> >
> Ben, please lets be clear about this.  You say this patch doesn't help on a new
> system.  Even thought its almost the exact same system, its not the same system.
> Does this patch work consistently on the system you initially reported the
> problem on?  I've done enough work on this at this point that I'm invested in
> not abandoning this fix.  If this solves the problem on dual core system, but
> not quad core, I'd much rather move forward with this fix and address your quad
> core problem as a separate issue.
>
> Neil
>
>
> > -ben
> >
> >
> >
> > Neil Horman wrote:
> > > Recently a kdump bug was discovered in which a system would hang inside
> > > calibrate_delay during the booting of the kdump kernel.  This was caused by the
> > > fact that the jiffies counter was not being incremented during timer
> > > calibration.  The root cause of this problem was found to be a bios
> > > misconfiguration of the hypertransport bus.  On system affected by this hang,
> > > the bios had assigned APIC ids which used extended apic bits (more than the
> > > nominal 4 bit ids's), but failed to configure bit 17 of the hypertransport
> > > transaction config register, which indicated that the mask for the destination
> > > field of interrupt packets accross the ht bus (see section 3.3.9 of
> > > http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/26094.PDF).
> > > If a crash occurs on a cpu with an APIC id that extends beyond 4 bits, it will
> > > not recieve interrupts during the kdump kernel boot, and this hang will be the
> > > result.  The fix is to add this patch, whcih add an early pci quirk check, to
> > > forcibly enable this bit in the httcfg register.  This enables all cpus on a
> > > system to receive interrupts, and allows kdump kernel bootup to procede
> > > normally.
> > >
> > > Regards
> > > Neil
> > >
> > >
> > > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > >
...
> > >  static struct chipset early_qrk[] __initdata = {
> > > -   { PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
> > > -   { PCI_VENDOR_ID_VIA, via_bugs },
> > > -   { PCI_VENDOR_ID_ATI, ati_bugs },
> > > +   { PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, nvidia_bugs },
> > > +   { PCI_VENDOR_ID_VIA, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, via_bugs },
> > > +   { PCI_VENDOR_ID_ATI, PCI_ANY_ID, PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, ati_bugs },
> > > +   { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB, PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, fix_hypertransport_config },

==>

+   { PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, fix_hypertransport_config },
+   { PCI_VENDOR_ID_AMD, 0x1200 , PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID,
fix_hypertransport_config },

I still think good way is that you ask Supermicro to update their BIOS
to use newer code from AMD.

YH

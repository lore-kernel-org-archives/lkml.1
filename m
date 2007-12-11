Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbXLKSij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbXLKSij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbXLKSiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:38:24 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4194 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454AbXLKSiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:38:22 -0500
Date: Tue, 11 Dec 2007 13:29:51 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on
	boot cpu
Message-ID: <20071211182951.GC10999@hmsreliant.think-freely.org>
References: <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com> <86802c440712070122q6e5824bcp12e1c3f560e2ab53@mail.gmail.com> <20071207142144.GA10389@hmsendeavour.rdu.redhat.com> <20071207175832.GA18485@hmsreliant.think-freely.org> <m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com> <20071211034349.GA3635@localhost.localdomain> <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com> <20071211143910.GA10999@hmsreliant.think-freely.org> <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com> <86802c440712111000l39291faaka797bc4ee22f798a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440712111000l39291faaka797bc4ee22f798a@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 10:00:00AM -0800, Yinghai Lu wrote:
> On Dec 11, 2007 7:29 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> > Neil Horman <nhorman@tuxdriver.com> writes:
> >
> > > On Mon, Dec 10, 2007 at 09:48:11PM -0700, Eric W. Biederman wrote:
> > >> Neil Horman <nhorman@tuxdriver.com> writes:
> > >>
> > >> Almost there.
> > > cool! :)
> > >
> > > <snip>
> > >>
> > >> We should not need check_hypertransport_config as the generic loop
> > >> now does the work for us.
> > >> > +
> > >> >  static void __init nvidia_bugs(void)
> > >> >  {
> > >> >  #ifdef CONFIG_ACPI
> > >> > @@ -83,15 +127,25 @@ static void __init ati_bugs(void)
> > >> >  #endif
> > >> >  }
> > >> >
> > >> > +static void __init amd_host_bugs(void)
> > >> > +{
> > >> > +  printk(KERN_CRIT "IN AMD_HOST_BUGS\n");
> > >> > +  check_hypertransport_config();
> > >> > +}
> > >>
> > >> Likewise this function is unneeded and the printk is likely confusing
> > >> for users.
> > >>
> > > Copy that. Fixed
> > >
> > > <snip>
> > >> >    {}
> > >> So make that fix_hypertransport_config and we should be good.
> > > Done
> > >
> > >>
> > >> We don't need to shift device.  Although we can do:
> > >> device_vendor = read_pci_config(num, slot, func, PCI_VENDOR_ID);
> > >> device = device_vendor >> 16;
> > >> vendor = device_vendor & 0xffff;
> > >>
> > > I'm not so sure about this.  In my testing, it was clear that I needed to do a
> > > shift on device to make valid comparisons to the defined PCI_DEVICE_* macros.
> > > The origional code had to do the same thing with the class field, which is
> > > simmilarly positioned in the pci config space.
> >
> > Ok.  I just looked at read_pci_config.  It doesn't do the right thing for
> > a non-aligned 32bit access.  (Not that I am convinced there is a right
> > thing we can do).  Please make this read_pci_config_16 instead
> > and you won't need the shift.
> >
> > Either that or as I earlier suggested just do a 32bit read from offset 0
> > and use shifts and masks to get vendor and device fields.
> >
> > The current code doing a shift where none should be needed (because
> > we ignore the two low order bits in our read) is totally weird
> > when looking at it.
> >
> > > Other than that, new patch attached.  Enables the detection of AMD
> > > hypertransport functions and checks for the proper quirk just as before, and
> > > incoporates your comments above Eric, as well as yours Yinghai.
> >
> > You almost got YH's comment.  You need return 2 for the old functions
> > so we don't try and apply a per chipset fixup for every device in
> > the system.
> >
> > I'm actually inclined to remove the return magic and just do something
> > like:
> >         static fix_applied;
> >         if (fix_applied++)
> >                 return;
> > In those functions that should be called only once.
> 
> it seems we need to have two tables. one for northbridge (sweep all
> the NB_K8) and another for SB ( like Nvidia, ati..., one touch and
> leave)
> 
> YH
> 
I like Erics idea better I think.  My origional patch had two tables, and it
seems that it made the early quirk detection logic that much more convoluted.
This way each quirk can determine if it needs to be applied to more than one pci
device.

Neil

> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

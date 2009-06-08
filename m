Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZFHSMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZFHSMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZFHSMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:12:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35706 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZFHSMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:12:39 -0400
Date: Mon, 8 Jun 2009 11:12:37 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gary Hade <garyhade@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, yinghai@kernel.org, lcm@us.ibm.com,
       suresh.b.siddha@intel.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining
	triggered "inactive" device IRQ interrruption
Message-ID: <20090608181237.GB8264@us.ibm.com>
References: <20090602193202.GB7282@us.ibm.com> <m1hbyxv8ep.fsf@fess.ebiederm.org> <20090604163840.GB7233@us.ibm.com> <20090607095403.GG31286@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090607095403.GG31286@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 11:54:03AM +0200, Ingo Molnar wrote:
> 
> * Gary Hade <garyhade@us.ibm.com> wrote:
> 
> > On Wed, Jun 03, 2009 at 04:55:26AM -0700, Eric W. Biederman wrote:
> > > Gary Hade <garyhade@us.ibm.com> writes:
> > > 
> > > > Impact: Eliminates a race that can leave the system in an
> > > >         unusable state
> > > >
> > > > During rapid offlining of multiple CPUs there is a chance
> > > > that an IRQ affinity move destination CPU will be offlined
> > > > before the IRQ affinity move initiated during the offlining
> > > > of a previous CPU completes.  This can happen when the device
> > > > is not very active and thus fails to generate the IRQ that is
> > > > needed to complete the IRQ affinity move before the move
> > > > destination CPU is offlined.  When this happens there is an
> > > > -EBUSY return from __assign_irq_vector() during the offlining
> > > > of the IRQ move destination CPU which prevents initiation of
> > > > a new IRQ affinity move operation to an online CPU.  This
> > > > leaves the IRQ affinity set to an offlined CPU.
> > > >
> > > > I have been able to reproduce the problem on some of our
> > > > systems using the following script.  When the system is idle
> > > > the problem often reproduces during the first CPU offlining
> > > > sequence.
> > > 
> > > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > 
> > > fixup_irqs() is broken for allowing such a thing.
> > 
> > When fixup_irqs() calls the set_affinity function:
> >                    ...
> >   if (desc->chip->set_affinity)
> >   	desc->chip->set_affinity(irq, affinity);
> >                    ...
> > it receives no feedback so it obviously expects the set_affinity
> > function or it's called functions to do the right thing by preventing
> > or correctly handling any problems that should arise.  In the case of
> > this bug there is obviously a problem happening during the set_affinity
> > function call that needs to be resolved and/or properly handled.
> > 
> > When you made your "x86_64 irq: Safely cleanup an irq after moving it."
> > changes (re: http://lkml.org/lkml/2007/2/23/92) you added the check
> > to __assign_irq_vector() that causes it to return -EBUSY if the
> > migration of the IRQ is still in progress:
> > +	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
> > +		return -EBUSY;
> > +
> > However, you did not add any code to other functions on the
> > call stack to properly deal with this error.  When doing this
> > you may have assumed (as I may have also assumed) that the underlying
> > code was solid enough that the handling was not needed.  Unfortunately,
> > you apparently did not anticipate the case where an idle or relatively
> > idle device may not generate the IRQ needed to complete the move
> > before the CPU that is still handling that IRQ is offlined.
> > 
> > My fix only addresses the issue that caused the -EBUSY return
> > and subsequent mess.  It does not address the omitted handling
> > for this error condition.  If we were to add the handling to
> > fixup_irq() and the arch and non-arch specific functions above
> > it on the call stack as you may be suggesting, it would be quite
> > involved because of all the things that would need to be undone.
> > 
> > I am not certain that my fix plugs the very last hole that could 
> > cause the -EBUSY return from __assign_irq_vector() so maybe we 
> > should at least add a warning or BUG_ON to make the unhandled 
> > error more obvious in the future.  I would be happy to provide 
> > this via a separate patch.
> 
> A WARN_ON_ONCE() patch would certainly be nice, as a reminder and as 
> a prodder-tool.

Done.  re: http://lkml.org/lkml/2009/6/8/354  

In the case of the bug we are discussing here, the added warning
looks like:
WARNING: at arch/x86/kernel/apic/io_apic.c:1334 __assign_irq_vector+0x53/0x262()
Hardware name: IBM x3850-[88641RY]-
Modules linked in: radeon drm ipv6 af_packet microcode fuse loop dm_mod rtc_cmos rtc_core i2c_piix4 tg3 e1000e s2io sr_mod libphy rtc_lib i2c_core joydev button pcspkr cdrom sg usbhid hid sd_mod crc_t10dif ohci_hcd ehci_hcd aic94xx libsas scsi_transport_sas usbcore edd ext3 mbcache jbd fan ide_pci_generic serverworks ide_core ata_generic thermal processor thermal_sys hwmon pata_serverworks libata scsi_mod
Pid: 5328, comm: kstop/5 Not tainted 2.6.30-rc8-gh-5-default #5
Call Trace:
 [<ffffffff8021cf2a>] ? __assign_irq_vector+0x53/0x262
 [<ffffffff8023ee59>] warn_slowpath_common+0x77/0xa4
 [<ffffffff8023ee95>] warn_slowpath_null+0xf/0x11
 [<ffffffff8021cf2a>] __assign_irq_vector+0x53/0x262
 [<ffffffff8021d16a>] assign_irq_vector+0x31/0x4d
 [<ffffffff8021d1c6>] set_desc_affinity+0x40/0x86
 [<ffffffff8021d53b>] set_ioapic_affinity_irq_desc+0x3b/0x135
 [<ffffffff8021d651>] set_ioapic_affinity_irq+0x1c/0x20
 [<ffffffff8020de46>] fixup_irqs+0xd5/0x163
 [<ffffffff8021b1c2>] cpu_disable_common+0x19f/0x1ae
 [<ffffffff8021b200>] native_cpu_disable+0x2f/0x37
 [<ffffffff80491878>] take_cpu_down+0x12/0x38
 [<ffffffff80274d56>] stop_cpu+0x87/0xc7
 [<ffffffff8024e55f>] worker_thread+0x172/0x20c
 [<ffffffff80274ccf>] ? stop_cpu+0x0/0xc7
 [<ffffffff802520b8>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8024e3ed>] ? worker_thread+0x0/0x20c
 [<ffffffff8024e3ed>] ? worker_thread+0x0/0x20c
 [<ffffffff80251ce8>] kthread+0x56/0x83
 [<ffffffff8020ca3a>] child_rip+0xa/0x20
 [<ffffffff80251c92>] ? kthread+0x0/0x83
 [<ffffffff8020ca30>] ? child_rip+0x0/0x20

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc


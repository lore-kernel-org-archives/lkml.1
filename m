Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbXL3WGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbXL3WGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 17:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758262AbXL3WGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 17:06:31 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51009 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120AbXL3WGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 17:06:31 -0500
Date: Mon, 31 Dec 2007 00:06:20 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: clear IO_APIC before enabing apic error
	vector. v2
Message-ID: <20071230220620.GC17670@does.not.exist>
References: <200712291952.20455.yinghai.lu@sun.com> <20071230145115.GR16946@elte.hu> <86802c440712301248m38cd000ejf7e48f273d573edd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86802c440712301248m38cd000ejf7e48f273d573edd@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 12:48:48PM -0800, Yinghai Lu wrote:
> On Dec 30, 2007 6:51 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> >
> > > please check if you can replace the one in the x86-mm
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=ffcbdc220a1520d006a837f33589c7c19ffbeb76
> > >
> > > the updated one avoid one link warning.
> >
> > please send delta patches instead - so that we can review the changes.
> 
> will do that in another patch.
> 
> >
> > > this is the updated verison that take enable_IO_APIC as extra call for
> > > setup_local_APIC to avoid linking warning.
> >
> > hm, what link warning did you get? Perhaps the following __cpuinit:
> 
> WARNING: vmlinux.o(.text+0x163d5): Section mismatch: reference to
> .init.text:enable_IO_APIC (between 'setup_local_APIC' and
> 'apic_is_clustered_box')

So you are doing complicated things for silencing the warning (there is
an easier ways for achieving it), but the real bug that you will get an 
Oops when calling enable_IO_APIC() after bootup since it already got 
freed stays?

> > > -void __cpuinit setup_local_APIC (void)
> >
> > does not mix well with an __init call:
> >
> > > +void __init enable_IO_APIC(void)
> >
> > and you hack it around by using a function pointer. Nasty and still
> > buggy. The proper solution would be to mark enable_IO_APIC as __cpuinit
> > too (or something like that).
> 
> after change that to __cpuinit, i got
> 
> WARNING: vmlinux.o(.text+0x17f84): Section mismatch: reference to
> .init.text: (between 'enable_IO_APIC' and 'ioapic_resume')
> WARNING: vmlinux.o(.text+0x17f92): Section mismatch: reference to
> .init.text: (between 'enable_IO_APIC' and 'ioapic_resume')

find_isa_irq_{apic,pin} are called by enable_IO_APIC() and therefore 
also have to be changed from __init to __cpuinit.

> YH

cu
Adrian

BTW: Is there a reason why your patch doesn't touch the 32bit code?

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


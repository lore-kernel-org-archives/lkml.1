Return-Path: <linux-kernel-owner+w=401wt.eu-S1423092AbXBBDBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423092AbXBBDBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 22:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423091AbXBBDBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 22:01:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:26286 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423089AbXBBDB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 22:01:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,269,1167638400"; 
   d="scan'208"; a="176098238:sNHT22123108"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
Date: Fri, 2 Feb 2007 11:01:21 +0800
Message-ID: <10EA09EFD8728347A513008B6B0DA77A086BD0@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <aec7e5c30702011838g6e9edd23sc782321aacb07297@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
Thread-Index: AcdGc0ve2RLBQETOTWWQwkBmMU1T/AAAjVyw
From: "Zou, Nanhai" <nanhai.zou@intel.com>
To: "Magnus Damm" <magnus.damm@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Magnus Damm" <magnus@valinux.co.jp>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
       <fastboot@lists.osdl.org>, "Jay Lan" <jlan@sgi.com>
X-OriginalArrivalTime: 02 Feb 2007 03:01:28.0203 (UTC) FILETIME=[6EC7EDB0:01C74676]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-ia64-owner@vger.kernel.org
> [mailto:linux-ia64-owner@vger.kernel.org] On Behalf Of Magnus Damm
> Sent: 2007Äê2ÔÂ2ÈÕ 10:39
> To: Andrew Morton
> Cc: Magnus Damm; linux-kernel@vger.kernel.org; linux-ia64@vger.kernel.org;
> Luck, Tony; fastboot@lists.osdl.org
> Subject: Re: [PATCH] kexec: Fix CONFIG_SMP=n compilation (ia64)
> 
> On 2/2/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > (added ia64 list)
> > (added ia64 maintainer)
> > (added kexec list)
> 
> Sorry about that.
> 
> > On Thu, 01 Feb 2007 22:13:47 +0900
> > Magnus Damm <magnus@valinux.co.jp> wrote:
> >
> > > kexec: Fix CONFIG_SMP=n compilation (ia64)
> > >
> > > This patch makes it possible to compile kexec for ia64 without SMP support.
> > >
> >
> > Please always include the compiler stderr when fixing build errors or
> > warnings.
> 
> Ok, will do. With CONFIG_SMP=n and CONFIG_HOTPLUG_CPU=n:
> 
>   CC      arch/ia64/kernel/machine_kexec.o
> arch/ia64/kernel/machine_kexec.c: In function `machine_shutdown':
> arch/ia64/kernel/machine_kexec.c:77: warning: implicit declaration of
> function `cpu_down'
>   AS      arch/ia64/kernel/relocate_kernel.o
>   CC      arch/ia64/kernel/crash.o
> arch/ia64/kernel/crash.c: In function `kdump_cpu_freeze':
> arch/ia64/kernel/crash.c:139: warning: implicit declaration of
> function `ia64_jump_to_sal'
> arch/ia64/kernel/crash.c:139: error: `sal_boot_rendez_state'
> undeclared (first use in this function)
> arch/ia64/kernel/crash.c:139: error: (Each undeclared identifier is
> reported only once
> arch/ia64/kernel/crash.c:139: error: for each function it appears in.)
> arch/ia64/kernel/crash.c: At top level:
> arch/ia64/kernel/crash.c:84: warning: 'kdump_wait_cpu_freeze' defined
> but not used
> make[1]: *** [arch/ia64/kernel/crash.o] Error 1
> make: *** [arch/ia64/kernel] Error 2
> damm@localhost ~/build/kernel/linux-2.6.20-rc7 $
> 
> > > --- 0002/arch/ia64/kernel/crash.c
> > > +++ work/arch/ia64/kernel/crash.c     2007-02-01 12:42:38.000000000
> +0900
> > > @@ -79,6 +79,7 @@ crash_save_this_cpu()
> > >       final_note(buf);
> > >  }
> > >
> > > +#ifdef CONFIG_SMP
> > >  static int
> > >  kdump_wait_cpu_freeze(void)
> > >  {
> > > @@ -91,6 +92,7 @@ kdump_wait_cpu_freeze(void)
> > >       }
> > >       return 1;
> > >  }
> > > +#endif
> >
> > I think this is a warning fix?
> 
> Yes. The file already has some CONFIG_SMP #ifdeffery in it but not
> enough to compile properly.
> 
> > >  void
> > >  machine_crash_shutdown(struct pt_regs *pt)
> > > @@ -132,11 +134,12 @@ kdump_cpu_freeze(struct unw_frame_info *
> > >       atomic_inc(&kdump_cpu_freezed);
> > >       kdump_status[cpuid] = 1;
> > >       mb();
> > > -     if (cpuid == 0) {
> > > -             for (;;)
> > > -                     cpu_relax();
> > > -     } else
> > > +#ifdef CONFIG_HOTPLUG_CPU
> > > +     if (cpuid != 0)
> > >               ia64_jump_to_sal(&sal_boot_rendez_state[cpuid]);
> > > +#endif
> > > +     for (;;)
> > > +             cpu_relax();
> > >  }
> >
> > I trust ia64_jump_to_sal doesn't return.
> 
> So do I. The main problem with the compilation seems to be that
> ia64_jump_to_sal() only exists if CONFIG_HOTPLUG_CPU=y.
> (include/asm-ia64/sal.h, arch/ia64/kernel/head.S)
> 
 This may cause problem on SN platform. 
I remember SN requires cpu0 return to SAL rendez loop to do IRQ redirection.
However this needs SGI people to confirm...

Thanks
Zou Nan hai

> 
> Thanks!
> 
> / magnus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

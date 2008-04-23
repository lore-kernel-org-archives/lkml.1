Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbYDWOhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbYDWOhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbYDWOhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:37:46 -0400
Received: from ns.suse.de ([195.135.220.2]:45284 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbYDWOhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:37:45 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Wed, 23 Apr 2008 16:38:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <andi@firstfloor.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200804172140.02311.jdelvare@suse.de> <20080421210909.GC21028@one.firstfloor.org> <200804211414.45629.jbarnes@virtuousgeek.org>
In-Reply-To: <200804211414.45629.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804231638.01479.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

Le lundi 21 avril 2008, Jesse Barnes a écrit :
> On Monday, April 21, 2008 2:09 pm Andi Kleen wrote:
> > > Both call disable_ioapic_setup(), so how can they not be the same?
> >
> > See Jesse's explanation. Basically there is special code in the smp
> > boot up to handle 0 CPUs and it disables all APICs.
> >
> > This is very old and crufty and somewhat obsolete logic,
> > but it is like that.
> 
> This might be closer to a real fix.  Can you confirm that this works for you 
> Jean?
> 
> Thanks,
> Jesse
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index e6abe8a..7cdf930 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1138,14 +1138,10 @@ static int __init smp_sanity_check(unsigned max_cpus)
>  				 "forcing use of dummy APIC emulation.\n");
>  		smpboot_clear_io_apic();
>  #ifdef CONFIG_X86_32
> -		if (nmi_watchdog == NMI_LOCAL_APIC) {
> -			printk(KERN_INFO "activating minimal APIC for"
> -					 "NMI watchdog use.\n");
> -			connect_bsp_APIC();
> -			setup_local_APIC();
> -			end_local_APIC_setup();
> -		}
> +		connect_bsp_APIC();
>  #endif
> +		setup_local_APIC();
> +		end_local_APIC_setup();
>  		return -1;
>  	}
>  
> 

Sorry for the late reply. I tested the patch above on top of 2.6.25-git4
and yes, it fixes my problem: booting with "nosmp" works now. Thanks!

Is this patch good enough to go upstream, and if so, through whose
tree? Adding Thomas Gleixner to Cc.

-- 
Jean Delvare
Suse L3

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXGaI3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXGaI3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbXGaI3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:29:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:55203 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbXGaI3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:29:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,202,1183359600"; 
   d="scan'208";a="256779523"
Subject: Re: [PATCH 3/5] x86_64 EFI support -v3: EFI runtime support
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m14pjluref.fsf@ebiederm.dsl.xmission.com>
References: <1185851579.23149.28.camel@caritas-dev.intel.com>
	 <m14pjluref.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 16:29:26 +0800
Message-Id: <1185870566.23149.63.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 08:29:37.0028 (UTC) FILETIME=[EE2D7440:01C7D34C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 22:30 -0600, Eric W. Biederman wrote:
> > This patch adds runtime service support for EFI x86_64 system.
> >
> > The EFI support for emergency_restart and RTC clock is added. The EFI
> > based implementation and legacy BIOS or CMOS based implementation are
> > put in separate functions and are chosen based on the value of
> > efi_enabled.
> 
> The patches to the reboot path are wrong (see below).
> 
> Why do we need to do this anyway?  Why do we need any EFI runtime
> support?  We already have ACPI.  Isn't that good enough to abstract
> out the runtime parts of the hardware?
> 
> Why do we need to replace working code that directly talks to the
> architecturally defined hardware, with firmware calls?
> 
> What is the point?  What is the advantage?
> 
> The disadvantage of having more code to maintain and having
> to deal with more BIOS bugs should be obvious.

The reboot EFI runtime service is needed because otherwise we have no
way to tell firmware whether a warm or cold reboot is requested. The
"0x472" protocol is used by legacy BIOS, but not by EFI based firmware.
For EFI based firmware, the parameter to runtime service call is the
only way to tell firmware whether a warm or cold reboot is requested.

That is not implemented by current EFI support patch yet, but we will
add it in the next version.

> > Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> >
> > ---
> >
> >  reboot.c |   11 ++++++++++-
> >  time.c   |   47 +++++++++++++++++++++++++++++++----------------
> >  2 files changed, 41 insertions(+), 17 deletions(-)
> >
> > Index: linux-2.6.23-rc1/arch/x86_64/kernel/reboot.c
> > ===================================================================
> > --- linux-2.6.23-rc1.orig/arch/x86_64/kernel/reboot.c 2007-07-23
> > 04:41:00.000000000 +0800
> > +++ linux-2.6.23-rc1/arch/x86_64/kernel/reboot.c 2007-07-30 09:26:56.000000000
> > +0800
> > @@ -9,6 +9,7 @@
> >  #include <linux/pm.h>
> >  #include <linux/kdebug.h>
> >  #include <linux/sched.h>
> > +#include <linux/efi.h>
> >  #include <asm/io.h>
> >  #include <asm/delay.h>
> >  #include <asm/hw_irq.h>
> > @@ -117,7 +118,7 @@
> >  	pci_iommu_shutdown();
> >  }
> >  
> > -void machine_emergency_restart(void)
> > +static inline void bios_emergency_restart(void)
> >  {
> >  	int i;
> >  
> > @@ -145,6 +146,14 @@
> >  	}      
> >  }
> >  
> > +void machine_emergency_restart(void)
> > +{
> > +	if (efi_enabled)
> > +		efi_emergency_restart();
> > +	else
> > +		bios_emergency_restart();
> > +}
> > +
> 
> A EFI is a bios so naming the current machine_emergency_restart bios_emergency_restart is
> a misnomer, especially since pounds the hardware not the firmware.
> Second we already have a perfectly capable mechanism in the
> reboot_type variable so you should just need to add one more type and
> handle this properly. 

Yes. Reboot via EFI should be implemented as a new type of
"reboot_type".

Best Regards,
Huang Ying

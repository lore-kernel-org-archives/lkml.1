Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896AbZHLFnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbZHLFnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 01:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZHLFnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 01:43:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:7776 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbZHLFnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 01:43:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,365,1246863600"; 
   d="scan'208";a="174852993"
Date: Wed, 12 Aug 2009 13:41:09 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH]x86/RTC: introduce a new generic rtc_ops for x86
Message-ID: <20090812134109.0913f9a9@feng-desktop>
In-Reply-To: <20090811084529.GB25647@elte.hu>
References: <20090811154850.3127fff0@feng-desktop>
	<20090811084529.GB25647@elte.hu>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 16:45:29 +0800
Ingo Molnar <mingo@elte.hu> wrote:
> > -#include <asm/mc146818rtc.h>
> > -#ifdef CONFIG_X86_32
> > -#include <linux/efi.h>
> > +struct arch_rtc_dev_ops {
> > +	unsigned long	(*get_wall_time)(void);
> > +	int		(*set_wall_time)(unsigned long);
> > +};
> > +extern struct arch_rtc_dev_ops *x86_rtc_ops;
> 
> looks like the right direction at first glance. What's the 
> management interface around the driver (there's none at the moment)? 
> Set up at early boot time and never changed afterwards?
Currently there is no management interface around it, the structure works
the way like x86_quirks, as EFI/mc146818 are kindly fixed and can't be
dynamically detected.

> 
> Have you looked at other architectures (MIPS, ARM, etc.) to see how 
> they abstracted away their RTC functionality?
I did a quick look at other architectures, and didn't see a nice abstracted
way for RTC.

In kernel early boot phase, read_persistent_clock() is called to get the HW
time, x86 implements the API by calling get_wall_time(), but just a few other
architectures implement their own read_persistent_clock() if they have rtc
devices/services that could be accessed in early boot phase, like some of
MIPS/PowerPC/s390...(ARM doesn't). So it would be difficult to ask all
architectures to use the arch_rtc_dev_ops structure.

But as kernel needs the HW time anyway, some arch/platforms implements
their rtc driver in drivers/rtc/ not in arch/.../kernel/, which will get HW
time and set it to the system time in late boot phase using late_initcall

Thanks,
Feng
> 
> 	Ingo

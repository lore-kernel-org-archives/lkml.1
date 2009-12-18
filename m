Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbZLRQgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbZLRQgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZLRQge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:36:34 -0500
Received: from www.tglx.de ([62.245.132.106]:44898 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbZLRQgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:36:33 -0500
Date: Fri, 18 Dec 2009 17:35:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: "H. Peter Anvin" <hpa@linux.intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
 setup
In-Reply-To: <43F901BD926A4E43B106BF17856F07559A257FE1@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0912181704360.2755@localhost.localdomain>
References: <43F901BD926A4E43B106BF17856F07559A257B5C@orsmsx508.amr.corp.intel.com> <20091217194148.GB5414@lenovo> <43F901BD926A4E43B106BF17856F07559A257E3D@orsmsx508.amr.corp.intel.com> <4B2AB1F0.1020105@linux.intel.com>
 <43F901BD926A4E43B106BF17856F07559A257FE1@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Pan, Jacob jun wrote:
> >-----Original Message-----
> >From: H. Peter Anvin [mailto:hpa@linux.intel.com]
> >Sent: Thursday, December 17, 2009 2:34 PM
> >To: Pan, Jacob jun
> >Cc: Cyrill Gorcunov; linux-kernel@vger.kernel.org; x86@kernel.org
> >Subject: Re: [PATCH 2/2] x86/apic: check global clockevent in lapic timer setup
> >
> >On 12/17/2009 02:31 PM, Pan, Jacob jun wrote:
> >>> Wouldn't be better to operate the same way as in case of "noapictimer"
> >>> boot option. I guess the non-pc x86 midplatforms you're mentioning
> >>> do not use SMP ever but just to be consistent in code.
> >>>
> >> [[JPAN]] We do use SMP with hyper threading in Moorestown.
> >> In that case we have a per cpu platform timer without global clockevent.
> >> so i think we don't want the dummy lapic event. we don't want to use the
> >> broadcast mechanism as mentioned in the comments before disabling lapic
> >> timer.
> >>
> >> For moorestown, I can use x86_init.timers.setup_percpu_clockev
> >> abstraction function so that Moorestown platform does not need to call
> >> setup_boot_APIC_clock() if per cpu platform timer is used. so many IFs :).
> >>
> >> But in the case of having constant and always on LAPIC timer, we still do
> >> not want the dummy lapic clockevent and the broadcast. we will just have
> >> per cpu always on local apic timers without global clockevent device.
> >
> >OK, I'm not entirely sure I follow this, and I'm not sure someone trying
> >to understand the code in five years would, either.  I don't really see
> >the above translating into "we don't have a global clockevent, therefore
> >we shouldn't initialize (but should still not disable) the local APIC
> >timer."
> >
> >	-hpa
> [[JPAN]] There is some thing wrong in my logic.
> 
> If we have always running lapic timer, and per cpu platform timers, we would
> still want to set up the lapic timer without global clockevent, just without
> calibration. perhaps use a platform specific setup_percpu_clockev() function.
> 
> So i don't think we need this patch at the moment, maybe we only need to do a
> sanity check for global clockevent in calibrate_APIC_clock().

No, we need to fix the whole lapic timer calibration logic first.

There is no reason why we don't calibrate the lapic at the same time
as we calibrate the TSC.

Another question is why there is no way to read out the lapic clock
frequency from some config registers or wherever the chip designers
decided to hide that. There is no real reason why the lapic timer
calibration needs to be extremly precise.

> Honestly, i don't fully understand how the dummy lapic event device
> is related to the broadcast mechanism. can someone explain why we
> register the dummy lapic clockevent?

The broadcast mechanism is there in the first place to work around the
APIC stops in deeper C-states idiocy. 

Then we need to support the disable lapic timer command line option
(even on SMP) so we make use of the existing broadcast mechanism and
register the dummy device to have a per cpu clock event device.

Thanks,

	tglx

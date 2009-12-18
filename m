Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbZLRSOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbZLRSOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZLRSOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:14:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:53098 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbZLRSN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:13:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,419,1257148800"; 
   d="scan'208";a="580275710"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Fri, 18 Dec 2009 10:13:52 -0800
Subject: RE: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
 setup
Thread-Topic: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
 setup
Thread-Index: AcqAACe2bTf+i4Q1Tqeu/SXA6l8eDgACJF5A
Message-ID: <43F901BD926A4E43B106BF17856F07559A25826A@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559A257B5C@orsmsx508.amr.corp.intel.com>
 <20091217194148.GB5414@lenovo>
 <43F901BD926A4E43B106BF17856F07559A257E3D@orsmsx508.amr.corp.intel.com>
 <4B2AB1F0.1020105@linux.intel.com>
 <43F901BD926A4E43B106BF17856F07559A257FE1@orsmsx508.amr.corp.intel.com>
 <alpine.LFD.2.00.0912181704360.2755@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912181704360.2755@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de]
>Sent: Friday, December 18, 2009 8:36 AM
>To: Pan, Jacob jun
>Cc: H. Peter Anvin; Cyrill Gorcunov; linux-kernel@vger.kernel.org;
>x86@kernel.org
>Subject: RE: [PATCH 2/2] x86/apic: check global clockevent in lapic timer setup
>
>On Thu, 17 Dec 2009, Pan, Jacob jun wrote:
>> >-----Original Message-----
>> >From: H. Peter Anvin [mailto:hpa@linux.intel.com]
>> >Sent: Thursday, December 17, 2009 2:34 PM
>> >To: Pan, Jacob jun
>> >Cc: Cyrill Gorcunov; linux-kernel@vger.kernel.org; x86@kernel.org
>> >Subject: Re: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
>setup
>> >
>> >On 12/17/2009 02:31 PM, Pan, Jacob jun wrote:
>> >>> Wouldn't be better to operate the same way as in case of "noapictimer"
>> >>> boot option. I guess the non-pc x86 midplatforms you're mentioning
>> >>> do not use SMP ever but just to be consistent in code.
>> >>>
>> >> [[JPAN]] We do use SMP with hyper threading in Moorestown.
>> >> In that case we have a per cpu platform timer without global clockevent.
>> >> so i think we don't want the dummy lapic event. we don't want to use the
>> >> broadcast mechanism as mentioned in the comments before disabling lapic
>> >> timer.
>> >>
>> >> For moorestown, I can use x86_init.timers.setup_percpu_clockev
>> >> abstraction function so that Moorestown platform does not need to call
>> >> setup_boot_APIC_clock() if per cpu platform timer is used. so many IFs :).
>> >>
>> >> But in the case of having constant and always on LAPIC timer, we still do
>> >> not want the dummy lapic clockevent and the broadcast. we will just have
>> >> per cpu always on local apic timers without global clockevent device.
>> >
>> >OK, I'm not entirely sure I follow this, and I'm not sure someone trying
>> >to understand the code in five years would, either.  I don't really see
>> >the above translating into "we don't have a global clockevent, therefore
>> >we shouldn't initialize (but should still not disable) the local APIC
>> >timer."
>> >
>> >	-hpa
>> [[JPAN]] There is some thing wrong in my logic.
>>
>> If we have always running lapic timer, and per cpu platform timers, we would
>> still want to set up the lapic timer without global clockevent, just without
>> calibration. perhaps use a platform specific setup_percpu_clockev() function.
>>
>> So i don't think we need this patch at the moment, maybe we only need to do a
>> sanity check for global clockevent in calibrate_APIC_clock().
>
>No, we need to fix the whole lapic timer calibration logic first.
>
>There is no reason why we don't calibrate the lapic at the same time
>as we calibrate the TSC.
[[JPAN]] that seems to be much more efficient and we can have platform specific
way of calibration too with the x86_init abstraction.
>
>Another question is why there is no way to read out the lapic clock
>frequency from some config registers or wherever the chip designers
>decided to hide that. There is no real reason why the lapic timer
>calibration needs to be extremly precise.
>
[[JPAN]] x86 does have MSR_FSB_FREQ to read bus frequency then the DCR to figure
out LAPIC timer freq. but i guess not all CPU models have that. so having
the abstraction would be a plus for those do have reliable reporting of lapic
freq.

>> Honestly, i don't fully understand how the dummy lapic event device
>> is related to the broadcast mechanism. can someone explain why we
>> register the dummy lapic clockevent?
>
>The broadcast mechanism is there in the first place to work around the
>APIC stops in deeper C-states idiocy.
>
>Then we need to support the disable lapic timer command line option
>(even on SMP) so we make use of the existing broadcast mechanism and
>register the dummy device to have a per cpu clock event device.
>
[[JPAN]] thanks for the explanation. so if we have per cpu timer that is
always-on, and don't have a broadcast timer, then the dummy device would not
be needed, correct?


>Thanks,
>
>	tglx

Return-Path: <linux-kernel-owner+w=401wt.eu-S936317AbZLQWbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936317AbZLQWbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 17:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935820AbZLQWbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 17:31:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:62271 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935856AbZLQWbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 17:31:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,415,1257148800"; 
   d="scan'208";a="477191029"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 17 Dec 2009 14:31:44 -0800
Subject: RE: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
	setup
Thread-Topic: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
	setup
Thread-Index: Acp/UQPNc3wUhxreR7WJvqf1W3pMpwAEw87A
Message-ID: <43F901BD926A4E43B106BF17856F07559A257E3D@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559A257B5C@orsmsx508.amr.corp.intel.com>
 <20091217194148.GB5414@lenovo>
In-Reply-To: <20091217194148.GB5414@lenovo>
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


>
>Wouldn't be better to operate the same way as in case of "noapictimer"
>boot option. I guess the non-pc x86 midplatforms you're mentioning
>do not use SMP ever but just to be consistent in code.
>
[[JPAN]] We do use SMP with hyper threading in Moorestown.
In that case we have a per cpu platform timer without global clockevent.
so i think we don't want the dummy lapic event. we don't want to use the
broadcast mechanism as mentioned in the comments before disabling lapic
timer.

For moorestown, I can use x86_init.timers.setup_percpu_clockev
abstraction function so that Moorestown platform does not need to call
setup_boot_APIC_clock() if per cpu platform timer is used. so many IFs :).

But in the case of having constant and always on LAPIC timer, we still do
not want the dummy lapic clockevent and the broadcast. we will just have
per cpu always on local apic timers without global clockevent device.


>Perhaps something like:
>
>void __init setup_boot_APIC_clock(void) {
>
>	if (!global_clock_event) {
>		pr_info("No global clockevent for calibration\n");
>		disable_apic_timer = 1;
>	}
>
>	if (disable_apic_timer) {
>		pr_info("Disabling APIC timer\n");
>		/* No broadcast on UP ! */
>		if (num_possible_cpus() > 1) {
>			lapic_clockevent.mult = 1;
>			setup_APIC_timer();
>		}
>		return;
>	}
>
>	...
>}
>
>Or I miss something?
>
>	-- Cyrill

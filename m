Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZEWPFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZEWPFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 11:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZEWPFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 11:05:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:27413 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbZEWPFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 11:05:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,237,1241420400"; 
   d="scan'208";a="146173839"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Date: Sat, 23 May 2009 08:07:55 -0700
Subject: RE: [patch 1/2] x86: Add pm_play_dead funcptr to power-efficiently
 offline CPUs
Thread-Topic: [patch 1/2] x86: Add pm_play_dead funcptr to power-efficiently
 offline CPUs
Thread-Index: Acnbk4iUaqxMINc7TgqQ5iHNaS93SAAIkIEA
Message-ID: <7E82351C108FA840AB1866AC776AEC46686F550A@orsmsx505.amr.corp.intel.com>
References: <20090522231940.553094000@intel.com>
	 <20090522232230.020301000@intel.com> <1243075498.6582.1049.camel@laptop>
In-Reply-To: <1243075498.6582.1049.camel@laptop>
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
>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl] 
>Sent: Saturday, May 23, 2009 3:45 AM
>To: Pallipadi, Venkatesh
>Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; 
>linux-kernel@vger.kernel.org; lenb@kernel.org; Li, Shaohua; 
>svaidy@linux.vnet.ibm.com
>Subject: Re: [patch 1/2] x86: Add pm_play_dead funcptr to 
>power-efficiently offline CPUs
>
>On Fri, 2009-05-22 at 16:19 -0700, venkatesh.pallipadi@intel.com wrote:
>> plain text document attachment
>> (0001-x86-Add-pm_play_dead-funcptr-to-power-efficiently-o.patch)
>> Add a funcptr pm_play_dead (similar to pm_idle) that can take
>> the offline CPUs to the most power efficient idle state.
>> 
>> This patch just adds the func pointer. The pointer will get 
>initialized
>> by patch that follows.
>
>Since the pm_idle function pointer has given us so much grief, I don't
>think its wise to repeat that particular disaster.
>
>I'd much rather see a framework where idle functions can be registered,
>and selected from based on criteria such as wakeup latency as provided
>by the pm_qos stuff, and power saving.
>
>This framework should be shared between hotplug-idle and the regular
>idle routines. Hotplug would of course not care about things 
>like wakeup
>latency and might therefore pick another idle routine.
>

Yes. Thought about that approach. There are issues with that approach however.
- It would be ugly as we have to add logic in various low level idle handlers we have today mwait_idle, default_idle, acpi_mwait_idle, acpi_ioport_idle to make them aware of offline idle case and disable interrupt and not enable interrupt while going idle and not to wake up on interrupt.
- There are limitations on what we can and cannot do when offline. We have had issues with calling acpi methods and/or IO port accesses, during suspend before, so CPU going on suspend only uses C1. Specifically, with the above approach we will have:
1) CPU 1 going offline and starts using regular ACPI IO port C-states.
2) CPU 0 starts suspend and after some points it is unsafe to access ACPI io port accesses, which can potentially result in crash/hangs.

So, I would like to keep ACPI out of play_dead. And keeping idle and play_dead separate seemed to be cleaner way to do it.

Thanks,
Venki

 
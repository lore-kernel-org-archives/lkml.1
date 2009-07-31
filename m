Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZGaReI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZGaReI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZGaReI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:34:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:63652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZGaReH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:34:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,303,1246863600"; 
   d="scan'208";a="537589920"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Date: Fri, 31 Jul 2009 10:37:05 -0700
Subject: RE: Dynamic configure max_cstate
Thread-Topic: Dynamic configure max_cstate
Thread-Index: AcoR7MuwGBeg/HkuQUGELlDo8SK9nAAF8n/A
Message-ID: <7E82351C108FA840AB1866AC776AEC466D56BA7A@orsmsx505.amr.corp.intel.com>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de>
	<1248748935.2560.669.camel@ymzhang>
	<4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com>
	<1248771635.2560.682.camel@ymzhang>
	<20090728101135.GA22358@rhlx01.hs-esslingen.de>	<4A726844.7040505@gmail.com>
 <1249024006.2560.735.camel@ymzhang>
	<20090731080728.GA25049@rhlx01.hs-esslingen.de>
 <87prbg3ohq.fsf@basil.nowhere.org>
In-Reply-To: <87prbg3ohq.fsf@basil.nowhere.org>
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
>From: Andi Kleen [mailto:andi@firstfloor.org] 
>Sent: Friday, July 31, 2009 7:40 AM
>To: Zhang, Yanmin
>Cc: Robert Hancock; Corrado Zoccolo; LKML; 
>linux-acpi@vger.kernel.org; Pallipadi, Venkatesh
>Subject: Re: Dynamic configure max_cstate
>
>Andreas Mohr <andi@lisas.de> writes:
>
>> Instead we should strive for a far-reaching _generic_ mechanism
>> which gathers average latencies of various I/O activities/devices
>> and then uses some formula to determine the maximum (not 
>necessarily ACPI)
>> idle latency that we're willing to endure (e.g. average 
>device I/O reply latency
>> divided by 10 or so).
>
>The interrupt heuristics in the menu cpuidle governour are already
>attempting this, based on interrupt rates (or rather
>wakeup rates) which are supposed to roughly correspond with IO rates
>and scheduling events together.
>
>Apparently that doesn't work in this case. The challenge would
>be to find out why and improve the menu algorithm to deal with it.
>I doubt a completely new mechanism is needed or makes sense.
>

Yes. cpuidle's attempt at guessing the interrupt rate is not working here.
I got this test running on a test system here and looks like its not just
the cpuidle that causes problems here.
I am still collecting more data, but from what I have right now, this is what I see:
- cpuidle and deep C-state usage reduces the performance here, as has been
discussed in this thread.
- cpufreq ondemand governor also has a problem with the workload, as it runs the
CPU mostly at lower freq (as CPU utilization is hardly over 20%) and switching the
cpus to high frequency increases the performance.
- It also depends on where fio and the ahci interrupt handler runs. Looks like,
for maximum performance, they have to run on different CPUs sharing the caches.

So, getting this workload to give best performance by default will be a
major challenge :-). Another thing that will be interesting to look at is
performance/power for this workload and I haven't ventured into that
territory yet.

Thanks,
Venki
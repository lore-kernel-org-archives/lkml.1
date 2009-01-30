Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZA3Rbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZA3Rbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 12:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZA3Rbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 12:31:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:60410 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbZA3Rba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 12:31:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,352,1231142400"; 
   d="scan'208";a="661449813"
Subject: Re: cpufreq on demand governor sampling rate restricted to HZ even
	on NO_HZ kernels
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200901301559.15170.trenn@suse.de>
References: <200901301559.15170.trenn@suse.de>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 09:28:16 -0800
Message-Id: <1233336496.13694.49.camel@jamoon.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 06:59 -0800, Thomas Renninger wrote:
> Hi,
> 
> depending on HZ set to:
> 
> 100
> 250
> 1000
> 
> the ondemand governor is currently limited to poll the CPU load
> and adjust the frequency (sampling rate sysfs variable) every:
> 
> 200ms
> 80ms
> 20ms
> 
> This limitation does not consider NO_HZ which looks wrong?
> If this is correct, can someone give me a pointer, I'd like
> to understand why.
> 

That is wrong. ondemand sampling_rate should not limit the sampling rate
based on HZ when NO_HZ is configured. The idle statistics is not limited
by HZ rate with NO_HZ, as we will have idle microaccounting.

> If NO_HZ can/should go down to 20ms polling and more (current
> CPUs are able to switch fast enough, so that the ondemand governor
> would calculate the default polling interval below 80ms for them),
> this would hurt in respect of C-states at some point.
> 
> For performance reasons, one wants to poll as much as possible, for
> powersaving reasons (C-states), one wants to poll as seldom as
> possible.
> 
> I wonder whether it makes sense to dynamically adjust the polling
> interval (e.g. by a hint (and initial wakeup) from the scheduler or
> taking C-states into account) to:
>   - increase the sampling rate, e.g. based on context switching
>     activity
>   - lower sampling rate when the system is idle (to gain
>     full C-state efficiency)
> Or in what other way deep C-states could be taken into account
> in respect of ondemand polling?
> 

ondemand polling uses deferrable timer and hence will not be called
frequently on a totally idle CPU. The main reason we did not do the
dynamic sampling_rate is because it increases the ondemand response time
with a sudden increase of load, which is not liked by most workloads.

Thanks,
Venki


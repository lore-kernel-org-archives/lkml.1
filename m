Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbYHDTaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbYHDTaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbYHDTar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:30:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53389 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbYHDTao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:30:44 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5352"; a="5133462"
Message-ID: <489758F6.9080601@qualcomm.com>
Date: Mon, 04 Aug 2008 12:31:02 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Oruba <peter.oruba@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [rfc-patch, bugfix] x86-microcode
References: <1217778135.4912.40.camel@earth>
In-Reply-To: <1217778135.4912.40.camel@earth>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> Hi,
> 
> 
> [ consider it a pre-release and RFC... I'm a bit in hurry now and just send what I have got by this moment.
> Although, I expect it to be workable ]
> 
> 
> this change is supposed to fix bug#11197 (note, its name "Oops in microcode sysfs registration" is misleading)
> 
> The problem description can be found here:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0807.3/3791.html
> or
> http://lkml.org/lkml/2008/7/24/260
> 
> perhaps it does look quite bulky for -rc, although it's mainly move-redesign-some-bits of the code and
> I tried to preserve the original logic (even if it looked like a possible optimizations might had been applied)
> as much as possible.
> 
> The basic idea is that we introduce another mechanism to run ucode-updates on a target cpu
> and replace set_cpus_allowed_ptr() in (1) cpu-hotplug events and (2) module load.
> 
> 
> [1/2] x86-microcode: generic updates
> 
> Basically, it introduces microcode_update_cpu() which can be run either from start_secondary()
> (perhaps via a function pointer) or scheduled via keventd ([2/2]) and reworks the logic of cpu-hotplug events.
> 
> [2/2] x86-microcode: do updates via workqueue

Looks good to me. You did not change the old interface which still does
set_cpus_allowed_ptr() (ie racy against sched_setaffinity()) but it's not in
hotplug path and we can take care of that later.

> More testing is necessary. I tested without ucode-package (so only generic machinery) and for
> - load/unload module;
> - cpu-hotplug (so it doesn't give an oops anymore)
Test here too (dell latitude d620 - core2 duo). I have correct ucode files and
stuff. My cpu does not seem to need any updates so the actual update does not
get applied but everything else (workqueue, request firmware, etc) is working
as expected.

> hm, suspend/resume seems to be broken even without the 'microcode' module (will check the date of my previous kernel).
Works very here.

btw I do not think it's to bulky for -rc. Seems like a very straightforward fixes.

Max



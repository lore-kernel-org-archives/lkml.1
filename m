Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbYHDUBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbYHDUBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbYHDUB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:01:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:21192 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYHDUBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WO/IVBnLDaxdQPXcLQ/HE0l07sSBD8K+Jx1LHpIuaFBgB3ZrzzJZo3CqNU5Q6Ybl2o
         nTsdsosb2BLkgWno4fQqlKmRm4pxDZY7PBafd0VPHTepMMs1K6cR+sXflLqe2vaeZrLg
         einiiCyZrXd0huXs2bg3RSPGUVwBJabXhQlz8=
Message-ID: <b647ffbd0808041301v665f1c45k85794ad18c735d2@mail.gmail.com>
Date: Mon, 4 Aug 2008 22:01:23 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [rfc-patch, bugfix] x86-microcode
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, "Peter Oruba" <peter.oruba@amd.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489758F6.9080601@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217778135.4912.40.camel@earth> <489758F6.9080601@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/4 Max Krasnyansky <maxk@qualcomm.com>:
> Dmitry Adamushko wrote:
>> Hi,
>>
>>
>> [ consider it a pre-release and RFC... I'm a bit in hurry now and just send what I have got by this moment.
>> Although, I expect it to be workable ]
>>
>>
>> this change is supposed to fix bug#11197 (note, its name "Oops in microcode sysfs registration" is misleading)
>>
>> The problem description can be found here:
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0807.3/3791.html
>> or
>> http://lkml.org/lkml/2008/7/24/260
>>
>> perhaps it does look quite bulky for -rc, although it's mainly move-redesign-some-bits of the code and
>> I tried to preserve the original logic (even if it looked like a possible optimizations might had been applied)
>> as much as possible.
>>
>> The basic idea is that we introduce another mechanism to run ucode-updates on a target cpu
>> and replace set_cpus_allowed_ptr() in (1) cpu-hotplug events and (2) module load.
>>
>>
>> [1/2] x86-microcode: generic updates
>>
>> Basically, it introduces microcode_update_cpu() which can be run either from start_secondary()
>> (perhaps via a function pointer) or scheduled via keventd ([2/2]) and reworks the logic of cpu-hotplug events.
>>
>> [2/2] x86-microcode: do updates via workqueue
>
> Looks good to me. You did not change the old interface which still does
> set_cpus_allowed_ptr() (ie racy against sched_setaffinity())

ah, right. I've only fixed reload_store() vs. cpu_down().

sched_setaffinity() calls get_online_cpus() so a pair of
cpu_maps_update_begin() + cpu_hotplug_begin() would need to be used by
the following code:

old_mask = p->cpus_allowed;
set_cpus_allowed_ptr(p, new_mask);
// do_something
set_cpus_allowed_ptr(p, old_mask);

or we'd introduce another mutex to be used in both cases...  but I
think we just can get rid of most of use-cases (if not all) by
replacing them with schedule_work_on().


>
> Max
>

-- 
Best regards,
Dmitry Adamushko

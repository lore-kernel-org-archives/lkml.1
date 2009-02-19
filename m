Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZBSI2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZBSI2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 03:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZBSI1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 03:27:53 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:57973 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbZBSI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 03:27:52 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	<sWhNs83kKPE.A.p4D.L20jJB@chimera>
	<878wognj00.fsf@burly.wgtn.ondioline.org>
	<200902142342.59186.rjw@sisk.pl>
	<87hc2u26m5.fsf@burly.wgtn.ondioline.org>
	<1234775410.26036.122.camel@pasglop>
	<87d4di1wwr.fsf@burly.wgtn.ondioline.org>
Date: Thu, 19 Feb 2009 21:27:50 +1300
In-Reply-To: <87d4di1wwr.fsf@burly.wgtn.ondioline.org> (Paul Collins's message
	of "Mon, 16 Feb 2009 23:47:00 +1300")
Message-ID: <87r61uzv95.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins <paul@burly.ondioline.org> writes:

> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
>
>> On Mon, 2009-02-16 at 20:17 +1300, Paul Collins wrote:
>>> It turns out I didn't test this properly.  The warning is only
>>> triggered
>>> when I close and open the lid, not when I run 'snooze' to suspend and
>>> hit Return to resume, as I did for my so-called testing of 2.6.29-rc4.
>>> 
>>> Whatever is triggering the warning is still present in 2.6.29-rc5.
>>
>> Right, we probably need to stop sending input events from the PMU driver
>> when it's "suspended".
>>
>> Ping me if I don't produce a patch tomorrow (ie, I forgot :-)
>
> Just for laughs I slapped together the following, which seems to do the
> job, although not especially tidily.

And it doesn't even do the job.  Judging by this new trace, submitting
input events from the via-pmu resume function is still too early.

NIP [c0053b4c] getnstimeofday+0x24/0x188
LR [c0053ccc] do_gettimeofday+0x1c/0x58
Call Trace:
[eed09cb0] [c0053ccc] do_gettimeofday+0x1c/0x58
[eed09ce0] [c03492cc] evdev_event+0x28/0x158
[eed09d10] [c0341748] input_pass_event+0xac/0xb0
[eed09d30] [c03444a8] input_event+0x80/0x98
[eed09d50] [c02f7668] via_pmu_event_resume+0x60/0xb8 <-- the function I added
[eed09d60] [c02f725c] pmu_sys_resume+0x5c/0x74
[eed09de0] [c02d6420] __sysdev_resume+0x64/0x84
[eed09e00] [c02d6498] sysdev_resume+0x58/0xa4
[eed09e20] [c02dd39c] device_power_up+0x18/0x38
[eed09e40] [c00609d4] suspend_devices_and_enter+0x11c/0x180
[eed09e60] [c0060be8] enter_state+0x11c/0x160
[eed09e80] [c02f4d6c] pmu_ioctl+0x15c/0x24c
[eed09e90] [c00bad34] vfs_ioctl+0x8c/0x90
[eed09ea0] [c00bade8] do_vfs_ioctl+0x8c/0x70c
[eed09f10] [c00bb504] sys_ioctl+0x9c/0xa4
[eed09f40] [c0012eb8] ret_from_syscall+0x0/0x38

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood

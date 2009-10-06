Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbZJFLXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbZJFLXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932163AbZJFLXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:23:31 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:62269 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbZJFLXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:23:31 -0400
MIME-Version: 1.0
In-Reply-To: <1254825795.31336.204.camel@eenurkka-desktop>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
	 <1254814298.31336.63.camel@eenurkka-desktop>
	 <f488382f0910060322y12e2e7dbm9a1372e481c9013f@mail.gmail.com>
	 <1254825795.31336.204.camel@eenurkka-desktop>
Date: Tue, 6 Oct 2009 04:22:54 -0700
Message-ID: <f488382f0910060422t420ade8bvdefbf3e3d0720266@mail.gmail.com>
Subject: Re: [BISECTED] "conservative" cpufreq governor broken
From: Steven Noonan <steven@uplinklabs.net>
To: ext-eero.nurkkala@nokia.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 3:43 AM, Eero Nurkkala
<ext-eero.nurkkala@nokia.com> wrote:
> On Tue, 2009-10-06 at 12:22 +0200, ext Steven Noonan wrote:
>>
>> I would suspect you have to have CONFIG_NO_HZ enabled to be able to
>> reproduce the issue (considering the title of the bisected commit and
>> my own config). Do you have it enabled?
>>
>
> Yes, it's enabled.
>
>> > And another round:
>> >
>> > cpufreq stats: OP1:16,78%, OP2:0,24%, OP3:5,14%, OP4:77,83%  (72)
>> >
>> > Just once more after doing nothing:
>> > OP1:7,41%, OP2:0,11%, OP3:2,38%, OP4:90,10%  (82)
>> >
>> > So I can't agree it's broken. The patch you bisected, actually filtered
>> > out such phenomenon, in which an IRQ made the cpufreq framework
>> > occasionally think we were idling, although we were not. So you got
>> > "bonus" idle time that shouldn't been there in the first place. Now that
>> > the "bonus" idle time is not there, your system load may indeed be so
>> > high that the system never spends 80% or more time in idle? Could that
>> > be the case? Of course, even though I can't agree it's broken, doesn't
>> > mean it isn't somehow broken ;) It'd be nice to get info on other
>> > systems as well...
>>
>> Interestingly, "ondemand" (the governor fixed by the bisected commit)
>> works fine. "conservative" is the only broken one.
>>
>
> If you took timestamps in /arch/x86/kernel/process_**.c:
> (let's assume process_64.c) in cpu_idle()
> around enter_idle(); and __exit_idle(), took the diff,
> added the diffs up, and compared it to system uptime, you could see how
> much time you spend in idle()? I think it's possible that
> even if the cpu load is near 0%, the system may idle only for a bare
> moment (that translates to a buggy pm_idle()), and time is spent
> elsewhere (less than 80% in idle).

This makes logical sense, but how should I test this? Is there a way
to do this with existing tracers?

By the way, a revert of the bisected commit changes the cpufreq stats favorably:

2333000 31
2167000 13
2000000 6
1833000 79
1667000 239
1500000 193
1333000 959
1000000 10260
2333000 11
2167000 13
2000000 13
1833000 26
1667000 33
1500000 333
1333000 59
1000000 11293

- Steven

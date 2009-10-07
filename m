Return-Path: <linux-kernel-owner+w=401wt.eu-S934103AbZJGIGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103AbZJGIGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934065AbZJGIGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:06:18 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:39721 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934069AbZJGIGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:06:13 -0400
MIME-Version: 1.0
In-Reply-To: <1254901778.30157.62.camel@eenurkka-desktop>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
	 <f488382f0910060322y12e2e7dbm9a1372e481c9013f@mail.gmail.com>
	 <1254825795.31336.204.camel@eenurkka-desktop>
	 <f488382f0910060422t420ade8bvdefbf3e3d0720266@mail.gmail.com>
	 <1254832609.31336.290.camel@eenurkka-desktop>
	 <f488382f0910061754g6d15cf58v572e85701fc5aa4f@mail.gmail.com>
	 <f488382f0910061822wf8da0c1m7f118f04fe793abe@mail.gmail.com>
	 <1254893230.30157.28.camel@eenurkka-desktop>
	 <f488382f0910070030m153773e8s6d93cbd7e48f5461@mail.gmail.com>
	 <1254901778.30157.62.camel@eenurkka-desktop>
Date: Wed, 7 Oct 2009 01:05:36 -0700
Message-ID: <f488382f0910070105g19cbf75ci8034f2917b7e5606@mail.gmail.com>
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

On Wed, Oct 7, 2009 at 12:49 AM, Eero Nurkkala
<ext-eero.nurkkala@nokia.com> wrote:
> On Wed, 2009-10-07 at 09:30 +0200, ext Steven Noonan wrote:
>>
>> Okay, wow, I'm a moron. I misread what cpu_idle() was intended to be
>> for. I thought that cpu_idle() was a function that was periodically
>> called whenever the CPU had nothing to do, but now I see that it's
>> actually the main loop. I should really read the code next time.
>>
>> I've moved the statistics printout code to the _inside_ of that
>> infinite loop and retested. I had it print every several hundred
>> iterations. Here's the results (note the machine was idle the whole
>> time, except for about the first 10-20 seconds while the machine
>> booted):
>>
>> [    3.627716] timings[0]: 2250511125 / 3627716116
>> [    6.946216] timings[0]: 4780901366 / 6946213531
>> [   13.355182] timings[0]: 9385417604 / 13355183525
>> [   18.551304] timings[1]: 16300853077 / 18551301189
>> [   21.589039] timings[0]: 15984495433 / 21589037480
>> [   47.152733] timings[1]: 44386121538 / 47152731476
>> [   51.682630] timings[0]: 45713834076 / 51682628295
>> [   79.587359] timings[0]: 73524821916 / 79587356820
>> [   88.630110] timings[1]: 85324277596 / 88630109605
>> [   96.082386] timings[0]: 89691306072 / 96082384539
>>
>
> Those look good.
>
> Well, might as well then go for:
> /drivers/cpufreq/cpufreq_conservative.c
> dbs_check_cpu() ->
> load = 100 * (wall_time - idle_time) / wall_time; <- What is your load?

That's probably the problem...

[   40.632277] cpufreq load = 100 * (66667 - 3310) / 66667 = 95
[   40.698947] cpufreq load = 100 * (66661 - 3238) / 66661 = 95
[   73.965425] cpufreq load = 100 * (66667 - 12820) / 66667 = 80
[   74.032095] cpufreq load = 100 * (66661 - 1124) / 66661 = 98
[  107.298571] cpufreq load = 100 * (66666 - 13092) / 66666 = 80
[  107.365301] cpufreq load = 100 * (66722 - 3317) / 66722 = 95
[  140.631717] cpufreq load = 100 * (66666 - 3311) / 66666 = 95
[  140.698387] cpufreq load = 100 * (66662 - 3237) / 66662 = 95

idle_time is wrong.

> Let assume load is sane, look for (in dbs_check_cpu())
>        if (load < (dbs_tuners_ins.down_threshold - 10)) {
>
> whether it is taken ever...if not, what is your
> (dbs_tuners_ins.down_threshold - 10) ?
>
> - Eero
>
>

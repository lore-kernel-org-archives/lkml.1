Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbZJGIYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbZJGIYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbZJGIYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:24:51 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:45423 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791AbZJGIYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:24:50 -0400
MIME-Version: 1.0
In-Reply-To: <1254903263.30157.69.camel@eenurkka-desktop>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
	 <f488382f0910060422t420ade8bvdefbf3e3d0720266@mail.gmail.com>
	 <1254832609.31336.290.camel@eenurkka-desktop>
	 <f488382f0910061754g6d15cf58v572e85701fc5aa4f@mail.gmail.com>
	 <f488382f0910061822wf8da0c1m7f118f04fe793abe@mail.gmail.com>
	 <1254893230.30157.28.camel@eenurkka-desktop>
	 <f488382f0910070030m153773e8s6d93cbd7e48f5461@mail.gmail.com>
	 <1254901778.30157.62.camel@eenurkka-desktop>
	 <f488382f0910070105g19cbf75ci8034f2917b7e5606@mail.gmail.com>
	 <1254903263.30157.69.camel@eenurkka-desktop>
Date: Wed, 7 Oct 2009 01:24:13 -0700
Message-ID: <f488382f0910070124v6f1e1539gbeb7765ab6f32231@mail.gmail.com>
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

On Wed, Oct 7, 2009 at 1:14 AM, Eero Nurkkala
<ext-eero.nurkkala@nokia.com> wrote:
> On Wed, 2009-10-07 at 10:05 +0200, ext Steven Noonan wrote:
>> > Those look good.
>> >
>> > Well, might as well then go for:
>> > /drivers/cpufreq/cpufreq_conservative.c
>> > dbs_check_cpu() ->
>> > load = 100 * (wall_time - idle_time) / wall_time; <- What is your load?
>>
>> That's probably the problem...
>>
>> [   40.632277] cpufreq load = 100 * (66667 - 3310) / 66667 = 95
>> [   40.698947] cpufreq load = 100 * (66661 - 3238) / 66661 = 95
>> [   73.965425] cpufreq load = 100 * (66667 - 12820) / 66667 = 80
>> [   74.032095] cpufreq load = 100 * (66661 - 1124) / 66661 = 98
>> [  107.298571] cpufreq load = 100 * (66666 - 13092) / 66666 = 80
>> [  107.365301] cpufreq load = 100 * (66722 - 3317) / 66722 = 95
>> [  140.631717] cpufreq load = 100 * (66666 - 3311) / 66666 = 95
>> [  140.698387] cpufreq load = 100 * (66662 - 3237) / 66662 = 95
>>
>> idle_time is wrong.
>>
>> > Let assume load is sane, look for (in dbs_check_cpu())
>> >        if (load < (dbs_tuners_ins.down_threshold - 10)) {
>> >
>> > whether it is taken ever...if not, what is your
>> > (dbs_tuners_ins.down_threshold - 10) ?
>> >
>> > - Eero
>> >
>> >
>
> <------------Sidenote------------------------------>
> Vankatesh, I think the following is not smp friendly:
>        cpufreq_conservative.c:
>        /* Get Absolute Load */
>        for_each_cpu(j, policy->cpus) {
>        ...
>        load = 100 * (wall_time - idle_time) / wall_time;
>
>        now the load is only considered from the last cpu in line?
>        in ondemand, load goes to max_load_freq...so max is taken
>        from all cpus out there. (well, doesn't seem like the case with
>        conservative). Of course I may be wrong, and things are like
>        supposed.
> </------------Sidenote------------------------------>
>
> Steven, how do the cpu loads look like without the patch?

They're sane:

[   40.019381] cpufreq load = 100 * (66666 - 66337) / 66666 = 0
[   40.019396] cpufreq load = 100 * (66666 - 66299) / 66666 = 0
[   73.352580] cpufreq load = 100 * (66717 - 66349) / 66717 = 0
[   73.352595] cpufreq load = 100 * (66634 - 63848) / 66634 = 4

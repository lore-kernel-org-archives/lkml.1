Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZBRBME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZBRBME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbZBRBLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:11:52 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:65199 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZBRBLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:11:51 -0500
MIME-Version: 1.0
In-Reply-To: <200902161546.28630.trenn@suse.de>
References: <1234469284-15924-1-git-send-email-mike@android.com>
	 <49996B42.5040500@tremplin-utc.net> <200902161546.28630.trenn@suse.de>
Date: Tue, 17 Feb 2009 17:11:49 -0800
Message-ID: <8bb80c380902171711o3e2afec3h2cd22ebe4567414b@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Governor poll frequency tuneables exported in 
	config.
From: Mike Chan <mike@android.com>
To: Thomas Renninger <trenn@suse.de>
Cc: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
       davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 6:46 AM, Thomas Renninger <trenn@suse.de> wrote:
> On Monday 16 February 2009 14:33:54 Éric Piel wrote:
>> Mike Chan schreef:
>> >     cpufreq: Governor poll frequency tuneables exported in config.
>> >
>> Hello,
>>
>> > +config CPU_FREQ_MIN_TICKS
>> > +   int "Ticks between governor polling interval."
>> > +   default 10
>> > +   help
>> > +     Minimum number of ticks between polling interval for governors.
>> I don't think it makes much sense to let anyone tune this parameter.
>> This is a constant that says we need at least a 10% granularity to
>> compute any statistic correctly. There is nothing much to be discussed
>> or tuned.
>>
>>
>> > +config CPU_FREQ_SAMPLING_LATENCY_MULTIPLIER
>> > +   int "Sampling rate multiplier for governors."
>> > +   default 1000
>> > +   help
>> > +     Sampling latency rate multiplied by the cpu switch latency.
>> > +     Affects governor polling.
>> This one, why not (although I don't think it's worth neither), and it
>> would need a better documentation.
> It is already configurable in userspace, no need to introduce a
> new config variable:
>
> Documentation/cpu-freq/governors.txt
>
> ==================
> sampling_rate: measured in uS (10^-6 seconds), this is how often you
> want the kernel to look at the CPU usage and to make decisions on
> what to do about the frequency.  Typically this is set to values of
> around '10000' or more. It's default value is (cmp. with users-guide.txt):
> transition_latency * 1000
> The lowest value you can set is:
> transition_latency * 100 or it may get restricted to a value where it
> makes not sense for the kernel anymore to poll that often which depends
> on your HZ config variable (HZ=1000: max=20000us, HZ=250: max=5000).
> Be aware that transition latency is in ns and sampling_rate is in us, so
> you
> get the same sysfs value by default.
> Sampling rate should always get adjusted considering the transition latency
> To set the sampling rate 750 times as high as the transition latency
> in the bash (as said, 1000 is default), do:
> echo `$(($(cat cpuinfo_transition_latency) * 750 / 1000)) \
>    >ondemand/sampling_rate
> ===================
>
> But this is only in the very latest cpufreq next tree and should pop up
> in 2.6.30.
>
> Hmm, the statement:
> "Typically this is set to values of around '10000' or more"
> Is wrong (E.g. if you have HZ=250 you cannot go below 80000), but I plan to
> touch this again soon. Then this statement hopefully is correct again.
>
>    Thomas
>

The problem currently in 29 is that I need a faster response time from
the governors.
Take for example cpuinfo_transition_latency = 20us.
This gives a default sample_rate = 200ms, sample_rate_min = 100ms.

There is no way to get faster response times unless you tune those
values, or lie to the governor about the cpu switch speeds.

Some will argue 100ms is sufficient, but if you are trying to render @
60fps and are cpu bound this will cause a few dropped frames.

You mention "transition_latency * 100" but this is hard-coded in the
.c file, I don't see a way around this in 29, I'm assuming this will
be adjustable in 30?
I don't care so much about this patch's implementation, just that the
sampling_rate limitations are not an issue in the latest cpufreq tree
/ 30.

-- 
MIke Chan

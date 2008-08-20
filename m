Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYHTSnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYHTSnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYHTSnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:43:31 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:42755 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751550AbYHTSnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:43:31 -0400
Message-ID: <48AC65CD.9080108@gawab.com>
Date: Wed, 20 Aug 2008 11:43:25 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
Subject: Re: [PATCH] sched: disable hrtick implementation
References: <48A9BDC0.9070800@gawab.com> <20080819003110.GH9914@elte.hu>	 <1219127296.10800.357.camel@twins> <20080819092543.GD28713@elte.hu>	 <1219138380.10800.376.camel@twins> <20080819182222.GA25576@suse.de>	 <48AB1F49.6040207@gawab.com> <20080819194428.GA9997@suse.de>	 <48AB4F2B.9070405@gawab.com> <1219217091.10800.395.camel@twins>
In-Reply-To: <1219217091.10800.395.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-08-19 at 15:54 -0700, Justin Madru wrote:
>> The hrtick implementation in 2.6.25 and .26 has been known to cause boot
>> problems with at least Intel GMA cards. see:
>>
>> https://bugs.freedesktop.org/show_bug.cgi?id=15602
>> http://bugzilla.kernel.org/show_bug.cgi?id=10892
>>
>> A full fix to hrtick went into 2.6.27
>> (31656519e132f6612584815f128c83976a9aaaef),
>> but that fix is too intrusive to backport. Henceforth, we default to
>> disable hrtick.
>
> Thing is, I'm still not understanding how, or if, the old code is wrong.
>
> That said, this will paper over the problem just fine, and as its old
> kernels we're talking about I don't particularly care.

Fair enough.

All I know is that right when I started testing .25-rc1 I kept getting a 
garbled boot splash, blank screen, and even lock-ups during booting. It 
seemed to be that if I disabled the boot splash and/or started x 
manually the problem would rarely occur. So, maybe the first change to 
hrtick just exposed a bug in the boot splash or the x server. If that's 
true then, I don't get why right when .27-rc1 was out all the boot 
problems were gone.

Bisecting found both commits (introduce and fix) to be about hrtick. So 
maybe the commit that introduced my bug wasn't completely wrong, but at 
least it was not right enough because of the second commit was trying to 
fix something -- right? And the kernel still boots with hrtick disabled, 
I tested that.


> Just occured to me that a Kconfig change that always makes
> CONFIG_SCHED_HRTICK not set will also do.
>> Signed-off-by: Justin Madru <jdm64@gawab.com>
>> Tested-by: Justin Madru <jdm64@gawab.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>>
>> --- a/kernel/sched_features.h
>> +++ b/kernel/sched_features.h
>> @@ -4,7 +4,7 @@
>> SCHED_FEAT(AFFINE_WAKEUPS, 1)
>> SCHED_FEAT(CACHE_HOT_BUDDY, 1)
>> SCHED_FEAT(SYNC_WAKEUPS, 1)
>> -SCHED_FEAT(HRTICK, 1)
>> +SCHED_FEAT(HRTICK, 0)
>> SCHED_FEAT(DOUBLE_TICK, 0)
>> SCHED_FEAT(NORMALIZED_SLEEPER, 1)
>> SCHED_FEAT(DEADLINE, 1)
>>

Wouldn't disabling CONFIG_HIGH_RES_TIMERS (in the menu) also disable 
CONFIG_SCHED_HRTICK? In any case what about this patch below?


The hrtick implementation in 2.6.25 and .26 has been known to cause boot
problems with at least Intel GMA cards. see:

https://bugs.freedesktop.org/show_bug.cgi?id=15602
http://bugzilla.kernel.org/show_bug.cgi?id=10892

A full fix to hrtick went into 2.6.27 
(31656519e132f6612584815f128c83976a9aaaef),
but that fix is too intrusive to backport. Henceforth, we default to 
disable hrtick.

Signed-off-by: Justin Madru <jdm64@gawab.com>
Tested-by: Justin Madru <jdm64@gawab.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>

--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -55,4 +55,5 @@
     default 1000 if HZ_1000

 config SCHED_HRTICK
-    def_bool HIGH_RES_TIMERS && X86
+    bool
+    default n


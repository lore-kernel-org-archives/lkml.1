Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZI3IBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZI3IBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZI3IBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:01:37 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:60007 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbZI3IBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=En8Kki+RLVg3YTNugr4aAeaNJr4Kl3V3VWnPQz8qT6pl6UA2AgS/Big8uz8SXWWuiR
         7ThHoz8mJ3CcpsYZsGjJaKi773nKFq3uk4jAV8oPPwc0GKtA2lWVKWSYbTqiSf/FDx+d
         u9PfqITnwEiU97AplXTerex1fYv97pbsbNmsg=
MIME-Version: 1.0
In-Reply-To: <20090930095043.48e7081f@hammerfall>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	 <2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
	 <20090929072454.GA11414@elte.hu>
	 <2674af740909290231m5af0fbc6t5fba0b127c63bd9f@mail.gmail.com>
	 <20090930095043.48e7081f@hammerfall>
Date: Wed, 30 Sep 2009 16:01:40 +0800
Message-ID: <2674af740909300101x2ef4bbdewc12d52e703bdadf@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 3:50 PM, Michal Schmidt <mschmidt@redhat.com> wrote:
> Dne Tue, 29 Sep 2009 17:31:43 +0800
> Yong Zhang <yong.zhang0@gmail.com> napsal(a):
>
>> On Tue, Sep 29, 2009 at 3:24 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> > Could you try this with .32-rc1? This commit should have fixed the
>> > message above:
>> >
>> > 89133f9: clocksource: Resume clocksource without taking the
>> > clocksource mutex
>> >
>>
>> Hi Ingo,
>>
>> Indeed, Maciej said this issue is gone with .32-rc1. But I don't think
>> this is the same
>> issue with 89133f9 because in this one timekeeping_resume() is called
>> with irq enabled.
>> This is very odd and the bug exists in other parts.
>
> It is the same issue. Maciej has CONFIG_PREEMPT_VOLUNTARY=y which means
> taking the mutex in clocksource_resume() could have called into
> schedule(), thus enabling irqs.
>

>From my previous mail, I have ask Maciej to test the blow patch:
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fb0f46f..4a00a1a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -569,6 +569,9 @@ static int timekeeping_resume(struct sys_device *dev)
       unsigned long flags;
       struct timespec ts;

+       WARN_ONCE(!irqs_disabled(),
+               KERN_INFO "timekeeping_resume() called with IRQs enabled!");
+
       read_persistent_clock(&ts);

       clocksource_resume();

And indeed, the warning is showed. That means irq is enabled before
entering timekeeping_resume().
So is there other way to call clocksource_resume() and lead to this issue?

Best Regards,
Yong

> Michal
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbXGIDxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbXGIDxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 23:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbXGIDxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 23:53:34 -0400
Received: from smtp1.Stanford.EDU ([171.67.22.28]:55691 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750AbXGIDxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 23:53:33 -0400
Date: Sun, 8 Jul 2007 20:53:28 -0700 (PDT)
From: Fernando Pablo Lopez-Lezcano <nando@ccrma.Stanford.EDU>
X-X-Sender: nando@cmn3.stanford.edu
To: Gabriel C <nix.or.die@googlemail.com>
cc: Ingo Molnar <mingo@elte.hu>, Rui Nuno Capela <rncbc@rncbc.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "jcaceres@ccrma.Stanford.EDU" <jcaceres@ccrma.Stanford.EDU>,
       Carsten Emde <carsten.emde@osadl.org>
Subject: Re: v2.6.21.5-rt19
In-Reply-To: <46917678.70700@googlemail.com>
Message-ID: <Pine.LNX.4.63.0707082047130.12404@cmn3.stanford.edu>
References: <1183582155.3291.160.camel@chaos>  <9609.194.65.103.1.1183731007.squirrel@www.rncbc.org>
  <1183758545.20747.34.camel@cmn3.stanford.edu>  <20070707092401.GB21234@elte.hu>
 <1183934205.11854.11.camel@cmn3.stanford.edu> <46917678.70700@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Gabriel C wrote:
> Fernando Lopez-Lezcano wrote:
>> On Sat, 2007-07-07 at 11:24 +0200, Ingo Molnar wrote:
>>> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
>>>>>> Changes since 2.6.21.5-rt18:
>>>>>> - Fixed a nasty and hard to track down slowness / boot problem on SMP
>>>>>> machines with CONFIG_NOHZ enabled. The problem was caused by the timer
>>>>>> wheel base lock held during the get_next_timer_interrupt() call in the
>>>>>> idle path, which eventually led to a bogus PI boosting of the idle task
>>>>>> and in consequence a stale wrong scheduler selection for the affected 
>>>>>> idle
>>>>>> task.
>>>>>> 
>>>>>> Kudos to Carsten Emde, who patiently and meticulously isolated the
>>>>>> problem and provided the traces, which allowed to identify the root 
>>>>>> cause.
>>>>>> 
>>>>>> Problem solution: Prevent idle task boosting
>>>>>> 
>>>>> Maybe someone remember me whining about troubles with 2.6.21-rt2..18 on 
>>>>> my Core2 T7200 laptop (fujitsu-siemens amilo i1520).
>>>>> 
>>>>> Althought I'm still with my fingers crossed, I can tell the good news 
>>>>> are that 2.6.21.5-rt19 (and -rt20) does behave far better now on the 
>>>>> very same box.
>>>>> 
>>>> Yes, it works much better indeed...
>>>> 
>>>> Ingo: is there a place where I can read about the changes in different 
>>>> rtxx releases? What is new/better/fixed in rt20? (I see scheduler stuff 
>>>> in a diff from rt19 to rt20 but I don't really know what it means).
>>>> 
>>> and rt18 was a -rt-only NOHZ fix, that bug got introduced in rt11 when CFS 
>>> was merged.
>>> 
>>> i _think_ Rui might have seen two separate problems. Perhaps by the time 
>>> we fixed the first problem (which Rui saw since -rt2) we introduced the 
>>> other one via -rt11 - which then got fixed in -rt19.
>> 
>> Ahh, CFS is now part of rt, I was obviously not paying attention... I'm
>> really trying to provide a "stable" rt kernel for audio usage and
>> including another subsystem into rt is - IMHO - not going to help.
>> What's the chance of splitting things?
>> 
>>> btw., we'd love to get more feedback regarding CFS. CFS is a completely 
>>> new scheduler for Linux. 
>> 
>> Then I'd rather have it separate from rt.
>> 
>>> It has a design centered around keeping application latencies down, so it 
>>> is ultimately real-time friendly, and it should also make things work 
>>> better for desktop-ish and audio-ish stuff as well. (even under 
>>> SCHED_OTHER)
>>> 
>> 
>> Maybe this is CFS related? (tail of a thread in the Planet CCRMA mailing
>> list):
>> 
>> On Sun, 2007-07-08 at 15:26 -0400, Hector Centeno wrote:
>> 
>>> Ok, so just to confirm, that 2.6.21-0182.rt19.1.fc7.ccrmart works fine
>>> on my desktop but on my laptop it makes Firefox and Tomboy to crash.
>>> On the same laptop using 2.6.21-0182.rt17.1.fc7.ccrmart there is no
>>> problem.
>>> 
>> I managed to completely hang firefox (fc7) with flash 9 installed
>> (unkillable even with -9).
>
> Firefox with flash 9 does not work good , there are a lot bugs reported 
> about ( just google ) and it hangs on vanilla or whatever other kernels 
> as well. Not only Firefox but also Swiftfox, Opera, Epiphany etc.
>
> The most time Firefox dies when you use flash 9 and close a window or a 
> tab.

More tests...

The problem is the rt kernel AFAICT, this goes beyond Flash 9, way 
beyond:

_OpenOffice_ hangs with 2.6.21.5-rt20, works fine with stock Fedora 7 
kernel. Flash 9 hangs with 2.6.21.5-rt20, works fine with the stock Fedora 
7 kernel. Same machine booting different kernels, I'd say it is the 
kernel.

The only way out for a hung app is a reboot.

Ingo: what would be a good way to trace this? It makes the rt kernels not 
very usable at least on this hardware (more tests tomorrow in the CCRMA 
machines).

Same on 2.6.21.5-rt18 with CONFIG_NO_HZ not set.

-- Fernando

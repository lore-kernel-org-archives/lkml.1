Return-Path: <linux-kernel-owner+w=401wt.eu-S1751409AbZHRTtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbZHRTtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 15:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZHRTtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 15:49:36 -0400
Received: from cinke.fazekas.hu ([195.199.244.225]:49687 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZHRTtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 15:49:35 -0400
Date: Tue, 18 Aug 2009 21:49:31 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: CPU scheduler weirdness?
In-Reply-To: <20090813155812.GA15714@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LNX.2.00.0908171758340.2764@cinke.fazekas.hu>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de> <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu> <20090813155812.GA15714@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-943463948-1673848324-1250624971=:8537"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-1673848324-1250624971=:8537
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

Hi,

On Thu, 13 Aug 2009, Andreas Mohr wrote:
> On Thu, Aug 13, 2009 at 05:39:10PM +0200, Marton Balint wrote:
>>>> Does anybody have any idea what can cause this?
>>>
>>> /sys/devices/system/cpu/sched_smt_power_savings , perhaps?
>>
>> Thanks for the tip, tuning the sched_mc_power_savings setting helped! The
>> original value of it was 0, but after setting it to 1, the two
>> cpu-intensive processes got scheduled to different CPU cores, as
>> expected.
>
> Heh, I did expect it to not help, and indeed that thing helping in this
> way points to a... BUG, plain and simple.
>
> http://lwn.net/Articles/297306/
> lists possible settings as
>
> "
> The power savings and performance of the given workload in an under
> utilised system can be controlled by setting values of 0, 1 or 2 to
> /sys/devices/system/cpu/sched_mc_power_savings with 0 being highest
> performance and least power savings and level 2 indicating maximum
> power savings even at the cost of slight performance degradation.
> "
>
> which is exactly opposite to what I'd have expected to be normal,
> unconfigured behaviour in your case.
>
>> Setting it back to 0 casused the two cpu-intensive processes to run on
>> the same CPU again. So I guess I will just set it to 1 after booting the
>> system.
>
> ...which would indicate a level=1 or level=2 (maximum powersaving)
> behaviour. Something either seems reversed or really weird.
> But it could just be opaque if correct behaviour due to a much more complex
> load balancing algo in the scheduler or so.
>
> Comments, anyone?

In the meantime, I was able to create a tiny C program which always 
succesfully reproduces the bug. It's basically an endless loop which does 
not stop while the process is running on the last CPU core. The program 
creates multiple instances of itself, to be able to keep all of the CPU 
cores busy. After 1 second, the processes running on other than the last 
CPU core die, the processes running on the last CPU core remain stuck 
there...

I tested it on my dual core system, if someone could test it on a quad 
core and report back that would probably be useful.

Usage: ./schedtest <number of CPU cores>

And don't forget to kill the stuck processes after using the program! :)

Regards,
   Marton
---943463948-1673848324-1250624971=:8537
Content-Type: TEXT/x-c++src; name=schedtest.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.0908182149310.8537@cinke.fazekas.hu>
Content-Description: 
Content-Disposition: attachment; filename=schedtest.c

I2RlZmluZSBfR05VX1NPVVJDRQ0KI2luY2x1ZGUgPHV0bXB4Lmg+DQojaW5j
bHVkZSA8c3lzL3RpbWUuaD4NCiNpbmNsdWRlIDx1bmlzdGQuaD4NCg0KLyog
VXNhZ2U6IC4vc2NoZWR0ZXN0IDxudW1iZXIgb2YgY3B1IGNvcmVzPiAqLw0K
DQppbnQgbWlsaXNlY29uZHMoKSB7DQogIHN0cnVjdCB0aW1ldmFsIHR2Ow0K
ICBnZXR0aW1lb2ZkYXkoJnR2LCAwKTsNCiAgcmV0dXJuIHR2LnR2X3VzZWMv
MTAwMDsNCn0NCg0KaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkg
ew0KICBpbnQgbGl2ZXMgPSAxMDAwLCB0aW1lLCBsYXN0dGltZSwgY2hpbGRz
LCBjb3JlcyA9IDI7DQogIGlmIChhcmdjID4gMSkNCiAgICBjb3JlcyA9IGF0
b2koYXJndlsxXSk7DQogIGNoaWxkcyA9IGNvcmVzICogMjsNCiAgd2hpbGUg
KGNoaWxkcy0tICYmICFmb3JrKCkpOw0KICB3aGlsZSAobGl2ZXMpIHsNCiAg
ICB0aW1lID0gbWlsaXNlY29uZHMoKTsNCiAgICBpZiAobGFzdHRpbWUgIT0g
dGltZSAmJiBzY2hlZF9nZXRjcHUoKSAhPSAoY29yZXMtMSkpDQogICAgICAg
bGl2ZXMtLTsNCiAgICBsYXN0dGltZSA9IHRpbWU7DQogIH0NCiAgcmV0dXJu
IDA7DQp9DQo=

---943463948-1673848324-1250624971=:8537--

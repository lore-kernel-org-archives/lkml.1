Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZHTQ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZHTQ4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZHTQ4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:56:08 -0400
Received: from cinke.fazekas.hu ([195.199.244.225]:45106 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbZHTQ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:56:07 -0400
Date: Thu, 20 Aug 2009 18:56:03 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org
Subject: Re: CPU scheduler weirdness?
In-Reply-To: <20090820105645.GA23635@elte.hu>
Message-ID: <alpine.LNX.2.00.0908201814270.12548@cinke.fazekas.hu>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de> <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu> <20090813155812.GA15714@rhlx01.hs-esslingen.de> <alpine.LNX.2.00.0908171758340.2764@cinke.fazekas.hu> <1250665455.7583.326.camel@twins>
 <alpine.LNX.2.00.0908191353100.19120@cinke.fazekas.hu> <1250683834.7583.360.camel@twins> <alpine.LNX.2.00.0908191428300.20409@cinke.fazekas.hu> <1250707331.7154.1.camel@laptop> <alpine.LNX.2.00.0908192125180.4364@cinke.fazekas.hu>
 <20090820105645.GA23635@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-943463948-146071587-1250787363=:24170"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-146071587-1250787363=:24170
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII



On Thu, 20 Aug 2009, Ingo Molnar wrote:

>
> * Marton Balint <cus@fazekas.hu> wrote:
>
>>
>> On Wed, 19 Aug 2009, Peter Zijlstra wrote:
>>
>>> On Wed, 2009-08-19 at 14:34 +0200, Marton Balint wrote:
>>>>
>>>> On Wed, 19 Aug 2009, Peter Zijlstra wrote:
>>>>
>>>>> On Wed, 2009-08-19 at 14:01 +0200, Marton Balint wrote:
>>>>>> On Wed, 19 Aug 2009, Peter Zijlstra wrote:
>>>>>>> On Tue, 2009-08-18 at 21:49 +0200, Marton Balint wrote:
>>>>>>>
>>>>>>>> In the meantime, I was able to create a tiny C program which always
>>>>>>>> succesfully reproduces the bug. It's basically an endless loop which does
>>>>>>>> not stop while the process is running on the last CPU core. The program
>>>>>>>> creates multiple instances of itself, to be able to keep all of the CPU
>>>>>>>> cores busy. After 1 second, the processes running on other than the last
>>>>>>>> CPU core die, the processes running on the last CPU core remain stuck
>>>>>>>> there...
>>>>>>>>
>>>>>>>> I tested it on my dual core system, if someone could test it on a quad
>>>>>>>> core and report back that would probably be useful.
>>>>>>>>
>>>>>>>> Usage: ./schedtest <number of CPU cores>
>>>>>>>>
>>>>>>>> And don't forget to kill the stuck processes after using the program! :)
>>>>>>>
>>>>>>> So what's the bug? Sure one task will stay on the cpu, and because there
>>>>>>> is no contention it doesn't get migrated, and therefore won't quit,
>>>>>>> how's that a problem?
>>>>>>
>>>>>> Problem is that more than one processes remain on that CPU core, and none
>>>>>> of them get migrated to other (idle) cores. I tested it with my E8400
>>>>>> processor and 2.6.31-rc5-git3 kernel.
>>>>>
>>>>> Only one remains here.. on a c2q running 2.6.31-rc6-tip
>>>>>
>>>>> Do you have a .config handy?
>>>>>
>>>>
>>>> Yes it's in my original post:
>>>>
>>>> http://marc.info/?l=linux-kernel&m=125012584709800&w=2
>>>
>>> Right you are,.. so I build a kernel with the cgroup scheduler in and
>>> tested it on a dual-core opteron machine, but I can't seem to reproduce
>>> this.
>>>
>>> Are you using cgroups in any way, or do you simply have it enabled in
>>> your config?
>>
>> No, it's just enabled. Actually the kernel is from the
>> openSUSE build service:
>>
>> http://download.opensuse.org/repositories/Kernel:/HEAD/openSUSE_11.1/x86_64/
>>
>> But the problem is present for both the kernel-default
>> kernel and the kernel-vanilla kernel which does not
>> contain any suse-specific patches.
>>
>> This evening I had a bit more time to test, and I've
>> made a surprising discovery: I can only reproduce the
>> bug if the kernel module of my TV tuner card is loaded.
>> I have a Leadtek Winfast 2000 XP Expert TV card, it
>> uses the cx8800 kernel module. It seems that the
>> problem is somehow related to the infrared sensor of
>> the TV card, because I recompiled the module with the
>> 'case CX88_BOARD_WINFAST2000XP_EXPERT:' line removed
>> from cx88-input.c and I couldn't reproduce the bug with
>> the new kernel module.
>
> Extremely weird. Are timers somehow busted?

How can I check that?

In the meantime, I updated my original C program and also created a kernel 
module (schedtest_mod.c) which causes the same scheduling problems as the 
kernel module of my TV card. The kernel module is a skeleton of the 
infrared sensor polling code in cx88-input.c. It uses 
schedule_delayed_work, this seems to cause the problem. The C program 
(schedtest.c) is also updated, it now detects the number of CPU cores, 
from now, what you can set as a command line parameter is the CPU core 
number, on which the schedtest processes will not quit. (previously this 
was always the last core).

So to reproduce the bug on a dual core system, compile and insert the 
kernel module (schedtest_mod.c). Then check dmesg, it should contain on 
which CPU core is the delayed_work running. You should use the CPU core id 
of the _other_ CPU core as a command line parameter to the updated 
schedtest program.

And by the way, thank you guys for the help so far, hopefully we'll get to 
the bottom of this :)

Regards,
   Marton
---943463948-146071587-1250787363=:24170
Content-Type: TEXT/x-c++src; name=schedtest_mod.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.0908201856030.24170@cinke.fazekas.hu>
Content-Description: 
Content-Disposition: attachment; filename=schedtest_mod.c

I2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0KI2luY2x1ZGUgPGxpbnV4L2lu
aXQuaD4NCiNpbmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4NCiNpbmNsdWRl
IDxhc20vc21wLmg+DQoNCnN0YXRpYyBpbnQgaTsNCnN0YXRpYyBzdHJ1Y3Qg
ZGVsYXllZF93b3JrIGRfd29yazsNCg0Kc3RhdGljIHZvaWQgc2NoZWR0ZXN0
X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0Kew0KCXNjaGVkdWxl
X2RlbGF5ZWRfd29yaygmZF93b3JrLCBtc2Vjc190b19qaWZmaWVzKDEpKTsN
CglpZiAoaSsrICUgNTAwID09IDApIHsNCgkJcHJpbnRrKEtFUk5fREVCVUcg
InNjaGVkdGVzdDogSSBhbSBvbiBDUFUgJWQuXG4iLCBnZXRfY3B1KCkpOw0K
CQlwdXRfY3B1KCk7DQoJfQ0KfQ0KDQpzdGF0aWMgaW50IF9faW5pdCBzY2hl
ZHRlc3RfaW5pdF9tb2R1bGUodm9pZCkNCnsNCglJTklUX0RFTEFZRURfV09S
SygmZF93b3JrLCBzY2hlZHRlc3Rfd29yayk7DQoJc2NoZWR1bGVfZGVsYXll
ZF93b3JrKCZkX3dvcmssIDApOw0KCXJldHVybiAwOw0KfQ0KDQpzdGF0aWMg
dm9pZCBfX2V4aXQgc2NoZWR0ZXN0X2NsZWFudXBfbW9kdWxlKHZvaWQpDQp7
DQoJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZkX3dvcmspOw0KfQ0KDQpt
b2R1bGVfaW5pdChzY2hlZHRlc3RfaW5pdF9tb2R1bGUpOw0KbW9kdWxlX2V4
aXQoc2NoZWR0ZXN0X2NsZWFudXBfbW9kdWxlKTsNCg0KTU9EVUxFX0xJQ0VO
U0UoIkdQTCIpOw0K

---943463948-146071587-1250787363=:24170
Content-Type: TEXT/x-c++src; name=schedtest.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LNX.2.00.0908201856031.24170@cinke.fazekas.hu>
Content-Description: 
Content-Disposition: attachment; filename=schedtest.c

I2RlZmluZSBfR05VX1NPVVJDRQ0KI2luY2x1ZGUgPHV0bXB4Lmg+DQojaW5j
bHVkZSA8c3lzL3RpbWUuaD4NCiNpbmNsdWRlIDx1bmlzdGQuaD4NCg0KLyog
VXNhZ2U6IC4vc2NoZWR0ZXN0IDxjcHUgY29yZSB0byB0ZXN0PiAqLw0KDQpp
bnQgbWlsaXNlY29uZHMoKSB7DQogIHN0cnVjdCB0aW1ldmFsIHR2Ow0KICBn
ZXR0aW1lb2ZkYXkoJnR2LCAwKTsNCiAgcmV0dXJuIHR2LnR2X3VzZWMvMTAw
MDsNCn0NCg0KaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkgew0K
ICBpbnQgbGl2ZXMgPSAxMDAwLCB0aW1lLCBsYXN0dGltZSwgY2hpbGRzLCBj
b3JlcywgY29yZV90b190ZXN0Ow0KICBjb3JlcyA9IHN5c2NvbmYoX1NDX05Q
Uk9DRVNTT1JTX09OTE4pOw0KICBjaGlsZHMgPSBjb3JlcyAqIDI7DQogIGlm
IChhcmdjID4gMSkNCiAgICBjb3JlX3RvX3Rlc3QgPSBhdG9pKGFyZ3ZbMV0p
Ow0KICBlbHNlDQogICAgY29yZV90b190ZXN0ID0gY29yZXMtMTsNCiAgd2hp
bGUgKGNoaWxkcy0tICYmICFmb3JrKCkpOw0KICB3aGlsZSAobGl2ZXMpIHsN
CiAgICB0aW1lID0gbWlsaXNlY29uZHMoKTsNCiAgICBpZiAobGFzdHRpbWUg
IT0gdGltZSAmJiBzY2hlZF9nZXRjcHUoKSAhPSBjb3JlX3RvX3Rlc3QpDQog
ICAgICAgbGl2ZXMtLTsNCiAgICBsYXN0dGltZSA9IHRpbWU7DQogIH0NCiAg
cmV0dXJuIDA7DQp9DQo=

---943463948-146071587-1250787363=:24170--

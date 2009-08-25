Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZHYSiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZHYSiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZHYSiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:38:16 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:41036 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755542AbZHYSiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:38:16 -0400
Message-ID: <4A942F96.7000900@nets.rwth-aachen.de>
Date: Tue, 25 Aug 2009 20:38:14 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
References: <4A9407B1.6020400@nets.rwth-aachen.de> <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com> <4A94161A.2020609@nets.rwth-aachen.de> <1251219129.4852.1.camel@penberg-laptop> <4A94242E.30309@nets.rwth-aachen.de> <1251223399.13451.5.camel@penberg-laptop> <4A942BDD.70303@nets.rwth-aachen.de> <20090825182510.GA6903@elte.hu> <4A942DB9.3020209@goop.org>
In-Reply-To: <4A942DB9.3020209@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> On 08/25/09 11:25, Ingo Molnar wrote:
>> * Arnd Hannemann <hannemann@nets.rwth-aachen.de> wrote:
>>
>>
>>> Pekka Enberg wrote:
>>>
>>>> On Tue, 2009-08-25 at 19:49 +0200, Arnd Hannemann wrote:
>>>>
>>>>> Hi Pekka,
>>>>>
>>>>> Pekka Enberg wrote:
>>>>>
>>>>>> On Tue, 2009-08-25 at 18:49 +0200, Arnd Hannemann wrote:
>>>>>>
>>>>>>>> Thanks for doing the bisect! Can we also see your
>>>>>>>> .config also?
>>>>>>>>
>>>>>>> Config for -rc7 is attached. My bisect configs were based
>>>>>>> on that
>>>>>>>
>>>>>> Thanks! While we wait for the Xen people, you can try the
>>>>>> following patch to see if we can narrow the bug down to
>>>>>> trap_init().
>>>>>>
>>>>> Yes seems to be trap_init(). -rc7 with this patch applied
>>>>> boots up to the prompt.
>>>>>
>>>> Thanks for testing! Ingo, what do you think of the following
>>>> patch? AFAICT, x86-32 is the only architecture playing with
>>>> traps in mem_init() so this should be the safest fix for
>>>> 2.6.31.
>>>>
>>> Hmm, -rc7 + this fix does not work for me :-/ Still hangs before
>>> any output...
>>>
>> does earlyprintk=vga tell you anything about precisely where it
>> hangs?
>>
>
> It's a Xen domain, so it should be earlyprintk=xen
>
> J
>
Here is the output with earlyprintk=xen and the second patch from pekka
applied:

(early) [    0.000000] Initializing CPU#0
(early) [    0.000000] Checking if this processor honours the WP bit
even in supervisor mode...(early)
(early) [    0.000000] BUG: unable to handle kernel (early) NULL pointer
dereference(early)  at (null)
(early) [    0.000000] IP:(early)  [<c1192993>]
xen_evtchn_do_upcall+0xd3/0x160
(early) [    0.000000] *pdpt = 0000000008386001 (early)
(early) [    0.000000] Thread overran stack, or stack corrupted
(early) [    0.000000] Oops: 0000 [#1] (early) SMP (early)
(early) [    0.000000] last sysfs file:
(early) [    0.000000] Modules linked in:(early)
(early) [    0.000000]
(early) [    0.000000] Pid: 0, comm: swapper Not tainted
(2.6.31-rc7-pae-um #10)
(early) [    0.000000] EIP: 0061:[<c1192993>] EFLAGS: 00010046 CPU: 0
(early) [    0.000000] EIP is at xen_evtchn_do_upcall+0xd3/0x160
(early) [    0.000000] EAX: 00000004 EBX: 00000000 ECX: 00000004 EDX:
ffffffff
(early) [    0.000000] ESI: fffffffe EDI: 00000000 EBP: 00000000 ESP:
c1413e64
(early) [    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: e021
(early) [    0.000000] Process swapper (pid: 0, ti=c1412000
task=c13d11a0 task.ti=c1412000)
(early) [    0.000000] Stack:
(early) [    0.000000]  f5793000(early)  c146d9f0(early) 
c146d9f0(early)  00000000(early)  c1413e9c(early)  00000000(early) 
00000000(early)  c3a01020(early)
(early) [    0.000000] <0>(early)  00000000(early)  eec06067(early) 
c000cff8(early)  00000000(early)  00000000(early)  c10086d7(early) 
eec06067(early)  c000cff8(early)
(early) [    0.000000] <0>(early)  f55ff000(early)  c000cff8(early) 
00000000(early)  00000000(early)  c13d7d60(early)  c101e021(early) 
c141e021(early)  c10100d8(early)
(early) [    0.000000] Call Trace:
(early) [    0.000000]  [<c10086d7>] ? xen_do_upcall+0x7/0xc
(early) [    0.000000]  [<c101e021>] ? ptep_set_access_flags+0x1/0x80
(early) [    0.000000]  [<c141e021>] ? find_e820_area_size+0x51/0x330
(early)


Best regards,
Arnd


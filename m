Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbXGWW2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbXGWW2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXGWW1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:27:52 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39137 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbXGWW1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:27:51 -0400
Date: Tue, 24 Jul 2007 00:26:48 +0200 (MEST)
Message-Id: <200707232226.l6NMQmm5009122@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: hpa@zytor.com, mikpe@it.uu.se
Subject: Re: [BUG] 2.6.23-rc1 broke APM
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 08:50:41 -0700, H. Peter Anvin wrote:
>Mikael Pettersson wrote:
>> On this machine (Gigabyte mobo with i815EP chipset and a PIII),
>> APM worked fine up to 2.6.22. With 2.6.23-rc1 however the APM
>> driver fails to locate the APM bios:
>> 
>> --- dmesg-2.6.22	2007-07-23 14:07:46.000000000 +0200
>> +++ dmesg-2.6.23-rc1	2007-07-23 14:48:24.000000000 +0200
>> @@ -102,7 +105,7 @@
>>  Unpacking initramfs... done
>>  Freeing initrd memory: 976k freed
>>  Machine check exception polling timer started.
>> -apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
>> +apm: BIOS not found.
>>  io scheduler noop registered
>>  io scheduler anticipatory registered (default)
>>  io scheduler deadline registered
>> 
>> The only change in 2.6.23-rc1 to arch/i386/kernel/apm.c is a
>> trivial nofreeze flag removal, so I suspect the boot code changes,
>> perhaps the new arch/i386/boot/apm.c:query_apm_bios().
>> 
>
>Seems like a reasonable suspicion.
>
>Could you try the attached patch and:
>
>a) see if it helps the situation, and
>b) tell me what it prints?
>
>	-hpa

Only the first printf() triggers, and it prints:

apm: err = 0, ax = 0x102, bx = 0x504d, cx = 0x7

The err and bx checks will succeed, but the "if (cx & 0x02)"
check will cause query_apm_bios() to return failure.

I compared this check with the original assembly code,
and it turns out that the i386 boot rewrite accidentally
inverted the sense of this check. I've just posted a
patch to fix it.

/Mikael

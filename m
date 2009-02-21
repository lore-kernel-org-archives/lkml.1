Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZBUWUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZBUWUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 17:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZBUWTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 17:19:54 -0500
Received: from mail-fx0-f164.google.com ([209.85.220.164]:62069 "EHLO
	mail-fx0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZBUWTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 17:19:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sFopXSLleIqxeVpCoaOrEp0gZ1sdJrcI4E2Fl+f1hqQatELTbdDtP05cESDKJBioIo
         97DkW6UFkGxBtMMNRwxgO188pyYdabKpwKYl2jeo+3YTABMedS0wCVGtXAYEqKyI8Vy0
         K9ThGej7d9MegBTjiqgD0M9MI6poVoGB+GZ74=
MIME-Version: 1.0
In-Reply-To: <19f34abd0902211332r6fd0a1e3l3cee6c49e85f879e@mail.gmail.com>
References: <20090221211908.GA6798@silver.sucs.org>
	 <19f34abd0902211332r6fd0a1e3l3cee6c49e85f879e@mail.gmail.com>
Date: Sat, 21 Feb 2009 23:19:50 +0100
Message-ID: <19f34abd0902211419p4109f8bfsf987b68162b01f50@mail.gmail.com>
Subject: Re: Is kmemcheck currently broken on tip?
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/21 Vegard Nossum <vegard.nossum@gmail.com>:
> 2009/2/21 Sitsofe Wheeler <sitsofe@yahoo.com>:
>> Hi,
>>
>> I've been trying to test kmemcheck in linux-tip on my EeePC and things
>> have been going suspiciously not so slow with little extra memory used
>> (at least compared to the last time I used kmemcheck). While I see
>> [    0.063412] kmemcheck: "Bugs, beware!"
>> in dmesg, I'm not sure kmemcheck is working especially since nothing is
>> flagged when I trigger the issue described in
>> http://marc.info/?l=linux-kernel&m=123472656015761&w=1 ...
>
> Thanks for the tip! :-D I get this:
>
...

> (Hm, maybe storing the unreliable stack frames wasn't such a good idea
> at all -- all they do is fill up the space.)
>

A different one, with more stack:

[  352.792672] WARNING: kmemcheck: Caught 8-bit read from uninitialized memory (
f54fb0b8)
[  352.801437] 2e76b5343061aa6a6fc5db64689d95188383de4b60554e79ffffffffffffffff
[  352.828424]  i i i i i i i i i i i i i i i i i i i i i i i i u u u u u u u u
[  352.855402]                                                  ^
[  352.861954]
[  352.864110] Pid: 2414, comm: cat Not tainted (2.6.29-rc4 #251) 945P-A
[  352.871286] EIP: 0060:[<c11a76e9>] EFLAGS: 00010297 CPU: 0
[  352.877479] EIP is at strnlen+0x9/0x20
[  352.881904] EAX: f54fb0b8 EBX: c162081e ECX: f54fb000 EDX: ffffff46
[  352.888900] ESI: ffffffff EDI: f54fb000 EBP: f552bd8c ESP: c17866e4
[  352.895897]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  352.902012] CR0: 8005003b CR2: f6c04070 CR3: 354fa000 CR4: 000006d0
[  352.909009] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  352.916006] DR6: ffff4ff0 DR7: 00000400
[  353.023259]    [<c11a64a8>] string+0x28/0xd0
[  353.029382]    [<c11a69d4>] vsnprintf+0x484/0xac0
[  353.164334]    [<c11a702c>] sprintf+0x1c/0x20
[  353.170556]    [<c10443ff>] param_get_charp+0x1f/0x30
[  353.177475]    [<c1044152>] param_attr_show+0x22/0x50
[  353.191231]    [<c1043d88>] module_attr_show+0x28/0x40
[  353.198241]    [<c10efbad>] sysfs_read_file+0x7d/0x110
[  353.205246]    [<c10a52d9>] vfs_read+0x99/0x160
[  353.218557]    [<c10a545d>] sys_read+0x3d/0x70
[  353.224846]    [<c1003483>] sysenter_do_call+0x12/0x21
[  353.231857]    [<ffffffff>] 0xffffffff

That's where it happened:

$ addr2line -e vmlinux -i c11a76e9 c11a64a8 c11a69d4 c11a702c c10443ff
c1044152 c1043d88 c10efbad c10a52d9 c10a545d
arch/x86/lib/string_32.c:222
lib/vsprintf.c:524
lib/vsprintf.c:846
lib/vsprintf.c:1058
kernel/params.c:227
kernel/params.c:407
kernel/params.c:671
fs/sysfs/file.c:92
fs/sysfs/file.c:142
fs/read_write.c:292
fs/read_write.c:369
fs/read_write.c:382

(Code is -rc4)

Hope this helps, if you didn't sort it out already :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

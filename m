Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYGWVg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYGWVg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYGWVgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:36:02 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:7457 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbYGWVf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TgvJ0D9faLpplEO1OqJyKsbJa36wMVNcJiNl0Tb0Nvopaes72YayA9iyWcezd/B3Nv
         dEyZSAd0CdRtmzWBfacVAKh/MlcIu9QoBzny5JX4PII4/3k1yCcKO4SP+8aMRE9SqriW
         YGXINBiD0/JGiOdfw5yU+4OfbrCBMWKdsw0ic=
Message-ID: <19f34abd0807231435yed788d1r30b1e420c5b9de5d@mail.gmail.com>
Date: Wed, 23 Jul 2008 23:35:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "the arch/x86 maintainers" <x86@kernel.org>
Subject: Re: recent -git: BUG in free_thread_xstate
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <19f34abd0807231328j3fdb1f13r31a567bdd780a974@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807231307y191c0ad7tfab4cda57ee88eb@mail.gmail.com>
	 <19f34abd0807231323g2ad85760v2a289b6fd0602cb1@mail.gmail.com>
	 <19f34abd0807231328j3fdb1f13r31a567bdd780a974@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 10:28 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Wed, Jul 23, 2008 at 10:23 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> My test is basically stressing the network and running CPU hotplug at
>> the same time.
>
> FWIW, a third run gives us this additional clue before going down with
> the first error I posted in this thread:
>
> =============================================================================
> BUG task_struct: Poison overwritten
> -----------------------------------------------------------------------------
> INFO: 0xf3d00000-0xf3d0006b. First byte 0x1 instead of 0x6b

Note that the number of overwritten bytes is exactly 0x6b. This sounds
VERY much like a use-after-free, e.g. maybe something loaded 0x6b into
the "size" parameter for memcpy().

> INFO: Allocated in copy_process+0x68/0x1130 age=4 cpu=0 pid=4338
> INFO: Freed in free_task+0x2c/0x30 age=2 cpu=0 pid=4

Pid 4 seems to always be ksoftirqd/0 on this machine.

> INFO: Slab 0xc1c25c00 objects=8 used=3 fp=0xf3d00000 flags=0x400020c3
> INFO: Object 0xf3d00000 @offset=0 fp=0xf3d03fc0
>  Object 0xf3d00000:  01 40 66 00 00 16 ec ee ad b9 00 1c 26 8a 70 f8
> .@f...<EC><U+EB79>..&.p<F8>

That's the "magic number": 0x00664001.

Why would this always get written in this position of the task struct?

>  Object 0xf3d00010:  08 00 45 00 00 54 00 00 40 00 40 01 b7 e8 c0 a8
> ..E..T..@.@.<B7><E8><C0><A8>
>  Object 0xf3d00020:  00 c4 c0 a8 00 ac 08 00 6e c0 df 24 55 33 75 af
> .<C4><C0><A8>.<AC>..n<C0><DF>$U3u<AF>
>  Object 0xf3d00030:  87 48 69 ec 03 00 08 09 0a 0b 0c 0d 0e 0f 10 11
> .Hi<EC>............
>  Object 0xf3d00040:  12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21
> ...............!
>  Object 0xf3d00050:  22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31
> "#$%&'()*+,-./01
>  Object 0xf3d00060:  32 33 34 35 36 37 89 e0 c8 4a fb e0 6b 6b 6b 6b
> 234567.<E0><C8>J<FB><E0>kkkk

Why is it writing the sequence of numbers from 0x08 to 0x37 here?

Also, the last line disassembles to this:

   0:   89 e0                   mov    %esp,%eax
   2:   c8 4a 4b e0             enterq $0x4b4a,$0xe0


...Additional clues may be found... maybe :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

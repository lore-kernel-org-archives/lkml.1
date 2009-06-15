Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbZFOEZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbZFOEZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 00:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZFOEZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 00:25:09 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:32784 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZFOEZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 00:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wHocU8LD+AS19C0B9Jr6Yw38D8jeQrw4QO796XHU4aULcDWqPhEbgLxyUAy3hXUM6U
         BcHA//gYatqMMwChmZuh0khTbfqIytYUkkiQt24NGHaF/rKAKiNdLdkb7Jnf0pTpXeHD
         Zira5qm1O+GPFe2VPf3ADHHHVai+KeMxPdOA8=
MIME-Version: 1.0
In-Reply-To: <19f34abd0906141603o2edadf22h2d61408b9abdb7a3@mail.gmail.com>
References: <20090614081052.GA9276@elte.hu> <4A34B2E2.7080702@cs.helsinki.fi>
	 <84144f020906140130w189239c0l56dccad99529aa7@mail.gmail.com>
	 <84144f020906140132s56b5616flf61040553d88c05b@mail.gmail.com>
	 <19f34abd0906141603o2edadf22h2d61408b9abdb7a3@mail.gmail.com>
Date: Mon, 15 Jun 2009 07:25:08 +0300
X-Google-Sender-Auth: a08a53232356822c
Message-ID: <84144f020906142125x206ec93cj2af7cbfebf0ab3b5@mail.gmail.com>
Subject: Re: tty_ldisc_try_get(): BUG kmalloc-8: Poison overwritten
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 2:03 AM, Vegard Nossum<vegard.nossum@gmail.com> wrote:
> 2009/6/14 Pekka Enberg <penberg@cs.helsinki.fi>:
>> On Sun, Jun 14, 2009 at 11:20 AM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
>>>> You could add something like
>>>>
>>>>  WARN_ON(ld->refcount == 0x6b)
>>>>
>>>> to tty_ldisc_deref() to see if that triggers.
>>
>> On Sun, Jun 14, 2009 at 11:30 AM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
>>> Make that
>>>
>>>    WARN_ON(ld->refcount == (int)0xa56b6b6b)
>>>
>>> instead.
>>
>> And oh, kmemcheck should be able to catch this too. :-)
>>
>
> I was able to get this trace:
>
> (none) login: [  867.947401] WARNING: kmemcheck: Caught 32-bit read
> from freed memory (469e2f44)
> [  867.962162] 00000000020000000038bf41020000000038bf41020000000038bf4102000000
> [  868.012078]  i i i i f f f f i i i i i i i i i i i i i i i i i i i i i i i i
> [  868.061629]          ^
> [  868.067686]
> [  868.071709] Pid: 1857, comm: getty Not tainted (2.6.30 #416)
> [  868.082651] EIP: 0060:[<414772ea>] EFLAGS: 00000002 CPU: 0
> [  868.095379] EIP is at tty_ldisc_deref+0x1a/0x70
> [  868.103757] EAX: 00000216 EBX: 469e2f40 ECX: 414772e8 EDX: 41bf3870
> [  868.115752] ESI: 00000216 EDI: 4766483c EBP: 46f37f3c ESP: 41e22450
> [  868.131343]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [  868.141609] CR0: 8005003b CR2: 47806e04 CR3: 06b6b000 CR4: 00000690
> [  868.155263] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  868.167168] DR6: 00004000 DR7: 00000000
> [  868.175228]  [<4146f26d>] tty_read+0x8d/0xc0
> [  868.184598]  [<410ca219>] vfs_read+0x99/0x180
> [  868.196380]  [<410ca3bd>] sys_read+0x3d/0x70
> [  868.206936]  [<41003a6f>] sysenter_do_call+0x12/0x3c
> [  868.219746]  [<ffffffff>] 0xffffffff
>
> Thats:
>
> drivers/char/tty_ldisc.c:366
> drivers/char/tty_io.c:896
>
> I also saw this a couple of times (it's not my printk):
>
> [ 1266.934668] tty_ldisc_deref: no references.
> [ 1267.531655] tty_ldisc_deref: no references.
> [ 1267.790096] tty_ldisc_deref: no references.

Yup, that's the tty layer complaining that we're trying to
tty_ldisc_deref() but reference count is zero. Ingo doesn't see this
because of slab poisoning which is why kmemcheck is able to produce a
nicer stack trace in this case.

                                      Pekka

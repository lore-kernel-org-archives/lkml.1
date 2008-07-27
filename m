Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYG0KIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYG0KIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 06:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYG0KH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 06:07:56 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:61580 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYG0KHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 06:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RUbQ3g5aBXVpOrY7eF5S3MTOzZ31cijdN6lL41vFwDmXfZ2e7tfcKEKuS5gi0BLo08
         QuAGbqNUFlPupwkpsZkrIwZyMagW8cipxLL2+2m8Ro0giJy6L2KcmwZlX3oVPqxlksF3
         tpShkGnefDmWmcyk6uW+oWQU82X60kwdPTvuo=
Message-ID: <19f34abd0807270307p505568b8nf871162d89b002ef@mail.gmail.com>
Date: Sun, 27 Jul 2008 12:07:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: -git: BUG: unable to handle kernel paging request at c0100248 [CPU hotplug]
Cc: "Thomas Meyer" <thomas@m3y3r.de>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Glauber Costa" <gcosta@redhat.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <19f34abd0807270255o1ff260a8ucb9d931905aa4947@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807270255o1ff260a8ucb9d931905aa4947@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 11:55 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Hi,
>
> Something broke CPU-hotplug _again_, here with a freshly built latest -git:
>
> BUG: unable to handle kernel paging request at c0100248

[snip]

> c067c3db:       c7 05 48 02 10 c0 f0    movl   $0xc067c9f0,0xc0100248
> c067c3e2:       c9 67 c0
>
> $ addr2line -e vmlinux -i c067c3db
> arch/x86/kernel/smpboot.c:859
> arch/x86/kernel/smpboot.c:993
>
> Hm... that doesn't really make sense, does it? It's this line:
>
>        initial_code = (unsigned long)start_secondary;
>
> ..but I don't see where the memory dereference comes from.

"initial_code" (0xc0100248) is in a .text section:

Idx Name          Size      VMA       LMA       File off  Algn
  0 .text.head    000003a1  c0100000  00100000  00001000  2**2
  1 .text         00583b8d  c01003b0  001003b0  000013b0  2**4

And I have CONFIG_DEBUG_RODATA=y. Maybe this was introduced in

commit e3f77edfc1d0beb7b10f9f31d9e39206f7dbef7b
Author: Glauber Costa <gcosta@redhat.com>
Date:   Wed May 28 12:57:02 2008 -0300

    x86: use initial_code for i386

    x86_64 jumps to whatever is written in "initial_code" symbol,
    instead of a fixed address. Do it for i386 too. It will allow us
    to integrate more of the smp boot code.

    Signed-off-by: Glauber Costa <gcosta@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYH3UNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYH3UNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYH3UNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:13:25 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:3300 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYH3UNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fYuUGLGolWMtZBAIcHSfLiywJs2yTL8Q4LdNZSkl5hQ6QgnA5fiYWgeJApy8sX4837
         7Fz/BS8wT5mGgGxaKjnWH3oy1dlX1+vGG9c9hsk0hmuvyzAklF9D8sVIcvL0LkEEyxd1
         SEmXsE0Jn/+/1ooOIpgPyRyF55jglMDRwwsQc=
Message-ID: <19f34abd0808301313v640a47fbl7bc61fd35e7cf4d5@mail.gmail.com>
Date: Sat, 30 Aug 2008 22:13:23 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Cc: "Tom Tucker" <tom@opengridcomputing.com>, "Neil Brown" <neilb@suse.de>,
       "Chuck Lever" <chuck.lever@oracle.com>, "Greg Banks" <gnb@sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080830200423.GI7611@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080830184422.GA9598@localhost.localdomain>
	 <20080830190642.GC7611@lenovo>
	 <19f34abd0808301242j63d357f5h7afd3eff796a4cf0@mail.gmail.com>
	 <20080830195622.GH7611@lenovo>
	 <19f34abd0808301259s385844efx13cd5b02d083da77@mail.gmail.com>
	 <20080830200423.GI7611@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 10:04 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Vegard Nossum - Sat, Aug 30, 2008 at 09:59:38PM +0200]
> | On Sat, Aug 30, 2008 at 9:56 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> | > | BTW, look at this:
> | > |
> | > |     $ od -A x -t x1z /proc/sys/sunrpc/transports
> | > |     000000 74 63 70 20 31 30 34 38 35 37 36 0a 75 64 70 20  >tcp 1048576.udp <
> | > |     000010 33 32 37 36 38 0a 00 00 00 00 00 00 00 00 00 00  >32768...........<
> | > |     000020 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  >................<
> | > |     *
> | > |     0003e0 00 00 00 00 00 00 00 00 00 00                    >..........<
> | > |     0003ea
> | > |
> | > | ...and:
> | > |
> | > |     $ strace -e trace=read cat /proc/sys/sunrpc/transports > /dev/null
> | > |     read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@G\316E4\0\0\0"...,
> | > | 512) = 512
> | > |     read(3, "tcp 1048576\nudp 32768\n\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4074
> | > |     read(3, "", 4096)                       = 0
> | > |
> | > | ...why does it have a huge return value? The output is only about 40
> | > | bytes... why add all the \0? Would your patch also fix this?
> | >
> | > I think it's from strace side - it pass 4096 zero'ed buffer.
> |
> | "cat" passed buffer of size 4096, yes. But read() still returned 4074.
> | It should have returned 38 or so.
> |
> | > At least I don't see additional issues from kernel side in buffer
> | > filling - except from svc_print_xprts() which walk over list.
> | > But I think sunpc guys should know details :)
> | > Will send short-fix patch soon :)
> |
> | It looks like it's returning (sizeof(buffer) - x) where it really
> | should be returning x. Maybe it's this one that should be different?
> |
> |         *lenp -= len;
> |
>
> yes, but this is just a side effect, if we fix main error - it should
> resolve this problem too. Did you try the fix I sent a few msgs ago?
> (I don't have sunrpc on my machine)

Sorry, I did it now :-)

    $ uname -a
    Linux grianne 2.6.27-rc5-00006-gbef69ea-dirty #4 SMP PREEMPT Sat
Aug 30 22:07:18 CEST 2008 i686 i686 i386 GNU/Linux

    $ strace -e trace=read cat /proc/sys/sunrpc/transports > /dev/null
    read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320
\265\0004\0\0\0"..., 512) = 512
    read(3, "tcp 1048576\nudp 32768\n\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4074
    read(3, "", 4096)                       = 0

So that problem seems to remain.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

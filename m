Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYH3Tmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYH3Tmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYH3Tmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:42:33 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:8852 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYH3Tmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:42:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gyLT8AG39By1tMy7D0ZqOfJpGG7EAa5KCfcXypwy9Y4bSUR6XoVl7I3xxFO00WdFqp
         4K0gaic3ssTY1MEGDGgA9KTToIQM6N45YdwTQ9oayqIRWULFhgh8f9/FV+WCmNMAnrHV
         erQZ8bdo2zebwZq2d7D7eA1XUvjqTYMsj4TvU=
Message-ID: <19f34abd0808301242j63d357f5h7afd3eff796a4cf0@mail.gmail.com>
Date: Sat, 30 Aug 2008 21:42:30 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Cc: "Tom Tucker" <tom@opengridcomputing.com>, "Neil Brown" <neilb@suse.de>,
       "Chuck Lever" <chuck.lever@oracle.com>, "Greg Banks" <gnb@sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080830190642.GC7611@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080830184422.GA9598@localhost.localdomain>
	 <20080830190642.GC7611@lenovo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 9:06 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> [Vegard Nossum - Sat, Aug 30, 2008 at 08:44:22PM +0200]
> | Hi,
> |
> | I noticed that something weird is going on with /proc/sys/sunrpc/transports.
> | This file is generated in net/sunrpc/sysctl.c, function proc_do_xprt(). When
> | I "cat" this file, I get the expected output:
> |
> |     $ cat /proc/sys/sunrpc/transports
> |     tcp 1048576
> |     udp 32768
> |
> | But I think that it does not check the length of the buffer supplied by
> | userspace to read(). With my original program, I found that the stack was
> | being overwritten by the characters above, even when the length given to
> | read() was just 1. So I have created a test program, see it at the bottom of
> | this e-mail. Here is its output:
> |
> ...
>
> Indeed, maybe just add checking for user buffer length?
> As proc_dodebug() in this file are doing. I don't think
> the user would be happy with his stack burned :)
>
> Something like:
> ---
>
> Index: linux-2.6.git/net/sunrpc/sysctl.c
> ===================================================================
> --- linux-2.6.git.orig/net/sunrpc/sysctl.c      2008-07-20 11:40:14.000000000 +0400
> +++ linux-2.6.git/net/sunrpc/sysctl.c   2008-08-30 23:05:30.000000000 +0400
> @@ -69,6 +69,8 @@ static int proc_do_xprt(ctl_table *table
>                return -EINVAL;
>        else {
>                len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
> +               if (*lenp < len)
> +                       return -EFAULT;
>                if (!access_ok(VERIFY_WRITE, buffer, len))
>                        return -EFAULT;
>
>

BTW, look at this:

    $ od -A x -t x1z /proc/sys/sunrpc/transports
    000000 74 63 70 20 31 30 34 38 35 37 36 0a 75 64 70 20  >tcp 1048576.udp <
    000010 33 32 37 36 38 0a 00 00 00 00 00 00 00 00 00 00  >32768...........<
    000020 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  >................<
    *
    0003e0 00 00 00 00 00 00 00 00 00 00                    >..........<
    0003ea

...and:

    $ strace -e trace=read cat /proc/sys/sunrpc/transports > /dev/null
    read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@G\316E4\0\0\0"...,
512) = 512
    read(3, "tcp 1048576\nudp 32768\n\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4074
    read(3, "", 4096)                       = 0

...why does it have a huge return value? The output is only about 40
bytes... why add all the \0? Would your patch also fix this?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

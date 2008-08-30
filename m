Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYH3TqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYH3TqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYH3TqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:46:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:42797 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYH3TqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uVBQVh8xzkF9i/h62E84kMg3J3gajTdLGjFwGZt5379YyjNVebchLH9/Kj1bqLLo1k
         hJrJR9f4GNRsD2qecEqh30PWTShZ4ja3jwsPEaZ6R0gQJhBX/0uW56vxQX8vwA1+ef94
         V0VlAHD5e0tH1MiVaEgPf8uf2kSFvy8242LRg=
Date: Sat, 30 Aug 2008 23:45:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Tom Tucker <tom@opengridcomputing.com>, Neil Brown <neilb@suse.de>,
       Chuck Lever <chuck.lever@oracle.com>, Greg Banks <gnb@sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Message-ID: <20080830194555.GG7611@lenovo>
References: <20080830184422.GA9598@localhost.localdomain> <20080830190642.GC7611@lenovo> <19f34abd0808301242j63d357f5h7afd3eff796a4cf0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808301242j63d357f5h7afd3eff796a4cf0@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Sat, Aug 30, 2008 at 09:42:30PM +0200]
| On Sat, Aug 30, 2008 at 9:06 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > [Vegard Nossum - Sat, Aug 30, 2008 at 08:44:22PM +0200]
| > | Hi,
| > |
| > | I noticed that something weird is going on with /proc/sys/sunrpc/transports.
| > | This file is generated in net/sunrpc/sysctl.c, function proc_do_xprt(). When
| > | I "cat" this file, I get the expected output:
| > |
| > |     $ cat /proc/sys/sunrpc/transports
| > |     tcp 1048576
| > |     udp 32768
| > |
| > | But I think that it does not check the length of the buffer supplied by
| > | userspace to read(). With my original program, I found that the stack was
| > | being overwritten by the characters above, even when the length given to
| > | read() was just 1. So I have created a test program, see it at the bottom of
| > | this e-mail. Here is its output:
| > |
| > ...
| >
| > Indeed, maybe just add checking for user buffer length?
| > As proc_dodebug() in this file are doing. I don't think
| > the user would be happy with his stack burned :)
| >
| > Something like:
| > ---
| >
| > Index: linux-2.6.git/net/sunrpc/sysctl.c
| > ===================================================================
| > --- linux-2.6.git.orig/net/sunrpc/sysctl.c      2008-07-20 11:40:14.000000000 +0400
| > +++ linux-2.6.git/net/sunrpc/sysctl.c   2008-08-30 23:05:30.000000000 +0400
| > @@ -69,6 +69,8 @@ static int proc_do_xprt(ctl_table *table
| >                return -EINVAL;
| >        else {
| >                len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
| > +               if (*lenp < len)
| > +                       return -EFAULT;
| >                if (!access_ok(VERIFY_WRITE, buffer, len))
| >                        return -EFAULT;
| >
| >
| 
| BTW, look at this:
| 
|     $ od -A x -t x1z /proc/sys/sunrpc/transports
|     000000 74 63 70 20 31 30 34 38 35 37 36 0a 75 64 70 20  >tcp 1048576.udp <
|     000010 33 32 37 36 38 0a 00 00 00 00 00 00 00 00 00 00  >32768...........<
|     000020 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  >................<
|     *
|     0003e0 00 00 00 00 00 00 00 00 00 00                    >..........<
|     0003ea
| 
| ...and:
| 
|     $ strace -e trace=read cat /proc/sys/sunrpc/transports > /dev/null
|     read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@G\316E4\0\0\0"...,
| 512) = 512
|     read(3, "tcp 1048576\nudp 32768\n\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4074
|     read(3, "", 4096)                       = 0
| 
| ...why does it have a huge return value? The output is only about 40
| bytes... why add all the \0? Would your patch also fix this?
| 
| 
| Vegard

Get me some time to check

| 
| -- 
| "The animistic metaphor of the bug that maliciously sneaked in while
| the programmer was not looking is intellectually dishonest as it
| disguises that the error is the programmer's own creation."
| 	-- E. W. Dijkstra, EWD1036
| 
		- Cyrill -

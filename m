Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYH3U3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYH3U3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYH3U3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:29:31 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:13000 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbYH3U3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hmkio7BoFdwbQ2mkZpepgRxPTzzIWFJBz9CVEWXkFY/eXRfUyDweT5Ruc0JQfC37vj
         2lNpUAdQRlEwMUzHdJ5CEzvvoKvjezDhs9Sc8bX7HMDxF+OAh8neioi3ry6B8PhVGFbQ
         MEurQXmUCuRnFwNWyTsrm+9BLbWpqeEsPbZmQ=
Date: Sun, 31 Aug 2008 00:29:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Tom Tucker <tom@opengridcomputing.com>, Neil Brown <neilb@suse.de>,
       Chuck Lever <chuck.lever@oracle.com>, Greg Banks <gnb@sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Message-ID: <20080830202928.GB3659@lenovo>
References: <20080830184422.GA9598@localhost.localdomain> <20080830190642.GC7611@lenovo> <19f34abd0808301242j63d357f5h7afd3eff796a4cf0@mail.gmail.com> <20080830195622.GH7611@lenovo> <19f34abd0808301259s385844efx13cd5b02d083da77@mail.gmail.com> <20080830200423.GI7611@lenovo> <19f34abd0808301313v640a47fbl7bc61fd35e7cf4d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808301313v640a47fbl7bc61fd35e7cf4d5@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Sat, Aug 30, 2008 at 10:13:23PM +0200]
| On Sat, Aug 30, 2008 at 10:04 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > [Vegard Nossum - Sat, Aug 30, 2008 at 09:59:38PM +0200]
| > | On Sat, Aug 30, 2008 at 9:56 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | > | BTW, look at this:
| > | > |
| > | > |     $ od -A x -t x1z /proc/sys/sunrpc/transports
| > | > |     000000 74 63 70 20 31 30 34 38 35 37 36 0a 75 64 70 20  >tcp 1048576.udp <
| > | > |     000010 33 32 37 36 38 0a 00 00 00 00 00 00 00 00 00 00  >32768...........<
| > | > |     000020 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  >................<
| > | > |     *
| > | > |     0003e0 00 00 00 00 00 00 00 00 00 00                    >..........<
| > | > |     0003ea
| > | > |
| > | > | ...and:
| > | > |
| > | > |     $ strace -e trace=read cat /proc/sys/sunrpc/transports > /dev/null
| > | > |     read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@G\316E4\0\0\0"...,
| > | > | 512) = 512
| > | > |     read(3, "tcp 1048576\nudp 32768\n\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4074
| > | > |     read(3, "", 4096)                       = 0
| > | > |
| > | > | ...why does it have a huge return value? The output is only about 40
| > | > | bytes... why add all the \0? Would your patch also fix this?
| > | >
| > | > I think it's from strace side - it pass 4096 zero'ed buffer.
| > |
| > | "cat" passed buffer of size 4096, yes. But read() still returned 4074.
| > | It should have returned 38 or so.
| > |
| > | > At least I don't see additional issues from kernel side in buffer
| > | > filling - except from svc_print_xprts() which walk over list.
| > | > But I think sunpc guys should know details :)
| > | > Will send short-fix patch soon :)
| > |
| > | It looks like it's returning (sizeof(buffer) - x) where it really
| > | should be returning x. Maybe it's this one that should be different?
| > |
| > |         *lenp -= len;
| > |
| >
| > yes, but this is just a side effect, if we fix main error - it should
| > resolve this problem too. Did you try the fix I sent a few msgs ago?
| > (I don't have sunrpc on my machine)
| 
| Sorry, I did it now :-)
| 
|     $ uname -a
|     Linux grianne 2.6.27-rc5-00006-gbef69ea-dirty #4 SMP PREEMPT Sat
| Aug 30 22:07:18 CEST 2008 i686 i686 i386 GNU/Linux
| 
|     $ strace -e trace=read cat /proc/sys/sunrpc/transports > /dev/null
|     read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\320
| \265\0004\0\0\0"..., 512) = 512
|     read(3, "tcp 1048576\nudp 32768\n\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4074
|     read(3, "", 4096)                       = 0
| 
| So that problem seems to remain.
| 
| 
| Vegard

Vegard, are you sure you test it with this patch (a bit updated)?

| 
| -- 
| "The animistic metaphor of the bug that maliciously sneaked in while
| the programmer was not looking is intellectually dishonest as it
| disguises that the error is the programmer's own creation."
| 	-- E. W. Dijkstra, EWD1036
| 
		- Cyrill -
---

Index: linux-2.6.git/net/sunrpc/sysctl.c
===================================================================
--- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-07-20 11:40:14.000000000 +0400
+++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-31 00:19:42.000000000 +0400
@@ -69,9 +69,10 @@ static int proc_do_xprt(ctl_table *table
 		return -EINVAL;
 	else {
 		len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
+		if (*lenp < len)
+			len = *lenp;
 		if (!access_ok(VERIFY_WRITE, buffer, len))
 			return -EFAULT;
-
 		if (__copy_to_user(buffer, tmpbuf, len))
 			return -EFAULT;
 	}

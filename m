Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYH3TP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYH3TP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYH3TPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:15:19 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:63561 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYH3TPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=m9PuUQCez8fCjN8P2lTXe93jGlGbXLeDtEhAZ6Aeu9hNYQ8YJJJh3chhvb3GpUurAt
         L6glVcmMalHdQYSC8Kpt9peO8kaQxQXT9XcDWXkNW6LdPcRIqfazOJEquApp815DKTfP
         T9LVN0zr18zZaay+7/rVmuDyTIc5I/Pltgg4Q=
Message-ID: <19f34abd0808301215i445e8411q987c864c0b478d30@mail.gmail.com>
Date: Sat, 30 Aug 2008 21:15:16 +0200
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

Hm. I think this is wrong. Shouldn't we copy as many bytes as the user
indicated?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

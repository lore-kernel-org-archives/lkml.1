Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYH3TVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYH3TVY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYH3TVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:21:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:34923 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYH3TVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nNW9FZld6EwfhGdXv/IRn9EPH3rK30JcVGdo29NGqSlrF4I48znz4q/g85MQSf03CO
         yUuIlQlCp9LoPvZXjarCdQlzkiwVpJ7et5/ri+gHW3ZSsniHin1/QqpP6704YorwYR7O
         3oPK/YiPtT8+JdIXfo4IP4azNWthqzZhYubV0=
Date: Sat, 30 Aug 2008 23:21:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Tom Tucker <tom@opengridcomputing.com>, Neil Brown <neilb@suse.de>,
       Chuck Lever <chuck.lever@oracle.com>, Greg Banks <gnb@sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Message-ID: <20080830192112.GD7611@lenovo>
References: <20080830184422.GA9598@localhost.localdomain> <20080830190642.GC7611@lenovo> <19f34abd0808301215i445e8411q987c864c0b478d30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808301215i445e8411q987c864c0b478d30@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Sat, Aug 30, 2008 at 09:15:16PM +0200]
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
| 
| Hm. I think this is wrong. Shouldn't we copy as many bytes as the user
| indicated?

Well, hard to say what user-space programmer is expecting from us.
I mean - maybe he (reader) wants only part of results not the whole
contents BUT by this way he never know what the whole conetnts would be
until trying to read more (ie to check if there no more data from
kernel side). What is preferred behaviour - i don't know :)

| 
| 
| Vegard
| 
| -- 
| "The animistic metaphor of the bug that maliciously sneaked in while
| the programmer was not looking is intellectually dishonest as it
| disguises that the error is the programmer's own creation."
| 	-- E. W. Dijkstra, EWD1036
| 

		- Cyrill -

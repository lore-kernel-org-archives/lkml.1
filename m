Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYH3Toc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYH3Toc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYH3ToX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:44:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:43820 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYH3ToW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cg4F5T/DyFSFG+87fQ2u96ZYcFWd+uy0/ZEXho8bxzwwQH4zDOR+lW3ri8Pi5vmYPO
         Tcb96QYgI1FXsmkFPd/+O08gKLRx2bU85sN4xEFgz7YGoz6CvCbinmB7fYwExLd7fYb8
         D301x89o3OGOI8gBp7atfXXBpptBDojmaFAig=
Date: Sat, 30 Aug 2008 23:44:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Tom Tucker <tom@opengridcomputing.com>, Neil Brown <neilb@suse.de>,
       Chuck Lever <chuck.lever@oracle.com>, Greg Banks <gnb@sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Message-ID: <20080830194420.GF7611@lenovo>
References: <20080830184422.GA9598@localhost.localdomain> <20080830190642.GC7611@lenovo> <19f34abd0808301215i445e8411q987c864c0b478d30@mail.gmail.com> <20080830192112.GD7611@lenovo> <19f34abd0808301234k3fae5572xdd8835827201f15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808301234k3fae5572xdd8835827201f15@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Sat, Aug 30, 2008 at 09:34:21PM +0200]
| On Sat, Aug 30, 2008 at 9:21 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > | Hm. I think this is wrong. Shouldn't we copy as many bytes as the user
| > | indicated?
| >
| > Well, hard to say what user-space programmer is expecting from us.
| > I mean - maybe he (reader) wants only part of results not the whole
| > contents BUT by this way he never know what the whole conetnts would be
| > until trying to read more (ie to check if there no more data from
| > kernel side). What is preferred behaviour - i don't know :)
| 
| For any other file, read(1) + read(1) should be exactly equivalent to
| a read(2). What's the difference here?

Convinced completely :) Moreover proc_dodebug() does exactly
the same as you talking about.

| 
| (Btw, thanks for the quick reply :-))

with my pleasure :)

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
---

Index: linux-2.6.git/net/sunrpc/sysctl.c
===================================================================
--- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-07-20 11:40:14.000000000 +0400
+++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-30 23:43:14.000000000 +0400
@@ -71,7 +71,8 @@ static int proc_do_xprt(ctl_table *table
 		len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
 		if (!access_ok(VERIFY_WRITE, buffer, len))
 			return -EFAULT;
-
+		if (*lenp < len)
+			len = *lenp;
 		if (__copy_to_user(buffer, tmpbuf, len))
 			return -EFAULT;
 	}

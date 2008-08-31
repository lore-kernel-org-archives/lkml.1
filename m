Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbYHaKaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbYHaKaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbYHaKab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:30:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:52010 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbYHaKaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OBwIrHYT+fl8JBD0xRCZIShXXLD9wRh+Cst5/1RNyoYBNs0vYsMhPAvtHDtLPnQogu
         dWDfYUOu/n+Ikl9JhL6zdKJfXxtewQpXTL+4MwBgAG86rH6AEoSOq576MIhI0/Nk0T2D
         bjz0mHZWc0egM3i9F4kLdRnbU+9AvHWZkqfAE=
Date: Sun, 31 Aug 2008 14:30:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Wagner <daw-news@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Message-ID: <20080831103026.GF7391@lenovo>
References: <20080830184422.GA9598@localhost.localdomain> <20080830190642.GC7611@lenovo> <g9cj5n$tjv$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g9cj5n$tjv$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Wagner - Sat, Aug 30, 2008 at 10:55:51PM +0000]
| Cyrill Gorcunov  wrote:
| >Index: linux-2.6.git/net/sunrpc/sysctl.c
| >===================================================================
| >--- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-07-20 11:40:14.000000000 +0400
| >+++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-30 23:05:30.000000000 +0400
| >@@ -69,6 +69,8 @@ static int proc_do_xprt(ctl_table *table
| > 		return -EINVAL;
| > 	else {
| > 		len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
| >+		if (*lenp < len)
| >+			return -EFAULT;
| > 		if (!access_ok(VERIFY_WRITE, buffer, len))
| > 			return -EFAULT;
| 
| 1. Would it be better to use copy_to_user() rather than
| access_ok() followed immediately by __copy_to_user()?

Yes, thanks

| 
| 2. Is it OK to dereference *lenp directly?  Is lenp a pointer into user
| memory or kernel memory?  If it points to user memory, why is it safe to
| dereference it directly?  (What about TOCTTOU bugs?)  Should there be
| some sparse annotations here to ensure the code is not dereferencing
| user pointers directly?  Later on, proc_do_xprt() also dereferences
| *lenp and *ppos directly.

Not only proc_do_xprt do that so I think it's safe (check for NULL
on highr level I suspect).

| 
| 3. 'len' is declared as a signed int.  len will be converted to size_t
| before doing the comparison, so if len can ever be negative (e.g.,
| svc_print_xprts() returns -1 because of an error), this patch will do
| the wrong thing.  Looks like the current definition of svc_print_xprts()
| won't ever do that, as that code currently stands, so at present this
| is not a bug.  However from a security point of view there are benefits
| to code whose correctness is 'locally obvious', all else being equal.
| In particular this seems like a possible maintenance hazard.  Would it be
| better to use type size_t for lengths like this that are never supposed
| to be negative?

thanks, I changed it to size_t and as you mentoined negative is never coming
from called svc_print_xprts.

| 
| 4. Is proc_dostring() relevant here?

it's not possible to use for now this function (one of my patches
was quite wrong by using it :)

		- Cyrill -

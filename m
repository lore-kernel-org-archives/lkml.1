Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYH3W4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYH3W4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 18:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYH3Wzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 18:55:53 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:33149 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbYH3Wzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 18:55:53 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Date: Sat, 30 Aug 2008 22:55:51 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <g9cj5n$tjv$1@taverner.cs.berkeley.edu>
References: <20080830184422.GA9598@localhost.localdomain> <20080830190642.GC7611@lenovo>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1220136951 30335 128.32.168.222 (30 Aug 2008 22:55:51 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sat, 30 Aug 2008 22:55:51 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov  wrote:
>Index: linux-2.6.git/net/sunrpc/sysctl.c
>===================================================================
>--- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-07-20 11:40:14.000000000 +0400
>+++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-30 23:05:30.000000000 +0400
>@@ -69,6 +69,8 @@ static int proc_do_xprt(ctl_table *table
> 		return -EINVAL;
> 	else {
> 		len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
>+		if (*lenp < len)
>+			return -EFAULT;
> 		if (!access_ok(VERIFY_WRITE, buffer, len))
> 			return -EFAULT;

1. Would it be better to use copy_to_user() rather than
access_ok() followed immediately by __copy_to_user()?

2. Is it OK to dereference *lenp directly?  Is lenp a pointer into user
memory or kernel memory?  If it points to user memory, why is it safe to
dereference it directly?  (What about TOCTTOU bugs?)  Should there be
some sparse annotations here to ensure the code is not dereferencing
user pointers directly?  Later on, proc_do_xprt() also dereferences
*lenp and *ppos directly.

3. 'len' is declared as a signed int.  len will be converted to size_t
before doing the comparison, so if len can ever be negative (e.g.,
svc_print_xprts() returns -1 because of an error), this patch will do
the wrong thing.  Looks like the current definition of svc_print_xprts()
won't ever do that, as that code currently stands, so at present this
is not a bug.  However from a security point of view there are benefits
to code whose correctness is 'locally obvious', all else being equal.
In particular this seems like a possible maintenance hazard.  Would it be
better to use type size_t for lengths like this that are never supposed
to be negative?

4. Is proc_dostring() relevant here?

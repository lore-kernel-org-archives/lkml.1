Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbYHaIiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbYHaIiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 04:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYHaIiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 04:38:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:19079 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYHaIh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 04:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f6g1WOSSieVQn8nlZwAChteZ1sZsVYsNYYsXOjXfNXlwWBCgpML3PD5edFytaxRnLm
         1lTwUmy5tAsSMZSGVIZkGxlqsAXqXnexzNz+DFr/p9YYmksU1/PgCyzltf5kUZgiQsyy
         nBwu0Y16DJBVSr8PbBmra/o4O3CNSnw6BDkGQ=
Date: Sun, 31 Aug 2008 12:37:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Wagner <daw-news@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Message-ID: <20080831083753.GA7391@lenovo>
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
| 
| 2. Is it OK to dereference *lenp directly?  Is lenp a pointer into user
| memory or kernel memory?  If it points to user memory, why is it safe to
| dereference it directly?  (What about TOCTTOU bugs?)  Should there be
| some sparse annotations here to ensure the code is not dereferencing
| user pointers directly?  Later on, proc_do_xprt() also dereferences
| *lenp and *ppos directly.

Didn't check for this - will do.

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
| 
| 4. Is proc_dostring() relevant here?
| 

Yes David, I think proc_dostring is better candidate to use here, thanks!

		- Cyrill -

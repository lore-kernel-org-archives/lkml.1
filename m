Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZIOJxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZIOJxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZIOJw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:52:56 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:30569 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbZIOJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:52:55 -0400
X-Trace: 258171297/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.90.143/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.90.143
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAGMAr0pPRVqP/2dsb2JhbACBU9pEhBcFgVY
X-IronPort-AV: E=Sophos;i="4.44,388,1249254000"; 
   d="scan'208";a="258171297"
Date: Tue, 15 Sep 2009 10:52:08 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Wu Fengguang <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       "mtosatti@redhat.com" <mtosatti@redhat.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       "avi@qumranet.com" <avi@qumranet.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Question: how to handle too big f_pos Re: [PATCH] devmem: handle
 partial kmem write/read
In-Reply-To: <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0909151031130.22062@sister.anvils>
References: <20090914032901.GA16189@localhost> <20090915165852.032d164f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, KAMEZAWA Hiroyuki wrote:

> I'm writing a patch against /dev/kmem...I found a problem.
> 
> /dev/kmem (and /proc/<pid>/mem) puts virtual addres to f->f_pos.
> 
> And, f->f_pos is loff_t .... signed value (not unsigned)
> 
> Then, this check
> rw_verify_area(READ, file, pos, count);
> =>
>         pos = *ppos;
>         if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
>                 return retval;
> 	
> always returns -EINVAL when I read /dev/kmem's valid address.
> 
> Then, how should I do for read /dev/kmem ? Any idea ?
> (Added Al Viro to CC:)

I believe what's supposed to happen is that special drivers like
/dev/mem and /dev/kmem provide their own .llseek method (they do).
But at some point along the way rw_verify_area() got "improved"
and now prevents them working on many configurations.

I noticed around 2.6.24-rc1, and have been building my debug kernels
with the patch below ever since then, as I sometimes like to peek and
poke into /dev/kmem to examine and try different things while running.

But whether it's the right patch is another matter.  Though this should
be independent of that, I've also got a patch at the drivers/char/mem.c
end (I'll post that shortly in the main thread, not appropriate here),
and have never found time to consider whether these hacks amount to
anything more than "works for me".

IIRC, this patch below only covers one aspect of the negative offset
problem.  Where the problems lie does change from time to time - back
in 2003 I used to use pread() and pwrite() to avoid llseek() issues;
but when I came back to it in 2007, I think I found those no longer
worked (on i386 or x86_64 or powerpc?), and lseek64() was the best bet.

Anyway, for what it's worth, ...

--- 2.6.31/fs/read_write.c	2009-09-09 23:13:59.000000000 +0100
+++ 2.6.31d/fs/read_write.c	2009-09-10 09:38:30.000000000 +0100
@@ -222,8 +222,13 @@ int rw_verify_area(int read_write, struc
 	if (unlikely((ssize_t) count < 0))
 		return retval;
 	pos = *ppos;
-	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
-		return retval;
+	if (pos >= 0) {
+		if (unlikely((loff_t) (pos + count) < 0))
+			count = 1 + (size_t) LLONG_MAX - pos;
+	} else {
+		if (unlikely((loff_t) (pos + count) > 0))
+			count = - pos;
+	}
 
 	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
 		retval = locks_mandatory_area(

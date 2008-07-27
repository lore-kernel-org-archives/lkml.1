Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYG0DZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYG0DZj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 23:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbYG0DZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 23:25:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075AbYG0DZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 23:25:31 -0400
Date: Sat, 26 Jul 2008 20:25:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 2.6.26-mmotm-0724 - linux-next.git loses /proc/sys/fs/quota,
 breaks disk quotas
Message-Id: <20080726202525.3ac3052f.akpm@linux-foundation.org>
In-Reply-To: <14615.1217125366@turing-police.cc.vt.edu>
References: <14615.1217125366@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 22:22:46 -0400 Valdis.Kletnieks@vt.edu wrote:

> I bisected the problem to somewhere in here:
> 
> repeatable-slab-corruption-with-ltp-msgctl08.patch GOOD
> #
> linux-next.patch
> linux-next-git-rejects.patch
> linux-next-fixup.patch BAD
> 
> I have no idea how to go bisecting through linux-next.patch

You need to grab the git tree and use git-bisect.  Then wade through
all the runtime and compile-time bisection breakage which people
nowadays seem to find acceptable because git collapses in an
ignominious heap when these are fixed.

> It works in 26-mmotm-0715, but is broken in -0724, so that will hopefully
> narrow the suspect commits down a *little* bit...
> 
> The problem is that the userspace does this:
> 
>         /* Detect new kernel interface; Assume generic interface unless we can p
> rove there is not one... */
>         if (!stat("/proc/sys/fs/quota", &st) || errno != ENOENT) {
>                 kernel_iface = IFACE_GENERIC;
>                 kernel_formats |= (1 << QF_VFSOLD) | (1 << QF_VFSV0);
>         }
>         else {
>                 struct v2_dqstats v2_stats;
> 
> and /proc/sys/fs/quota has mysteriously vanished in -0724. As a result,
> the userspace code goes looking for the quotav1 files and doesn't find them,
> since the actual files on disk are quotav2 (with a different name).
> 
> fs/dquot.c, which contains the code for that, appears to be identical in -0715
> and -0724, so something *else* is breaking it.
> 
> Anybody know where /proc/sys/fs/quota went?
> 

Nope.  There are pretty extensive changes to procfs core in the vfs
tree - perhaps something there made /proc/sys/fs/quota vanish.

<checks>

Yup, it happens in the most recent linux-next too.

Ah, it seems to be taking a little vacation over in
/proc/sys/kernel/.  Curious.

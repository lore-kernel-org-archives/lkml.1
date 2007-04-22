Return-Path: <linux-kernel-owner+w=401wt.eu-S1030963AbXDVUuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030963AbXDVUuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 16:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030964AbXDVUuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 16:50:17 -0400
Received: from ns2.suse.de ([195.135.220.15]:47034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030963AbXDVUuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 16:50:15 -0400
Message-ID: <462BCA74.5020109@suse.com>
Date: Sun, 22 Apr 2007 16:49:56 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.righi@cineca.it, "Vladimir V. Saveliev" <vs@namesys.com>,
       linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com,
       Edward Shishkin <edward@namesys.com>, zam@clusterfs.com, ak@suse.de
Subject: Re: [PATCH] reiserfs: fix xattr root locking/refcount bug
References: <20070413095219.02075323.akpm@linux-foundation.org>	<462536B2.5060308@users.sourceforge.net>	<c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>	<200704181816.21166.vs@namesys.com>	<46263270.9010108@suse.com>	<20070420170738.e269fcae.akpm@linux-foundation.org>	<46296CB8.3090100@suse.com>	<462A0F06.9020602@cineca.it>	<462A2055.1040509@suse.com>	<462A2107.6060902@suse.de>	<462A2D27.3060809@suse.com> <20070421123956.f74575d0.akpm@linux-foundation.org>
In-Reply-To: <20070421123956.f74575d0.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> On Sat, 21 Apr 2007 11:26:31 -0400 Jeff Mahoney <jeffm@suse.com> wrote:
> 
>>  The listxattr() and getxattr() operations are only protected by a read
>>  lock. As a result, if either of these operations run in parallel, a race
>>  condition exists where the xattr_root will end up being cached twice,
>>  which results in the leaking of a reference and a BUG() on umount.
>>
>>  This patch refactors get_xa_root(), __get_xa_root(), and
>>  create_xa_root(), into one get_xa_root() function that takes
>>  the appropriate locking around the entire critical section.
> 
> Great, thanks.
>  
> Now we need to work out the timing.  Our options are to shove
> it into 2.6.21 immediately, or to give it a run in 2.6.22-rc1 then
> backport into 2.6.21.x.
> 
> What is everyone's confidence level?

I'm pretty confident in this patch for 2.6.21, but I wouldn't object to
waiting until 2.6.22-rc1 either. Operationally, the change isn't that
big and makes the locking more clear and the code simpler. I've tested
on populated file systems, virgin file systems, and tested the error
handling path with each. There is still a bug lurking in how a failure
in ACL inheritance is cleaned up that I ran into while testing, but this
patch didn't introduce it or exacerbate it. I'll add that to my xattr
patch queue.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGK8p0LPWxlyuTD7IRAthXAJ9Hk4f40vwuir2fp2dyte5U1juzlgCeLyiW
UnrEFDbKp/iVAE+CrFVSmqs=
=6s1J
-----END PGP SIGNATURE-----

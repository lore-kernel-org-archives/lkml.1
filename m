Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXDUBpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXDUBpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 21:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXDUBpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 21:45:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:54942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbXDUBps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 21:45:48 -0400
Message-ID: <46296CB8.3090100@suse.com>
Date: Fri, 20 Apr 2007 21:45:28 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>, a.righi@cineca.it,
       linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com,
       Edward Shishkin <edward@namesys.com>, zam@clusterfs.com, ak@suse.de
Subject: Re: Fwd: Fw: [2.6.20.4] BUG: dentry xattrs still in use in shrink_dcache_for_umount()
 with reiserfs
References: <20070413095219.02075323.akpm@linux-foundation.org>	<462536B2.5060308@users.sourceforge.net>	<c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>	<200704181816.21166.vs@namesys.com>	<46263270.9010108@suse.com> <20070420170738.e269fcae.akpm@linux-foundation.org>
In-Reply-To: <20070420170738.e269fcae.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> On Wed, 18 Apr 2007 11:00:00 -0400
> Jeff Mahoney <jeffm@suse.com> wrote:
> 
>>> Do you think that could be a reason of the extra reference count on   xattr_root dentry?
>> No, I don't think it is. Looking at the code now, it seems obvious, but
>> I didn't notice it before and nobody else has reported a problem.
>>
>> getxattr() doesn't require any VFS locking. When we get down into the
>> reiserfs code, it takes a read lock. If we get two concurrent threads
>> looking up an xattr before the root has been saved, there's a window
>> where REISERFS_SB(s)->xattr_root is NULL but we've already looked it up
>> and taken a reference on it.
>>
>> I have a patch set to clean up the extended attribute code that fixes
>> this problem along the way by killing off the xattr locks and using the
>> backing files/dirs i_mutex instead. I'll post them to the reiserfs
>> mailing list.
> 
> Do we have anything suitable for 2.6.21 which will address this crash?
> 
> Also, it's not clear to me how many users we can expect to be impacted by it.
> I assume that if the same bug is in 2.6.20 then the answer is "not many".
> How come Andrea is able to keep hitting it?

I have the patchset that I mentioned, but I'm not proposing it for 2.6.21.
It's much too invasive to be introduced in an -rc7, but it does include
locking changes that I believe avoid this bug.

Vladimir was right in his analysis that sometimes get_xa_root() takes the
reference once and other times twice, but not for the right reasons.  I save
a reference to the xattr dir to avoid a lookup later, but when there are multiple
getxattrs or listxattrs as the first xattr operation on the file system, we can end
up taking a second reference when we shouldn't. This is because those operations
are protected by read locks and the ->xattr_root pointer isn't protected by anything
else. A quick fix would be to just extend the protection of the priv root's i_mutex
around the assignment, and test first. The right fix involves a complete rework of
the locking, and I have code to do that, it's just too late to include it in 2.6.21.

I'd love to know what Andrea (and now Andi Kleen) are doing to hit this now. There
haven't been any changes in this code in a while, and the shrink_dcache_for_umount()
has been around since October. I'm unable to reproduce locally so far, so if Andrea
or Andi could see if this fixes it for them, I'd appreciate it.

- -Jeff

- --- a/fs/reiserfs/xattr.c	2007-04-20 21:19:05.000000000 -0400
+++ b/fs/reiserfs/xattr.c	2007-04-20 21:41:16.000000000 -0400
@@ -72,14 +72,16 @@
 		err =
 		    privroot->d_inode->i_op->mkdir(privroot->d_inode, xaroot,
 						   0700);
- -		mutex_unlock(&privroot->d_inode->i_mutex);
 
 		if (err) {
+			mutex_unlock(&privroot->d_inode->i_mutex);
 			dput(xaroot);
 			dput(privroot);
 			return ERR_PTR(err);
 		}
- -		REISERFS_SB(sb)->xattr_root = dget(xaroot);
+		if (REISERFS_SB(sb)->xattr_root == NULL)
+			REISERFS_SB(sb)->xattr_root = dget(xaroot);
+		mutex_unlock(&privroot->d_inode->i_mutex);
 	}
 
       out:

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGKWy4LPWxlyuTD7IRAhcVAJ9vpYk2ayYf7xP7eB40inFpkiERvgCglayP
P7pDkPouMuBlw07rs1qaKPo=
=jdRe
-----END PGP SIGNATURE-----

Return-Path: <linux-kernel-owner+w=401wt.eu-S2992628AbXDRPAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992628AbXDRPAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992697AbXDRPAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:00:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:48240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992628AbXDRPAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:00:24 -0400
Message-ID: <46263270.9010108@suse.com>
Date: Wed, 18 Apr 2007 11:00:00 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: a.righi@cineca.it, linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com,
       Edward Shishkin <edward@namesys.com>, zam@clusterfs.com
Subject: Re: Fwd: Fw: [2.6.20.4] BUG: dentry xattrs still in use in shrink_dcache_for_umount()
 with reiserfs
References: <20070413095219.02075323.akpm@linux-foundation.org> <462536B2.5060308@users.sourceforge.net> <c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com> <200704181816.21166.vs@namesys.com>
In-Reply-To: <200704181816.21166.vs@namesys.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Vladimir V. Saveliev wrote:
> Hello
> 
> On Wednesday 18 April 2007 12:52, ReiserFS Developers Mailing List wrote:
>> *Forwarded Conversation*
>> Subject: *[2.6.20.4] BUG: dentry xattrs still in use in
>> shrink_dcache_for_umount() with reiserfs*
>> ------------------------
>>
>> * From: Andrea Righi* <righiandr@users.sourceforge.net> Reply-To:
>> righiandr@users.sourceforge.net
>> To: reiserfs-dev@namesys.com
>> Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <
>> akpm@linux-foundation.org>
>> Date: Fri, Apr 13, 2007 at 3:04 PM
>> Attachments: config.gz
>>
>> I can reproduce the problem umounting my /var (reiserfs), but it doesn't
>> occur with /usr or /opt, that are reiserfs too.
>>
>> It seems very similar to this issue:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.18-rc3/2.6.18-rc3-mm2/hot-fixes/reiserfs-make-sure-all-dentries-refs-are-released-before-calling-kill_block_super-try-2.patch
>>
>> How the xattrs->d_count can be 1 if the dentry is explicitly released
>> in reiserfs_kill_sb(), before calling kill_super_block()?
>>
> 
> Jeff, in 2.6.20/fs/reiserfs/xattr.c we have get_xa_root,
> which may increment xattr_root reference count either by 1 or 2:
> 
> If REISERFS_SB()->xattr_root != NULL - dentry reference count is incremented by 1 with dget.
> 
> If REISERFS_SB()->xattr_root == NULL, __get_xa_root is called which may increase xattr_root dentry reference count by 2:
> once in lookup_one_len->__lookup_hash->cached_lookup->__d_lookup and once explicitly with dget in __get_xa_root.

__get_xa_root() takes two references because it keeps one associated
with the superblock to avoid the lookup and locking later and passes one
back to the caller. When the file system is umounted, the saved
reference is freed.

The fix Andrea mentioned is unrelated. It's a fix for another patch in
- -mm. David Howells had a patch to tear down the entire dentry tree
associated with a superblock, but it depended on there being no live
references other than s_root at the time generic_shutdown_super is
called. It just moves the freeing of the dentries to ->put_super rather
than ->kill_sb.

> Do you think that could be a reason of the extra reference count on   xattr_root dentry?

No, I don't think it is. Looking at the code now, it seems obvious, but
I didn't notice it before and nobody else has reported a problem.

getxattr() doesn't require any VFS locking. When we get down into the
reiserfs code, it takes a read lock. If we get two concurrent threads
looking up an xattr before the root has been saved, there's a window
where REISERFS_SB(s)->xattr_root is NULL but we've already looked it up
and taken a reference on it.

I have a patch set to clean up the extended attribute code that fixes
this problem along the way by killing off the xattr locks and using the
backing files/dirs i_mutex instead. I'll post them to the reiserfs
mailing list.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGJjJwLPWxlyuTD7IRAle+AJ9erx2RC68KZWfkaIT/YkqFfYRsJgCgpEKA
fVDdl8KSCE4OUeOQhtpaLEY=
=YaYd
-----END PGP SIGNATURE-----

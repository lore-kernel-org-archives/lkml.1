Return-Path: <linux-kernel-owner+w=401wt.eu-S2992561AbXDRORx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992561AbXDRORx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992576AbXDRORx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:17:53 -0400
Received: from mail.alkar.net ([195.248.191.95]:58536 "EHLO mail.alkar.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992561AbXDRORw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:17:52 -0400
From: "Vladimir V. Saveliev" <vs@namesys.com>
To: Jeff Mahoney <jeffm@suse.com>, a.righi@cineca.it
Subject: Re: Fwd: Fw: [2.6.20.4] BUG: dentry xattrs still in use in shrink_dcache_for_umount() with reiserfs
Date: Wed, 18 Apr 2007 18:16:20 +0400
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com,
       Edward Shishkin <edward@namesys.com>, zam@clusterfs.com
References: <20070413095219.02075323.akpm@linux-foundation.org> <462536B2.5060308@users.sourceforge.net> <c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>
In-Reply-To: <c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704181816.21166.vs@namesys.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Wednesday 18 April 2007 12:52, ReiserFS Developers Mailing List wrote:
> *Forwarded Conversation*
> Subject: *[2.6.20.4] BUG: dentry xattrs still in use in
> shrink_dcache_for_umount() with reiserfs*
> ------------------------
> 
> * From: Andrea Righi* <righiandr@users.sourceforge.net> Reply-To:
> righiandr@users.sourceforge.net
> To: reiserfs-dev@namesys.com
> Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <
> akpm@linux-foundation.org>
> Date: Fri, Apr 13, 2007 at 3:04 PM
> Attachments: config.gz
> 
> I can reproduce the problem umounting my /var (reiserfs), but it doesn't
> occur with /usr or /opt, that are reiserfs too.
> 
> It seems very similar to this issue:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.18-rc3/2.6.18-rc3-mm2/hot-fixes/reiserfs-make-sure-all-dentries-refs-are-released-before-calling-kill_block_super-try-2.patch
> 
> How the xattrs->d_count can be 1 if the dentry is explicitly released
> in reiserfs_kill_sb(), before calling kill_super_block()?
> 

Jeff, in 2.6.20/fs/reiserfs/xattr.c we have get_xa_root,
which may increment xattr_root reference count either by 1 or 2:

If REISERFS_SB()->xattr_root != NULL - dentry reference count is incremented by 1 with dget.

If REISERFS_SB()->xattr_root == NULL, __get_xa_root is called which may increase xattr_root dentry reference count by 2:
once in lookup_one_len->__lookup_hash->cached_lookup->__d_lookup and once explicitly with dget in __get_xa_root.

Do you think that could be a reason of the extra reference count on   xattr_root dentry?


> (config attached)
> 
> -Andrea
> 
> BUG: Dentry dfcd2570{i=21bc,n=xattrs} still in use (1) [unmount of reiserfs
> dm-4]

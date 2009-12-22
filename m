Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZLVJAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZLVJAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 04:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZLVJAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 04:00:43 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:47910 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZLVJAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 04:00:43 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Eric Blake <ebb9@byu.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>,
       fuse-devel@lists.sourceforge.net
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
Date: Tue, 22 Dec 2009 18:00:36 +0900
In-Reply-To: <4B304D04.6040501@byu.net> (Eric Blake's message of "Mon, 21 Dec
	2009 21:37:24 -0700")
Message-ID: <87d427jscr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Blake <ebb9@byu.net> writes:

> According to OGAWA Hirofumi on 12/21/2009 8:05 AM:
>>> It may also be file-system dependent.  On the machine where I saw the
>>> original failure:
>>>> $ uname -a
>>>> Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
>>>> x86_64 GNU/Linux
>>> $ df -T .
>>> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
>>> /dev/sdb1      xfs   419299328 269018656 150280672  65% /srv/data
>> 
>> Thanks.
>> 
>> This is good point. This would be xfs issue or design. xfs seems to have
>> own special handling of ctime.
>
> Here's another report, this time about an mtime update not happening on
> ntfs-3g.  http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/19336

It is likely the issue of libfuse or ntfs-3g. I don't know about ntfs-3g
people at all. So, for now, just Cc: to fuse people.

> utimensat(0, NULL, {UTIME_OMIT, UTIME_NOW}, 0) = 0

>From this, "ia_valid" will have "ATTR_CTIME | ATTR_MTIME". And the
request would pass to userland via fuse of kernel part, then it will be
handled by libfuse.

>From quick grep of libfuse and ntfs-3g (would not be latest), ntfs-3g is
using "struct fuse_operations", not "struct fuse_lowlevel_ops".

So, fuse_lib_setattr() would be the handler for it in libfuse. And, from
the following part, it seems to require the both of MTIME and ATIME to
call ntfs-3g's ->utime handler.

I don't know whether it is limitation or bug in fuse_operations.
Any ideas?

		if (!err &&
		    (valid & (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) ==
		    (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) {
			struct timespec tv[2];
			tv[0].tv_sec = attr->st_atime;
			tv[0].tv_nsec = ST_ATIM_NSEC(attr);
			tv[1].tv_sec = attr->st_mtime;
			tv[1].tv_nsec = ST_MTIM_NSEC(attr);
			err = fuse_fs_utimens(f->fs, path, tv);
		}

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

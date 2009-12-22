Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZLVKnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZLVKnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 05:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZLVKnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 05:43:22 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:46458 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZLVKnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 05:43:21 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jean-Pierre =?iso-8859-1?Q?Andr=E9?= 
	<jean-pierre.andre@wanadoo.fr>
Cc: Eric Blake <ebb9@byu.net>, fuse-devel@lists.sourceforge.net,
       Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>
Date: Tue, 22 Dec 2009 19:43:16 +0900
In-Reply-To: <4B3097C4.3060803@wanadoo.fr> ("Jean-Pierre =?iso-8859-1?Q?An?=
 =?iso-8859-1?Q?dr=E9=22's?= message of
	"Tue, 22 Dec 2009 10:56:20 +0100")
Message-ID: <874onjjnln.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Pierre André <jean-pierre.andre@wanadoo.fr> writes:

> Hi all,

Hi,

> OGAWA Hirofumi wrote:
>> Eric Blake<ebb9@byu.net>  writes:
>>
>>    
>> It is likely the issue of libfuse or ntfs-3g. I don't know about ntfs-3g
>> people at all. So, for now, just Cc: to fuse people.
>>    
>
> Which ntfs-3g version are you using ?

I don't know which version is used by actual user. But, well, I've got
source by "apt-get source", and the version was 1:2009.4.4-1.

Now, I've got ntfs-3g-2009.11.14AC.2.tgz from specified url.

>>> utimensat(0, NULL, {UTIME_OMIT, UTIME_NOW}, 0) = 0
>
> Currently ntfs-3g does not set sub-second precision.
>
> There is also a slight problem in the fuse interface :
> the time buffer is never passed as NULL, consequently
> in some circumstances ntfs-3g cannot decide correctly
> over permissions. A permissive action is taken in this
> situation.
>
>> > From this, "ia_valid" will have "ATTR_CTIME | ATTR_MTIME". And the
>> request would pass to userland via fuse of kernel part, then it will be
>> handled by libfuse.
>>
>> > From quick grep of libfuse and ntfs-3g (would not be latest), ntfs-3g is
>> using "struct fuse_operations", not "struct fuse_lowlevel_ops".
>>    
>
> With the latest ntfs-3g, currently as a release candidate,
> you can (optionally) use the low level fuse interface
> http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html
> use the "lowntfs-3g" driver instead of "ntfs-3g"

Well, the problem seems in fuse_lib_setattr() and ntfs_fuse_setattr()
(lowlevel op too).

The both functions is requiring "ATIME | MTIME". Doesn't it mean the
ntfs-3g can't set only MTIME like above utimensat()?

In fuse_lib_setattr(),

        if (!err && (valid & (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) ==
            (FUSE_SET_ATTR_ATIME | FUSE_SET_ATTR_MTIME)) {

In ntfs_fuse_setattr(),
	case FUSE_SET_ATTR_ATIME + FUSE_SET_ATTR_MTIME :
		res = ntfs_fuse_utime(&security, ino, attr, &stbuf);

Or I'm missing something?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

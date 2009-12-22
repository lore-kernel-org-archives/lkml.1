Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZLVNad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZLVNad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZLVNac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:30:32 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:41067 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZLVNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:30:30 -0500
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
	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>
Date: Tue, 22 Dec 2009 22:30:24 +0900
In-Reply-To: <4B30B67A.7080703@wanadoo.fr> ("Jean-Pierre =?iso-8859-1?Q?An?=
 =?iso-8859-1?Q?dr=E9=22's?= message of
	"Tue, 22 Dec 2009 13:07:22 +0100")
Message-ID: <87ljgvi1an.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Pierre André <jean-pierre.andre@wanadoo.fr> writes:

> Hi again,

Hi,

>> Well, the problem seems in fuse_lib_setattr() and ntfs_fuse_setattr()
>> (lowlevel op too).
>>
>> The both functions is requiring "ATIME | MTIME". Doesn't it mean the
>> ntfs-3g can't set only MTIME like above utimensat()?
>>    
>
> With ntfs-3g this is not directly possible, because
> the interface does not provide flags telling which
> timestamps should be updated. The only way would
> be fuse feeding both values (even though unchanged)
> before calling ntfs-3g. This is true for all versions of
> ntfs-3g.

Yes, with fuse_operations. It is why I'm saying the issue is libfuse or
ntfs-3g.

But I noticed ntfs-3g is including libfuse-lite sources and use it with
static link (I might be wrong here, because I just looked ntfs-3g source
slightly). AFAIK, the fuse of kernel part is passing the flags of some
sort of detail always.

[BTW, the code of that part in kernel may be the following,

fs/fuse/dir.c:iattr_to_fattr(),

	if (ivalid & ATTR_ATIME) {
		arg->valid |= FATTR_ATIME;
		arg->atime = iattr->ia_atime.tv_sec;
		arg->atimensec = iattr->ia_atime.tv_nsec;
		if (!(ivalid & ATTR_ATIME_SET))
			arg->valid |= FATTR_ATIME_NOW;
	}
	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid)) {
		arg->valid |= FATTR_MTIME;
		arg->mtime = iattr->ia_mtime.tv_sec;
		arg->mtimensec = iattr->ia_mtime.tv_nsec;
		if (!(ivalid & ATTR_MTIME_SET))
			arg->valid |= FATTR_MTIME_NOW;
	}
]

So, if libfuse-lite was fixed to supported that update request, it would
be able to do even if fuse_operations.  I.e. in libfuse-lite, emulate
"ATIME | MTIME" request if "MTIME" only (pass unchanged original atime),
then call ->utime() callback. (or adds new utime2 callback with flags, or
something other solutions)

Or, if that request is known limitation of fuse_operations, I think it
would be clear state and ok. The fs needs to use lowlevel op to support
that.

> With lowntfs-3g (release candidate only), this could
> be possible.... but this is not implemented, as the
> case was never found up to now. I can provide you
> with a patch,... if fuse can feed in the flags selectively.

Yes.  AFAIK, fuse of kernel part is passing FATTR_MTIME without
FATTR_ATIME to userland (i.e. FUSE_SET_ATTR_ATIME and
FUSE_SET_ATTR_MTIME in libfuse).

I think it's good to implement if it's not design decision of ntfs-3g.

[BTW, just my guess though, it would be good to use "if (vaild &
ATTR_XXX)" style, not "switch()" to support various combinations of
flags]

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

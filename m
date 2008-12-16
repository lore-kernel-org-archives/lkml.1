Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757601AbYLPXTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYLPXTK (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYLPXSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:18:55 -0500
Received: from kumera.dghda.com ([80.68.90.171]:33066 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbYLPXSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:18:55 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Tue, 16 Dec 2008 23:18:50 +0000
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ufs: ensure fast symlinks are NUL-terminated
Message-ID: <20081216231850.GA12692@dastardly.home.dghda.com>
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com> <1229442720-31056-2-git-send-email-duaneg@dghda.com> <1229442720-31056-3-git-send-email-duaneg@dghda.com> <1229442720-31056-4-git-send-email-duaneg@dghda.com> <1229442720-31056-5-git-send-email-duaneg@dghda.com> <1229442720-31056-6-git-send-email-duaneg@dghda.com> <1229442720-31056-7-git-send-email-duaneg@dghda.com> <20081216194053.GA17671@rain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216194053.GA17671@rain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 10:40:55PM +0300, Evgeniy Dushistov wrote:
> There is different types of ufs, one used 64 bit for "pointers to
> blocks", another 32 bit,
> so sizeof(UFS_I(inode)->i_u1.i_symlink))
> is not right choice every time,
> in ufs2 it should be
> sizeof(UFS_I(inode)->i_u1.u2_i_data) which 2 times bigger,
> 
> also there is hint for *BSD ufs
> 
> fs/ufs/ufs_fs.h:
> __fs32	fs_maxsymlinklen;/* max length of an internal symlink */
> 
> which may be used if ufs type ufs1 or ufs2

Hmm, I see. However it looks like ufs1_read_inode and ufs2_read_inode
both copy the same, ((UFS_NDADDR + UFS_NINDIR) * 4), amount of inline
symlink data. They also both copy it to ufs_inode_info->i_u1.i_symlink
(not that that matters, I suppose). Perhaps I'm being obtuse, but it
looks like inline ufs2 symlinks between 60 and 120 characters long are
being truncated to 60 characters, no?

There also doesn't seem to be any validation of (f)s_maxsymlinklen being
done. Unless I'm mistaken ufs_symlink could end up overwriting random
memory if it contains a large bogus value.

Does that all sound correct? If so would you like me to whip up a couple
of patches to fix it? I'll respin the NUL-termination patch on top of
those, if so.

> /Evgeniy

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan

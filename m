Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab0BVKfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:35:21 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35955 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751115Ab0BVKfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:35:19 -0500
Date: Mon, 22 Feb 2010 11:35:17 +0100
From: Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       npiggin@suse.de
Subject: Re: [PATCH 0/7] vfs: notify_changes() error handling
Message-ID: <20100222103516.GA5131@atrey.karlin.mff.cuni.cz>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Dmitry,

> Current inode attr setting path looks like follows
> 
>  ret = inode_change_ok()
>  if(ret)
>      goto out;
>  /*
>   perform private-fs specific logic here
>   */
>  if(ia_valid & ATTR_UID || ...)
>     ret = vfs_dq_transfer()
> 
>  /*
>    more private-fs specific logic
>    for example update on_disk data structures.
>    */
> 
>   ret = inode_setattr()
> 
> In fact inode_setattr() call vmtruncate() which may fail in number
> of reasons IS_SWAPFILE, RLIMIT_FSIZE. After this many filesystem is
> unable to rollback changes. And just live inode in inconsistent
> state. We may check IS_SWAPFILE at the very beginning(currently it
> is not checked), but RLIMIT_FSIZE may changed under our feet.
> In order make things straight. Let's divide vmtruncate() in to
> two parts which perform all checks, and second which can not fail.
> After this notify_change() perform all necessary checks inside
> inode_change_ok() and simply call nofail version of vmtruncate().
  Actually, there are more problems than these in the truncate path.  Some
filesystems can decide to fail truncate only in their .truncate method but that
is called only after i_size is set which is too late.  Nick Piggin has a patch
set which was addressing this problem and should be basically a superset of
your changes. But I'm not sure whether the patch series is available somewhere
or what it's current status. Nick?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

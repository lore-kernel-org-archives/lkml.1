Return-Path: <linux-kernel-owner+w=401wt.eu-S1762570AbYEAPsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762570AbYEAPsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761944AbYEAPsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:48:01 -0400
Received: from sous-sol.org ([216.99.217.87]:39232 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761909AbYEAPsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:48:00 -0400
Date: Thu, 1 May 2008 08:47:16 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: chrisw@sous-sol.org, viro@ZenIV.linux.org.uk, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
Subject: Re: [TOMOYO #8 (2.6.25-mm1) 1/7] Introduce new LSM hooks.
Message-ID: <20080501154716.GL30511@sequoia.sous-sol.org>
References: <20080501055405.024390000@nttdata.co.jp> <20080501055543.269648000@nttdata.co.jp> <20080501080144.GJ30511@sequoia.sous-sol.org> <200805020007.HHC90622.OQSFOJtVOMFHFL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805020007.HHC90622.OQSFOJtVOMFHFL@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp) wrote:
> The MAY_WRITE flag is not passed to security_inode_permission()
> if security_inode_permission() is called from __open_namei_create().
> Since TOMOYO Linux doesn't check MAY_READ/MAY_WRITE permissions for individual
> read()/write() requests, the permission checks at open() time (i.e. may_open())
> is the only chance to check MAY_WRITE flag. If I can't check MAY_WRITE flag
> here, TOMOYO Linux can't control open(O_WRONLY | O_CREATE | O_EXCL).
> 
> Also, the O_TRUNC flag is not passed to security_inode_permission() because
> vfs_permission() receives only MAY_READ/MAY_WRITE/MAY_APPEND flags, but
> I have to check O_TRUNC flag before do_truncate().
> 
> So, I inserted a new hook here so that this hook can check all
> MAY_READ/MAY_WRITE/O_APPEND/O_TRUNC flags together in a single place.

The reason I ask is because it doesn't check.  It only checks O_APPEND,
but that's already passed in (MAY_APPEND).  So AFAICT, it's only O_TRUNC
that you are trying to special case.  But in that case...all that is
being asked for is MAY_WRITE permission.  Anything else doesn't make
sense, especially since that's all you get from the truncate(2) path.

<snip>
> This is an inevitable duplication since I want to do conventional checks
> (DAC checks and inode operation existence checks) before TOMOYO Linux's check.
> 
> By the way, Stephen Smalley thinks it is better to copy codes which is needed by
> pre_vfs_*() (i.e. may_create()/may_delete()/check_sticky()) into
> security/tomoyo/ directory and leave vfs_*() untouched rather than
> extract pre_vfs_*() from vfs_*() and call pre_vfs_*() from vfs_*().

I'm not sure he means literally copy.  Typically we take existing
functionality and make it externally usable.

Also, all the changes you make that are not in vfs_* helpers won't get
picked up by NFS.

thanks,
-chris

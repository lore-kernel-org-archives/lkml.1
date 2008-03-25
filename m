Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYCYBdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYCYBdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 21:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYCYBdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 21:33:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39283 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753552AbYCYBdh (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 21:33:37 -0400
Date: Tue, 25 Mar 2008 12:33:14 +1100
From: David Chinner <dgc@sgi.com>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] freeze feature ver 1.0
Message-ID: <20080325013314.GA107684377@sgi.com>
References: <20080324201136t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324201136t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 08:11:36PM +0900, Takashi Sato wrote:
> Hi,
> 
> This is the rebased freeze feature patch for linux-2.6.25-rc6.
> We can take a backup which keeps the filesystem's consistency with it.
> I have tested it cooperating with
> DRBD (Distributed Replicated Block Device (http://www.drbd.org/))
> and made sure that I could take the consistent backup with a short
> frozen time (several seconds) while using the filesystem.
> The detailed procedure for my test is below.
> 
> 1. Set up the replication between server A (primary) and
>    server B (secondary)
> 
> 2. Make the ext3 filesystem on server A and mount it
>    (Run Linux kernel compile by 5 threads in parallel on it)
> 
> 3. Freeze the filesystem on server A to block I/O and
>    keep the filesystem's consistency
> 
> 4. Detach the secondary volume on server B
>    (e.g /sbin/drbdadm detach r0)
> 
> 5. Unfreeze the filesystem on server A
> 
> 6. Use the secondary volume on server B
>    I confirmed the followings.
>    - fsck didn't report any errors.
>    - It could be mounted correctly.
>    - Linux kernel compiles could re-start correctly.
> 
> There is no functional change from the previous version.
> All of comments from ML have already been reflected in this patch.

Can you please split this into two patches - one which introduces the
generic functionality *without* the timeout stuff, and a second patch
that introduces the timeouts.

I think this timeout stuff is dangerous - it adds significant
complexity and really does not protect against anything that can't
be done in userspace.  i.e. If your system is running well enough
for the timer to fire and unfreeze the filesystem, it's running well
enough for you to do "freeze X; sleep Y; unfreeze X".  If you are
trying to protect against a freeze operation that hangs then
the filesystem needs fixing, not some new API to work around a bug....

FWIW, there is nothing to guarantee that the filesystem has finished
freezing when the timeout fires (it's not uncommon to see
freeze_bdev() taking *minutes*) and unfreezing in the middle of a
freeze operation will cause problems - either for the filesystem
in the middle of a freeze operation, or for whatever is freezing the
filesystem to get a consistent image.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

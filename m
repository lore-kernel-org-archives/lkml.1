Return-Path: <linux-kernel-owner+w=401wt.eu-S1765275AbXHJQrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765275AbXHJQrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932531AbXHJQrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:47:23 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39039 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S937238AbXHJQrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:47:21 -0400
Message-ID: <386764436.02604@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 11 Aug 2007 00:47:15 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] writeback: 3-queue based writeback schedule
Message-ID: <20070810164715.GA5508@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@osdl.org>,
	Ken Chen <kenchen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070810063412.238042387@mail.ustc.edu.cn> <20070810063419.549052142@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810063419.549052142@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 02:34:14PM +0800, Fengguang Wu wrote:
> Properly manage the 3 queues of sb->s_dirty/s_io/s_more_io so that
> 	- time-ordering of dirtied_when can be easily maintained
> 	- writeback can continue from where previous run left out
> 
> The majority work has been done by Andrew Morton and Ken Chen,
> this patch just clarifies the roles of the 3 queues:
> - s_dirty   for io delay(up to dirty_expire_interval)
> - s_io      for io run(a full scan of s_io may involve multiple runs)
> - s_more_io for io continuation
> 
> The following paradigm shows the data flow.
> 
>                             requeue on new scan(empty s_io)
>                             +-----------------------------+
>                             |                             |
>  dirty           old        |                             |
>  inodes          enough     V                             |
>  ======> s_dirty ======> s_io                             |
>          ^                |     requeue io                |
>          |                +---------------------> s_more_io
>          |   hold back    |
>          +----------------+----------> disk write requests
> 
> sb->s_dirty: a FIFO queue
> - s_dirty hosts not-yet-expired(recently dirtied) dirty inodes
> - once expired, inodes will be moved out of s_dirty and *never put back*
>   (unless for some reason we have to hold on the inode for some time)
> 
> sb->s_io and sb->s_more_io: a cyclic queue scanned for io
> - on each run of generic_sync_sb_inodes(), some more s_dirty inodes may be
>   appended to s_io
> - on each full scan of s_io, all s_more_io inodes will be moved back to s_io
> - large files that cannot be synced in one run will be moved to s_more_io for
>   retry on next full scan

In fact s_more_io is no longer necessary. We end up with a priority
io-delaying queue s_dirty and a cyclic io-syncing queue s_io. They are
properly decoupled.  More flexible data structure can be used for
s_dirty, if we want to redirty an inode with arbitrary delays. Also
more priority queues can be introduced in addition to s_dirty. For
example, we can designate a queue s_dirty_atime for inodes dirtied
only by `atime', and sync them lazily.

> inode->dirtied_when
> - inode->dirtied_when is updated to the *current* jiffies on pushing into
>   s_dirty, and is never changed in other cases.
> - time-ordering thus can be simply ensured while moving inodes between lists,
>   since (time order == enqueue order)
> 
> Cc: Ken Chen <kenchen@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  fs/fs-writeback.c |  106 +++++++++++++++++++++-----------------------
>  1 file changed, 52 insertions(+), 54 deletions(-)


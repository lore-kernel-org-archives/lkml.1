Return-Path: <linux-kernel-owner+w=401wt.eu-S936806AbZDJDqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936806AbZDJDqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 23:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbZDJDqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 23:46:07 -0400
Received: from mga06.intel.com ([134.134.136.21]:55794 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756126AbZDJDqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 23:46:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,164,1239001200"; 
   d="scan'208";a="401958756"
Subject: Re: [PATCH 0/13] Per-bdi writeback flusher threads #3
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 11:46:39 +0800
Message-Id: <1239335199.2567.784.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 14:00 +0200, Jens Axboe wrote:
> Hi,
> 
> This is the third version of the patchset. Changes since v2:
Jens,

The patchset forgets kernel/sysctl.c part, so the compilation link fails.

Yanmin

> 
> - Dropped some of the prep patches, since they are now in mainline.
>   Unfortunately we grew another pdflush_operation() user (emergency thaw),
>   so I had to introduce a new prep patch for that.
> 
> - Fix the data consistency issue in generic_sync_sb_inodes() with
>   WB_SYNC_ALL that Jan Kara pointed out. I had to switch bdi_list
>   to SRCU protection for this. I pondered using a mutex for bdi_lock,
>   but that does not work with the pending list <-> active list
>   RCU callback scheme.
> 
> - Fix race in bdi task removal, we need to synchronize_rcu() before
>   doing the wb task kill, not after. This ensures that once we do the
>   task kill, nobody is accessing our bdi anymore.
> 
> - Separate default wb task creation from filesystem initiated task
>   additions. The former can be racy and should check the pending bit
>   only to see whether it should proceed, the latter should block waiting
>   for previous task additions to finish.
> 
> - Move the bdi_cap_flusher_forker() back in the series to where the
>   BDI_CAP_FLUSH_FORKER flag was introduced.
> 
> - Fix a problem where the first incremental step ended up writing back
>   all the dirty inodes on a bdi, not just the ones belonging to a
>   specific super_block. Only a problem after the first patch, the 2nd
>   patch in the series got it right again. (Thanks Jan Kara).
> 
> - Allow writeback tasks to exit, if the bdi has been idle for a certain
>   period of time. The lazy create will recreate them if we see dirty
>   inodes on the bdi later on.
> 
> - btrfs must register its fs_info bdi, or direct writeback will not work
>   as intended. Also kill capabilities inherit from
>   default_backing_dev_info and fix failure to check bdi_init() return
>   value.
> 
> The branch can be pulled from:
> 
> git://git.kernel.dk/linux-2.6-block.git writeback
> 
> Or these patches can be applied directly to 2.6.30-rc1.
> 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbXFGO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbXFGO3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbXFGO3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:29:06 -0400
Received: from styx.suse.cz ([82.119.242.94]:38442 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752213AbXFGO3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:29:05 -0400
Date: Thu, 7 Jun 2007 16:41:21 +0200
From: Jan Kara <jack@suse.cz>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UDF: fix deadlock on inode being dropped
Message-ID: <20070607144121.GC12549@duck.suse.cz>
References: <20070606175351.GA8397@cvg> <20070607093606.GA12549@duck.suse.cz> <20070607135458.GA8393@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607135458.GA8393@cvg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-06-07 17:54:58, Cyrill Gorcunov wrote:
> [Jan Kara - Thu, Jun 07, 2007 at 11:36:07AM +0200]
> |   Hi Cyrill!
> | 
> | On Wed 06-06-07 21:53:51, Cyrill Gorcunov wrote:
> | > This patch prevents from deadlock on inode being dropped.
> | > The deadlock is caused by inderect call of mark_inode_dirty()
> | > within udf_drop_inode() but inode lock is already kept
> | > by the kernel. So moving code from udf_drop_inode() to
> | > udf_delete_inode() we save its functionality and avoid
> | > deadlock.
> |   The patch is wrong. You cannot truncate the extent just in delete_inode.
> | That would lead to inodes with untruncated last extent on disk after
> | unmounting, which is forbidden in the specification. You need to truncate
> | the last extent whenever inode is being removed from memory or something
> | like that... I'm already thinking how to do it and avoid calling
> | mark_inode_dirty()...
> | 
> 
> Arh, thanks... Jan, actually the reason I've moved the code into
> 'delete' section was that I found no reasonable difference for our
> case between 'drop' and 'delete'. Moreover, by seeing into VFS code
> the only diff between 'drop' and 'delete' is that
> inside generic_delete_inode() a few inode structure elements
> are being destroyed and then our udf_drop_inode is called. So assuming,
> that you're right in drop_inode I've code just moved to 'delete' section.
  The difference is that udf_delete_inode() is called only when inode has
i_nlink == 0 and thus it's being deleted on disk. udf_drop_inode() is
called whenever inode is removed from memory which is what we want.
  I'm already testing a patch which should fix the problem...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

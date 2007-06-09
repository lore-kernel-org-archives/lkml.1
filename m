Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbXFINhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbXFINhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 09:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXFINhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 09:37:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:57511 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbXFINhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 09:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bTOTirZAs63KYsDJs69e6PTNKVZNBhkOPrP9i27GVPKMvkFSBElr4NDZ0+0ohEgfh2ovsRnOIQaL9qWjDMYH+1B32gRLbERCDqkIivD6l7Uwi8SeqENA0uDVICHQYr8zsm/4kbie4HBVO6Mei1isny1Vix4R8Vd97T2LBKmmmJo=
Date: Sat, 9 Jun 2007 17:35:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UDF: fix deadlock on inode being dropped
Message-ID: <20070609133536.GA8654@cvg>
References: <20070606175351.GA8397@cvg> <20070607093606.GA12549@duck.suse.cz> <20070607135458.GA8393@cvg> <20070607144121.GC12549@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607144121.GC12549@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Kara - Thu, Jun 07, 2007 at 04:41:21PM +0200]
| On Thu 07-06-07 17:54:58, Cyrill Gorcunov wrote:
| > [Jan Kara - Thu, Jun 07, 2007 at 11:36:07AM +0200]
| > |   Hi Cyrill!
| > | 
| > | On Wed 06-06-07 21:53:51, Cyrill Gorcunov wrote:
| > | > This patch prevents from deadlock on inode being dropped.
| > | > The deadlock is caused by inderect call of mark_inode_dirty()
| > | > within udf_drop_inode() but inode lock is already kept
| > | > by the kernel. So moving code from udf_drop_inode() to
| > | > udf_delete_inode() we save its functionality and avoid
| > | > deadlock.
| > |   The patch is wrong. You cannot truncate the extent just in delete_inode.
| > | That would lead to inodes with untruncated last extent on disk after
| > | unmounting, which is forbidden in the specification. You need to truncate
| > | the last extent whenever inode is being removed from memory or something
| > | like that... I'm already thinking how to do it and avoid calling
| > | mark_inode_dirty()...
| > | 
| > 
| > Arh, thanks... Jan, actually the reason I've moved the code into
| > 'delete' section was that I found no reasonable difference for our
| > case between 'drop' and 'delete'. Moreover, by seeing into VFS code
| > the only diff between 'drop' and 'delete' is that
| > inside generic_delete_inode() a few inode structure elements
| > are being destroyed and then our udf_drop_inode is called. So assuming,
| > that you're right in drop_inode I've code just moved to 'delete' section.
|   The difference is that udf_delete_inode() is called only when inode has
| i_nlink == 0 and thus it's being deleted on disk. udf_drop_inode() is
| called whenever inode is removed from memory which is what we want.
|   I'm already testing a patch which should fix the problem...
| 
| 								Honza
| -- 
| Jan Kara <jack@suse.cz>
| SuSE CR Labs
| 

Hi Jan,

how your progress? Could I help with something?

		Cyrill


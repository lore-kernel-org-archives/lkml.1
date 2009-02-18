Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZBRJUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZBRJUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZBRJTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:19:49 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:7483 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbZBRJTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:19:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUDAPtem0l5LClxgWdsb2JhbACUTgEBFiK+ZoQTBg
X-IronPort-AV: E=Sophos;i="4.38,228,1233495000"; 
   d="scan'208";a="293560843"
Date: Wed, 18 Feb 2009 20:19:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: xfs problems (possibly after upgrading from linux kernel
	2.6.27.10 to .14)
Message-ID: <20090218091935.GD8830@disturbed>
Mail-Followup-To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org
References: <499ACE6C.4060304@aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499ACE6C.4060304@aei.mpg.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 03:49:16PM +0100, Carsten Aulbert wrote:
> Hi all,
> 
> within the past few days we hit many XFS internal errors like these. Are these
> errors known (and possibly already fixed)? I checked the commits till 
> 2.6.27.17 and there does not seem anything related to this.

.....

> Feb 16 20:34:49 n0035 kernel: [275873.335916] Filesystem "sda6": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_

A transaction shutdown on create. That implies some kind of ENOSPC
issue.

> Do you need more information or can I send these nodes into a re-install?

More information. Can you get a machine into a state where you can
trigger this condition reproducably by doing:

	mount filesystem
	touch /mnt/filesystem/some_new_file

If you can get it to that state, and you can provide an xfs_metadump
image of the filesystem when in that state, I can track down the
problem and fix it.

> Feb 16 22:01:28 n0260 kernel: [1129250.851451] Filesystem "sda6": xfs_iflush: Bad inode 1176564060 magic number 0x36b5, ptr 0xffff8801a7c06c00

However, this implies some kind of memory corruption is occurring.
That is reading the inode out of the buffer before flushing the
in-memory state to disk. This implies someone has scribbled over
page cache pages.


> Feb 17 05:57:44 n0463 kernel: [1156816.912129] Filesystem "sda6": XFS internal error xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff802dd15b

And that is another buffer that has been scribbled over.
Something is corrupting the page cache, I think. Whether the
original shutdown is caused by the some corruption, i don't
know.

> plus a few more nodes showing the same characteristics 

Hmmmm. Did this show up in 2.6.27.10? Or did it start occurring only
after you upgraded from .10 to .14?

Cheers,

Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Dave Chinner
david@fromorbit.com

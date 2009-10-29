Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZJ2WXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZJ2WXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZJ2WXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:23:38 -0400
Received: from THUNK.ORG ([69.25.196.29]:42875 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbZJ2WXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:23:37 -0400
Date: Thu, 29 Oct 2009 18:23:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Shawn Starr <shawn.starr@rogers.com>
Subject: Re: [Bug #14472] EXT4 corruption
Message-ID: <20091029222335.GJ18464@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Lutomirski <luto@MIT.EDU>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Shawn Starr <shawn.starr@rogers.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.haF.Are5KB@chimera> <cb0375e10910291257t1f2f16ciade932bd78689ccc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0375e10910291257t1f2f16ciade932bd78689ccc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 03:57:32PM -0400, Andrew Lutomirski wrote:
> 
> This but is *not* fixed.  I just triggered it a few minutes ago by
> abusing i915 and drm, which caused a panic.  This is slightly newer
> than 2.6.32-rc5, with a couple of i915 bugfixes thrown in.

Andrew, can you test to see if this patch helps?

Thanks,

						- Ted

commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Oct 27 15:36:38 2009 +0530

    ext4: discard preallocation during truncate
    
    We need to make sure when we drop and reacquire the inode's
    i_data_sem we discard the inode preallocation. Otherwise we
    could have blocks marked as free in bitmap but still belonging
    to prealloc space.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5c5bc5d..a1ef1c3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -209,6 +209,12 @@ static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
 	up_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_journal_restart(handle, blocks_for_truncate(inode));
 	down_write(&EXT4_I(inode)->i_data_sem);
+	/*
+	 * We have dropped i_data_sem. So somebody else could have done
+	 * block allocation. So discard the prealloc space created as a
+	 * part of block allocation
+	 */
+	ext4_discard_preallocations(inode);
 
 	return ret;
 }

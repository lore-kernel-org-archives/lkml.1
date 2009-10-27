Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZJ0KAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZJ0KAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 06:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZJ0KAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 06:00:32 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:53502 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZJ0KAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:00:31 -0400
Date: Tue, 27 Oct 2009 15:45:34 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>, Parag Warudkar <parag.lkml@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Message-ID: <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
 <20091016091558.GA10184@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016091558.GA10184@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you try this patch ?

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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZLXXPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZLXXPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 18:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZLXXPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 18:15:16 -0500
Received: from THUNK.ORG ([69.25.196.29]:58121 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZLXXPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 18:15:15 -0500
Date: Thu, 24 Dec 2009 18:15:11 -0500
From: tytso@mit.edu
To: Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Message-ID: <20091224231511.GB32757@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Alexander Beregalov <a.beregalov@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
 <20091224230512.GA32757@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091224230512.GA32757@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 06:05:12PM -0500, tytso@MIT.EDU wrote:
> On Fri, Dec 25, 2009 at 01:28:34AM +0300, Alexander Beregalov wrote:
> > 
> > Kernel is 2.6.33-rc1-00366-g2f99f5c
> > Ext4 mounts ext3 filesystem
> > 
> > kernel BUG at fs/ext4/inode.c:1063!
> 
> OK, that's this BUG which is triggering:
> 
> 	if (mdb_free) {
> 		/* Account for allocated meta_blocks */
> 		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
> 		BUG_ON(mdb_free < mdb_claim);  <------- BUG triggered
> 		mdb_free -= mdb_claim;
> 
> Can you replicate this?  If so, I'd like to ask you to replicate with
> the following debugging patch applied:

Here's a revised version of the patch which should avoid the BUG_ON,
which should make it be less annoying.  We should really figure out
what's going on and fix it, though.  It may be fixed by the recently
pushed quota race fixes, or at least there's a good chace that it's
related to a ext4 quota-releated WARN_ON that people have been
complaining about.

					- Ted

--- /tmp/inode.c	2009-12-24 17:55:03.736366001 -0500
+++ /tmp/inode.c.new	2009-12-24 18:13:07.716366002 -0500
@@ -1060,8 +1060,14 @@
 	if (mdb_free) {
 		/* Account for allocated meta_blocks */
 		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
-		BUG_ON(mdb_free < mdb_claim);
-		mdb_free -= mdb_claim;
+		if (mdb_free < mdb_claim) {
+			ext4_msg(inode->i_sb, KERN_ERR, "inode #%lu: "
+				 "mdb_free (%d) < mdb_claim (%d) BUG\n",
+				 inode->i_ino, mdb_free, mdb_claim);
+			WARN_ON(1);
+			mdb_free = 0;
+		} else
+			mdb_free -= mdb_claim;
 
 		/* update fs dirty blocks counter */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZIQNeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZIQNeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZIQNeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:34:04 -0400
Received: from thunk.org ([69.25.196.29]:53963 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbZIQNeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:34:02 -0400
Date: Thu, 17 Sep 2009 09:34:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Howto switch off ext4's delayed allocation?
Message-ID: <20090917133401.GC24438@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Clemens Eisserer <linuxhippy@gmail.com>,
	linux-kernel@vger.kernel.org
References: <194f62550909090403x16e61cc1g3a23593085de0b@mail.gmail.com> <194f62550909160532q248cb45coee639a2da10292a@mail.gmail.com> <20090916163822.GA15451@mit.edu> <194f62550909161141n5730049cra2643ce1654a7aaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194f62550909161141n5730049cra2643ce1654a7aaf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 02:41:09PM -0400, Clemens Eisserer wrote:
> 
> > If you can run a strace on eclipse while and then arrange to edit an
> > existing file and save it, it would be interesting to see what the
> > heck it is doing.
> I'll have a look.

Thanks, but no need.  I did some investigating, and when I found that
kwrite was doing a truncate-and-rewrite, I did some more digging, and
found that we had a bug in our truncate hueristics.  I'll get this
fixed for 2.6.32, and it will be a candidate for the 2.6.31 stable
tree.

(This needs to get backported for ext3 as well.)

						 - Ted

commit dbc380bc2268bed9faa687b2ec1f98a7706b5909
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Sep 17 09:33:32 2009 -0400

    ext4: Fix the alloc on close after a truncate hueristic
    
    In an attempt to avoid doing an unneeded flush after opening a
    (previously non-existent) file with O_CREAT|O_TRUNC, the code only
    triggered the hueristic if ei->disksize was non-zero.  Turns out that
    the VFS doesn't call ->truncate() if the file doesn't exist, and
    ei->disksize is always zero even if the file previously existed.  So
    remove the test, since it isn't necessary and in fact disabled the
    hueristic.
    
    Thanks to Clemens Eisserer that he was seeing problems with files
    written using kwrite and eclipse after sudden crashes caused by a
    buggy Intel video driver.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9887a0c..4abd683 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3973,8 +3973,7 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;
 
-	if (ei->i_disksize && inode->i_size == 0 &&
-	    !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
+	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
 		ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;
 
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {

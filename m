Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbYKEXHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbYKEXHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYKEXHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:07:25 -0500
Received: from mail.fieldses.org ([66.93.2.214]:33130 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbYKEXHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:07:24 -0500
Date: Wed, 5 Nov 2008 18:07:15 -0500
To: Doug Nazar <nazard@dragoninc.ca>
Cc: "'David Woodhouse'" <David.Woodhouse@intel.com>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc3 truncates nfsd results
Message-ID: <20081105230715.GP1455@fieldses.org>
References: <000301c93eaa$fae98460$f0bc8d20$@ca> <20081104223000.GG10974@fieldses.org> <004a01c93f37$f2a09090$d7e1b1b0$@ca> <20081105214655.GK1455@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105214655.GK1455@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems good to me; I cleaned up commit message, as below, and I'll submit
in a few days.  If you didn't mind me adding a signed-off-by for you,
that'd also be good.  I hope we've got it right this time!

--b.

commit 19e1e96e0b51f9ad4cb0329e6b32a742cf9db713
Author: Doug Nazar <nazard@dragoninc.ca>
Date:   Wed Nov 5 06:16:28 2008 -0500

    Fix nfsd truncation of readdir results
    
    Commit 8d7c4203 "nfsd: fix failure to set eof in readdir in some
    situations" introduced a bug: on a directory in an exported ext3
    filesystem with dir_index unset, a READDIR will only return about 250
    entries, even if the directory was larger.
    
    Bisected it back to this commit; reverting it fixes the problem.
    
    It turns out that in this case ext3 reads a block at a time, then
    returns from readdir, which means we can end up with buf.full==0 but
    with more entries in the directory still to be read.  Before 8d7c4203
    (but after c002a6c797 "Optimise NFS readdir hack slightly"), this would
    cause us to return the READDIR result immediately, but with the eof bit
    unset.  That could cause a performance regression (because the client
    would need more roundtrips to the server to read the whole directory),
    but no loss in correctness, since the cleared eof bit caused the client
    to send another readdir.  After 8d7c4203, the setting of the eof bit
    made this a correctness problem.
    
    So, move nfserr_eof into the loop and remove the buf.full check so that
    we loop until buf.used==0.  The following seems to do the right thing
    and reduces the network traffic since we don't return a READDIR result
    until the buffer is full.
    
    Tested on an empty directory & large directory; eof is properly sent and
    there are no more short buffers.
    
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 848a03e..4433c8f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1875,11 +1875,11 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 		return -ENOMEM;
 
 	offset = *offsetp;
-	cdp->err = nfserr_eof; /* will be cleared on successful read */
 
 	while (1) {
 		unsigned int reclen;
 
+		cdp->err = nfserr_eof; /* will be cleared on successful read */
 		buf.used = 0;
 		buf.full = 0;
 
@@ -1912,9 +1912,6 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 			de = (struct buffered_dirent *)((char *)de + reclen);
 		}
 		offset = vfs_llseek(file, 0, SEEK_CUR);
-		cdp->err = nfserr_eof;
-		if (!buf.full)
-			break;
 	}
 
  done:

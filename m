Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYKELQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYKELQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 06:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYKELQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 06:16:37 -0500
Received: from [74.13.241.36] ([74.13.241.36]:43530 "EHLO slyph.dragoninc.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbYKELQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 06:16:36 -0500
From: "Doug Nazar" <nazard@dragoninc.ca>
To: "'J. Bruce Fields'" <bfields@fieldses.org>
Cc: "'David Woodhouse'" <David.Woodhouse@intel.com>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, <linux-kernel@vger.kernel.org>
References: <000301c93eaa$fae98460$f0bc8d20$@ca> <20081104223000.GG10974@fieldses.org>
In-Reply-To: <20081104223000.GG10974@fieldses.org>
Subject: RE: 2.6.28-rc3 truncates nfsd results
Date: Wed, 5 Nov 2008 06:16:28 -0500
Message-ID: <004a01c93f37$f2a09090$d7e1b1b0$@ca>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ack+zO0qwfqSLSHJSCqlmvLV5oKIWAAWnLtA
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> From: J. Bruce Fields [mailto:bfields@fieldses.org]
> On Tue, Nov 04, 2008 at 01:27:23PM -0500, Doug Nazar wrote:
> > Commit 8d7c4203 "nfsd: fix failure to set eof in readdir in some situations"
> > breaks the nfsd server. Bisected it back to this commit and reverting it
> > fixes the problem.
> >
> > However, it only happens on certain machines even with the same kernel &
> > filesystem (ext3). I've two groups of similar computers, each group running
> > identical kernels. The ones listing only ~250 files are of course in error.
> > Eldritch is running 2.6.28-rc3 with that commit reverted. With 2.8.28-rc3 it
> > showed the incorrect number.
> 
> Well, that's strange; it must be staring me in the face, but I don't see
> the problem (and can't reproduce it).  Can you watch for the readdir
> with wireshark and see if it's returning an error on the readdir?  Or is
> it  just returning succesfully with eof set after the first ~250
> entries?

Ok, think I've figured it out. 

The computers showing the issue are not using dir_index. This causes ext3 to read a block at a time, which then means we can end up
with buf.full==0 but not finished reading the directory. Before 8d7c4203, we'd always get called again because we never set
nfserr_eof which papered over it.

I think the correct solution is to move nfserr_eof into the loop and remove the buf.full check so that we loop until buf.used==0.
The following seems to do the right thing and reduces the network traffic since we now ensure each buffer is full.

Tested on an empty directory & large directory, eof is properly sent and no short buffers.

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




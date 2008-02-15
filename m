Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbYBOUQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbYBOUQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbYBOUQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:16:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755586AbYBOUQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:16:42 -0500
Date: Fri, 15 Feb 2008 12:15:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, jdike@addtoit.com,
       jack@suse.cz
Subject: Re: isofs - Re: 2.6.24-mm1 bugs
Message-Id: <20080215121548.b3c3f548.akpm@linux-foundation.org>
In-Reply-To: <19039.1203094015@turing-police.cc.vt.edu>
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
	<19039.1203094015@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 11:46:55 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Fri, 15 Feb 2008 12:43:45 +0100, Miklos Szeredi said:
> > I'm trying out 2.6.24-mm1 on my work laptop (T60), and generally it
> 
> >  - mounting isofs always results in an empty directory
> 
> I hit this in 24-rc8-mm1, and bisected it down to
> iget-stop-isofs-from-using-read_inode-fix-2.patch
> 
> Apparently it got broken way back in 24-rc6-mm1.
> 
> And that directory is *really* empty - even . and .. are missing. :)
>

Seems that 2.6.24-mm1+hot-fixes still didn't have
iget-stop-isofs-from-using-read_inode-fix-3.patch:



From: David Howells <dhowells@redhat.com>

Fix isofs_get_block() to return only 0 on success.  It shouldn't return a
+ve block count for example.

Also make sure that isofs_get_blocks() doesn't accidentally return an error
if rv is 0 come the return statement.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix-3 fs/isofs/inode.c
--- a/fs/isofs/inode.c~iget-stop-isofs-from-using-read_inode-fix-3
+++ a/fs/isofs/inode.c
@@ -1022,6 +1022,7 @@ int isofs_get_blocks(struct inode *inode
 		rv++;
 	}
 
+	error = 0;
 abort:
 	unlock_kernel();
 	return rv != 0 ? rv : error;
@@ -1033,12 +1034,15 @@ abort:
 static int isofs_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create)
 {
+	int ret;
+
 	if (create) {
 		printk(KERN_DEBUG "%s: Kernel tries to allocate a block\n", __func__);
 		return -EROFS;
 	}
 
-	return isofs_get_blocks(inode, iblock, &bh_result, 1);
+	ret = isofs_get_blocks(inode, iblock, &bh_result, 1);
+	return ret < 0 ? ret : 0;
 }
 
 static int isofs_bmap(struct inode *inode, sector_t block)
_


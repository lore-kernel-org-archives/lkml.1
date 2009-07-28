Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZG1X6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZG1X6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZG1XuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:04 -0400
Received: from kroah.org ([198.145.64.141]:35785 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbZG1XuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:56 2009
Message-Id: <20090728234156.272913574@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [patch 33/71] nilfs2: remove unlikely directive causing mis-conversion of error code
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=nilfs2-remove-unlikely-directive-causing-mis-conversion-of-error-code.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 0cfae3d8795f388f9de78adb0171520d19da77e9 upstream.

The following error code handling in nilfs_segctor_write() function
wrongly converted negative error codes to a truth value (i.e. 1):

   err = unlikely(err) ? : res;

which originaly meant to be

   err = err ? : res;

This mis-conversion caused that write or sync functions receive the
unexpected error code.  This fixes the bug by removing the unlikely
directive.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/segment.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1846,8 +1846,8 @@ static int nilfs_segctor_write(struct ni
 		err = nilfs_segbuf_write(segbuf, &wi);
 
 		res = nilfs_segbuf_wait(segbuf, &wi);
-		err = unlikely(err) ? : res;
-		if (unlikely(err))
+		err = err ? : res;
+		if (err)
 			return err;
 	}
 	return 0;



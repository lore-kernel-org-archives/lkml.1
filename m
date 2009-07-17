Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZGQUUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZGQUUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZGQUT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:19:59 -0400
Received: from kroah.org ([198.145.64.141]:43143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbZGQUT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:38 2009
Message-Id: <20090717201237.955389551@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Miklos Szeredi <mszeredi@suse.cz>
Subject: [patch 23/24] fuse: fix return value of fuse_dev_write()
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=fuse-fix-return-value-of-fuse_dev_write.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Csaba Henk <csaba@gluster.com>

commit b4c458b3a23d76936e76678f2074b1528f129f7a upstream.

On 64 bit systems -- where sizeof(ssize_t) > sizeof(int) -- the following test
exposes a bug due to a non-careful return of an int or unsigned value:

implement a FUSE filesystem which sends an unsolicited notification to
the kernel with invalid opcode. The respective write to /dev/fuse
will return (1 << 32) - EINVAL with errno == 0 instead of -1 with
errno == EINVAL.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -904,7 +904,7 @@ static ssize_t fuse_dev_write(struct kio
 			       unsigned long nr_segs, loff_t pos)
 {
 	int err;
-	unsigned nbytes = iov_length(iov, nr_segs);
+	size_t nbytes = iov_length(iov, nr_segs);
 	struct fuse_req *req;
 	struct fuse_out_header oh;
 	struct fuse_copy_state cs;



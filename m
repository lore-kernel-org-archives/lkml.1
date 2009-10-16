Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZJPRSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZJPRSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZJPRSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:14 -0400
Received: from kroah.org ([198.145.64.141]:48421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbZJPRSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:12 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:48 2009
Message-Id: <20091016171147.825732900@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:09:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [03/46] SCSI: sg: Free data buffers after calling blk_rq_unmap_user
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=scsi-sg-free-data-buffers-after-calling-blk_rq_unmap_user.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christof Schmitt <christof.schmitt@de.ibm.com>

commit e27168f8c337b12b8aa8d59c3123c79d2f83603d upstream.

Running sg_luns on s390x with CONFIG_DEBUG_PAGEALLOC enabled fails
with EFAULT from the SG_IO ioctl. The EFAULT is the result from
copy_to_user failing in this call chain:

sg_ioctl
sg_new_read
sg_finish_rem_req
blk_rq_unmap_user
__blk_rq_unmap_user
bio_uncopy_user
__bio_copy_iov
copy_to_user

The sg driver calls sg_remove_scat to free the memory pages before
calling blk_rq_unmap_user that tries to copy the data back to
userspace. Change the order to first call blk_rq_unmap_user before
freeing the pages in sg_remove_scat.

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sg.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1708,11 +1708,6 @@ static int sg_finish_rem_req(Sg_request 
 	Sg_scatter_hold *req_schp = &srp->data;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_finish_rem_req: res_used=%d\n", (int) srp->res_used));
-	if (srp->res_used)
-		sg_unlink_reserve(sfp, srp);
-	else
-		sg_remove_scat(req_schp);
-
 	if (srp->rq) {
 		if (srp->bio)
 			ret = blk_rq_unmap_user(srp->bio);
@@ -1720,6 +1715,11 @@ static int sg_finish_rem_req(Sg_request 
 		blk_put_request(srp->rq);
 	}
 
+	if (srp->res_used)
+		sg_unlink_reserve(sfp, srp);
+	else
+		sg_remove_scat(req_schp);
+
 	sg_remove_request(sfp, srp);
 
 	return ret;



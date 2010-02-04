Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab0BDRjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:39:05 -0500
Received: from kroah.org ([198.145.64.141]:34557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758435Ab0BDRVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:25 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:47 2010
Message-Id: <20100204171447.247021743@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [01/74] [SCSI] scsi_lib: Fix bug in completion of bidi commands
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 63c43b0ec1765b74c734d465ba6345ef4f434df8 upstream.

Because of the terrible structuring of scsi-bidi-commands
it breaks some of the life time rules of a scsi-command.
It is now not allowed to free up the block-request before
cleanup and partial deallocation of the scsi-command. (Which
is not so for none bidi commands)

The right fix to this problem would be to make bidi command
a first citizen by allocating a scsi_sdb pointer at scsi command
just like cmd->prot_sdb. The bidi sdb should be allocated/deallocated
as part of the get/put_command (Again like the prot_sdb) and the
current decoupling of scsi_cmnd and blk-request should be kept.

For now make sure scsi_release_buffers() is called before the
call to blk_end_request_all() which might cause the suicide of
the block requests. At best the leak of bidi buffers, at worse
a crash, as there is a race between the existence of the bidi_request
and the free of the associated bidi_sdb.

The reason this was never hit before is because only OSD has the potential
of doing asynchronous bidi commands. (So does bsg but it is never used)
And OSD clients just happen to do all their bidi commands synchronously, up
until recently.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -749,9 +749,9 @@ void scsi_io_completion(struct scsi_cmnd
 			 */
 			req->next_rq->resid_len = scsi_in(cmd)->resid;
 
+			scsi_release_buffers(cmd);
 			blk_end_request_all(req, 0);
 
-			scsi_release_buffers(cmd);
 			scsi_next_command(cmd);
 			return;
 		}



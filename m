Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZJPRSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZJPRSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZJPRSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:11 -0400
Received: from kroah.org ([198.145.64.141]:48411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbZJPRSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:11 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:11:47 2009
Message-Id: <20091016171146.787259060@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:09:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [01/46] SCSI: Retry ADD_TO_MLQUEUE return value for EH commands
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=scsi-retry-add_to_mlqueue-return-value-for-eh-commands.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hannes Reinecke <hare@suse.de>

commit 6e883b0e42739aa560133cfaf41be1138c51a500 upstream.

A target reset when I/O is ongoing might result
an eventual device offline, as scsi_eh_completed_normally()
might return ADD_TO_MLQUEUE in addition to the
advertised SUCCESS, FAILED, and NEEDS_RETRY.

Which is unfortunate as scsi_send_eh_cmnd() will
therefore map ADD_TO_MLQUEUE to FAILED instead of
the more appropriate NEEDS_RETRY.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_error.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -721,6 +721,9 @@ static int scsi_send_eh_cmnd(struct scsi
 		case NEEDS_RETRY:
 		case FAILED:
 			break;
+		case ADD_TO_MLQUEUE:
+			rtn = NEEDS_RETRY;
+			break;
 		default:
 			rtn = FAILED;
 			break;



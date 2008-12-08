Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYLHNQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYLHNQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYLHNPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:15:54 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:22116 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYLHNPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:15:53 -0500
Message-ID: <493D1DE2.5090907@hp.com>
Date: Mon, 08 Dec 2008 08:15:14 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Mike Anderson <andmike@linux.vnet.ibm.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>,
       James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH] Correctly release and allocate a new request on TUR	retries
References: <49393C88.8080103@hp.com> <20081205144954.GO18255@kernel.dk> <20081205180851.GA9671@linux.vnet.ibm.com>
In-Reply-To: <20081205180851.GA9671@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------090103080508060808080708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090103080508060808080708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Mike Anderson wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Fri, Dec 05 2008, Alan D. Brunelle wrote:
>>> Commands needing to be retried (TUR in this case) would result in a block
>>> I/O request being re-used, without being re-initialized properly. This
>>> patch ensures that the requests are correctly re-initialized via
>>> standard allocation means.
>>>
>>> Prior to this patch, boots were failing consistently as in:
>>> http://lkml.org/lkml/2008/12/5/161
>>>
>>> With this patch in place, the system is booting reliably.
>>>
>>> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
>>> Cc: Jens Axboe <jens.axboe@oracle.com>
>> Looks good.
>>
>> Acked-by: Jens Axboe <jens.axboe@oracle.com>
>>
>> Perhaps James can push it in, I'm about to shutdown for the day...
>>
> 
> I know a failure was not detected in the hp_sw_start_stop function, but it
> uses the same retry method as hp_sw_tur we should update this function
> also.
> 
> I made a quick scope of callers of blk_get_request and I did not see a
> repeated of this retry usage model. I will make another pass to see if I
> missed something.

drivers/cdrom/cdrom.c:cdrom_read_cdda_bpc() is even worse: it gets one
request, then sits in a while loop re-using the same request over and
over again.

Since blk_rq_init() is an exported symbol, perhaps instead of having the
three callers realloc, it _may_ be sufficient to just have them call
that before re-use? (See attached un-tested patch for an example.)

Regards,
Alan

--------------090103080508060808080708
Content-Type: text/x-diff;
 name="0001-Correctly-re-initialize-requests-on-retries.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Correctly-re-initialize-requests-on-retries.patch"


Commands needing to be retried would result in a block I/O request being
re-used, without being re-initialized properly.  This patch ensures that
the requests are correctly re-initialized via standard allocation means.

Prior to this patch, boots were failing consistently as in:
http://lkml.org/lkml/2008/12/5/161

With this patch in place, the system is booting reliably.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/cdrom/cdrom.c                       |    2 ++
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index d16b024..0b86d8a 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2131,6 +2131,8 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		nframes -= nr;
 		lba += nr;
 		ubuf += len;
+
+		blk_rq_init(q, rq);
 	}
 
 	blk_put_request(rq);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 9aec4ca..075ae35 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -136,8 +136,10 @@ retry:
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
+	if (ret == SCSI_DH_IMM_RETRY) {
+		blk_rq_init(req->q, q);
 		goto retry;
+	}
 	if (ret == SCSI_DH_DEV_OFFLINED) {
 		h->path_state = HP_SW_PATH_PASSIVE;
 		ret = SCSI_DH_OK;
@@ -231,8 +233,10 @@ retry:
 		ret = SCSI_DH_OK;
 
 	if (ret == SCSI_DH_RETRY) {
-		if (--retry)
+		if (--retry) {
+			blk_rq_init(req->q, req);
 			goto retry;
+		}
 		ret = SCSI_DH_IO;
 	}
 
-- 
1.5.6.3


--------------090103080508060808080708--

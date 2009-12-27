Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbZL0OSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbZL0OSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 09:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZL0OSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 09:18:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:10865 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZL0OSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 09:18:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mTiFf8sD8uM43sLfyzPwUCi9E4j4KlN7hs8yUmqIE/VMVWP8vUVhsw9vUYAAStic3q
         tGHfConG6LcPlRqOqn6GZs+KcrzUyNvg4IY+2v78FI0zxb0ShF0UV/k5icaFfEVnKYO6
         rK1IUz5UDgx112b7n3by44iEa11dryz2FpjDg=
Message-ID: <4B376CB7.2050904@panasas.com>
Date: Sun, 27 Dec 2009 16:18:31 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, open-osd <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: pointless assignments
References: <20091227134148.GL6075@bicker>
In-Reply-To: <20091227134148.GL6075@bicker>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2009 03:41 PM, Dan Carpenter wrote:
> drivers/scsi/osd/osd_initiator.c +1435 osd_finalize_request warning: assignment to 'ret' was never used

Thanks, very good catch. Humans 0 Robots 1 ;-)

I'll queue the below patch for next Kernel. (Such an unused code path no need
rocking the bote)

Boaz
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Sun, 27 Dec 2009 16:06:47 +0200
Subject: [PATCH] libosd: Fix unchecked err return found by smatch

Doing CHECK="smatch --two-passes gives:
drivers/scsi/osd/osd_initiator.c +1435 osd_finalize_request warning: assignment to 'ret' was never used

Which is an unchecked possible allocation failure, Fixed.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 2422347..9334431 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1433,6 +1433,10 @@ int osd_finalize_request(struct osd_request *or,
 	cdbh->command_specific_options |= or->attributes_mode;
 	if (or->attributes_mode == OSD_CDB_GET_ATTR_PAGE_SET_ONE) {
 		ret = _osd_req_finalize_attr_page(or);
+		if (ret) {
+			OSD_DEBUG("_osd_req_finalize_set_attr_list failed\n");
+			return ret;
+		}
 	} else {
 		/* TODO: I think that for the GET_ATTR command these 2 should
 		 * be reversed to keep them in execution order (for embeded
-- 
1.6.5.2


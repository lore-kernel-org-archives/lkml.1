Return-Path: <linux-kernel-owner+w=401wt.eu-S937040AbXGLA5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937040AbXGLA5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXGLA45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:56:57 -0400
Received: from gatekeeper.greshamstorage.com ([216.143.252.225]:26729 "EHLO
	AUSEXCH1.greshamstorage.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751569AbXGLA44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:56:56 -0400
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 20:56:56 EDT
Message-ID: <46957820.9090008@greshamstorage.com>
Date: Wed, 11 Jul 2007 19:38:56 -0500
From: Jeremy Linton <jli@greshamstorage.com>
Organization: Gresham Enterprise Storage
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@SteelEye.com>,
       Linux Scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH][BUG] Incorrect SCSI transfer length computation from odd
 sized scsi_execute_async() transfers.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jul 2007 00:40:24.0933 (UTC) FILETIME=[3C5F6950:01C7C41D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any function which use scsi_execute_async() and transfers "odd" sized 
data that doesn't align correctly with the segment sizes may have its 
transfer length padded out to the closest segment size.

For writes, this results in unnecessary data being transfered to the 
SCSI target. For reads, it affects the residual data length being 
returned to the application since the residual length will be based on 
the padded transfer size rather than the actual request size.

The easiest way to see this is by trying to read using the SG_IO ioctl a 
large (>32k) buffer size from a tape device that only has a few bytes of 
data stored for the current block. The resulting resid will generally be 
incorrect.

I've fixed this simply by changing scsi_req_map_sg() so that it places 
the requested transfer length in rq->data_len rather than the sum of all 
the sg segments.

This patch applies against scsi_lib.c in 2.6.22.

Signed-off-by: Jeremy Linton <jli@greshamstorage.com>


--- linux-2.6.22/drivers/scsi/scsi_lib.c.orig   2007-07-11 
19:07:06.000000000 -0500
+++ linux-2.6.22/drivers/scsi/scsi_lib.c        2007-07-11 
18:43:36.000000000 -0500
@@ -350,7 +350,7 @@ static int scsi_req_map_sg(struct reques
         }

         rq->buffer = rq->data = NULL;
-       rq->data_len = data_len;
+       rq->data_len = bufflen;
         return 0;

  free_bios:




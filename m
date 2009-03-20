Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZCTDdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZCTDdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZCTDdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:33:06 -0400
Received: from rtr.ca ([76.10.145.34]:33879 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbZCTDdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:33:04 -0400
Message-ID: <49C30E67.4060702@rtr.ca>
Date: Thu, 19 Mar 2009 23:32:55 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Overagressive failing of disk reads, both LIBATA and IDE
References: <F79C774361EF45A6A68BC08F8621E406@DIAMOND8600>
In-Reply-To: <F79C774361EF45A6A68BC08F8621E406@DIAMOND8600>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norman Diamond wrote:
> For months I was wondering how a disk could do this:
> dd if=/dev/hda of=/dev/null bs=512 skip=551540 count=4  # succeeds
> dd if=/dev/hda of=/dev/null bs=512 skip=551544 count=4  # succeeds
> dd if=/dev/hda of=/dev/null bs=512 skip=551540 count=8  # fails
> 
> It turns out the disk isn't doing that.  Linux is.  The old IDE drivers did
> it, but with LIBATA the same thing happens to /dev/sda.  In later examples
> also, the same happens to /dev/sda as /dev/hda.
..

You can blame me for the IDE driver not doing that properly.
But for libata, it's the SCSI layer.

I've been patching this for years for my clients,
and will be updating the patch soon-ish and trying
again to get it into upstream kernels.

Here's the (now ancient) 2.6.20 version for SLES10:

* * *

Allow SCSI to continue with the remaining blocks of a request
after encountering a media error.  Otherwise, it may just fail
the entire request, even though some blocks were fine and needed
by a completely different process than the one that wanted the bad block(s).

Signed-off-by: Mark Lord <mlord@pobox.com>

--- linux-2.6.16.60-0.6/drivers/scsi/scsi_lib.c	2008-03-10 13:46:03.000000000 -0400
+++ linux/drivers/scsi/scsi_lib.c	2008-03-21 11:54:09.000000000 -0400
@@ -888,6 +888,12 @@
 	 */
 	if (sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
+		case MEDIUM_ERROR:
+		/* Bad sector.  Fail it, and then continue the rest of the request. */
+		if (scsi_end_request(cmd, 0, cmd->device->sector_size, 1) == NULL) {
+			cmd->retries = 0;       // go around again..
+			return;
+		}
 		case UNIT_ATTENTION:
 			if (cmd->device->removable) {
 				/* Detected disc change.  Set a bit

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbXFNPcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbXFNPcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 11:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbXFNPc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 11:32:26 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2690 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbXFNPcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 11:32:25 -0400
Date: Thu, 14 Jun 2007 11:31:19 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: mike.miller@hp.com, iss_storagedev@hp.com, akpm@linux-foundation.org,
       nhorman@tuxdriver.com
Subject: [PATCH] cciss: force ignore of responses to unsent scsi commands after kexec reboot
Message-ID: <20070614153119.GC32137@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey -
	cciss hardware currently can continue to send responses to scsi commands
after the host system has undergone a kexec reboot.  The way the drier is
currently written, reception of these commands results in a BUG halt, since it
can't match the response to any issued command since the boot.  This patch
corrects that by using the kexec reset_devices command line paramter to force
ignore any commands that it cant correlate.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 cciss.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5acc6c4..ec1c1d2 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2131,6 +2131,14 @@ static int add_sendcmd_reject(__u8 cmd, int ctlr, unsigned long complete)
 		       ctlr, complete);
 		/* not much we can do. */
 #ifdef CONFIG_CISS_SCSI_TAPE
+		/* We might get notification of completion of commands
+		 * which we never issued in this kernel if this boot is
+		 * taking place after previous kernel's crash. Simply
+		 * ignore the commands in this case.
+		 */
+		if (reset_devices)
+			return 0;
+
 		return 1;
 	}
 

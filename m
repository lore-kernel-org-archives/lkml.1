Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbXIBUHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbXIBUHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXIBUG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:06:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56849 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbXIBUG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:06:57 -0400
Date: Mon, 3 Sep 2007 01:50:05 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Eric Moore <Eric.Moore@lsi.com>,
       James Bottomley <james.bottomley@steeleye.com>, support@lsi.com,
       mpt_linux_developer@lsi.com
Subject: [PATCH -mm] mpt fusion: Shut up uninitialized variable warnings
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030148590.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-781556762-1188764408=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-781556762-1188764408=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


drivers/message/fusion/mptctl.c: In function ‘mptctl_mpt_command’:
drivers/message/fusion/mptctl.c:1764: warning: ‘bufIn.len’ may be used uninitialized in this function
drivers/message/fusion/mptctl.c:1765: warning: ‘bufOut.len’ may be used uninitialized in this function

come because gcc gets confused by some "goto" statements in above function.
The warnings have been verified to be bogus, however, the function does
initialize these later (after the offending goto's) in the function anyway.
So let's move those initializations to top of function, thereby also shutting
up these warnings.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/message/fusion/mptctl.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc4-mm1/drivers/message/fusion/mptctl.c~fix	2007-09-02 21:51:14.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/message/fusion/mptctl.c	2007-09-02 21:54:25.000000000 +0530
@@ -1773,7 +1773,10 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	ulong 		timeout;
 	struct scsi_device *sdev;
 
+	/* bufIn and bufOut are used for user to kernel space transfers
+	 */
 	bufIn.kptr = bufOut.kptr = NULL;
+	bufIn.len = bufOut.len = 0;
 
 	if (((iocnum = mpt_verify_adapter(karg.hdr.iocnum, &ioc)) < 0) ||
 	    (ioc == NULL)) {
@@ -2107,11 +2110,6 @@ mptctl_do_mpt_command (struct mpt_ioctl_
 	psge = (char *) (((int *) mf) + karg.dataSgeOffset);
 	flagsLength = 0;
 
-	/* bufIn and bufOut are used for user to kernel space transfers
-	 */
-	bufIn.kptr = bufOut.kptr = NULL;
-	bufIn.len = bufOut.len = 0;
-
 	if (karg.dataOutSize > 0)
 		sgSize ++;
 
--464262402-781556762-1188764408=:29617--

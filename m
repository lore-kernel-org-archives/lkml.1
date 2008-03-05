Return-Path: <linux-kernel-owner+w=401wt.eu-S1762454AbYCEHmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762454AbYCEHmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbYCEHlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:41:12 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:60391 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760356AbYCEHlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:41:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tRJR0qMlWvxf+uHl54++yOQz7wZyrc1fxRBi2J/J+jUB2B6KTpdy2NjFiIBcDyLBG8C+sDruY8O4QG3EZSB6I2xenxG4vxwsD2ZS57gSxIzcIPjRNUHQKZfT22tHhmL5G77BO+3VNPVq8Xiq/sdmbJKGZKN2EXw0inZe+qmNHQk=
Subject: [PATCH 3/3] scsi: ch.c fix shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 23:40:56 -0800
Message-Id: <1204702856.17484.20.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err shadows the array of errors in this driver, switch to ch_err
drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
drivers/scsi/ch.c:116:3: originally declared here

cmd shadows the argument to this function, switch to ch_cmd
drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
drivers/scsi/ch.c:596:20: originally declared here

Small code cleanup as well in if() statement.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/ch.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7aad154..f9c3f3a 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -268,16 +268,16 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
 static int
 ch_init_elem(scsi_changer *ch)
 {
-	int err;
+	int ch_err;
 	u_char cmd[6];
 
 	vprintk("INITIALIZE ELEMENT STATUS, may take some time ...\n");
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
 	cmd[1] = ch->device->lun << 5;
-	err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
+	ch_err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
 	vprintk("... finished\n");
-	return err;
+	return ch_err;
 }
 
 static int
@@ -721,7 +721,7 @@ static long ch_ioctl(struct file *file,
 	case CHIOGELEM:
 	{
 		struct changer_get_element cge;
-		u_char  cmd[12];
+		u_char  ch_cmd[12];
 		u_char  *buffer;
 		unsigned int elem;
 		int     result,i;
@@ -739,17 +739,18 @@ static long ch_ioctl(struct file *file,
 		mutex_lock(&ch->lock);
 
 	voltag_retry:
-		memset(cmd,0,sizeof(cmd));
-		cmd[0] = READ_ELEMENT_STATUS;
-		cmd[1] = (ch->device->lun << 5) |
-			(ch->voltags ? 0x10 : 0) |
-			ch_elem_to_typecode(ch,elem);
-		cmd[2] = (elem >> 8) & 0xff;
-		cmd[3] = elem        & 0xff;
-		cmd[5] = 1;
-		cmd[9] = 255;
-
-		if (0 == (result = ch_do_scsi(ch, cmd, buffer, 256, DMA_FROM_DEVICE))) {
+		memset(ch_cmd,0,sizeof(ch_cmd));
+		ch_cmd[0] = READ_ELEMENT_STATUS;
+		ch_cmd[1] = (ch->device->lun << 5) |
+			    (ch->voltags ? 0x10 : 0) |
+			    ch_elem_to_typecode(ch,elem);
+		ch_cmd[2] = (elem >> 8) & 0xff;
+		ch_cmd[3] = elem        & 0xff;
+		ch_cmd[5] = 1;
+		ch_cmd[9] = 255;
+
+		result = ch_do_scsi(ch, ch_cmd, buffer, 256, DMA_FROM_DEVICE);
+		if (!result) {
 			cge.cge_status = buffer[18];
 			cge.cge_flags = 0;
 			if (buffer[18] & CESTATUS_EXCEPT) {
-- 
1.5.4.GIT


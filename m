Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZGSNHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZGSNHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 09:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbZGSNHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 09:07:39 -0400
Received: from bu3sch.de ([62.75.166.246]:41833 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZGSNHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 09:07:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] DAC960: Fix undefined behavior on empty string
Date: Sun, 19 Jul 2009 15:05:47 +0200
User-Agent: KMail/1.9.9
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907191505.47243.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes undefined behavior due to buffer underrun,
if an empty string is written to the proc file.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: stable@kernel.org

---

This patch is untested, because I do not have the hardware.

---
 drivers/block/DAC960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/block/DAC960.c
+++ linux-2.6/drivers/block/DAC960.c
@@ -6555,21 +6555,21 @@ static int DAC960_ProcWriteUserCommand(s
 				       const char __user *Buffer,
 				       unsigned long Count, void *Data)
 {
   DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
   unsigned char CommandBuffer[80];
   int Length;
   if (Count > sizeof(CommandBuffer)-1) return -EINVAL;
   if (copy_from_user(CommandBuffer, Buffer, Count)) return -EFAULT;
   CommandBuffer[Count] = '\0';
   Length = strlen(CommandBuffer);
-  if (CommandBuffer[Length-1] == '\n')
+  if (Length > 0 && CommandBuffer[Length-1] == '\n')
     CommandBuffer[--Length] = '\0';
   if (Controller->FirmwareType == DAC960_V1_Controller)
     return (DAC960_V1_ExecuteUserCommand(Controller, CommandBuffer)
 	    ? Count : -EBUSY);
   else
     return (DAC960_V2_ExecuteUserCommand(Controller, CommandBuffer)
 	    ? Count : -EBUSY);
 }
 
 

-- 
Greetings, Michael.

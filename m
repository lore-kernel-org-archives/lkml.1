Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZBCIOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZBCIOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZBCIOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:14:43 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:47085 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZBCIOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:14:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=S3n6G7Zzlgf10ZpWeVIaJxBvC6AWlu1NJOLmNO5wXqnLjKui1Jrrkc+e68HOHSXD9S
         Rto0R+OMW0oKaq3il4u2zpOvG9Lip5YyYBb8mUtLQXIw5XWJIn/4Itudi4UllJ6+Bq5I
         gduQAnfTNfvwwd4/ZgrgadVmZds3S3G2MLx3g=
Date: Tue, 3 Feb 2009 11:14:21 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bikeee
To: R.E.Wolff@BitWizard.nl
cc: linux-kernel@vger.kernel.org
Subject: [patch] unlock_kernel() on error path in sx_fw_ioctl()
Message-ID: <alpine.DEB.2.00.0902030829580.31813@bikeee>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we return directly with -EPERM then lock_kernel() is still held.

This was found with a code checker (http://repo.or.cz/w/smatch.git/). 
Compile tested only, sorry.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/char/sx.c	2009-02-03 08:27:59.000000000 +0300
+++ devel/drivers/char/sx.c	2009-02-03 08:28:31.000000000 +0300
@@ -1747,7 +1747,8 @@
  		break;
  	case SXIO_DO_RAMTEST:
  		if (sx_initialized)	/* Already initialized: better not ramtest the board.  */
-			return -EPERM;
+			rc = -EPERM;
+			break;
  		if (IS_SX_BOARD(board)) {
  			rc = do_memtest(board, 0, 0x7000);
  			if (!rc)

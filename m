Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbZBDFEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbZBDFEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZBDFEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:04:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbZBDFEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:04:35 -0500
Date: Tue, 3 Feb 2009 20:58:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <error27@gmail.com>
Cc: R.E.Wolff@BitWizard.nl, linux-kernel@vger.kernel.org
Subject: Re: [patch] unlock_kernel() on error path in sx_fw_ioctl()
Message-Id: <20090203205857.a2b4b1c1.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0902030829580.31813@bikeee>
References: <alpine.DEB.2.00.0902030829580.31813@bikeee>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 11:14:21 +0300 (EAT) Dan Carpenter <error27@gmail.com> wrote:

> If we return directly with -EPERM then lock_kernel() is still held.
> 
> This was found with a code checker (http://repo.or.cz/w/smatch.git/). 
> Compile tested only, sorry.
> 
> regards,
> dan carpenter
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> --- orig/drivers/char/sx.c	2009-02-03 08:27:59.000000000 +0300
> +++ devel/drivers/char/sx.c	2009-02-03 08:28:31.000000000 +0300
> @@ -1747,7 +1747,8 @@
>   		break;
>   	case SXIO_DO_RAMTEST:
>   		if (sx_initialized)	/* Already initialized: better not ramtest the board.  */
> -			return -EPERM;
> +			rc = -EPERM;
> +			break;
>   		if (IS_SX_BOARD(board)) {
>   			rc = do_memtest(board, 0, 0x7000);
>   			if (!rc)

Yawn.  return-deep-inside-a-large-function strikes again.

We might as well fix the other one while we're there:

From: Andrew Morton <akpm@linux-foundation.org>

fix another such path - missed func_exit().

Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/sx.c~sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix drivers/char/sx.c
--- a/drivers/char/sx.c~sxc-fix-missed-unlock_kernel-on-error-path-in-sx_fw_ioctl-fix
+++ a/drivers/char/sx.c
@@ -1713,8 +1713,8 @@ static long sx_fw_ioctl(struct file *fil
 		for (i = 0; i < SX_NBOARDS; i++)
 			sx_dprintk(SX_DEBUG_FIRMWARE, "<%x> ", boards[i].flags);
 		sx_dprintk(SX_DEBUG_FIRMWARE, "\n");
-		unlock_kernel();
-		return -EIO;
+		rc = -EIO;
+		goto out;
 	}
 
 	switch (cmd) {
@@ -1845,6 +1845,7 @@ static long sx_fw_ioctl(struct file *fil
 		rc = -ENOTTY;
 		break;
 	}
+out:
 	unlock_kernel();
 	func_exit();
 	return rc;
_


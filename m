Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYGZPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYGZPCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYGZPCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:02:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:65216 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYGZPCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vsprFXWAZLt+UDrmO6yGhS+upGSKMmDqy9mHxlRYh7w78WGJGVTdhAFMTQOwxYkqw1
         gvLL+09GSeBYI/Uojrim5sBVD8WhoPrlFHdeg4x0qbdRnvCwYZQ0SvoaUT20B9FQA91u
         aBiD9ihph2tYe0VAIHUF8VFhNNlZUM/8YbJGA=
Date: Sun, 27 Jul 2008 00:02:20 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       tim@physik3.uni-rostock.de, linux-kernel@vger.kernel.org
Subject: [PATCH] nwflash: fix build errors and warning
Message-ID: <20080726150155.GA3562@localhost.localdomain>
References: <200807250848.m6P8mIWF001718@imap1.linux-foundation.org> <20080726141808.GB8871@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080726141808.GB8871@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 03:18:08PM +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 25, 2008 at 01:48:18AM -0700, akpm@linux-foundation.org wrote:
> > From: Akinobu Mita <akinobu.mita@gmail.com>
> > 
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Tim Schmielau <tim@physik3.uni-rostock.de>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Argh...  Are people now submitting untested patches as a rule?
> 
> drivers/char/nwflash.c: In function 'flash_read':
> drivers/char/nwflash.c:129: error: 'p' undeclared (first use in this function)
> drivers/char/nwflash.c:129: error: (Each undeclared identifier is reported only once
> drivers/char/nwflash.c:129: error: for each function it appears in.)
> drivers/char/nwflash.c:129: error: 'count' undeclared (first use in this function)
> drivers/char/nwflash.c:136: warning: passing argument 4 of 'simple_read_from_buffer' discards qualifiers from pointer target type
> make[2]: *** [drivers/char/nwflash.o] Error 1
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2

Sorry. I'm preparing cross compiler. But this patch should fix this
problem.

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: nwflash: fix build errors and warning

The commit 6ee8928d94841aa764aeaf645ad16daff811dc26
(nwflash: use simple_read_from_buffer()) broke nwflash.

drivers/char/nwflash.c: In function 'flash_read':
drivers/char/nwflash.c:129: error: 'p' undeclared (first use in this function)
drivers/char/nwflash.c:129: error: (Each undeclared identifier is reported only once
drivers/char/nwflash.c:129: error: for each function it appears in.)
drivers/char/nwflash.c:129: error: 'count' undeclared (first use in this function)
drivers/char/nwflash.c:136: warning: passing argument 4 of 'simple_read_from_buffer' discards qualifiers from pointer target type
make[2]: *** [drivers/char/nwflash.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/char/nwflash.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: 2.6-mm/drivers/char/nwflash.c
===================================================================
--- 2.6-mm.orig/drivers/char/nwflash.c
+++ 2.6-mm/drivers/char/nwflash.c
@@ -126,14 +126,15 @@ static ssize_t flash_read(struct file *f
 
 	if (flashdebug)
 		printk(KERN_DEBUG "flash_read: flash_read: offset=0x%lX, "
-		       "buffer=%p, count=0x%X.\n", p, buf, count);
+		       "buffer=%p, count=0x%zX.\n", *ppos, buf, size);
 	/*
 	 * We now lock against reads and writes. --rmk
 	 */
 	if (mutex_lock_interruptible(&nwflash_mutex))
 		return -ERESTARTSYS;
 
-	ret = simple_read_from_buffer(buf, size, ppos, FLASH_BASE, gbFlashSize);
+	ret = simple_read_from_buffer(buf, size, ppos, (void *)FLASH_BASE,
+					gbFlashSize);
 	mutex_unlock(&nwflash_mutex);
 
 	return ret;

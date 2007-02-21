Return-Path: <linux-kernel-owner+w=401wt.eu-S1422678AbXBUTTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422678AbXBUTTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422824AbXBUTTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:19:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38934 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422678AbXBUTTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:19:33 -0500
Date: Wed, 21 Feb 2007 11:19:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Faik Uygur <faik@pardus.org.tr>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jirislaby@gmail.com
Subject: Re: Linux 2.6.21-rc1
In-Reply-To: <200702211526.41493.faik@pardus.org.tr>
Message-ID: <Pine.LNX.4.64.0702211118350.4043@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
 <200702211526.41493.faik@pardus.org.tr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Feb 2007, Faik Uygur wrote:
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   CC [M]  drivers/char/ip2/ip2main.o
> In file included from drivers/char/ip2/ip2main.c:285:
> drivers/char/ip2/i2lib.c: In function `iiSendPendingMail_t':
> drivers/char/ip2/i2lib.c:83: sorry, unimplemented: inlining failed in call 
> to 'iiSendPendingMail': function body not available
> drivers/char/ip2/i2lib.c:157: sorry, unimplemented: called from here
> make[3]: *** [drivers/char/ip2/ip2main.o] Error 1
> make[2]: *** [drivers/char/ip2] Error 2
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2

Yeah, that thing was crud.

		Linus

---
commit 5fc7e655a50b0a19229a6b4a8a5e23bfedf700a4
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Wed Feb 21 11:18:26 2007 -0800

    Fix bogus 'inline' in drivers/char/ip2/i2lib.c
    
    Not only was the function way too big to be inlined in the first place,
    it was used before it was even defined.
    
    Noted-by: Faik Uygur <faik@pardus.org.tr>
    Cc: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/char/ip2/i2lib.c b/drivers/char/ip2/i2lib.c
index f86fa0c..e46120d 100644
--- a/drivers/char/ip2/i2lib.c
+++ b/drivers/char/ip2/i2lib.c
@@ -80,7 +80,7 @@ static int i2RetryFlushOutput(i2ChanStrPtr);
 // Not a documented part of the library routines (careful...) but the Diagnostic
 // i2diag.c finds them useful to help the throughput in certain limited
 // single-threaded operations.
-static inline void iiSendPendingMail(i2eBordStrPtr);
+static void iiSendPendingMail(i2eBordStrPtr);
 static void serviceOutgoingFifo(i2eBordStrPtr);
 
 // Functions defined in ip2.c as part of interrupt handling
@@ -166,7 +166,7 @@ static void iiSendPendingMail_t(unsigned long data)
 // If any outgoing mail bits are set and there is outgoing mailbox is empty,
 // send the mail and clear the bits.
 //******************************************************************************
-static inline void
+static void
 iiSendPendingMail(i2eBordStrPtr pB)
 {
 	if (pB->i2eOutMailWaiting && (!pB->i2eWaitingForEmptyFifo) )

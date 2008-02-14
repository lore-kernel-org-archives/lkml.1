Return-Path: <linux-kernel-owner+w=401wt.eu-S1763934AbYBNBcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763934AbYBNBcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933785AbYBNBcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:32:17 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:10526 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759014AbYBNBcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JoQtFT9V9SvONM6zMLIfGahm/saV4tlOyLVd5fpslD+pRLGrkSMLxEwFYIb1gMekSi7akauZfXihe4RKxjBE8ChuxN9+y/5T/F6XHgOakICKHvPvj3DdS0pIrtaWTvGPBN7bcLyGsOdvY1UMhKeIsLtFBUrrKjv4vJVRfaTMprs=
Message-ID: <47B39A17.9080509@gmail.com>
Date: Thu, 14 Feb 2008 10:32:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH UPDATED] printk: fix possible printk buffer overrun introduced
 with recursion check
References: <47B2AE7C.608@gmail.com> <20080213124548.GB6344@elte.hu> <47B38718.4030509@gmail.com>
In-Reply-To: <47B38718.4030509@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk recursion detection prepends message to printk_buf and offsets
printk_buf when actual message is printed but it forgets to trim
buffer length accordingly.  This can result in buffer overrun in
extreme cases.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
Splitted out fix portion.

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index bee3610..9adc2a4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -666,7 +666,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	}
 	/* Emit the output into the temporary buffer */
 	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf), fmt, args);
+				  sizeof(printk_buf) - printed_len, fmt, args);
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbXLEOMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbXLEOMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXLEOMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:12:10 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:41725 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbXLEOMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:12:08 -0500
Date: Wed, 5 Dec 2007 19:42:02 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, rsa@us.ibm.com,
       apw@shadowen.org, balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on powerpc
Message-ID: <20071205141202.GB13189@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071204211701.994dfce6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.24-rc4-mm1 kernel build fails with build failure,

  CC      drivers/char/hvcs.o
drivers/char/hvcs.c: In function ‘hvcs_open’:
drivers/char/hvcs.c:1180: error: wrong type argument to unary exclamation mark
make[2]: *** [drivers/char/hvcs.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

The kref_get begin void return type, check for the kobject return type
as in the previous kobject_get()
 
        if (!kref_get(&hvcsd->kref)) {
                spin_unlock_irqrestore(&hvcsd->lock, flags); 
                printk(KERN_ERR "HVCS: Kobject of open"
                        " hvcs doesn't exist.\n");
                return -EFAULT; /* Is this the right return value? */
        }

I have tested for the build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.24-rc4/drivers/char/hvcs.c	2007-12-05 12:17:37.000000000 +0530
+++ linux-2.6.24-rc4/drivers/char/~hvcs.c	2007-12-05 19:17:12.000000000 +0530
@@ -1177,12 +1177,8 @@ fast_open:
 	hvcsd = tty->driver_data;
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
-	if (!kref_get(&hvcsd->kref)) {
-		spin_unlock_irqrestore(&hvcsd->lock, flags);
-		printk(KERN_ERR "HVCS: Kobject of open"
-			" hvcs doesn't exist.\n");
-		return -EFAULT; /* Is this the right return value? */
-	}
+	kref_get(&hvcsd->kref);
+	spin_unlock_irqrestore(&hvcsd->lock, flags);
 
 	hvcsd->open_count++;
 

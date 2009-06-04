Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZFDUdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZFDUdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZFDUdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:33:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59023 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZFDUdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:33:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:subject:message-id:user-agent:mime-version:content-type;
	b=hoCPRi8NG0gDDYobEp6NSG16XPXW6a5yTTrtNsfjIIE7+AzEiSLa7mwv49ns4k/j3
	EyObXpXzOsn04PcORUtkA==
Date: Thu, 4 Jun 2009 13:32:55 -0700 (PDT)
From: Salman Qazi <sqazi@google.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: A bug in read operation for /dev/zero and a proposed fix.
Message-ID: <alpine.DEB.1.00.0906041330170.32557@bumblebee1.mtv.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running 20 parallel instances of dd as follows:

#!/bin/bash

for i in `seq 1 20`; do
         dd if=/dev/zero of=/export/hda3/dd_$i bs=1073741824 count=1 &
done
wait

on a 16G machine, we noticed that rather than just killing the
processes, the entire kernel went down.  Stracing dd reveals that it first
does an mmap2, which makes 1GB worth of zero page mappings.  Then it 
performs
a read on those pages from /dev/zero, and finally it performs a write. 
The
machine died during the reads.  Looking at the code, it was noticed that
/dev/zero's read operation had been changed at some point from giving
zero page mappings to actually zeroing the page.  The zeroing of the
pages causes physical pages to be allocated to the process.  But, when
the process exhausts all the memory that it can, the kernel cannot kill
it, as it is still in the kernel mode allocating more memory. 
Consequently,
the kernel eventually crashes.

To fix this, I propose that when a fatal signal is pending during
/dev/zero read operation, we simply return and let the user process die.
Here is a patch that does that.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8f05c38..2ffa36e 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -696,6 +696,11 @@ static ssize_t read_zero(struct file * file, char __user * buf,
  			break;
  		buf += chunk;
  		count -= chunk;
+		/* The exit code here doesn't actually matter, as userland
+		 * will never see it.
+		 */
+		if (fatal_signal_pending(current))
+			return -ENOMEM;
  		cond_resched();
  	}
  	return written ? written : -EFAULT;

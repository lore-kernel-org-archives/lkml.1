Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbXFVAOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbXFVAOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 20:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbXFVAOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 20:14:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54884 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbXFVAN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 20:13:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=CGcvkN0wWASVirFGGCmyFtDD0NZjPFbe4Uee/YkW1cWOwrWrzxzXhe1jTLcrEBpXN
	o35tsMBKTCgr1XzdPvA/g==
Date: Thu, 21 Jun 2007 17:13:49 -0700 (PDT)
From: Joshua Wise <jwise@google.com>
X-X-Sender: jwise@internets.corp.google.com
To: linux-kernel@vger.kernel.org
cc: ak@suse.de, thockin@google.com, akpm@google.com
Subject: [PATCH] x86_64: Fix misplaced `continue' in mce.c
Message-ID: <Pine.LNX.4.64.0706211706270.30728@internets.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joshua Wise <jwise@google.com>

Background:
  When a userspace application wants to know about machine check events, it
  opens /dev/mcelog and does a read(). Usually, we found that this interface
  works well, but in some cases, when the system was taking large numbers of
  machine check exceptions, the read() would hang. The system would output a
  soft-lockup warning, and the daemon reading from /dev/mcelog would suck up
  as much of a single CPU as it could spinning in system space.

Description:
  This patch fixes this bug. In particular, there was a "continue" inside a
  timeout loop that presumably was intended to break out of the outer loop,
  but instead caused the inner loop to continue. This patch also makes the
  condition for the break-out a little more evident by changing a
  !time_before to a time_after_eq.

Result:
  The read() no longer hangs in this test case.

Testing:
  On my system, I could replicate the bug with the following command:
    # for i in `seq 15000`; do ./inject_sbe.sh; done
  where inject_sbe.sh contains commands to inject a single-bit error into the
  next memory write transaction.

Patch:
  This patch is against git f1518a088bde6aea49e7c472ed6ab96178fcba3e.

Signed-off-by: Joshua Wise <jwise@google.com>
Signed-off-by: Tim Hockin <thockin@google.com>

--

diff --git a/arch/x86_64/kernel/mce.c b/arch/x86_64/kernel/mce.c
index a14375d..aa83023 100644
--- a/arch/x86_64/kernel/mce.c
+++ b/arch/x86_64/kernel/mce.c
@@ -497,15 +497,17 @@ static ssize_t mce_read(struct file *fil
  	for (i = 0; i < next; i++) {
  		unsigned long start = jiffies;
  		while (!mcelog.entry[i].finished) {
-			if (!time_before(jiffies, start + 2)) {
+			if (time_after_eq(jiffies, start + 2)) {
  				memset(mcelog.entry + i,0, sizeof(struct mce));
-				continue;
+				goto timeout;
  			}
  			cpu_relax();
  		}
  		smp_rmb();
  		err |= copy_to_user(buf, mcelog.entry + i, sizeof(struct mce));
  		buf += sizeof(struct mce); 
+	 timeout:
+	 	;
  	}

  	memset(mcelog.entry, 0, next * sizeof(struct mce));

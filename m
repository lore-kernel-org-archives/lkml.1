Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbXLRRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbXLRRbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbXLRRb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:31:28 -0500
Received: from mout1.freenet.de ([195.4.92.91]:50976 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbXLRRb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:31:27 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] 2.6.24-rcx: Make sys_poll() wait at least timeout ms
Date: Tue, 18 Dec 2007 18:31:23 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181831.24202.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while playing with jackd on 2.6.24-rcx, I found poll() timing out too early.
That is: earlier than its timeout argument specified.
Setting poll()'s timeout argument to "required timeout" + "1 jiffy in ms"
fixed it. Patch below should fix it too. Correct?
Untested.
Otherwise 2.6.24-rc5 ticks just fine here, thanks.

      Karsten
 
------------->
Make sys_poll() wait at least timeout ms

schedule_timeout(jiffies) waits for at least jiffies - 1.
Add 1 jiffie to the timeout_jiffies calculated in sys_poll() to wait at least
timeout_msecs, like poll() manpage says.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
---
 fs/select.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 47f4792..5633fe9 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -739,7 +739,7 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 			timeout_jiffies = -1;
 		else
 #endif
-			timeout_jiffies = msecs_to_jiffies(timeout_msecs);
+			timeout_jiffies = msecs_to_jiffies(timeout_msecs) + 1;
 	} else {
 		/* Infinite (< 0) or no (0) timeout */
 		timeout_jiffies = timeout_msecs;
-- 
1.5.3.6


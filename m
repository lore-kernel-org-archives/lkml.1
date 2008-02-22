Return-Path: <linux-kernel-owner+w=401wt.eu-S1763357AbYBVSes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763357AbYBVSes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbYBVSe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:34:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:31277 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762845AbYBVSe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Lb9yY2M9g/QKRAYKQn8XnHDlLr1HQXL7qyq1XVfm7T8y6/SHvA1INPFXUc4+ePJzy0CdurftstQDmTm3InPdo2Be2/lM3LH6NB5TAUHxG0uQGrAUhWAXf2nwk+43fJeB+OXmh0K2t7lGVQX3ik0LJ2tYZmb3BVqSGOch0bDG3cI=
Subject: [PATCH 2/2] char: fix possible double-unlock in specialix.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 10:34:44 -0800
Message-Id: <1203705284.5962.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse, trivial to see:
drivers/char/specialix.c:2112:3: warning: context imbalance in 'sx_throttle' - unexpected unlock

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
And with the torrent of warnings fixed, here we find a double-unlock.

 drivers/char/specialix.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 5487f37..b508e2c 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -2109,7 +2109,6 @@ static void sx_throttle(struct tty_struct * tty)
 	sx_out(bp, CD186x_CAR, port_No(port));
 	spin_unlock_irqrestore(&bp->lock, flags);
 	if (I_IXOFF(tty)) {
-		spin_unlock_irqrestore(&bp->lock, flags);
 		sx_wait_CCR(bp);
 		spin_lock_irqsave(&bp->lock, flags);
 		sx_out(bp, CD186x_CCR, CCR_SSCH2);
-- 
1.5.4.2.200.g99e75


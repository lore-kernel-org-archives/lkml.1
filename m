Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbYBVSu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbYBVSu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756244AbYBVSus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:50:48 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:19228 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbYBVSur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:50:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Usut0y4EcJph21MONaRhdbWRA+uNAagF6egNHWaEqvBfj8tKfRi+OQHrNxCzK1E12Ds+6dTtDTpv7Cpqdcc6+IWY0mB4IKs6r1cBXBk6oYcPkilHW4IMvkF753vG4f1v9Yx/PqVD5ZGtu2HaKCzDX6OTol2ovFPTrYdTz9WU3Pg=
Subject: [PATCH 1/2] char: hide sparse expensive pointer subtraction
	warning in specialix.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Bernd Petrovitsch <bernd@firmix.at>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203705247.5962.17.camel@brick>
References: <1203705247.5962.17.camel@brick>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 10:51:05 -0800
Message-Id: <1203706265.5962.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warnings come from two static inlines so the ugliness in hiding them
is well contained.
drivers/char/specialix.c:238:19: warning: potentially expensive pointer subtraction
drivers/char/specialix.c:245:19: warning: potentially expensive pointer subtraction

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Bernd noticed that I'm an idiot.  I was only hiding them to see what else
was in the file.  This patch is at least functionally correct.

Brown-paper-bagged-by: Harvey Harrison

 drivers/char/specialix.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index c0e08c7..34c7de6 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -228,21 +228,21 @@ static inline int sx_paranoia_check(struct specialix_port const * port,
 /* Get board number from pointer */
 static inline int board_No (struct specialix_board * bp)
 {
-	return bp - sx_board;
+	return ((char *)bp - (char *)sx_board) / sizeof(*bp);
 }
 
 
 /* Get port number from pointer */
 static inline int port_No (struct specialix_port const * port)
 {
-	return SX_PORT(port - sx_port);
+	return SX_PORT(((char *)port - (char *)sx_port) / sizeof(*port));
 }
 
 
 /* Get pointer to board from pointer to port */
 static inline struct specialix_board * port_Board(struct specialix_port const * port)
 {
-	return &sx_board[SX_BOARD(port - sx_port)];
+	return &sx_board[SX_BOARD(port_No(port))];
 }
 
 
-- 
1.5.4.2.200.g99e75



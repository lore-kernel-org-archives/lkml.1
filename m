Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbXCEWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbXCEWkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932473AbXCEWkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:40:45 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:7671 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbXCEWkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:40:31 -0500
Date: Mon, 5 Mar 2007 23:40:32 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: holzheu@de.ibm.com
Subject: [S390] tape: Compression overwrites crypto setting
Message-ID: <20070305224032.GE22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

[S390] tape: Compression overwrites crypto setting

After switching compression on/off with the mt command, tape encryption is no
longer working. The reason for that is, that the modeset_byte is set to
the compression value instead of using bitwise and/or bit operations to
enable/disable the corresponding bit.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/tape_std.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/char/tape_std.c linux-2.6-patched/drivers/s390/char/tape_std.c
--- linux-2.6/drivers/s390/char/tape_std.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/tape_std.c	2007-03-05 22:51:51.000000000 +0100
@@ -647,7 +647,10 @@ tape_std_mtcompression(struct tape_devic
 		return PTR_ERR(request);
 	request->op = TO_NOP;
 	/* setup ccws */
-	*device->modeset_byte = (mt_count == 0) ? 0x00 : 0x08;
+	if (mt_count == 0)
+		*device->modeset_byte &= ~0x08;
+	else
+		*device->modeset_byte |= 0x08;
 	tape_ccw_cc(request->cpaddr, MODE_SET_DB, 1, device->modeset_byte);
 	tape_ccw_end(request->cpaddr + 1, NOP, 0, NULL);
 	/* execute it */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbZLKPhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbZLKPhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbZLKPhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:37:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:57535 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180AbZLKPhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:37:14 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Roel Kluin <roel.kluin@gmail.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/9] kgdbts: Read buffer overflow
Date: Fri, 11 Dec 2009 09:36:11 -0600
Message-Id: <1260545777-8089-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1260545777-8089-3-git-send-email-jason.wessel@windriver.com>
References: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 Dec 2009 15:36:32.0378 (UTC) FILETIME=[B705ADA0:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

Prevent write to put_buf[BUFMAX] in kgdb test suite.

If put_buf_cnt was BUFMAX - 1 at the earlier test,
`\0' is written to put_buf[BUFMAX].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/misc/kgdbts.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index e4ff50b..2ab0492 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -712,6 +712,12 @@ static int run_simple_test(int is_get_char, int chr)
 
 	/* End of packet == #XX so look for the '#' */
 	if (put_buf_cnt > 3 && put_buf[put_buf_cnt - 3] == '#') {
+		if (put_buf_cnt >= BUFMAX) {
+			eprintk("kgdbts: ERROR: put buffer overflow on"
+				" '%s' line %i\n", ts.name, ts.idx);
+			put_buf_cnt = 0;
+			return 0;
+		}
 		put_buf[put_buf_cnt] = '\0';
 		v2printk("put%i: %s\n", ts.idx, put_buf);
 		/* Trigger check here */
-- 
1.6.4.rc1


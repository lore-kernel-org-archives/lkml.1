Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZKTQoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZKTQoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZKTQn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:43:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38980 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbZKTQkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:40:55 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 05/15] flash_read should update ppos instead of file->f_pos
Date: Fri, 20 Nov 2009 17:40:35 +0100
Message-Id: <1258735245-25826-6-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flash_read() updates file->f_pos directly instead of the ppos given. The
VFS later updates the file->f_pos and overwrites it with the unchanged
value of ppos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/sbus/char/flash.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index 4108347..12cd438 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -106,9 +106,9 @@ static ssize_t
 flash_read(struct file * file, char __user * buf,
 	   size_t count, loff_t *ppos)
 {
-	unsigned long p = file->f_pos;
+	loff_t p = *ppos;
 	int i;
-	
+
 	if (count > flash.read_size - p)
 		count = flash.read_size - p;
 
@@ -119,7 +119,7 @@ flash_read(struct file * file, char __user * buf,
 		buf++;
 	}
 
-	file->f_pos += count;
+	*ppos += count;
 	return count;
 }
 
-- 
1.6.4.2


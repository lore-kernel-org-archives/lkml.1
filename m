Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZJKNqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZJKNqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 09:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZJKNq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 09:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbZJKNq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 09:46:27 -0400
Date: Sun, 11 Oct 2009 15:45:16 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent Sanders <vince@simtec.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
Message-ID: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Locking in ch_open is covered by the spin_lock, it serializes the calls
to idr_find and scsi_device_get. The BKL appears redundant to me here.

>From b385c85bb5c2579e542cfe55475b729325eb65e1 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 11 Oct 2009 13:06:54 +0200
Subject: [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open

Everything in ch_open is covered by a spin_lock, so the lock_kernel is redundant
Remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/scsi/ch.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index fe11c1d..4ba8b67 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -579,19 +579,16 @@ ch_open(struct inode *inode, struct file *file)
 	scsi_changer *ch;
 	int minor = iminor(inode);
 
-	lock_kernel();
 	spin_lock(&ch_index_lock);
 	ch = idr_find(&ch_index_idr, minor);
 
 	if (NULL == ch || scsi_device_get(ch->device)) {
 		spin_unlock(&ch_index_lock);
-		unlock_kernel();
 		return -ENXIO;
 	}
+	file->private_data = ch;
 	spin_unlock(&ch_index_lock);
 
-	file->private_data = ch;
-	unlock_kernel();
 	return 0;
 }
 
-- 
1.6.0.6


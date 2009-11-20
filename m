Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZKTQk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZKTQk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZKTQky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:40:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:41511 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZKTQkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:40:51 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Willem Riede <osst@riede.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: [PATCH 02/15] osst: Use noop_llseek() instead of default_llseek()
Date: Fri, 20 Nov 2009 17:40:32 +0100
Message-Id: <1258735245-25826-3-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__os_scsi_tape_open() suggests that llseek() doesn't work:
"We really want to do nonseekable_open(inode, filp); here, but some
 versions of tar incorrectly call lseek on tapes and bail out if that
 fails.  So we disallow pread() and pwrite(), but permit lseeks."

Instead of using the fallback default_llseek() the driver should use
noop_llseek() which leaves the file->f_pos untouched but succeeds.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/scsi/osst.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index acb8358..761ca9d 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5619,6 +5619,7 @@ static const struct file_operations osst_fops = {
 	.open =         os_scsi_tape_open,
 	.flush =        os_scsi_tape_flush,
 	.release =      os_scsi_tape_close,
+	.llseek =	noop_llseek,
 };
 
 static int osst_supports(struct scsi_device * SDp)
-- 
1.6.4.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbZJNP72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbZJNP72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZJNP71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:59:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:35767 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbZJNP7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:59:25 -0400
Date: Wed, 14 Oct 2009 15:58:09 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       wim@iguana.be, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, wim@iguana.be, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, mingo@elte.hu
In-Reply-To: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
References: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] nvram: Drop the BKL from nvram_open()
Message-ID: <tip-83cb16727085b18191f45eb0ede6bf1f97d67a7a@git.kernel.org>
Git-Commit-ID: 83cb16727085b18191f45eb0ede6bf1f97d67a7a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:58:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83cb16727085b18191f45eb0ede6bf1f97d67a7a
Gitweb:     http://git.kernel.org/tip/83cb16727085b18191f45eb0ede6bf1f97d67a7a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 14 Oct 2009 17:48:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 17:54:03 +0200

nvram: Drop the BKL from nvram_open()

It's safe to remove the BKL from nvram_open(): there's no open()
versus read() races: nvram_init() is very simple and race-free,
it registers the device then puts it into /proc - there's no
state init to race with.

Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/char/nvram.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 2100a8f..7cf4518 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -329,14 +329,12 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
 
 static int nvram_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	spin_lock(&nvram_state_lock);
 
 	if ((nvram_open_cnt && (file->f_flags & O_EXCL)) ||
 	    (nvram_open_mode & NVRAM_EXCL) ||
 	    ((file->f_mode & FMODE_WRITE) && (nvram_open_mode & NVRAM_WRITE))) {
 		spin_unlock(&nvram_state_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -347,7 +345,6 @@ static int nvram_open(struct inode *inode, struct file *file)
 	nvram_open_cnt++;
 
 	spin_unlock(&nvram_state_lock);
-	unlock_kernel();
 
 	return 0;
 }

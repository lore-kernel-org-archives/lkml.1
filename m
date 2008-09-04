Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYIDOhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYIDOhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYIDOhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:37:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54305 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751481AbYIDOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:37:04 -0400
Date: Thu, 4 Sep 2008 15:35:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: linux-next: Tree for September 3
Message-ID: <20080904153542.6bf58c45@lxorguk.ukuu.org.uk>
In-Reply-To: <20080904001558.875f58b1.akpm@linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<20080903215455.792c78a3.akpm@linux-foundation.org>
	<20080904145744.3f791ca7.sfr@canb.auug.org.au>
	<20080903220546.bd673658.akpm@linux-foundation.org>
	<20080904152015.3145b06e.sfr@canb.auug.org.au>
	<20080903230129.806d54af.akpm@linux-foundation.org>
	<20080904001558.875f58b1.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I cannot revert tty-kref-get-current-tty and I can't immediately spot
> the bug in it.

Nailed it; magic ingredient is SELinux inclusion which then triggers a
leak on a flush unauthorized

diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index d18e6d2..3ef5425 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -430,11 +430,12 @@ fs3270_open(struct inode *inode, struct file *filp)
 		mutex_lock(&tty_mutex);
 		tty = get_current_tty();
 		if (!tty || tty->driver->major != IBM_TTY3270_MAJOR) {
-			mutex_unlock(&tty_mutex);
+			tty_kref_put(tty);
 			rc = -ENODEV;
 			goto out;
 		}
 		minor = tty->index + RAW3270_FIRSTMINOR;
+		tty_kref_put(tty);
 		mutex_unlock(&tty_mutex);
 	}
 	/* Check if some other program is already using fullscreen mode. */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 03fc6a8..c856db8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2122,6 +2122,7 @@ static inline void flush_unauthorized_files(struct files_struct *files)
 
 	mutex_lock(&tty_mutex);
 	tty = get_current_tty();
+	mutex_unlock(&tty_mutex);
 	if (tty) {
 		file_list_lock();
 		file = list_entry(tty->tty_files.next, typeof(*file), f_u.fu_list);
@@ -2138,8 +2139,8 @@ static inline void flush_unauthorized_files(struct files_struct *files)
 			}
 		}
 		file_list_unlock();
+		tty_kref_put(tty);
 	}
-	mutex_unlock(&tty_mutex);
 	/* Reset controlling tty. */
 	if (drop_tty)
 		no_tty();

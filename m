Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419Ab0ATXvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0ATXvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277Ab0ATXvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:51:43 -0500
Received: from kroah.org ([198.145.64.141]:37955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab0ATXuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:50:55 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>,
       stable <stable@kernel.org>
Subject: [PATCH 8/8] tty: fix race in tty_fasync
Date: Wed, 20 Jan 2010 15:50:03 -0800
Message-Id: <1264031403-32239-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100120234759.GC32068@kroah.com>
References: <20100120234759.GC32068@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to keep the lock held over the call to __f_setown() to
prevent a PID race.

Thanks to Al Viro for pointing out the problem, and to Travis for
making us look here in the first place.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tavis Ormandy <taviso@google.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Julien Tinnes <jln@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index f15df40..c6f3b48 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1951,8 +1951,8 @@ static int tty_fasync(int fd, struct file *filp, int on)
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		if (retval)
 			goto out;
 	} else {
-- 
1.6.5.7


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540Ab0AWA3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0AWA3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479Ab0AWA3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:29:25 -0500
Received: from kroah.org ([198.145.64.141]:35020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab0AWASn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:43 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:10 2010
Message-Id: <20100123001110.875409458@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>
Subject: [05/29] tty: fix race in tty_fasync
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 703625118069f9f8960d356676662d3db5a9d116 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1930,8 +1930,8 @@ static int tty_fasync(int fd, struct fil
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		if (retval)
 			goto out;
 	} else {



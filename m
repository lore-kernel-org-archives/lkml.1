Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194Ab0AZTaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab0AZTaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174Ab0AZT3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:29:53 -0500
Received: from kroah.org ([198.145.64.141]:33603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab0AZT3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:29:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 11:16:24 2010
Message-Id: <20100126191624.538119758@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 11:14:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>
Subject: [06/11] tty: fix race in tty_fasync
In-Reply-To: <20100126191730.GA20872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2437,8 +2437,8 @@ static int tty_fasync(int fd, struct fil
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		if (retval)
 			goto out;
 	} else {



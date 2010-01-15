Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988Ab0AOF1G (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 00:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823Ab0AOF1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 00:27:04 -0500
Received: from netz.smurf.noris.de ([213.95.21.43]:43797 "EHLO
	netz.smurf.noris.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab0AOF1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 00:27:04 -0500
X-Greylist: delayed 1139 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2010 00:27:03 EST
Subject: [PATCH] ldisc switching on a HUPped pty hangs the caller
From: Matthias Urlichs <matthias@urlichs.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: {M:U} IT Design
Date: Fri, 15 Jan 2010 06:07:52 +0100
Message-ID: <1263532072.22171.24.camel@kiste>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-Smurf-Spam-Score: -2.6 (--)
X-Smurf-Whitelist: smurf.noris.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling vhangup() and then switching line disciplines results in
incomplete clean-up and a wedged process if it then calls ioctl()
on the pty.

Signed-Off-By: Matthias Urlichs <matthias@urlichs.de>

---
I recently upgraded my gateway machine to 2.6.31. This caused
ppp-over-ssh to stop working. Indeed, the PPP process got wedged into
noninterruptible sleep, which this patch fixes.

(The comment, by the way, seems to be wrong. There was no race.) 

The underlying problem, however, turns out to be the vhangup() syscall
which the SSH server emits before exec'ing pppd. This causes the tty's
HUPPED bit to get set, which in turn causes the above error.

Browbeating sshd into not issuing vhangup() (why does it do that,
anyway? Presumably, using PTMX we can be sure that nobody is hogging the
pty in the first place, right?) means that I now have a working ssh
tunnel.

… until somebody forces me to switch to a 'real' VPN. :-P

---

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index aafdbae..bb92f5e 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -621,9 +621,8 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
 		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
-		mutex_unlock(&tty->ldisc_mutex);
-		tty_ldisc_put(new_ldisc);
-		return -EIO;
+		retval = -EIO;
+		goto out;
 	}
 
 	/* Shutdown the current discipline. */
@@ -652,7 +651,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	/*
 	 *	Allow ldisc referencing to occur again
 	 */
-
+out:
 	tty_ldisc_enable(tty);
 	if (o_tty)
 		tty_ldisc_enable(o_tty);




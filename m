Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbZJBBr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbZJBBr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZJBBde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:34 -0400
Received: from kroah.org ([198.145.64.141]:33259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298AbZJBBda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:18 2009
Message-Id: <20091002012417.976669283@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [073/136] pty_write: dont do a tty_wakeup() when the buffers are full
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=pty_write-don-t-do-a-tty_wakeup-when-the-buffers-are-full.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 202c4675c55ddf6b443c7e057d2dff6b42ef71aa upstream.

Commit ac89a9174 ("pty: don't limit the writes to 'pty_space()' inside
'pty_write()'") removed the pty_space() checking, in order to let the
regular tty buffer code limit the buffering itself.

That was all good, but as a subtle side effect it meant that we'd be
doing a tty_wakeup() even in the case where the buffers were all filled
up, and didn't actually make any progress on the write.

Which sounds innocuous, but it interacts very badly with the ppp_async
code, which has an infinite loop in ppp_async_push() that tries to push
out data to the tty.  When we call tty_wakeup(), that loop ends up
thinking that progress was made (see the subtle interactions between
XMIT_WAKEUP and 'tty_stuffed' for details).  End result: one unhappy ppp
user.

Fixed by noticing when tty_insert_flip_string() didn't actually do
anything, and then not doing any more processing (including, very much
not calling tty_wakeup()).

Bisected-and-tested-by: Peter Volkov <pva@gentoo.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/pty.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -120,8 +120,10 @@ static int pty_write(struct tty_struct *
 		/* Stuff the data into the input queue of the other end */
 		c = tty_insert_flip_string(to, buf, c);
 		/* And shovel */
-		tty_flip_buffer_push(to);
-		tty_wakeup(tty);
+		if (c) {
+			tty_flip_buffer_push(to);
+			tty_wakeup(tty);
+		}
 	}
 	return c;
 }



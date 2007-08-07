Return-Path: <linux-kernel-owner+w=401wt.eu-S935959AbXHGU7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935959AbXHGU7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935427AbXHGUuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:50:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbXHGUuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:50:06 -0400
Date: Tue, 7 Aug 2007 13:44:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, davi@haxent.com.br, mtk-manpages@gmx.net,
       davidel@xmailserver.org
Subject: [2.6.22.2 review 26/84] make timerfd return a u64 and fix the
	__put_user
Message-ID: <20070807204459.GA23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="make-timerfd-return-a-u64-and-fix-the-__put_user.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Davide Libenzi <davidel@xmailserver.org>

Davi fixed a missing cast in the __put_user(), that was making timerfd
return a single byte instead of the full value.

Talking with Michael about the timerfd man page, we think it'd be better to
use a u64 for the returned value, to align it with the eventfd
implementation.

This is an ABI change.  The timerfd code is new in 2.6.22 and if we merge this
into 2.6.23 then we should also merge it into 2.6.22.x.  That will leave a few
early 2.6.22 kernels out in the wild which might misbehave when a future
timerfd-enabled glibc is run on them.

mtk says:
	The difference would be that read() will only return 4 bytes,
	while the application will expect 8.  If the application is
	checking the size of returned value, as it should, then it will
	be able to detect the problem (it could even be sophisticated
	enough to know that if this is a 4-byte return, then it is
	running on an old 2.6.22 kernel).  If the application is not
	checking the return from read(), then its 8-byte buffer will not
	be filled -- the contents of the last 4 bytes will be undefined,
	so the u64 value as a whole will be junk.

	When I wrote up that description above, I forgot a crucial
	detail.  The above description described the difference between
	the new behavior implemented by the patch, and the current
	(i.e., 2.6.22) *intended* behavior.  However, as I originally
	remarked to Davide, the 2.6.22 read() behavior is broken: it
	should return 4 bytes on a read(), but as originally
	implemented, only the least significant byte contained valid
	information.  (In other words, the top 3 bytes of overrun
	information were simply being discarded.)

	So the patch both fixes a bug in the originally intended
	behavior, and changes the intended behavior (to return 8 bytes
	from a read() instead of 4).


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Davi Arnaut <davi@haxent.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/timerfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -95,7 +95,7 @@ static ssize_t timerfd_read(struct file 
 {
 	struct timerfd_ctx *ctx = file->private_data;
 	ssize_t res;
-	u32 ticks = 0;
+	u64 ticks = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
 	if (count < sizeof(ticks))
@@ -130,7 +130,7 @@ static ssize_t timerfd_read(struct file 
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks = (u32)
+			ticks = (u64)
 				hrtimer_forward(&ctx->tmr,
 						hrtimer_cb_get_time(&ctx->tmr),
 						ctx->tintv);
@@ -140,7 +140,7 @@ static ssize_t timerfd_read(struct file 
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (ticks)
-		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
+		res = put_user(ticks, (u64 __user *) buf) ? -EFAULT: sizeof(ticks);
 	return res;
 }
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZJFNFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZJFNFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbZJFNFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:05:32 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58092 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZJFNFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:05:31 -0400
Date: Tue, 6 Oct 2009 16:01:50 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Subject: Re: TTY loosing bytes ?
Message-ID: <20091006130150.GY4452@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20091006094845.GT4452@nokia.com>
 <20091006114528.GV4452@nokia.com>
 <20091006131230.5301f711@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006131230.5301f711@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Oct 2009 13:03:30.0167 (UTC) FILETIME=[66BBF870:01CA4685]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 02:12:30PM +0200, ext Alan Cox wrote:
> > why doesn't receive_buf() return the amount of bytes actually received ?
> 
> You'd have to ask whoever wrote the code in 199something.

fair enough ;-)

> > I see flush_to_ldisc() believes it can flush everything before even
> > calling receive_buf() then it will never act on the possibility of
> > receive_buf() not being able to receive the entire data.
> 
> The ldisc is responsible for maintaining tty->receive_room correctly at
> all times.
> 
> > Am I right ? Should receive_buf() return the amount of bytes actually
> > received ? Also, why isn't receive_room enough to be sure there's
> > enough space to really receive that block of data ?
> 
> I've not seen this reported elsewhere so I assume you are somehow
> tripping a bug in the n_tty ldisc code. The other possibility is that you
> are in canonical mode and some of your input is intentionally discarded
> by the ldisc either as errors, overruns or through things like quoting or
> flow control.

hmm, not canonical, no. I'm falling on the if (tty->real_raw) in
n_tty_receive_buf() for sure. Have prints there.

The following patch helps a whole lot but sometimes it still gets stuck
and I'm now debugging that:

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 2e50f4d..a00bd8d 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1348,7 +1348,7 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
  *	calls one at a time and in order (or using flush_to_ldisc)
  */
 
-static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
+static int n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			      char *fp, int count)
 {
 	const unsigned char *p;
@@ -1356,9 +1356,10 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	int	i;
 	char	buf[64];
 	unsigned long cpuflags;
+	int ret = 0;
 
 	if (!tty->read_buf)
-		return;
+		return 0;
 
 	if (tty->real_raw) {
 		spin_lock_irqsave(&tty->read_lock, cpuflags);
@@ -1370,6 +1371,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		tty->read_cnt += i;
 		cp += i;
 		count -= i;
+		ret += i;
 
 		i = min(N_TTY_BUF_SIZE - tty->read_cnt,
 			N_TTY_BUF_SIZE - tty->read_head);
@@ -1377,8 +1379,11 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		memcpy(tty->read_buf + tty->read_head, cp, i);
 		tty->read_head = (tty->read_head + i) & (N_TTY_BUF_SIZE-1);
 		tty->read_cnt += i;
+		ret += i;
 		spin_unlock_irqrestore(&tty->read_lock, cpuflags);
+
 	} else {
+		ret = count;
 		for (i = count, p = cp, f = fp; i; i--, p++) {
 			if (f)
 				flags = *f++;
@@ -1421,6 +1426,8 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	 */
 	if (tty->receive_room < TTY_THRESHOLD_THROTTLE)
 		tty_throttle(tty);
+
+	return ret;
 }
 
 int is_ignored(int sig)
diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 3108991..e53adb7 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -58,7 +58,7 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_struct *tty, size_t size)
 {
 	struct tty_buffer *p;
 
-	if (tty->buf.memory_used + size > 65536)
+	if (tty->buf.memory_used + size > 96 * 1024)
 		return NULL;
 	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
 	if (p == NULL)
@@ -417,6 +417,7 @@ static void flush_to_ldisc(struct work_struct *work)
 	if (head != NULL) {
 		tty->buf.head = NULL;
 		for (;;) {
+			int copied;
 			int count = head->commit - head->read;
 			if (!count) {
 				if (head->next == NULL)
@@ -439,11 +440,11 @@ static void flush_to_ldisc(struct work_struct *work)
 				count = tty->receive_room;
 			char_buf = head->char_buf_ptr + head->read;
 			flag_buf = head->flag_buf_ptr + head->read;
-			head->read += count;
 			spin_unlock_irqrestore(&tty->buf.lock, flags);
-			disc->ops->receive_buf(tty, char_buf,
+			copied = disc->ops->receive_buf(tty, char_buf,
 							flag_buf, count);
 			spin_lock_irqsave(&tty->buf.lock, flags);
+			head->read += copied;
 		}
 		/* Restore the queue head */
 		tty->buf.head = head;
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 0c4ee9b..e1c940f 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -133,7 +133,7 @@ struct tty_ldisc_ops {
 	/*
 	 * The following routines are called from below.
 	 */
-	void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
+	int	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
 			       char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
 

to me it seems that receive_room is being mis-set as I can see from some
debugging messages I added:

[  517.793792] first: read_cnt 3586 read_head 2904, second: read_cnt 4096 read_head 3414, room 1021
[  517.800994] Fuck, lost bytes (510, 512)!
[  524.998687] first: read_cnt 3591 read_head 3408, second: read_cnt 4096 read_head 3913, room 1016
[  525.005889] Fuck, lost bytes (505, 512)!

and it goes on and on.

With the patch above I still get this messages but it still goes through
since not receive_buf is returning the amount of bytes actually
received. Then flush_to_ldisc() will retry those bytes on the next
iteration. Maybe this is not the desired patch though ?

Thanks a lot for the comments Alan.

-- 
balbi

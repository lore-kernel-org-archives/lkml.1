Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZG0WE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZG0WE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbZG0WEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:04:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbZG0WEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:04:54 -0400
Date: Mon, 27 Jul 2009 15:04:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
In-Reply-To: <20090727224220.0e80b926@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0907271500110.25224@localhost.localdomain>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp>
 <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk> <20090727171213.GB4233@skywalker> <87skgikjr8.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0907271237250.25224@localhost.localdomain> <87ocr5dfpb.fsf@devron.myhome.or.jp> <20090727224220.0e80b926@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Jul 2009, Alan Cox wrote:
> 
> It's theoretically imperfect in the case where you write a vast amount of
> output in one go, the tty is blocked the other end and then you close.
> However in practice that doesn't happen because with tty->low_latency = 1
> we run the pty received n_tty ldisc code in our context so each write
> fires through the entire n_tty ldisc and does flow control synchronously.

An alternative might be something like this.

THIS IS TOTALLY UNTESTED.

This is just meant as a "this kind of approach may be a good idea", and 
just tries to make sure that any delayed work is flushed by closing the 
tty.

No guarantees. It may or may not compile. It may or may not make any 
difference. It might do unspeakable things to your pets. It really is 
meant to be an example of what a "flush" function could/should do. There 
are probably other things/buffers that may need flushing.

		Linus

---
 drivers/char/tty_io.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a3afa0c..1be69af 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -143,6 +143,7 @@ ssize_t redirected_tty_write(struct file *, const char __user *,
 static unsigned int tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
 static int tty_release(struct inode *, struct file *);
+static int tty_flush(struct file *filp, fl_owner_t id);
 long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
 static long tty_compat_ioctl(struct file *file, unsigned int cmd,
@@ -415,6 +416,7 @@ static const struct file_operations tty_fops = {
 	.unlocked_ioctl	= tty_ioctl,
 	.compat_ioctl	= tty_compat_ioctl,
 	.open		= tty_open,
+	.flush		= tty_flush,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
 };
@@ -1831,7 +1833,38 @@ static int tty_open(struct inode *inode, struct file *filp)
 	return ret;
 }
 
+/* This should probably be a generic function */
+static void flush_delayed_work(struct delayed_work *work)
+{
+	if (cancel_delayed_work(work)) {
+		schedule_delayed_work(work, 0);
+		flush_scheduled_work();
+	}
+}
 
+/**
+ *	tty_flush		-	vfs callback for close
+ *	@filp: file pointer for handle to tty
+ *	@id: struct files_struct of owner.
+ *
+ *	Called for every close(), whether the last or not
+ */
+static int tty_flush(struct file *filp, fl_owner_t id)
+{
+	struct tty_struct *tty, *o_tty;
+	struct inode *inode;
+
+	inode = filp->f_path.dentry->d_inode;
+	tty = (struct tty_struct *)filp->private_data;
+
+	if (tty_paranoia_check(tty, inode, "tty_flush"))
+		return 0;
+
+	o_tty = tty->link;
+	if (o_tty)
+		flush_delayed_work(&o_tty->buf.work);
+	return 0;
+}
 
 
 /**


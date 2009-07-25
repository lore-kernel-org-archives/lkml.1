Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZGYMGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZGYMGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 08:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZGYMGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 08:06:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54081 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752441AbZGYMGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 08:06:08 -0400
Date: Sat, 25 Jul 2009 13:07:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090725130703.04c42572@lxorguk.ukuu.org.uk>
In-Reply-To: <20090724182547.GB29851@skywalker>
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<20090724182547.GB29851@skywalker>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > See the thread starting here: ("possible regression with pty.c commit")
> >    http://lkml.org/lkml/2009/7/11/125
> 
> I am also facing a similar problem.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13815

Probably something like this fixes it. I'll be working on that Monday/Tuesday
along with various other bugs that need a review.

--


pty: ensure writes hit the reader before close

From: Alan Cox <alan@linux.intel.com>

Logically we move the buffering from one side to the other
---

 drivers/char/pty.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)


diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 6e6942c..7555890 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -36,6 +36,15 @@ static struct tty_driver *ptm_driver;
 static struct tty_driver *pts_driver;
 #endif
 
+static int pty_empty(struct tty_struct *tty)
+{
+	if (tty->buf.memory_used == 0)
+		return 1;
+	if (test_bit(TTY_HUPPED, &tty->flags))
+		return 1;
+	return 0;
+}
+
 static void pty_close(struct tty_struct *tty, struct file *filp)
 {
 	BUG_ON(!tty);
@@ -47,9 +56,11 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	}
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
+	
 	tty->packet = 0;
 	if (!tty->link)
 		return;
+	wait_event_interruptible(tty->write_wait, pty_empty(tty->link));
 	tty->link->packet = 0;
 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	wake_up_interruptible(&tty->link->read_wait);

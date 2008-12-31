Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYLaQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYLaQaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbYLaQaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:30:07 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:60674 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbYLaQaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:30:06 -0500
Date: Wed, 31 Dec 2008 17:30:00 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Bombe <aeb@debian.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] amiflop: get rid of sleep_on calls
In-Reply-To: <20081223142246.GA5122@infernal.debian.net>
Message-ID: <Pine.LNX.4.64.0812311728430.14380@anakin>
References: <1228755578-26069-1-git-send-email-aeb@debian.org>
 <Pine.LNX.4.64.0812090927580.29640@anakin> <20081210010219.GB5073@infernal.debian.net>
 <Pine.LNX.4.64.0812141719300.5936@anakin> <20081223142246.GA5122@infernal.debian.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008, Andreas Bombe wrote:
> On Sun, Dec 14, 2008 at 05:21:17PM +0100, Geert Uytterhoeven wrote:
> > On Wed, 10 Dec 2008, Andreas Bombe wrote:
> > > I just tried out my Amiga and it appears to be in better shape than
> > > expected.  So I might get to actually test it when I find the time.  My
> > > Amiga has no Linux installation so I need to whip up a ramdisk or
> > > something else sufficient to test it.
> > 
> > I think the good old ELF ramdisk at
> > ftp://ftp.uni-erlangen.de/pub/unix/Linux/680x0/v2.0/filesys/filesys-ELF-2.0.x-1400K-2.gz
> > should be sufficient to give it a try...
> 
> Not that easy with just 8 Megs of Fast RAM.  Besides, I couldn't gunzip
> the file to look at the image, gzip gives a format error.
> 
> Now, I finally got to test it with a very simply self-made initrd.  So
> far I only did some read tests in a single thread (dd to /dev/null at
> various offsets).  It didn't crash or hang, but I noticed that the
> floppy motor is never shut off (I'm not sure about the motor, at least
> the floppy LED stays on).  However, that is not a regression, I tested
> the mainline code and it shows the same problem.

Indeed, the floppy motor keeps on running.

I added some debug code and got this:

	floppy_off: nr = 0x40000000
	floppy_off: mod motor_off_timer 0 jiffies + 3*HZ
	fd_motor_off: drive = 0xc0000000


diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 8df436f..e42f168 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -336,6 +336,7 @@ static int fd_motor_on(int nr)
 {
 	nr &= 3;
 
+pr_err("%s: del motor_off_timer %d\n", __func__, nr);
 	del_timer(motor_off_timer + nr);
 
 	if (!unit[nr].motor) {
@@ -368,16 +369,13 @@ static int fd_motor_on(int nr)
 static void fd_motor_off(unsigned long drive)
 {
 	long calledfromint;
-#ifdef MODULE
-	long decusecount;
-
-	decusecount = drive & 0x40000000;
-#endif
+pr_err("%s: drive = 0x%lx\n", __func__, drive);
 	calledfromint = drive & 0x80000000;
 	drive&=3;
 	if (calledfromint && !try_fdc(drive)) {
 		/* We would be blocked in an interrupt, so try again later */
 		motor_off_timer[drive].expires = jiffies + 1;
+pr_err("%s: add motor_off_timer %ld jiffies + 1\n", __func__, drive);
 		add_timer(motor_off_timer + drive);
 		return;
 	}
@@ -391,9 +389,11 @@ static void floppy_off (unsigned int nr)
 {
 	int drive;
 
+pr_err("%s: nr = 0x%x\n", __func__, nr);
 	drive = nr & 3;
 	/* called this way it is always from interrupt */
 	motor_off_timer[drive].data = nr | 0x80000000;
+pr_err("%s: mod motor_off_timer %d jiffies + 3*HZ\n", __func__, drive);
 	mod_timer(motor_off_timer + drive, jiffies + 3*HZ);
 }
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

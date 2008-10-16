Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYJPLKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYJPLKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYJPLJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:09:56 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:48278 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYJPLJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:09:55 -0400
Date: Thu, 16 Oct 2008 13:09:50 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC PATCH 2/5] hvc_console: Add tty driver flag
	TTY_DRIVER_RESET_TERMIOS
Message-ID: <20081016110950.GA4125@cetus.boeblingen.de.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linux PPC devel <linuxppc-dev@ozlabs.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Ryan S. Arnold" <rsa@us.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com> <20081014091413.003841094@linux.vnet.ibm.com> <20081014104025.517ae734@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014104025.517ae734@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

for the sake of completion, here are few more details why I have suggest to
add the TTY_DRIVER_RESET_TERMIOS flag:

On Tue, Oct 14, 2008 at 10:40:25AM +0100, Alan Cox wrote:
> On Tue, 14 Oct 2008 11:12:49 +0200
> Hendrik Brueckner <brueckner@linux.vnet.ibm.com> wrote:
> 
> > After a tty hangup() or close() operation, processes might not reset the
> > termio settings to a sane state.
> That is the job of the getty task normally. pty is special as the reissue
> of the same pty is done as a new device (with new state).

During some testing, I have experienced that the bash alters few termios
settings before showing the bash prompt:
-
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(0, TCSETSW, {B38400 opost isig -icanon -echo ...}) = 0
write(2, "root@t6345050:~# ", 17) = 17
-
If the tty gets a hangup, the bash gets terminated but the settings still
remains after init has respawned the getty process.
For my network-based hvc backend, a tty_hangup() is caused by a disconnect.

I looked into the tty_io.c source and found out that the termios settings
are stored in an array of the tty driver struct and they remains unchanged
if a tty device is released and initialized again.
At tty device initialization, the tty_init_termios() set tty->termios to the
tty->driver->termios[tty->index].

The idea is to ensure that when a tty is initialized it has the
default (initial) termio settings; and that is actually done if
TTY_DRIVER_RESET_TERMIOS is set.

Anyhow the other possibility might be to always set the initial termios
when the tty is initialized (see patch below).
But I am not sure if that case is the general behavior of ttys.
Please let me know if there is a reason not to re-initialize the termios
of a new tty.

Thanks.

Best regards
Hendrik

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
---
 drivers/char/tty_io.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/tty_io.c	2008-10-16 09:48:00.000000000 +0200
+++ b/drivers/char/tty_io.c	2008-10-16 12:55:52.000000000 +0200
@@ -1243,10 +1243,9 @@ int tty_init_termios(struct tty_struct *
 		tp = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
 		if (tp == NULL)
 			return -ENOMEM;
-		memcpy(tp, &tty->driver->init_termios,
-						sizeof(struct ktermios));
 		tty->driver->termios[idx] = tp;
 	}
+	memcpy(tp, &tty->driver->init_termios, sizeof(struct ktermios));
 	tty->termios = tp;
 	tty->termios_locked = tp + 1;
 
-- 
Hendrik Brueckner
D/3303 Linux on System z Development
Tel: +49 7031 16-1073
Fax: +49 7031 16-3456
eMail: brueckner@linux.vnet.ibm.com
IBM Deutschland Research & Development GmbH, Schoenaicher Str. 220, 71032 Boeblingen

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschaeftsfuehrung: Erich Baier
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbXIMK4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbXIMK4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 06:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbXIMK4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 06:56:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbXIMK4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 06:56:45 -0400
Date: Thu, 13 Sep 2007 03:55:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Michael Neuling <mikey@neuling.org>, Jan Dittmer <jdi@l4x.org>,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@redhat.com>,
       davem@davemloft.net, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com,
       dhowells@redhat.com
Subject: Re: Define termios_1 functions for powerpc, s390, avr32 and frv
Message-Id: <20070913035506.b599e84f.akpm@linux-foundation.org>
In-Reply-To: <20070913095346.GA28194@linux-sh.org>
References: <18152.719.316280.579601@cargo.ozlabs.ibm.com>
	<46E8DF49.7090402@l4x.org>
	<5058.1189668156@neuling.org>
	<20070913095346.GA28194@linux-sh.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007 18:53:46 +0900 Paul Mundt <lethal@linux-sh.org> wrote:

> On Thu, Sep 13, 2007 at 05:22:36PM +1000, Michael Neuling wrote:
> > > > Commit f629307c857c030d5a3dd777fee37c8bb395e171 introduced uses of
> > > > kernel_termios_to_user_termios_1 and user_termios_to_kernel_termios_1
> > > > on all architectures.  However, powerpc, s390, avr32 and frv don't
> > > > currently define those functions since their termios struct didn't
> > > > need to be changed when the arbitrary baud rate stuff was added, and
> > > > thus the kernel won't currently build on those architectures.
> > > 
> > > alpha, parisc, sh, sparc{64,}, xtensa are still broken with this error...
> > 
> > They need to include <asm-generic/termios.h> in asm-<arch>/termios.h
> > like in powerpc.
> > 
> > Alternatively tonyb's patch should fix them.  Could also do that?
> > 
> Is there a consensus for this? It's a bit annoying to have this stuff
> broken this late in 2.6.23. If Tony's patch gets applied, then this stuff
> will work itself out. Otherwise everything has to be patched for
> asm-generic/termios.h. In which case.. here's the patch to define them on
> sh and sh64.

I think we need to go with Tony's patch.  sparc32 and sparc64 are
presently broken too, and the patch which converts sparc to use the
new interfaces introduces a few build errors.


From: Tony Breeds <tony@bakeyournoodle.com>

Add Guards around TIOCSLCKTRMIOS and TIOCGLCKTRMIOS.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_ioctl.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/char/tty_ioctl.c~sparc64-and-others-fix-tty_ioctlc-build drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~sparc64-and-others-fix-tty_ioctlc-build
+++ a/drivers/char/tty_ioctl.c
@@ -795,6 +795,19 @@ int n_tty_ioctl(struct tty_struct * tty,
 			if (L_ICANON(tty))
 				retval = inq_canon(tty);
 			return put_user(retval, (unsigned int __user *) arg);
+#ifndef TCGETS2
+		case TIOCGLCKTRMIOS:
+			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
+				return -EFAULT;
+			return 0;
+
+		case TIOCSLCKTRMIOS:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
+			if (user_termios_to_kernel_termios(real_tty->termios_locked, (struct termios __user *) arg))
+				return -EFAULT;
+			return 0;
+#else
 		case TIOCGLCKTRMIOS:
 			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
 				return -EFAULT;
@@ -806,6 +819,7 @@ int n_tty_ioctl(struct tty_struct * tty,
 			if (user_termios_to_kernel_termios_1(real_tty->termios_locked, (struct termios __user *) arg))
 				return -EFAULT;
 			return 0;
+#endif
 
 		case TIOCPKT:
 		{
_


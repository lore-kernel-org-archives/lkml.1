Return-Path: <linux-kernel-owner+w=401wt.eu-S966769AbXILLBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966769AbXILLBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966593AbXILLBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:01:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966596AbXILLBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:01:41 -0400
Date: Wed, 12 Sep 2007 04:01:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       Alan Cox <alan@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc: add new required termio functions
Message-Id: <20070912040109.3f6a9149.akpm@linux-foundation.org>
In-Reply-To: <20070912102032.GB7858@osiris.boeblingen.de.ibm.com>
References: <8018.1189562679@neuling.org>
	<20070912102032.GB7858@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 12:20:32 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Wed, Sep 12, 2007 at 12:04:39PM +1000, Michael Neuling wrote:
> > The "tty: termios locking functions break with new termios type" patch
> > (f629307c857c030d5a3dd777fee37c8bb395e171) breaks the powerpc compile.
> > [...]
> > I'm guessing other architectures are broken too?
> 
> FWIW, the above quoted patch breaks s390 as well.

Does this fix it?

diff -puN drivers/char/tty_ioctl.c~powerpc-add-new-required-termio-functions drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c~powerpc-add-new-required-termio-functions
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


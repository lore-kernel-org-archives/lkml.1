Return-Path: <linux-kernel-owner+w=401wt.eu-S934544AbXILL66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544AbXILL66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764676AbXILL6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:58:50 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1374 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764597AbXILL6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:58:49 -0400
Date: Wed, 12 Sep 2007 12:58:23 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Alan Cox <alan@redhat.com>, David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: 2.6.23-rc6-git1 -- termios *_1 compile failures on powerpc
Message-ID: <20070912115823.GG4835@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit just hit mainline and all my powerpc test boxes are
failing during compilation:

	commit f629307c857c030d5a3dd777fee37c8bb395e171
	tty: termios locking functions break with new termios type

Failing as follows:

  drivers/char/tty_ioctl.c: In function `n_tty_ioctl':
  drivers/char/tty_ioctl.c:799: error: implicit declaration of function
				`kernel_termios_to_user_termios_1'
  drivers/char/tty_ioctl.c:806: error: implicit declaration of function
				`user_termios_to_kernel_termios_1'
  make[2]: *** [drivers/char/tty_ioctl.o] Error 1

It seems that a lot of architectures already have these varients, but not
powerpc:

	include/asm-arm/termios.h
	include/asm-blackfin/termios.h
	include/asm-cris/termios.h
	include/asm-h8300/termios.h
	include/asm-i386/termios.h
	include/asm-ia64/termios.h
	include/asm-m32r/termios.h
	include/asm-m68k/termios.h
	include/asm-mips/termios.h
	include/asm-v850/termios.h
	include/asm-x86_64/termios.h
	include/asm-xtensa/termios.h

Looking closer there seems to be a generic implementation of the non _1
variants, which seem out of step with the architecture specific
variants?  Seems bad.

>From i386 we have the following (wrapped for clarity), and they seem
typical:

  #define user_termios_to_kernel_termios(k, u) 
  	copy_from_user(k, u, sizeof(struct termios2))
  #define kernel_termios_to_user_termios(u, k)
	copy_to_user(u, k, sizeof(struct termios2))
  #define user_termios_to_kernel_termios_1(k, u)
	copy_from_user(k, u, sizeof(struct termios))
  #define kernel_termios_to_user_termios_1(u, k)
	copy_to_user(u, k, sizeof(struct termios))

Generic versions from asm-generic/termios.h seem to be:

  #define user_termios_to_kernel_termios(k, u)
	copy_from_user(k, u, sizeof(struct termios))
  #define kernel_termios_to_user_termios(u, k)
	copy_to_user(u, k, sizeof(struct termios))

So I'd say we've missed a trick on this in the conversion.  Alan seems
to be the main source of these changes.  From the various commits which
update these defines in the architectures I get the implication that you
should be able to convert an architecture at a time as we go.  However,
the commit above seems to fly in the face of that.  It is therefore not
obvious if this commit is in error, or if the generic code needs fixing
to match?

Alan?

-apw

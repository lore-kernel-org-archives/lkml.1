Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbXIMAji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbXIMAji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 20:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXIMAja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 20:39:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbXIMAj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 20:39:29 -0400
Date: Wed, 12 Sep 2007 17:38:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Westermann <michael@dvmwest.de>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: DTR/DSR Patch
Message-Id: <20070912173817.7ca5c3dc.akpm@linux-foundation.org>
In-Reply-To: <20070831131741.GA14569@dvmwest.dvmwest.de>
References: <20070831131741.GA14569@dvmwest.dvmwest.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 15:17:41 +0200
Michael Westermann <michael@dvmwest.de> wrote:

> Hello,
> 
> I make driver for Point of Sale Printer, a wide range of Printer use
> only a DTR/DSR hardware-handshaking. When I use a handshaking in the
> userspace, the Printr has a overrun problem and our customer has a
> problem with the tax office.
> 
> my Patch relaize a simple DTR/DSR handhake with a small change of the
> code. The change auf the userspace is very simple. e.g.
> 
> 
> cflags |= CDTRDSR;
> 
> The change of the stty tool at 2 lines.
> 

googling for CDTRDSR is useful.  I see from
http://lkml.org/lkml/2006/12/10/49 that Russell was generally supportive,
but requested changes which afaict you have implemented here?


> --- linux-2.6/include/asm-i386/termbits.h	2007-05-21 10:37:10.000000000 +0200
> +++ linux-2.6.dsr_test/include/asm-i386/termbits.h	2007-08-28 11:58:43.000000000 +0200
> @@ -157,6 +157,7 @@
>  #define  B3500000 0010016
>  #define  B4000000 0010017
>  #define CIBAUD	  002003600000
> +#define CDTRDSR	  004000000000		/* dtrdsr flow control */
>  #define CMSPAR	  010000000000		/* mark or space (stick) parity */
>  #define CRTSCTS	  020000000000		/* flow control */
>  

This will break all architectures except for i386.  So for now I guess we
can do this: 

--- a/include/linux/termios.h~serial-8250-implement-dtr-dsr-handshaking-fix
+++ a/include/linux/termios.h
@@ -4,4 +4,8 @@
 #include <linux/types.h>
 #include <asm/termios.h>
 
+#ifndef CDTRDSR
+#define CDTRDSR 0 /* remove this when all architectures have a definition */
+#endif
+
 #endif
_

but that's temporary.  If we decide to proceed with this change then we
should add CDTRDSR to each arch's termbits.h.  That'll be pretty
straightforward to arrange.

Actually, let's spam them ...

--- a/include/linux/termios.h~serial-8250-implement-dtr-dsr-handshaking-fix
+++ a/include/linux/termios.h
@@ -4,4 +4,9 @@
 #include <linux/types.h>
 #include <asm/termios.h>
 
+#ifndef CDTRDSR
+#warning This architecture should implement CDTRDSR
+#define CDTRDSR 0 /* remove this when all architectures have a definition */
+#endif
+
 #endif
_


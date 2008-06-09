Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbYFIT53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbYFIT53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYFIT5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:57:21 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:27473 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753384AbYFIT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:57:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WX01nxLGwz9rZM+iRfAcyk2BntN7NCBFUIfIqw/OIxlr67l7qHyvr4lzEwdb3j2M9HktkCWQVqdJ5GSONTUwMk3Wu8qBf/QwGCbFjLVJ3bWTAa7aCb2UlHk8VEzZNwwNMRWjKgkYpkZdSpwF0uN+qmjnlM5vT/N0GF7wqckyNMQ=  ;
X-YMail-OSG: xe5o0pkVM1m6XhFpt0.9WYIlJLsd0_Bl0awG4BmaX.QLFoRF5tmZRoyzouYdFGw._N5Ptz5UlI9D67WPM..GwQdsk6H24VOmX1Pt4cQ1doOyg6z4c_VNQCCQvguqWBUmAm6T00f2_g53GKuJudEWx5hs
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Stefan Hellermann" <stefan@the2masters.de>
Subject: Re: GPIO-Ports on VIA EPIA-SN
Date: Mon, 9 Jun 2008 12:57:18 -0700
User-Agent: KMail/1.9.9
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org
References: <1213034405.2592.22.camel@hel-stefan.lan> <e2e108260806091203v6685d31duf057a3f9744fe7d4@mail.gmail.com>
In-Reply-To: <e2e108260806091203v6685d31duf057a3f9744fe7d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091257.18845.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008, Bart Van Assche wrote:
> On Mon, Jun 9, 2008 at 8:00 PM, Stefan Hellermann <stefan@the2masters.de> wrote:
> > I have a VIA Epia-SN embedded-board with 8 GPIO-connectors. I got the
> > attached documentation from VIA after I asked how to use the
> > GPIO-connectors with Linux.
> 
> Are you already familiar with the LDD book
> (http://lwn.net/Kernel/LDD3/ +
> http://lwn.net/Articles/2.6-kernel-api/) ? That book is a good
> starting point, together with the file Documentation/gpio.txt in the
> Linux kernel tree.

So in short:  you'll want to add a Kconfig option for your board,
and when it's selected you'll want to link in some EPIA-specific
int logic.  That logic will register a gpio_chip, and then you'll
be able to use the standard GPIO calls (and whatever uses them).

You will also want something like the appended patch ... but do
the "select" commands when your board is selected.

Of course an entirely roll-your-own approach could work too, but
I won't recommend that here.

- Dave


===== CUT HERE
DEBUG ONLY -- make X86_PC use gpiolib.

It's not clear to me how the various x86-ish platforms should
be made to work here, since there seems to be no convention
that each platform type has its own <asm/arch/...> subdir.

---
 arch/x86/Kconfig       |    2 ++
 include/asm-x86/gpio.h |   20 +++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

--- g26.orig/arch/x86/Kconfig	2008-06-03 19:43:53.000000000 -0700
+++ g26/arch/x86/Kconfig	2008-06-03 20:03:25.000000000 -0700
@@ -236,6 +236,8 @@ choice
 
 config X86_PC
 	bool "PC-compatible"
+	select GENERIC_GPIO
+	select HAVE_GPIO_LIB
 	help
 	  Choose this option if your computer is a standard PC or compatible.
 
--- g26.orig/include/asm-x86/gpio.h	2008-06-03 19:43:53.000000000 -0700
+++ g26/include/asm-x86/gpio.h	2008-06-03 20:03:25.000000000 -0700
@@ -1,6 +1,24 @@
 #ifndef _ASM_I386_GPIO_H
 #define _ASM_I386_GPIO_H
 
-#include <gpio.h>
+// #include <gpio.h>
+
+#include <linux/errno.h>
+#include <asm-generic/gpio.h>           /* cansleep wrappers */
+
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return -EINVAL;
+}
+
 
 #endif /* _ASM_I386_GPIO_H */



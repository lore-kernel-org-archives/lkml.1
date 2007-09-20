Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXITMxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXITMxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXITMxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:53:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:60056 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753991AbXITMxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:53:31 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19S6aQffAhStWedCjdhOiZRbTcNzqa60HOJtNGJCy
	cucg/oAT6soEm0
Date: Thu, 20 Sep 2007 14:53:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: 2.6.23-rc6-mm1 sparc build error
In-Reply-To: <20070918140508.e2c56212.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.60.0709201418000.5039@poirot.grange>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
 <20070918205403.GA13650@Krystal> <20070918140508.e2c56212.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide {enable,disable}_irq_wakeup dummies for undefined 
CONFIG_GENERIC_HARDIRQS case. Completely untested, as I don't even have 
cross-compilers for platforms without CONFIG_GENERIC_HARDIRQS.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

On Tue, 18 Sep 2007, Andrew Morton wrote:

> On Tue, 18 Sep 2007 16:54:03 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > I got the following error when building 2.6.23-rc6-mm1 on sparc:
> > 
> > 
> >   /opt/crosstool/gcc-4.1.1-glibc-2.3.6/sparc-unknown-linux-gnu/bin/sparc-unknown-linux-gnu-gcc -Wp,-MD,drivers/serial/.serial_core.o.d  -nostdinc -isystem /opt/crosstool/gcc-4.1.1-glibc-2.3.6/sparc-unknown-linux-gnu/lib/gcc/sparc-unknown-linux-gnu/4.1.1/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/compudj/git/linux-2.6-lttng/include -include include/linux/autoconf.h  -I/home/compudj/git/linux-2.6-lttng/drivers/serial -Idrivers/serial -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os -m32 -pipe -mno-fpu -fcall-used-g5 -fcall-used-g7 -fomit-frame-pointer -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(serial_core)"  -D"KBUILD_MODNAME=KBUILD_STR(serial_core)" -c -o drivers/serial/.tmp_serial_core.o /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c
> > /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c: In function 'uart_suspend_port':
> > /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c:1980: error: implicit declaration of function 'enable_irq_wake'
> > /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c: In function 'uart_resume_port':
> > /home/compudj/git/linux-2.6-lttng/drivers/serial/serial_core.c:2035: error: implicit declaration of function 'disable_irq_wake'
> 
> hm, I wonder why I didn't hit that.
> 
> enable_irq_wake() was added by wake-up-from-a-serial-port.patch
> 
> I note that git-input adds a call too, and might have a problem
> with !CONFIG_GENERIC_HARDIRQS.
> 
> Not sure what the best fix is here.  We could sprinkle ifdefs all
> over the code, or just add the suitable empty stubs for enable_irq_wake(),
> etc.

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5323f62..ecade41 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -205,6 +205,9 @@ static inline int disable_irq_wake(unsigned int irq)
 						enable_irq(irq)
 # endif
 
+#define enable_irq_wake(irq) ({ (void)(irq); 0; })
+#define disable_irq_wake(irq) ({ (void)(irq); 0; })
+
 #endif /* CONFIG_GENERIC_HARDIRQS */
 
 #ifndef __ARCH_SET_SOFTIRQ_PENDING

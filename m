Return-Path: <linux-kernel-owner+w=401wt.eu-S1765254AbXF1Uao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765254AbXF1Uao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761249AbXF1Uag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:30:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760899AbXF1Uaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:30:35 -0400
Date: Thu, 28 Jun 2007 13:29:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch -mm] Make check_signature() depend on CONFIG_HAS_IOMEM
Message-Id: <20070628132947.e3378811.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706282044360.30789@anakin>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070628133715.GA4343@osiris.boeblingen.de.ibm.com>
	<20070628110644.a530cfef.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706282017450.30789@anakin>
	<20070628113819.c24e592d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706282044360.30789@anakin>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 20:47:33 +0200 (CEST)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > > Apart from many Kconfig dependencies on HAS_IOMEM, CONFIG_HAS_IOMEM is
> > > further only used to control the build of lib/iomap_copy.c, which
> > > doesn't use readb() and friends, but the __raw*() operations.
> > > 
> > 
> > Well this is fun.
> > 
> > How to fix? Should we add a new CONFIG_HAS_IO?  (IOPORTS?)
> 
> There already exists a CONFIG_HAS_IOPORT :-) (for ISA/PCI-style I/O port
> access).
> 
> Just make check_signature() depend on ISA || PCI (and maybe || X86_32).
> According to its comment, it's used to `find BIOS signatures', which is
> a legacy PC thing. Please don't pollute non-legacy architectures with it ;-)

I merged the below and will await the next explosion.


From: Andrew Morton <akpm@linux-foundation.org>

check_signature() needs readb() but with some setups (s390, m68k allmodconfig)
there is no implementation of readb.  This causes build errors with
-Werror-implicit-function-declaration.

So make check_signature.o dependent upon ISA||PCI.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig  |    5 ++++-
 lib/Makefile |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig~check_signature-needs-readb lib/Kconfig
--- a/lib/Kconfig~check_signature-needs-readb
+++ a/lib/Kconfig
@@ -110,11 +110,14 @@ config TEXTSEARCH_FSM
 	tristate
 
 #
-# plist support is select#ed if needed
+# plist support is selected if needed
 #
 config PLIST
 	boolean
 
+config CHECK_SIGNATURE
+	def_bool ISA || PCI
+
 config HAS_IOMEM
 	boolean
 	depends on !NO_IOMEM
diff -puN lib/Makefile~check_signature-needs-readb lib/Makefile
--- a/lib/Makefile~check_signature-needs-readb
+++ a/lib/Makefile
@@ -13,7 +13,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o check_signature.o
+	 bust_spinlocks.o hexdump.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
@@ -33,6 +33,7 @@ obj-$(CONFIG_LOCK_KERNEL) += kernel_lock
 obj-$(CONFIG_PLIST) += plist.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
+obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 
 ifneq ($(CONFIG_HAVE_DEC_LOCK),y)
   lib-y += dec_and_lock.o
_


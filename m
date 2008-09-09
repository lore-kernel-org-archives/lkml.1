Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYIIJyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYIIJyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbYIIJxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:53:54 -0400
Received: from scing.com ([217.160.110.58]:46728 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYIIJxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:53:53 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
Date: Tue, 9 Sep 2008 11:53:48 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Jarod Wilson <jarod@redhat.com>,
       Christoph Bartelmus <lirc@bartelmus.de>,
       Mario Limonciello <superm1@ubuntu.com>, Janne Grunau <j@jannau.net>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-2-git-send-email-jwilson@redhat.com> <20080909074018.GA26076@Chamillionaire.breakpoint.cc>
In-Reply-To: <20080909074018.GA26076@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091153.49184.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 09:40:18 Sebastian Siewior wrote:
> >diff --git a/drivers/input/lirc/Makefile
> > b/drivers/input/lirc/Makefile new file mode 100644
> >index 0000000..cdb4c45
> >--- /dev/null
> >+++ b/drivers/input/lirc/Makefile
> >@@ -0,0 +1,8 @@
> >+# Makefile for the lirc drivers.
> >+#
> >+
> >+# Each configuration option enables a list of files.
> >+
> >+EXTRA_CFLAGS =-DIRCTL_DEV_MAJOR=61 -DLIRC_SERIAL_TRANSMITTER
> > -I$(src)

> LIRC_SERIAL_TRANSMITTER is used in patch 2 and just to enable a
> module options. Since it is always the case, please remove it.

Added CONFIG_LIRC_SERIAL_TRANSMITTER to Kconfig and removed this from 
the Makefile

> I haven't found the source of $src. It is probably a relic.

removed

> >+obj-$(CONFIG_LIRC_DEV)		+= lirc_dev.o
> >diff --git a/drivers/input/lirc/lirc_dev.c
> > b/drivers/input/lirc/lirc_dev.c new file mode 100644
> >index 0000000..c8f325c
> >--- /dev/null
> >+++ b/drivers/input/lirc/lirc_dev.c
> >@@ -0,0 +1,809 @@
...
> >+
> >+#include <linux/version.h>
>
> You souldn't need this one
>
> >+
> >+#include <linux/autoconf.h>
>
> this as well.

fixed, in all other files as well.

> >+#include <linux/semaphore.h>
>
> haven't found any call of down(). Do you really need this?

A relict. Lirc used many single holder semaphore and I forgot to remove 
the include after converting them to mutexes. I'll check the other 
files too.

> >+#define __KERNEL_SYSCALLS__
>
> this define shouldn't be here, should it?

Probably not, but it doesn't make a difference for the current kernel.
The only other hit for this symbol is arch/xtensa/kernel/syscall.c
38:#undef  __KERNEL_SYSCALLS__

...

> >+static inline void init_irctl(struct irctl *ir)
>
> this inline can go in my opinion. The others here as well. It is not
> *that* performance critical.

There is only one other inline. I doubt it makes a difference there but 
I won't change it without test. It does for the object size since the 
function is only called from one place.

...

> >+
> >+	bytes_in_key = p->code_length/8 + (p->code_length%8 ? 1 : 0);
>
> did you actually pass checkpatch.pl ?

yes, and while this is ugly I see no obvious CodingStyle violation.

is following better?

bytes_in_key = p->code_length/8;
if (p->code_length%8)
	bytes_in_key++;

> >+EXPORT_SYMBOL(lirc_register_plugin);
>
> Is EXPORT_SYMBOL_GPL() possible?

Afaik yes, all drivers using this symbol are in this patchset and under 
GPL. If it is desireable to to use EXPORT_SYMBOL_GPL() has someone else 
to decide. Christoph?


> >+/*
> >+ * Overrides for Emacs so that we follow Linus's tabbing style.
> >+ *
> > -------------------------------------------------------------------
> >-------- + * Local variables:
> >+ * c-basic-offset: 8
> >+ * End:
> >+ */
>
> Please don't enforce formating that way.

Removed, from all other files as well.

Thanks for the review. We will address the misssing comments later

Janne

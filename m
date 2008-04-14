Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbYDNHtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbYDNHtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbYDNHtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:49:06 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:43903 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759084AbYDNHtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:49:03 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-29.messagelabs.com!1208159342!10826904!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Mon, 14 Apr 2008 09:48:58 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080414074858.GA22694@digi.com>
References: <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local> <20080411062106.GA18096@digi.com> <20080411092158.GB31625@digi.com> <20080411103346.GC3185@local> <20080411110358.GC19973@digi.com> <20080411111703.GD3185@local> <20080411112543.GA23221@digi.com> <20080412131646.GF9669@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080412131646.GF9669@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Apr 2008 07:48:58.0856 (UTC) FILETIME=[FF7D6E80:01C89E03]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15848.005
X-TM-AS-Result: No--10.369000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > > > But what about this:
> > > > > 
> > > > > ERROR: "clk_get" [drivers/uio/uio_pdrv.ko] undefined!
> > > > > ERROR: "clk_enable" [drivers/uio/uio_pdrv.ko] undefined!
> > > > > ERROR: "clk_disable" [drivers/uio/uio_pdrv.ko] undefined!
> > > > > ERROR: "clk_put" [drivers/uio/uio_pdrv.ko] undefined!
> > > > > 
> > > > > Do you have any extra patches applied?
> > > > Yes I have, but nothing special.  This is part of a generic API defined
> > > > in include/linux/clk.h.  One of it's use it to abstract away some
> > > > platform dependencies.  There are several architectures that define
> > > > it[1].
> > > 
> > > I know. Unfortunately, I tested on x86_64, and it doesn't compile.
> > > If it's depending on something, then this dependency should be added in
> > > Kconfig. If it can be selected in the configuration, I expect it to
> > > compile (and work).
> > Maybe adding a dummy implementation that is compiled for machines that
> > don't provide a native one.  Currently there is no cpp symbol that tells
> > if an machine supports the API.
> > 
> > @Russell: Do you have an opinion regarding this!?
> 
> Only that the kernels Kconfig is turning into a real complicated mess
> of dependencies IMHO.
> 
> We could add a HAVE_CLK and add that to the dependency of all the drivers
> which use linux/clk.h.  The problem will be finding all those drivers and
> their corresponding Kconfig entries.
> 
> My feeling is that we're just going to end up creating another Kconfig
> symbol which folk half-heartedly use.
I don't like that either.  What do you think about the patch below?
It doesn't introduce a new symbol that needs much care and attention.
This way the clk API is available on all configurations provided that 
CONFIG_DUMMY_CLK is set correctly.  If CONFIG_DUMMY_CLK is set wrong it
should result in a compile error.  Either because there are two
implementations of clk_get or none.

The condition on when to define DUMMY_CLK isn't yet perfect, but not
defining it for a platform isn't a regression as there was no
implementation before this patch either.

This could supersede the implementation in
drivers/usb/gadget/pxa2xx_udc.c for IXP.  (That driver obviously doesn't
check if clk_enable() succeeded, because it's defined as:

	#define clk_enable(clk)		do { } while (0)

.)

Maybe it would be fine to make these functions inline and define them
directly in linux/clk.h?

Best regards
Uwe

---->8----
From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Date: Mon, 14 Apr 2008 09:02:30 +0200
Subject: [PATCH] provide a dummy implementation of the clk API

With this implementation clk_get and clk_enable always succeed.  The
counterparts clk_put and clk_disable only do some minor error checking.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
 lib/Kconfig    |    6 ++++++
 lib/Makefile   |    2 ++
 lib/dummyclk.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 lib/dummyclk.c

diff --git a/lib/Kconfig b/lib/Kconfig
index ba3d104..53fee1c 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -141,4 +141,10 @@ config HAS_DMA
 config CHECK_SIGNATURE
 	bool
 
+config DUMMY_CLK
+	def_bool y if X86
+	help
+	  This provides a dummy implementation for the API defined in
+	  linux/clk.h for platforms that don't implement it theirselves.
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 23de261..2ca3e82 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -70,6 +70,8 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
+obj-$(CONFIG_DUMMY_CLK) += dummyclk.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/dummyclk.c b/lib/dummyclk.c
new file mode 100644
index 0000000..bf364df
--- /dev/null
+++ b/lib/dummyclk.c
@@ -0,0 +1,54 @@
+/*
+ * lib/dummyclk.c
+ *
+ * Copyright (C) 2008 by Digi International Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/device.h>
+#include <linux/err.h>
+
+struct clk {
+	unsigned int enablecnt;
+};
+
+struct clk *clk_get(struct device *dev, const char *id)
+{
+	struct clk *ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+
+	if (ret)
+		return ret;
+	else
+		return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL(clk_get);
+
+void clk_put(struct clk *clk)
+{
+	WARN_ON(clk->enablecnt);
+}
+EXPORT_SYMBOL(clk_put);
+
+int clk_enable(struct clk *clk)
+{
+	++clk->enablecnt;
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	BUG_ON(!clk->enablecnt);
+	--clk->enablecnt;
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	BUG_ON(!clk->enablecnt);
+	return 0;
+}
+EXPORT_SYMBOL(clk_get_rate);
-- 
1.5.4.5


-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962

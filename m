Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbXKNJzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbXKNJzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbXKNJzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:55:11 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60686 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751194AbXKNJzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:55:10 -0500
Date: Wed, 14 Nov 2007 10:54:41 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Message-ID: <20071114105441.2d01018f@dhcp-255-175.norway.atmel.com>
In-Reply-To: <200711140037.58049.david-b@pacbell.net>
References: <200711091136.20051.david-b@pacbell.net>
	<200711132252.15872.david-b@pacbell.net>
	<200711140645.26363.nickpiggin@yahoo.com.au>
	<200711140037.58049.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 00:37:57 -0800
David Brownell <david-b@pacbell.net> wrote:

> Although another point is related to "trivial":  the data
> is being protected through an operation too trivial to be
> worth paying for any of that priority logic.

But isn't there any way we can remove the lock from the fast path
altogether? What is it really protecting?

Since this is the code that runs under the lock (excluding the "extra
checks" case):

+static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
+{
+	return chips[gpio / ARCH_GPIOS_PER_CHIP];
+}

I'd say it protects against chips being removed in the middle of the
operation. However, this comment says that chips cannot be removed
while any gpio on it is requested:

+/* gpio_lock protects the table of chips and to gpio_chip->requested.
+ * While any gpio is requested, its gpio_chip is not removable.  It's
+ * a raw spinlock to ensure safe access from hardirq contexts, and to
+ * shrink bitbang overhead:  per-bit preemption would be very wrong.
+ */

And since we drop the lock before calling the actual get/set bit
operation, we would be screwed anyway if the chip was removed during
the call to __gpio_set_value(). So what does the lock really buy us?

Håvard

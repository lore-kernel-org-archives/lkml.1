Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbYKGXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbYKGXXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYKGXWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:22:50 -0500
Received: from kroah.org ([198.145.64.141]:59134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752561AbYKGXWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:22:49 -0500
Date: Fri, 7 Nov 2008 15:15:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 01/23] gpiolib: fix oops in gpio_get_value_cansleep()
Message-ID: <20081107231514.GB1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="gpiolib-fix-oops-in-gpio_get_value_cansleep.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Brownell <dbrownell@users.sourceforge.net>

commit 978ccaa8ea5d8c7bf6b676209f2fc126eae6355b upstream

We can get the following oops from gpio_get_value_cansleep() when a GPIO
controller doesn't provide a get() callback:

 Unable to handle kernel paging request for instruction fetch
 Faulting instruction address: 0x00000000
 Oops: Kernel access of bad area, sig: 11 [#1]
 [...]
 NIP [00000000] 0x0
 LR [c0182fb0] gpio_get_value_cansleep+0x40/0x50
 Call Trace:
 [c7b79e80] [c0183f28] gpio_value_show+0x5c/0x94
 [c7b79ea0] [c01a584c] dev_attr_show+0x30/0x7c
 [c7b79eb0] [c00d6b48] fill_read_buffer+0x68/0xe0
 [c7b79ed0] [c00d6c54] sysfs_read_file+0x94/0xbc
 [c7b79ef0] [c008f24c] vfs_read+0xb4/0x16c
 [c7b79f10] [c008f580] sys_read+0x4c/0x90
 [c7b79f40] [c0013a14] ret_from_syscall+0x0/0x38

It's OK to request the value of *any* GPIO; most GPIOs are bidirectional,
so configuring them as outputs just enables an output driver and doesn't
disable the input logic.

So the problem is that gpio_get_value_cansleep() isn't making the same
sanity check that gpio_get_value() does: making sure this GPIO isn't one
of the atypical "no input logic" cases.

Reported-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -517,7 +517,7 @@ int gpio_get_value_cansleep(unsigned gpi
 
 	might_sleep_if(extra_checks);
 	chip = gpio_to_chip(gpio);
-	return chip->get(chip, gpio - chip->base);
+	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
 }
 EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
 

-- 

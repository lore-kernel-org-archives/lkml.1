Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYJPPps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYJPPps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYJPPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:45:25 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:32377 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751517AbYJPPpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:45:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pwQuwX46iePEOq/3H1tBEM9spfi2KkEggy6SS9YzfP1zq5Mp9VbwkwA26Bcz9OWzBpFvkIPNKTi4vf2AvkcZ3/KKSIVR2jQ+u5V0q8nrN0P6RIcSaxZ0uUGcOLxkmRjXIEQrMiuXinVLKkGt1Hn277ZTot0hXVLfeIHafavqD58=  ;
X-YMail-OSG: T9EOUM4VM1kmBgeoFm9B5vII54Y7lZjza.ha25N_WBPjXHZQxqTO6rUc00dNcxEXV4A5gGHgLhxapvZHGkRZtHrw5l1yZ_etQmphS0IcUuCiX1FkLjDDN8HtO5SWXvZdrO5pMEzd4UUs9xyRLgOEfGgp
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] gpiolib: fix oops in gpio_get_value_cansleep()
Date: Thu, 16 Oct 2008 08:45:22 -0700
User-Agent: KMail/1.9.9
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160845.22281.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

We can get the following oops from gpio_get_value_cansleep()
when a GPIO controller doesn't provide a get() callback:

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

It's OK to request the value of *any* GPIO; most GPIOs are
bidirectional, so configuring them as outputs just enables an
output driver and doesn't disable the input logic.

So the problem is that gpio_get_value_cansleep() isn't making
the same sanity check that gpio_get_value() does:  making sure
this GPIO isn't one of the atypical "no input logic" cases.

Reported-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/gpiolib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1056,7 +1056,7 @@ int gpio_get_value_cansleep(unsigned gpi
 
 	might_sleep_if(extra_checks);
 	chip = gpio_to_chip(gpio);
-	return chip->get(chip, gpio - chip->base);
+	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
 }
 EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
 

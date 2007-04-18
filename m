Return-Path: <linux-kernel-owner+w=401wt.eu-S1751052AbXDRIYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbXDRIYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXDRIYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:24:16 -0400
Received: from fgwmail9.fujitsu.co.jp ([192.51.44.39]:41084 "EHLO
	fgwmail9.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbXDRIYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:24:14 -0400
Subject: Re: [PATCH][BUG] Fix possible NULL pointer access in 8250 serial
	driver
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: izumi <izumi2005@soft.fujitsu.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20070416225206.cf7d8cd2.akpm@linux-foundation.org>
References: <46242DD2.7030207@soft.fujitsu.com>
	 <20070416225206.cf7d8cd2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 17:21:53 +0900
Message-Id: <1176884513.3945.54.camel@kane-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd imagine that other serial drivers might get upset having their
> ->get_mcrtl() called prior to being opened.  Perhaps we should be fixing
> this in uart_read_proc()?
> 

I looked at other serial drivers and I could not find any other
drivers which accesses port->info in their ->get_mctrl(). This 
is why we fix this problem in 8250 driver. But if there is a
possibility that other drivers accesses port->info in their
->get_mctrl(), we should be fixing this in uart_read_proc(), as
you said.

How about the following patch? We've also confirmed the problem
is fixed by it.

Thanks,
Kenji Kaneshige


This patch fixes the problem that uninitialized (NULL) 'info' member
of uart_port structure can be accessed if serial driver is accessed
through /proc filesystem before uart_open(), which initializes the
'info' member', is called.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Taku Izumi <izumi2005@soft.fujitsu.com>

---
 drivers/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-rc5/drivers/serial/serial_core.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/serial/serial_core.c
+++ linux-2.6.21-rc5/drivers/serial/serial_core.c
@@ -1665,7 +1665,7 @@ static int uart_line_info(char *buf, str
 	unsigned int status;
 	int mmio, ret;
 
-	if (!port)
+	if (!port || !port->info)
 		return 0;
 
 	mmio = port->iotype >= UPIO_MEM;




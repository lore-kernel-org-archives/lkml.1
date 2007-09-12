Return-Path: <linux-kernel-owner+w=401wt.eu-S970958AbXILRST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970958AbXILRST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969013AbXILRSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:18:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19173 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968679AbXILRSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:18:05 -0400
Date: Wed, 12 Sep 2007 10:15:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kgdb-bugreport@lists.sourceforge.net, amitkale@linsyssoft.com,
       jason.wessel@windriver.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>
Subject: [PATCH -mm] 2.6.23-rc4-mm1: kgdboe link errors
Message-Id: <20070912101537.129d10c7.randy.dunlap@oracle.com>
In-Reply-To: <46E7B1EA.2040009@gmail.com>
References: <46E7B1EA.2040009@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 11:31:22 +0200 Jiri Slaby wrote:

> randconfig [1] causes this link errors:
> ERROR: "netpoll_cleanup" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_setup" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_parse_options" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_poll" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_send_udp" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_set_trap" [drivers/net/kgdboe.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make: *** [all] Error 2
> 
> [1] http://www.fi.muni.cz/~xslaby/sklad/1.config


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kgdb build problems:
  Building modules, stage 2.
ERROR: "netpoll_cleanup" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_setup" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_parse_options" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_poll" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_send_udp" [drivers/net/kgdboe.ko] undefined!
ERROR: "netpoll_set_trap" [drivers/net/kgdboe.ko] undefined!
make[1]: *** [__modpost] Error 1


Add 'select' for net-poll/console related config symbols, but
make KGDBOE 'depend on' NET.  We don't want to 'select' CONFIG_NET,
but if it is already enabled, the 'select's will enable the rest
of the needed interfaces.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/Kconfig.kgdb |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1.orig/lib/Kconfig.kgdb
+++ linux-2.6.23-rc4-mm1/lib/Kconfig.kgdb
@@ -174,9 +174,11 @@ endchoice
 
 config KGDBOE
 	tristate "KGDB: On ethernet" if !KGDBOE_NOMODULE
-	depends on m && KGDB
+	depends on m && KGDB && NET
+	select NETCONSOLE
 	select NETPOLL
 	select NETPOLL_TRAP
+	select NET_POLL_CONTROLLER
 	help
 	  Uses the NETPOLL API to communicate with the host GDB via UDP.
 	  In order for this to work, the ethernet interface specified must

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756760AbZBRVBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbZBRVBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZBRVBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:01:17 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:45285 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZBRVBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:01:16 -0500
Date: Wed, 18 Feb 2009 13:01:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, akpm <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] staging/pohmelfs: fix kconfig dependencies
Message-Id: <20090218130134.b453d1c3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.499C76FE.006A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

pohmelfs wants to use CONNECTOR, so it selects CONNECTOR,
but when CONFIG_NET is not enabled, connector.c will not build,
since select does not follow the dependency chain.
Selecting NET is not a good idea, since that would build lots
of code that someone seemingly didn't want to build/store
and kconfig shouldn't do that behind someone's back.

pohmelfs should depend on NET since it uses network interfaces.

pohmelfs also uses CRYTPO and selects 2 cipher symbols, but
it should also select the top-level CRYPTO symbol since
kconfig dependency chains are not followed.
(found by inspection)
This allows the POHMELFS_CRYPTO option to depend only on
POHMELFS and makes the kconfig menu align properly.

Also fix minor typos & line lengths in kconfig help text.
Drop CONFIG_* in kconfig symbols in Kconfig file.


connector.c:(.text+0x46003): undefined reference to `kfree_skb'
connector.c:(.text+0x460a6): undefined reference to `kfree_skb'
connector.c:(.text+0x4612b): undefined reference to `kfree_skb'
(.text+0x4624f): undefined reference to `netlink_has_listeners'
(.text+0x4629b): undefined reference to `__alloc_skb'
(.text+0x462ea): undefined reference to `kfree_skb'
(.text+0x46308): undefined reference to `skb_put'
(.text+0x46385): undefined reference to `netlink_broadcast'
(.text+0x7b574): undefined reference to `sock_release'
(.text+0x7b8dd): undefined reference to `sock_create'
(.text+0x7b984): undefined reference to `kernel_connect'
(.text+0x7ba4c): undefined reference to `sock_release'
net.c:(.text+0x7bda4): undefined reference to `kernel_recvmsg'
(.text+0x7ef42): undefined reference to `kernel_sendmsg'
(.text+0x7f057): undefined reference to `kernel_sendpage'
(.text+0x7f1e8): undefined reference to `kernel_sendmsg'
connector.c:(.devinit.text+0x5b): undefined reference to `init_net'
connector.c:(.devinit.text+0x60): undefined reference to `netlink_kernel_create'
connector.c:(.devinit.text+0xc9): undefined reference to `netlink_kernel_release'
connector.c:(.devexit.text+0x2c): undefined reference to `netlink_kernel_release'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/staging/pohmelfs/Kconfig |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- mmotm-2009-0217-1233.orig/drivers/staging/pohmelfs/Kconfig
+++ mmotm-2009-0217-1233/drivers/staging/pohmelfs/Kconfig
@@ -1,12 +1,14 @@
 config POHMELFS
 	tristate "POHMELFS filesystem support"
+	depends on NET
 	select CONNECTOR
+	select CRYPTO
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HMAC
 	help
-	  POHMELFS stands for Parallel Optimized Host Message Exchange Layered File System.
-	  This is a network filesystem which supports coherent caching of data and metadata
-	  on clients.
+	  POHMELFS stands for Parallel Optimized Host Message Exchange Layered
+	  File System.  This is a network filesystem which supports coherent
+	  caching of data and metadata on clients.
 
 config POHMELFS_DEBUG
 	bool "POHMELFS debugging"
@@ -14,12 +16,13 @@ config POHMELFS_DEBUG
 	default n
 	help
 	  Turns on excessive POHMELFS debugging facilities.
-	  You usually do not want to slow things down noticebly and get really lots of kernel
-	  messages in syslog.
+	  You usually do not want to slow things down noticeably and get really
+	  lots of kernel messages in syslog.
 
 config POHMELFS_CRYPTO
 	bool "POHMELFS crypto support"
-	depends on CONFIG_CRYPTO_BLKCIPHER && CONFIG_CRYPTO_HASH
+	depends on POHMELFS
 	help
-	  This option allows to encrypt and/or protect with strong cryptographic hash all dataflow
-	  between server and clients. Each config group can have own keys.
+	  This option allows to encrypt and/or protect with strong
+	  cryptographic hash all dataflow between server and clients.
+	  Each config group can have its own keys.

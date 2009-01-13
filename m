Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZAMXWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZAMXWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZAMXWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:22:41 -0500
Received: from relanium.yandex.ru ([77.88.58.132]:7073 "EHLO
	relanium.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZAMXWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:22:40 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, dst@ioremap.net,
       Evgeniy Polaykov <zbr@ioremap.net>
Subject: [7/7] dst: kconfig and makefile changes.
Date: Wed, 14 Jan 2009 02:05:33 +0300
Message-Id: <1231887933-17843-8-git-send-email-zbr@ioremap.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1231887933-17843-7-git-send-email-zbr@ioremap.net>
References: <1231887933-17843-1-git-send-email-zbr@ioremap.net>
 <1231887933-17843-2-git-send-email-zbr@ioremap.net>
 <1231887933-17843-3-git-send-email-zbr@ioremap.net>
 <1231887933-17843-4-git-send-email-zbr@ioremap.net>
 <1231887933-17843-5-git-send-email-zbr@ioremap.net>
 <1231887933-17843-6-git-send-email-zbr@ioremap.net>
 <1231887933-17843-7-git-send-email-zbr@ioremap.net>
X-Antivirus: Dr.Web (R) for Mail Servers on relanium.yandex.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Evgeniy Polaykov <zbr@ioremap.net>

index 0000000..12ffa37
--- /dev/null
+++ b/drivers/staging/dst/Kconfig
@@ -0,0 +1,71 @@
+config DST
+	tristate "Distributed storage"
+	depends on NET && CRYPTO && SYSFS
+	select CONNECTOR
+	select LIBCRC32C
+	---help---
+	DST is a network block device storage, which can be used to organize
+	exported storages on the remote nodes into the local block device.
+
+	DST is a network block device storage, which can be used to organize
+	exported storages on the remote nodes into the local block device.
+
+	DST works on top of any network media and protocol, it is just a matter
+	of configuration utility to understand the correct addresses. The most
+	common example is TCP over IP allows to pass through firewalls and
+	created remote backup storage in the different datacenter. DST requires
+	single port to be enabled on the exporting node and outgoing connections
+	on the local node.
+
+	DST works with in-kernel client and server, which improves the performance
+	eliminating unneded data copies and allows not to depend on the version
+	of the external IO components. It requires userspace configuration utility
+	though.
+
+	DST uses transaction model, when each store has to be explicitly acked
+	from the remote node to be considered as successfully written. There
+	may be lots of in-flight transactions. When remote host does not ack
+	the transaction it will be resent predefined number of times with specified
+	timeouts between them. All those parameters are configurable. Transactions
+	are marked as failed after all resends completed unsuccessfully, having
+	long enough resend timeout and/or large number of resends allows not to
+	return error to the higher (FS usually) layer in case of short network
+	problems or remote node outages. In case of network RAID setup this means
+	that storage will not degrade until transactions are marked as failed, and
+	thus will not force checksum recalculation and data rebuild. In case of
+	connection failure DST will try to reconnect to the remote node automatically.
+	DST sends ping commands at idle time to detect if remote node is alive.
+
+	Because of transactional model it is possible to use zero-copy sending
+	without worry of data corruption (which in turn could be detected by the
+	strong checksums though).
+
+	DST may fully encrypt the data channel in case of untrusted channel and implement
+	strong checksum of the transferred data. It is possible to configure algorithms
+	and crypto keys, they should match on both sides of the network channel.
+	Crypto processing does not introduce noticeble performance overhead, since DST
+	uses configurable pool of threads to perform crypto processing.
+
+	DST utilizes memory pool model of all its transaction allocations (it is the
+	only additional allocation on the client) and server allocations (bio pools,
+	while pages are allocated from the slab).
+
+	At startup DST performs a simple negotiation with the export node to determine
+	access permissions and size of the exported storage. It can be extended if
+	new parameters should be autonegotiated.
+
+	DST carries block IO flags in the protocol, which allows to transparently implement
+	barriers and sync/flush operations. Those flags are used in the export node where
+	IO against the local storage is performed, which means that sync write will be sync
+	on the remote node too, which in turn improves data integrity and improved resistance
+	to errors and data corruption during power outages or storage damages.
+
+	Homepage: http://www.ioremap.net/projects/dst
+	Userspace configuration utility and the latest releases: http://www.ioremap.net/archive/dst/
+
+config DST_DEBUG
+	bool "DST debug"
+	depends on DST
+	---help---
+	This option will turn HEAVY debugging of the DST.
+	Turn it on ONLY if you have to debug some really obscure problem.
diff --git a/drivers/staging/dst/Makefile b/drivers/staging/dst/Makefile
new file mode 100644
index 0000000..3a8b0cf
--- /dev/null
+++ b/drivers/staging/dst/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_DST) += nst.o
+
+nst-y := dcore.o state.o export.o thread_pool.o crypto.o trans.o

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index ce6badd..9de9ad5 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -95,5 +95,7 @@ source "drivers/staging/epl/Kconfig"
 
 source "drivers/staging/android/Kconfig"
 
+source "drivers/staging/dst/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 9ddcc2b..14a89fa 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_INPUT_MIMIO)	+= mimio/
 obj-$(CONFIG_TRANZPORT)		+= frontier/
 obj-$(CONFIG_EPL)		+= epl/
 obj-$(CONFIG_ANDROID)		+= android/
+obj-$(CONFIG_DST)		+= dst/

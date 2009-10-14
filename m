Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbZJNV2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbZJNV2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbZJNV2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:28:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55705 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZJNV2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:28:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 14 Oct 2009 23:26:24 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.8ed463a294b8d2e4@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive a documentation update and a driver fix.

Justin P. Mattock (1):
      ieee1394: update URLs in debugging-via-ohci1394.txt

Stefan Richter (2):
      ieee1394: add documentation entry to MAINTAINERS
      firewire: sbp2: provide fallback if mgt_ORB_timeout is missing

 Documentation/debugging-via-ohci1394.txt |    8 ++--
 MAINTAINERS                              |    1 +
 drivers/firewire/sbp2.c                  |   39 ++++++++++-----------
 3 files changed, 24 insertions(+), 24 deletions(-)

Thanks.


commit eaf76e0d027a917a013ad8a88a94132d0feab622
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Oct 8 00:39:31 2009 +0200

    firewire: sbp2: provide fallback if mgt_ORB_timeout is missing
    
    The Unit_Characteristics entry of an SBP-2 unit directory is not
    mandatory as far as I can tell.  If it is missing, we would probably
    fail to log in into the target because firewire-sbp2 would not wait for
    status after it sent the login request.
    
    The fix moves the cleanup of tgt->mgt_orb_timeout into a place where it
    is executed exactly once before login, rather than 0..n times depending
    on the target's config ROM.  With targets with one or more
    Unit_Characteristics entries, the result is the same as before.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 50f0176..98dbbda 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -188,14 +188,7 @@ static struct fw_device *target_device(struct sbp2_target *tgt)
 /* Impossible login_id, to detect logout attempt before successful login */
 #define INVALID_LOGIN_ID 0x10000
 
-/*
- * Per section 7.4.8 of the SBP-2 spec, a mgt_ORB_timeout value can be
- * provided in the config rom. Most devices do provide a value, which
- * we'll use for login management orbs, but with some sane limits.
- */
-#define SBP2_MIN_LOGIN_ORB_TIMEOUT	5000U	/* Timeout in ms */
-#define SBP2_MAX_LOGIN_ORB_TIMEOUT	40000U	/* Timeout in ms */
-#define SBP2_ORB_TIMEOUT		2000U	/* Timeout in ms */
+#define SBP2_ORB_TIMEOUT		2000U		/* Timeout in ms */
 #define SBP2_ORB_NULL			0x80000000
 #define SBP2_RETRY_LIMIT		0xf		/* 15 retries */
 #define SBP2_CYCLE_LIMIT		(0xc8 << 12)	/* 200 125us cycles */
@@ -1034,7 +1027,6 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
 {
 	struct fw_csr_iterator ci;
 	int key, value;
-	unsigned int timeout;
 
 	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
@@ -1059,17 +1051,7 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
 
 		case SBP2_CSR_UNIT_CHARACTERISTICS:
 			/* the timeout value is stored in 500ms units */
-			timeout = ((unsigned int) value >> 8 & 0xff) * 500;
-			timeout = max(timeout, SBP2_MIN_LOGIN_ORB_TIMEOUT);
-			tgt->mgt_orb_timeout =
-				  min(timeout, SBP2_MAX_LOGIN_ORB_TIMEOUT);
-
-			if (timeout > tgt->mgt_orb_timeout)
-				fw_notify("%s: config rom contains %ds "
-					  "management ORB timeout, limiting "
-					  "to %ds\n", tgt->bus_id,
-					  timeout / 1000,
-					  tgt->mgt_orb_timeout / 1000);
+			tgt->mgt_orb_timeout = (value >> 8 & 0xff) * 500;
 			break;
 
 		case SBP2_CSR_LOGICAL_UNIT_NUMBER:
@@ -1087,6 +1069,22 @@ static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
 	return 0;
 }
 
+/*
+ * Per section 7.4.8 of the SBP-2 spec, a mgt_ORB_timeout value can be
+ * provided in the config rom. Most devices do provide a value, which
+ * we'll use for login management orbs, but with some sane limits.
+ */
+static void sbp2_clamp_management_orb_timeout(struct sbp2_target *tgt)
+{
+	unsigned int timeout = tgt->mgt_orb_timeout;
+
+	if (timeout > 40000)
+		fw_notify("%s: %ds mgt_ORB_timeout limited to 40s\n",
+			  tgt->bus_id, timeout / 1000);
+
+	tgt->mgt_orb_timeout = clamp_val(timeout, 5000, 40000);
+}
+
 static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 				  u32 firmware_revision)
 {
@@ -1171,6 +1169,7 @@ static int sbp2_probe(struct device *dev)
 			       &firmware_revision) < 0)
 		goto fail_tgt_put;
 
+	sbp2_clamp_management_orb_timeout(tgt);
 	sbp2_init_workarounds(tgt, model, firmware_revision);
 
 	/*

commit 544df55d6c1590bc21c86119b89a1689b1eb5e75
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Oct 3 10:17:29 2009 +0200

    ieee1394: add documentation entry to MAINTAINERS
    
    Add the file pattern of drivers/ieee1394/init_ohci1394_dma.c's
    documentation to the maintainers database.  init_ohci1394_dma.c is not
    really part of the IEEE 1394 subsystem, but this maintainers contact
    seems to be better than none at all.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8dca9d8..6a387f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2519,6 +2519,7 @@ L:	linux1394-devel@lists.sourceforge.net
 W:	http://www.linux1394.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
+F:	Documentation/debugging-via-ohci1394.txt
 F:	drivers/ieee1394/
 
 IEEE 1394 RAW I/O DRIVER

commit 211a641770c2ae191c9589fee69a8fb67f67fffd
Author: Justin P. Mattock <justinmattock@gmail.com>
Date:   Tue Sep 29 15:13:58 2009 -0700

    ieee1394: update URLs in debugging-via-ohci1394.txt
    
    Update URLs of the userspace tools to use ohci1394_dma=early for
    debugging.
    
    Seems the address ftp://ftp.suse.de/private/bk/firewire/tools/* is not
    very helpful.  After a quick search, seems this was talked about:
    http://www.mail-archive.com/kgdb-bugreport@lists.sourceforge.net/msg02761.html
    (can't find the original thread).
    
    Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/Documentation/debugging-via-ohci1394.txt b/Documentation/debugging-via-ohci1394.txt
index 59a91e5..611f5a5 100644
--- a/Documentation/debugging-via-ohci1394.txt
+++ b/Documentation/debugging-via-ohci1394.txt
@@ -64,14 +64,14 @@ be used to view the printk buffer of a remote machine, even with live update.
 
 Bernhard Kaindl enhanced firescope to support accessing 64-bit machines
 from 32-bit firescope and vice versa:
-- ftp://ftp.suse.de/private/bk/firewire/tools/firescope-0.2.2.tar.bz2
+- http://halobates.de/firewire/firescope-0.2.2.tar.bz2
 
 and he implemented fast system dump (alpha version - read README.txt):
-- ftp://ftp.suse.de/private/bk/firewire/tools/firedump-0.1.tar.bz2
+- http://halobates.de/firewire/firedump-0.1.tar.bz2
 
 There is also a gdb proxy for firewire which allows to use gdb to access
 data which can be referenced from symbols found by gdb in vmlinux:
-- ftp://ftp.suse.de/private/bk/firewire/tools/fireproxy-0.33.tar.bz2
+- http://halobates.de/firewire/fireproxy-0.33.tar.bz2
 
 The latest version of this gdb proxy (fireproxy-0.34) can communicate (not
 yet stable) with kgdb over an memory-based communication module (kgdbom).
@@ -178,7 +178,7 @@ Step-by-step instructions for using firescope with early OHCI initialization:
 
 Notes
 -----
-Documentation and specifications: ftp://ftp.suse.de/private/bk/firewire/docs
+Documentation and specifications: http://halobates.de/firewire/
 
 FireWire is a trademark of Apple Inc. - for more information please refer to:
 http://en.wikipedia.org/wiki/FireWire

-- 
Stefan Richter
-=====-==--= =-=- -===-
http://arcgraph.de/sr/


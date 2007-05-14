Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbXENMU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbXENMU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXENMUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 08:20:14 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58358 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbXENMUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 08:20:12 -0400
Message-ID: <464853D9.70904@drzeus.cx>
Date: Mon, 14 May 2007 14:19:37 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-19630-1179145210-0001-2"
To: LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC][PATCH] Make prepare_namespace() wait for devices
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-19630-1179145210-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Testing and/or comments welcome.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-19630-1179145210-0001-2
Content-Type: text/x-patch; name="initwait.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="initwait.patch"

commit 7c542a5a027caa95bb00f8a8223c7e4aef88c931
Author: Pierre Ossman <drzeus@drzeus.cx>
Date:   Mon May 14 14:15:46 2007 +0200

    init: wait for asynchronously scanned block devices
    
    Some buses (e.g. USB and MMC) do their scanning of devices in the
    background, causing a race between them and prepare_namespace().
    In order to be able to use these buses without an initrd, we now
    wait for the device specified in root= to actually show up.
    
    If the device never shows up than we will hang in an infinite loop.
    Previously we panic:ed instead, so this behaviour should be no
    worse.
    
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 46fe407..192b2d6 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -438,11 +438,24 @@ void __init prepare_namespace(void)
 			root_device_name += 5;
 	}
 
-	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
-
 	if (initrd_load())
 		goto out;
 
+	/* wait for any asynchronous scanning to complete */
+	if (ROOT_DEV == 0) {
+		printk("Waiting for root device %s...\n", saved_root_name);
+		do {
+			while (driver_probe_done() != 0)
+				msleep(100);
+			ROOT_DEV = name_to_dev_t(saved_root_name);
+			if (ROOT_DEV == 0)
+				msleep(100);
+		} while (ROOT_DEV == 0);
+	}
+
+	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
+
+
 	if (is_floppy && rd_doload && rd_load_disk(0))
 		ROOT_DEV = Root_RAM0;
 

--=_hera.drzeus.cx-19630-1179145210-0001-2--

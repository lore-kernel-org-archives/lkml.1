Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbXFAGuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbXFAGuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbXFAGum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:50:42 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:60835 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730AbXFAGul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:50:41 -0400
Message-ID: <465FC1E6.7000003@drzeus.cx>
Date: Fri, 01 Jun 2007 08:51:18 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-12578-1180680640-0001-2"
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make prepare_namespace() wait for devices
References: <4655834F.3050301@drzeus.cx>	<20070524170654.5d674474.akpm@linux-foundation.org>	<4656602A.3010000@drzeus.cx>	<20070524211737.daa3c99c.akpm@linux-foundation.org>	<465666AE.5020600@drzeus.cx>	<465EAF90.3030803@drzeus.cx>	<20070531085114.420b9cbe.akpm@linux-foundation.org>	<465FAD94.4020200@drzeus.cx> <20070531234037.bebbc659.akpm@linux-foundation.org>
In-Reply-To: <20070531234037.bebbc659.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-12578-1180680640-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> Could we have an update for Documentation/kernel-parameters.txt, please?
>   

Sorry, of course.

New patch included. "rootwait" is also just a boolean, so make sure it
is treated as such.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org


--=_hera.drzeus.cx-12578-1180680640-0001-2
Content-Type: text/x-patch; name="initwait.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="initwait.patch"

commit 1e5e9315f431f54d2a2ee90ed11279271a346764
Author: Pierre Ossman <drzeus@drzeus.cx>
Date:   Mon May 14 14:15:46 2007 +0200

    init: wait for asynchronously scanned block devices
    
    Some buses (e.g. USB and MMC) do their scanning of devices in the
    background, causing a race between them and prepare_namespace().
    In order to be able to use these buses without an initrd, we now
    wait for the device specified in root= to actually show up.
    
    If the device never shows up than we will hang in an infinite loop.
    In order to not mess with setups that reboot on panic, the feature
    must be turned on via the command line option "rootwait".
    
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index aae2282..685b748 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1538,6 +1538,10 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	rootfstype=	[KNL] Set root filesystem type
 
+	rootwait	[KNL] Wait (indefinitely) for root device to show up.
+			Useful for devices that are detected asynchronously
+			(e.g. USB and MMC devices).
+
 	rw		[KNL] Mount root device read-write on boot
 
 	S		[KNL] Run init in single mode
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 46fe407..187dcb5 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -25,6 +25,7 @@ int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
 int root_mountflags = MS_RDONLY | MS_SILENT;
 char * __initdata root_device_name;
 static char __initdata saved_root_name[64];
+int __initdata root_wait;
 
 dev_t ROOT_DEV;
 
@@ -216,6 +217,16 @@ static int __init root_dev_setup(char *line)
 
 __setup("root=", root_dev_setup);
 
+static int __init rootwait_setup(char *str)
+{
+	if (*str)
+		return 0;
+	root_wait = 1;
+	return 1;
+}
+
+__setup("rootwait", rootwait_setup);
+
 static char * __initdata root_mount_data;
 static int __init root_data_setup(char *str)
 {
@@ -438,11 +449,20 @@ void __init prepare_namespace(void)
 			root_device_name += 5;
 	}
 
-	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
-
 	if (initrd_load())
 		goto out;
 
+	/* wait for any asynchronous scanning to complete */
+	if ((ROOT_DEV == 0) && root_wait) {
+		printk(KERN_INFO "Waiting for root device %s...\n",
+			saved_root_name);
+		while (driver_probe_done() != 0 ||
+			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
+			msleep(100);
+	}
+
+	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
+
 	if (is_floppy && rd_doload && rd_load_disk(0))
 		ROOT_DEV = Root_RAM0;
 

--=_hera.drzeus.cx-12578-1180680640-0001-2--

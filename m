Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYBQMYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYBQMYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbYBQMW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:22:59 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38322 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096AbYBQMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:56 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 03/27] pcmcia: silence section mismatch warnings from class_interface variables
Date: Sun, 17 Feb 2008 13:22:40 +0100
Message-Id: <1203250984-11285-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence the following warnings:
WARNING: drivers/pcmcia/built-in.o(.data+0x348): Section mismatch in reference from the variable pccard_sysfs_interface to the function .devinit.text:pccard_sysfs_add_socket()
WARNING: drivers/pcmcia/built-in.o(.data+0x350): Section mismatch in reference from the variable pccard_sysfs_interface to the function .devexit.text:pccard_sysfs_remove_socket()
WARNING: drivers/pcmcia/built-in.o(.data+0x6e8): Section mismatch in reference from the variable pcmcia_bus_interface to the function .devinit.text:pcmcia_bus_add_socket()
WARNING: drivers/pcmcia/built-in.o(.data+0xa88): Section mismatch in reference from the variable pccard_rsrc_interface to the function .devinit.text:pccard_sysfs_add_rsrc()
WARNING: drivers/pcmcia/built-in.o(.data+0xa90): Section mismatch in reference from the variable pccard_rsrc_interface to the function .devexit.text:pccard_sysfs_remove_rsrc()

The variables of type class_interface contains references
to __devinit and __devexit functions which is OK.
Silence warnings by annotating the variables with __refdata.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/pcmcia/ds.c             |    2 +-
 drivers/pcmcia/rsrc_nonstatic.c |    2 +-
 drivers/pcmcia/socket_sysfs.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 5a85871..e407754 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -1520,7 +1520,7 @@ static void pcmcia_bus_remove_socket(struct device *dev,
 
 
 /* the pcmcia_bus_interface is used to handle pcmcia socket devices */
-static struct class_interface pcmcia_bus_interface = {
+static struct class_interface pcmcia_bus_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pcmcia_bus_add_socket,
 	.remove_dev = &pcmcia_bus_remove_socket,
diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index a8d1007..0fcf763 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -1045,7 +1045,7 @@ static void __devexit pccard_sysfs_remove_rsrc(struct device *dev,
 		device_remove_file(dev, *attr);
 }
 
-static struct class_interface pccard_rsrc_interface = {
+static struct class_interface pccard_rsrc_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pccard_sysfs_add_rsrc,
 	.remove_dev = __devexit_p(&pccard_sysfs_remove_rsrc),
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index b440900..4677286 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -403,7 +403,7 @@ static void __devexit pccard_sysfs_remove_socket(struct device *dev,
 		device_remove_file(dev, *attr);
 }
 
-struct class_interface pccard_sysfs_interface = {
+struct class_interface pccard_sysfs_interface __refdata = {
 	.class = &pcmcia_socket_class,
 	.add_dev = &pccard_sysfs_add_socket,
 	.remove_dev = __devexit_p(&pccard_sysfs_remove_socket),
-- 
1.5.4.rc3.14.g44397


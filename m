Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZGRPeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZGRPeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZGRPeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:34:23 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47044 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZGRPeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:34:23 -0400
Subject: vc: create vcs(a) devices for consoles
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 17:34:17 +0200
Message-Id: <1247931257.29760.1.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: vc: create vcs(a) devices for consoles

The buffer for the consoles are unconditionally allocated at
con_init() time, which miss the creation of the vcs(a) devices.

Since 2.6.30, these devices are no longer created at open()
and removed on close(), but controlled by the lifetime of the
buffers.

Reported-by: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Tested-by: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Cc: stable@kernel.org
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 drivers/char/vc_screen.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -495,11 +495,15 @@ void vcs_remove_sysfs(int index)
 
 int __init vcs_init(void)
 {
+	unsigned int i;
+
 	if (register_chrdev(VCS_MAJOR, "vcs", &vcs_fops))
 		panic("unable to get major %d for vcs device", VCS_MAJOR);
 	vc_class = class_create(THIS_MODULE, "vc");
 
 	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 0), NULL, "vcs");
 	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 128), NULL, "vcsa");
+	for (i = 0; i < MIN_NR_CONSOLES; i++)
+		vcs_make_sysfs(i);
 	return 0;
 }



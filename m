Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZG1XuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZG1XuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZG1XuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:00 -0400
Received: from kroah.org ([198.145.64.141]:35762 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbZG1Xt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:55 2009
Message-Id: <20090728234155.604543229@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@linux.intel.com>
Subject: [patch 29/71] vc: create vcs(a) devices for consoles
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=vc-create-vcs-devices-for-consoles.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kay Sievers <kay.sievers@vrfy.org>

commit c46a7aec556ffdbdb7357db0b05904b176cb3375 upstream.

The buffer for the consoles are unconditionally allocated at con_init()
time, which miss the creation of the vcs(a) devices.

Since 2.6.30 (commit 4995f8ef9d3aac72745e12419d7fbaa8d01b1d81, 'vcs:
hook sysfs devices into object lifetime instead of "binding"' to be
exact) these devices are no longer created at open() and removed on
close(), but controlled by the lifetime of the buffers.

Reported-by: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Tested-by: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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



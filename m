Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbZJOTSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbZJOTSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762964AbZJOTSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:18:01 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35529 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762965AbZJOTSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:18:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 15 Oct 2009 21:16:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v3] firewire: cdev: reduce stack usage by ioctl_dispatch
To: linux1394-devel@lists.sourceforge.net
cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <4AD6F672.705@cam.ac.uk>
Message-ID: <tkrat.01048c8f2bd44ae6@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
 <tkrat.af1058f9e26f4dba@s5r6.in-berlin.de>
 <tkrat.ec38f27900b7af20@s5r6.in-berlin.de>
 <tkrat.fac844bd855a29ff@s5r6.in-berlin.de> <4AD6F672.705@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a hardcoded buffer size by a sizeof union {}.  This shrinks the
stack-allocated ioctl argument buffer from 256 to 40 bytes.  (This is
not much, but subsequent stack usage particularly by the queue_iso ioctl
handler adds up.)

The new form is also easier to keep up to date than a hardcoded size if
more ioctls are added.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

On 15 Oct, Jonathan Cameron wrote:
[v2 with BUILD_BUG_ON() tests]
> Obviously this will work fine, but curious what advantage this have over 
> the approach (used for example in some of the network drivers) of defining a
> union containing all the ioctl structs?  Then you use the size of that
> to define your buffer. Thus any new larger ioctl will expand the buffer
> size as long as it's in the union.

Uh, right, that's better.  Thanks for the pointer.

Plus, I realized just now that the runtime tests of _IOC_SIZE(cmd) need
to stay, regardless of how the buffer declaration is coded. So here is
yet another update.

 drivers/firewire/core-cdev.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6.31/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.31/drivers/firewire/core-cdev.c
@@ -1299,7 +1299,23 @@ static int (* const ioctl_handlers[])(st
 static int dispatch_ioctl(struct client *client,
 			  unsigned int cmd, void __user *arg)
 {
-	char buffer[256];
+	char buffer[sizeof(union {
+		struct fw_cdev_get_info			_00;
+		struct fw_cdev_send_request		_01;
+		struct fw_cdev_allocate			_02;
+		struct fw_cdev_deallocate		_03;
+		struct fw_cdev_send_response		_04;
+		struct fw_cdev_initiate_bus_reset	_05;
+		struct fw_cdev_add_descriptor		_06;
+		struct fw_cdev_remove_descriptor	_07;
+		struct fw_cdev_create_iso_context	_08;
+		struct fw_cdev_queue_iso		_09;
+		struct fw_cdev_start_iso		_0a;
+		struct fw_cdev_stop_iso			_0b;
+		struct fw_cdev_get_cycle_timer		_0c;
+		struct fw_cdev_allocate_iso_resource	_0d;
+		struct fw_cdev_send_stream_packet	_13;
+	})];
 	int ret;
 
 	if (_IOC_TYPE(cmd) != '#' ||


-- 
Stefan Richter
-=====-==--= =-=- -====
http://arcgraph.de/sr/


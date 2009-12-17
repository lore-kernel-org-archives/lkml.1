Return-Path: <linux-kernel-owner+w=401wt.eu-S936588AbZLQEdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936588AbZLQEdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935621AbZLQEEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:31 -0500
Received: from kroah.org ([198.145.64.141]:55560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935512AbZLQEEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:25 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:51 2009
Message-Id: <20091217035650.926077960@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: [062/151] Driver core: fix race in dev_driver_string
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 3589972e51fac1e02d0aaa576fa47f568cb94d40 upstream.

This patch (as1310) works around a race in dev_driver_string().  If
the device is unbound while the function is running, dev->driver might
become NULL after we test it and before we dereference it.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -56,7 +56,14 @@ static inline int device_is_not_partitio
  */
 const char *dev_driver_string(const struct device *dev)
 {
-	return dev->driver ? dev->driver->name :
+	struct device_driver *drv;
+
+	/* dev->driver can change to NULL underneath us because of unbinding,
+	 * so be careful about accessing it.  dev->bus and dev->class should
+	 * never change once they are set, so they don't need special care.
+	 */
+	drv = ACCESS_ONCE(dev->driver);
+	return drv ? drv->name :
 			(dev->bus ? dev->bus->name :
 			(dev->class ? dev->class->name : ""));
 }



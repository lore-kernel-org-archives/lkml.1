Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbXHUXA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbXHUXA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXHUXAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:00:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXHUXAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:00:18 -0400
Message-ID: <46CB6E7F.9080104@redhat.com>
Date: Tue, 21 Aug 2007 19:00:15 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: input: limit memory allocated by uinput ff drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

input: limit memory allocated by uinput ff drivers

Don't let force feedback drivers allocate more than 256K of kernel
memory. On kernel 2.6.22 this causes a kernel OOPS with the SLUB
memory allocator; on later kernels the drivers may allocate large
amounts of memory.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---
 drivers/input/ff-core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux-2.6.22.noarch.orig/drivers/input/ff-core.c
+++ linux-2.6.22.noarch/drivers/input/ff-core.c
@@ -306,6 +306,7 @@ int input_ff_create(struct input_dev *de
 {
 	struct ff_device *ff;
 	int i;
+	int needed_mem;
 
 	if (!max_effects) {
 		printk(KERN_ERR
@@ -313,8 +314,11 @@ int input_ff_create(struct input_dev *de
 		return -EINVAL;
 	}
 
-	ff = kzalloc(sizeof(struct ff_device) +
-		     max_effects * sizeof(struct file *), GFP_KERNEL);
+	needed_mem = sizeof(struct ff_device) + max_effects * sizeof(struct file *);
+	if (needed_mem > 256 * 1024)
+		return -ENOMEM;
+
+	ff = kzalloc(needed_mem, GFP_KERNEL);
 	if (!ff)
 		return -ENOMEM;
 

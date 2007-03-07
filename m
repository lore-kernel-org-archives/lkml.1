Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXCGLpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXCGLpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXCGLpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:45:21 -0500
Received: from aug.linbit.com ([212.69.162.22]:42614 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751674AbXCGLpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:45:19 -0500
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 06:45:18 EST
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: connector: Bugfix for cn_call_callback()
Date: Wed, 7 Mar 2007 12:26:12 +0100
User-Agent: KMail/1.9.4
Cc: drbd-dev@linbit.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703071226.13088.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

When one stresses the connector code, with sending many messages
from userspace to kernel, one could get in the "unlikely()"
part in cn_call_callback().

There a new __cbq gets allocated, and a NULL pointer got assigned
to the callback by dereferencing __cbq. This is the bug. The right
thing is the dereference the original __cbq. Therefore the bugfix
is to use a new variable for the newly allocated __cbq. 

This is tested, and it fixes the issue.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

--- /usr/src/linux-2.6.20/drivers/connector/connector.c 2007-03-07 11:45:38.000000000 +0100
+++ /usr/src/linux-2.6.20-modified/drivers/connector/connector.c        2007-03-07 11:39:11.000000000 +0100
@@ -128,7 +128,7 @@
  */
 static int cn_call_callback(struct cn_msg *msg, void (*destruct_data)(void *), void *data)
 {
-       struct cn_callback_entry *__cbq;
+       struct cn_callback_entry *__cbq, *__new_cbq;
        struct cn_dev *dev = &cdev;
        int err = -ENODEV;

@@ -148,23 +148,23 @@
                        } else {
                                struct cn_callback_data *d;

-                               __cbq = kzalloc(sizeof(*__cbq), GFP_ATOMIC);
-                               if (__cbq) {
-                                       d = &__cbq->data;
+                               __new_cbq = kzalloc(sizeof(*__new_cbq), GFP_ATOMIC);
+                               if (__new_cbq) {
+                                       d = &__new_cbq->data;
                                        d->callback_priv = msg;
                                        d->callback = __cbq->data.callback;
                                        d->ddata = data;
                                        d->destruct_data = destruct_data;
-                                       d->free = __cbq;
+                                       d->free = __new_cbq;

-                                       INIT_WORK(&__cbq->work,
-                                                       &cn_queue_wrapper);
+                                       INIT_WORK(&__new_cbq->work,
+                                                 &cn_queue_wrapper);

                                        if (queue_work(dev->cbdev->cn_queue,
-                                                   &__cbq->work))
+                                                   &__new_cbq->work))
                                                err = 0;
                                        else {
-                                               kfree(__cbq);
+                                               kfree(__new_cbq);
                                                err = -EINVAL;
                                        }
                                } else


-- 
: Dipl-Ing Philipp Reisner                      Tel +43-1-8178292-50 :
: LINBIT Information Technologies GmbH          Fax +43-1-8178292-82 :
: Vivenotgasse 48, 1120 Vienna, Austria        http://www.linbit.com :

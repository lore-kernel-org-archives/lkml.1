Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbYESUIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbYESUIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762812AbYESUIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:08:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56555 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762872AbYESUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:08:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 19 May 2008 22:07:28 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2
To: Jonathan Corbet <corbet@lwn.net>, linux1394-devel@lists.sourceforge.net
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <4831D484.10505@s5r6.in-berlin.de>
Message-ID: <tkrat.4b36f75b3b22c54c@s5r6.in-berlin.de>
References: <19845.1211148908@vena.lwn.net>
 <4831BD08.6030600@s5r6.in-berlin.de> <4831D484.10505@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 May, Stefan Richter wrote at LKML:
> I wrote:
>> Jonathan Corbet wrote:
>>>  drivers/ieee1394/dv1394.c                    |    6 +++-
>>>  drivers/ieee1394/raw1394.c                   |    3 ++
>>>  drivers/ieee1394/video1394.c                 |   18 +++++++++---
>> ...
>>>       ieee1394: cdev lock_kernel() pushdown
>> 
>> I have yet to look at these drivers in detail whether they need BKL or 
>> not.  They likely don't.
> 
> video1394 needs it to serialize module init vs. open.  The race 
> condition there can be prevented by splitting hpsb_register_highlevel() 
> into an _init and a _register function.  I will follow up with a patch.
> 
> dv1394 and raw1394 do not need the BKL in their open() methods AFAICS.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: video1394: reorder module init, prepare BKL removal

This prepares video1394 for removal of the BKL (big kernel lock):
It allows video1394_open() to be called while video1394_init_module()
is still in progress.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/highlevel.c |    4 +---
 drivers/ieee1394/highlevel.h |   13 ++++++++++++-
 drivers/ieee1394/video1394.c |    2 ++
 3 files changed, 15 insertions(+), 4 deletions(-)

Index: linux/drivers/ieee1394/highlevel.c
===================================================================
--- linux.orig/drivers/ieee1394/highlevel.c
+++ linux/drivers/ieee1394/highlevel.c
@@ -228,10 +228,8 @@ void hpsb_register_highlevel(struct hpsb
 {
 	unsigned long flags;
 
+	hpsb_init_highlevel(hl);
 	INIT_LIST_HEAD(&hl->addr_list);
-	INIT_LIST_HEAD(&hl->host_info_list);
-
-	rwlock_init(&hl->host_info_lock);
 
 	down_write(&hl_drivers_sem);
 	list_add_tail(&hl->hl_list, &hl_drivers);
Index: linux/drivers/ieee1394/highlevel.h
===================================================================
--- linux.orig/drivers/ieee1394/highlevel.h
+++ linux/drivers/ieee1394/highlevel.h
@@ -2,7 +2,7 @@
 #define IEEE1394_HIGHLEVEL_H
 
 #include <linux/list.h>
-#include <linux/spinlock_types.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 
 struct module;
@@ -103,6 +103,17 @@ int highlevel_lock64(struct hpsb_host *h
 void highlevel_fcp_request(struct hpsb_host *host, int nodeid, int direction,
 			   void *data, size_t length);
 
+/**
+ * hpsb_init_highlevel - initialize a struct hpsb_highlevel
+ *
+ * This is only necessary if hpsb_get_hostinfo_bykey can be called
+ * before hpsb_register_highlevel.
+ */
+static inline void hpsb_init_highlevel(struct hpsb_highlevel *hl)
+{
+	rwlock_init(&hl->host_info_lock);
+	INIT_LIST_HEAD(&hl->host_info_list);
+}
 void hpsb_register_highlevel(struct hpsb_highlevel *hl);
 void hpsb_unregister_highlevel(struct hpsb_highlevel *hl);
 
Index: linux/drivers/ieee1394/video1394.c
===================================================================
--- linux.orig/drivers/ieee1394/video1394.c
+++ linux/drivers/ieee1394/video1394.c
@@ -1503,6 +1503,8 @@ static int __init video1394_init_module 
 {
 	int ret;
 
+	hpsb_init_highlevel(&video1394_highlevel);
+
 	cdev_init(&video1394_cdev, &video1394_fops);
 	video1394_cdev.owner = THIS_MODULE;
 	ret = cdev_add(&video1394_cdev, IEEE1394_VIDEO1394_DEV, 16);

-- 
Stefan Richter
-=====-==--- -=-= =--==
http://arcgraph.de/sr/


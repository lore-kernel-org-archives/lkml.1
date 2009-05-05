Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZEEPrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZEEPrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZEEPrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:47:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:7821 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZEEPrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:47:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=b4A8+m8xVUIx+2bRix5ANJ48ATe4oiAeQFQRnl3XiXRZlXp7A/tvZg0v6b7ZZM6wtz
         i9GlGAMh9YwUY5KekZkRnAFJPXuUSEx8QauL988X1Vef98LkegIZpFogotrjFV1cY6CV
         OfsZZD1pPEPxy+DrfLu6QrC6LvxxhYFj9Eubo=
Date: Tue, 5 May 2009 23:47:25 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David VomLehn <dvomlehn@cisco.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <greg@kroah.com>, <linux-scsi@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/5] initdev:kernel: Asynchronously-discovered device
 synchronization, v5
Message-ID: <20090505234725.5ab247db@linux-lm>
In-Reply-To: <Pine.LNX.4.44L0.0905041100500.3092-100000@iolanthe.rowland.org>
References: <20090504074522.13f1ed77@infradead.org>
	<Pine.LNX.4.44L0.0905041100500.3092-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 11:07:52 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Mon, 4 May 2009, Arjan van de Ven wrote:
> 
> > > > for normal device probing we already have infrastructure
> > > > though... wait_for_device_probe, driver_probe_done and
> > > > friends... (the scsi scanning thread is being converted to the
> > > > async infrastructure btw)
> > > > 
> > > > do we need to invent more ?
> > > 
> > > I suppose the usb-storage scanning thread could also be converted
> > > to the async infrastructure, although I haven't heard of anybody
> > > working on it.
> > > 
> > > But the USB hub driver's thread (khubd) cannot be converted.  It
> > > is central to the discovery of USB-based block devices.  How
> > > would you handle that?
> > 
> > take a ref in the driver_probe_done() sense, and release it when you
> > know you're done probing....
> > 
> > at that point all existing infrastructure will just work.
> 
> Isn't there still something missing?  The wait_for_device_probe()  
> routine would wait until all attached devices had been probed.  But
> why should prepare_namespace() have to wait that long?  Wouldn't it be
> better to wait only until the root device has been registered?

Yes, maybe David should merge the following patch into the patch
No.5(initdev:kernel: USB and SCSI block init device notification, v3).

Right?

diff --git a/init/do_mounts.c b/init/do_mounts.c
index dd7ee5f..22fd773 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -358,6 +358,12 @@ void __init mount_root(void)
 #endif
 }
 
+static int root_dev_done()
+{
+	return !!(ROOT_DEV = name_to_dev_t(saved_root_name));
+}
+
+
 /*
  * Prepare the namespace - decide what/where to mount, load ramdisks,
etc. */
@@ -398,12 +404,12 @@ void __init prepare_namespace(void)
 		goto out;
 
 	/* wait for any asynchronous scanning to complete */
-	if ((ROOT_DEV == 0) && root_wait) {
+	if (ROOT_DEV == 0 && root_wait) {
 		printk(KERN_INFO "Waiting for root device %s...\n",
 			saved_root_name);
-		while (driver_probe_done() != 0 ||
-			(ROOT_DEV = name_to_dev_t(saved_root_name)) ==
0)
-			msleep(100);
+		do {
+			initdev_wait(BOOTDEV_BLOCK, root_dev_done);
+		} while (!ROOT_DEV);
 		async_synchronize_full();
 	}
 



-- 
Lei Ming

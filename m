Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbXHFP0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbXHFP0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932962AbXHFP0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:26:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:13774 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879AbXHFP0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:26:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fgEVLtYQ9ThQXjUrryhiy8tjgkJP7mnfULJR3Zm8Oy56mOGXBq6Res+nXwp7afs4vWedCrV7HB0SwBvYYLS3KBCmPBEJRm01oHx6NrisodKSfdYV2ZWIKOvhTVtPWyi3Wa2CYLRZxBruuRVyhumK2TdfECB173Dz5bHaDGHq0Bw=
Message-ID: <961aa3350708060826n58a9dbd5o67355d5e53542e8a@mail.gmail.com>
Date: Tue, 7 Aug 2007 00:26:36 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.23-rc1-mm2 + cpufreq patch + hot-fixes -- [<f8ea528f>] usb_stor_scan_thread+0xbd/0x15a [usb_storage]
Cc: "Miles Lane" <miles.lane@gmail.com>, "Andrew Morton" <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <Pine.LNX.4.44L0.0708061007350.3265-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0708040518vfcf671p7ef1c6d89e330d89@mail.gmail.com>
	 <Pine.LNX.4.44L0.0708061007350.3265-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/6, Alan Stern <stern@rowland.harvard.edu>:
> On Sat, 4 Aug 2007, Miles Lane wrote:
>
> > Initializing USB Mass Storage driver...
> > usb-storage 4-3:1.0: usb_probe_interface
> > usb-storage 4-3:1.0: usb_probe_interface - got id
> > scsi2 : SCSI emulation for USB Mass Storage devices
> > usbcore: registered new interface driver usb-storage
> > usb-storage: device found at 2
> > usb-storage: waiting for device to settle before scanning
> > schedule_timeout: wrong timeout value f8ea51d2
> >  [<c01080ab>] show_trace_log_lvl+0x12/0x25
> >  [<c0108a9e>] show_trace+0xd/0x10
> >  [<c0108bac>] dump_stack+0x16/0x18
> >  [<c031e31e>] schedule_timeout+0x2c/0x8b
> >  [<f8ea528f>] usb_stor_scan_thread+0xbd/0x15a [usb_storage]
> >  [<c0139d64>] kthread+0x3b/0x63
> >  [<c0107c63>] kernel_thread_helper+0x7/0x10
> >  =======================
>
> Does this happen repeatably?
>
> Did you set usb-storage's delay_use parameter to something peculiar?

I also have same problem. It is caused by
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm2/broken-out/freezer-introduce-freezer-firendly-waiting-macros.patch

The patch below may not be good fix. But it shows what is problem.

Index: 2.6-mm/include/linux/freezer.h
===================================================================
--- 2.6-mm.orig/include/linux/freezer.h
+++ 2.6-mm/include/linux/freezer.h
@@ -149,13 +149,13 @@ static inline void set_freezable(void)

 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 ({									\
-	long __ret = timeout;						\
+	long ____ret = timeout;						\
 	do {								\
-		__ret = wait_event_interruptible_timeout(wq,		\
+		____ret = wait_event_interruptible_timeout(wq,		\
 				(condition) || freezing(current),	\
-				__ret); 				\
+				____ret); 				\
 	} while (try_to_freeze());					\
-	__ret;								\
+	____ret;							\
 })
 #else /* !CONFIG_PM_SLEEP */
 static inline int frozen(struct task_struct *p) { return 0; }

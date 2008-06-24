Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbYFXSts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbYFXSts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 14:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYFXStj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 14:49:39 -0400
Received: from smtp.nokia.com ([192.100.105.134]:25474 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYFXSth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 14:49:37 -0400
Message-ID: <48613FEF.8020004@nokia.com>
Date: Tue, 24 Jun 2008 21:41:51 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
References: <Pine.LNX.4.44L0.0806231403350.2556-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806231403350.2556-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2008 18:42:29.0517 (UTC) FILETIME=[0E31BBD0:01C8D62A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ext Alan Stern wrote:
> 
>>> Can you add debugging
>>> printk statements to the USB bluetooth driver to try and localize where
>>> the hang occurs?
>> Any suggestions where to start?
> 
> Around every place where the driver calls into the core.  You might 
> also want to debug the places where uhci-hcd acquires and releases 
> spinlocks.

I sprinkled some printk's into hci_usb.c. But I see only messages at the 
start of bluetooth daemon.

>>>>> git bisect resulted in the following bad commit:
>>>>>
>>>>> e9df41c5c5899259541dc928872cad4d07b82076 is first bad commit
>>>>> commit e9df41c5c5899259541dc928872cad4d07b82076
>>>>> Author: Alan Stern <stern@rowland.harvard.edu>
>>>>> Date:   Wed Aug 8 11:48:02 2007 -0400
>>>>>
>>>>>     USB: make HCDs responsible for managing endpoint queues
>>> Knowing this doesn't help much without more information.
> 
>> That commit has spinlock changes so I hoped that it would be a good 
>> starting point. Is there a way to track the locks?
> 
> Only what I suggested: Print something in the log whenever a lock is 
> acquired or released.

I played around with printk a little bit more. With the following change 
to uhci_giveback_urb():

--- a/drivers/usb/host/uhci-q.c
+++ b/drivers/usb/host/uhci-q.c
@@ -1526,11 +1530,17 @@ __acquires(uhci->lock)
         }

         uhci_free_urb_priv(uhci, urbp);
+       printk(KERN_CRIT "UHCI UNLINK ENTER %08x %08x\n",
+              (unsigned int) uhci, (unsigned int) urb);
         usb_hcd_unlink_urb_from_ep(uhci_to_hcd(uhci), urb);
+       printk(KERN_CRIT "UHCI UNLINK LEAVE %08x %08x\n",
+              (unsigned int) uhci, (unsigned int) urb);

         spin_unlock(&uhci->lock);

I see

  UHCI UNLINK ENTER xxxxxxxx yyyyyyyy
  UHCI UNLINK LEAVE xxxxxxxx yyyyyyyy
  UHCI UNLINK ENTER xxxxxxxx yyyyyyyy

on the console at the time of the lockup. Then I added the following change:

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1107,7 +1107,13 @@ EXPORT_SYMBOL_GPL(usb_hcd_check_unlink_urb);
  void usb_hcd_unlink_urb_from_ep(struct usb_hcd *hcd, struct urb *urb)
  {
         /* clear all state linking urb to this dev (and hcd) */
+#if 0
         spin_lock(&hcd_urb_list_lock);
+#else
+       if (!spin_trylock(&hcd_urb_list_lock)) {
+         printk(KERN_CRIT "HCD URB LIST ALREADY LOCKED!\n");
+       }
+#endif
         list_del_init(&urb->urb_list);
         spin_unlock(&hcd_urb_list_lock);
  }

and get this at the time of the lockup:

  UHCI UNLINK ENTER xxxxxxxx yyyyyyyy
  UHCI UNLINK LEAVE xxxxxxxx yyyyyyyy
  UHCI UNLINK ENTER xxxxxxxx yyyyyyyy
  HCD URB LIST ALREADY LOCKED!
             <---- here the original code would lockup
  UHCI UNLINK LEAVE xxxxxxxx yyyyyyyy
  HCD URB LIST ALREADY LOCKED!
  HCD URB LIST ALREADY LOCKED!
  HCD URB LIST ALREADY LOCKED!

So the lockup is caused by an already locked hcd_urb_list_lock. Is there 
a way to see the lock holder? Or any other suggestions how to proceed?

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com

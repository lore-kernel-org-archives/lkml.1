Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbXHITG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbXHITG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbXHITGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:06:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbXHITGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:06:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: Re: [linux-usb-devel] [usb-storage] schedule_timeout: wrong timeout value c1a95554
Date: Thu, 9 Aug 2007 21:15:42 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
References: <Pine.LNX.4.44L0.0708091042520.3559-100000@iolanthe.rowland.org> <200708091707.44742.rjw@sisk.pl> <200708091720.02027.m.kozlowski@tuxland.pl>
In-Reply-To: <200708091720.02027.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708092115.43548.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 9 August 2007 17:20, Mariusz Kozlowski wrote:
> > > > 	Happens every time I reattach usb pen drive.
> > > > 
> > > > usb 1-2: new high speed USB device using ehci_hcd and address 10
> > > > usb 1-2: configuration #1 chosen from 1 choice
> > > > scsi6 : SCSI emulation for USB Mass Storage devices
> > > > usb 1-2: new device found, idVendor=13fe, idProduct=1a00
> > > > usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
> > > > usb 1-2: Product: GEIL USB DISK   
> > > > usb 1-2: Manufacturer:         
> > > > usb-storage: device found at 10
> > > > usb-storage: waiting for device to settle before scanning
> > > > schedule_timeout: wrong timeout value c1a95554
> > > >  [<c010456a>] show_trace_log_lvl+0x1a/0x30
> > > >  [<c010508d>] show_trace+0x12/0x14
> > > >  [<c01051e0>] dump_stack+0x15/0x17
> > > >  [<c04174d1>] schedule_timeout+0x8c/0xa2
> > > >  [<c032aeec>] usb_stor_scan_thread+0x100/0x160
> > > >  [<c0127f2e>] kthread+0x36/0x58
> > > >  [<c0104233>] kernel_thread_helper+0x7/0x14
> > > >  =======================
> > > > scsi 6:0:0:0: Direct-Access              GEIL USB DISK    >2.0 PQ: 0 ANSI: 0 CCS
> > > > sd 6:0:0:0: [sda] 1007616 512-byte hardware sectors (516 MB)
> > > > sd 6:0:0:0: [sda] Write Protect is off
> > > > sd 6:0:0:0: [sda] Mode Sense: 23 00 00 00
> > > > sd 6:0:0:0: [sda] Assuming drive cache: write through
> > > > sd 6:0:0:0: [sda] 1007616 512-byte hardware sectors (516 MB)
> > > > sd 6:0:0:0: [sda] Write Protect is off
> > > > sd 6:0:0:0: [sda] Mode Sense: 23 00 00 00
> > > > sd 6:0:0:0: [sda] Assuming drive cache: write through
> > > >  sda: sda1
> > > > sd 6:0:0:0: [sda] Attached SCSI removable disk
> > > > sd 6:0:0:0: Attached scsi generic sg0 type 0
> > > > usb-storage: device scan complete
> > > 
> > > This is a known problem.  See
> > > 
> > > 	http://marc.info/?l=linux-kernel&m=118641424414399&w=2
> > > 
> > > Rafael, has this been fixed yet?
> > 
> > No, I wasn't aware of it.
> > 
> > I think that something like the appended patch is necessary.
> > 
> > Mariusz, please see if that helps.
> 
> Yes - this patch fixes the bug.

OK, thanks for the confirmation.

Here it goes again with a changelog etc.

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix a bug in freezer-introduce-freezer-firendly-waiting-macros.patch which
uses a wrong variable name in wait_event_freezable() and
wait_event_freezable_timeout() (this name is also used in 
wait_event_interruptible() and wait_event_interruptible_timeout() which are
macros and the names clash).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/freezer.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6.23-rc2/include/linux/freezer.h
===================================================================
--- linux-2.6.23-rc2.orig/include/linux/freezer.h
+++ linux-2.6.23-rc2/include/linux/freezer.h
@@ -134,28 +134,28 @@ static inline void set_freezable(void)
 
 #define wait_event_freezable(wq, condition)				\
 ({									\
-	int __ret;							\
+	int __retval;							\
 	do {								\
-		__ret = wait_event_interruptible(wq, 			\
+		__retval = wait_event_interruptible(wq, 		\
 				(condition) || freezing(current));	\
-		if (__ret && !freezing(current))			\
+		if (__retval && !freezing(current))			\
 			break;						\
 		else if (!(condition))					\
-			__ret = -ERESTARTSYS;				\
+			__retval = -ERESTARTSYS;			\
 	} while (try_to_freeze());					\
-	__ret;								\
+	__retval;							\
 })
 
 
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 ({									\
-	long __ret = timeout;						\
+	long __retval = timeout;					\
 	do {								\
-		__ret = wait_event_interruptible_timeout(wq,		\
+		__retval = wait_event_interruptible_timeout(wq,		\
 				(condition) || freezing(current),	\
-				__ret); 				\
+				__retval); 				\
 	} while (try_to_freeze());					\
-	__ret;								\
+	__retval;							\
 })
 #else /* !CONFIG_PM_SLEEP */
 static inline int frozen(struct task_struct *p) { return 0; }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764775AbXJONSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764775AbXJONSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759855AbXJONSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:18:39 -0400
Received: from styx.suse.cz ([82.119.242.94]:54688 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759572AbXJONSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:18:38 -0400
Date: Mon, 15 Oct 2007 15:17:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WTF is HIDIOCGRDESC supposed to do (aside of being a roothole)?
In-Reply-To: <20071015005623.GB8181@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0710151023110.20620@jikos.suse.cz>
References: <20071015005623.GB8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Al Viro wrote:

> This
> +                               if (get_user(len, (int __user *)arg))
> +                                       return -EFAULT;
> +                               if (copy_to_user(*((__u8 **)(user_arg +
> +                                                       sizeof(__u32))),
> +                                                       dev->hid->rdesc, len))
> is an instant trouble 

Ouch. My bad, I mis-merged from the wrong version of the branch when 
preparing the branch to merge.

The patch below is needed. Thanks a lot for catching this. I will take 
this through my tree in the next round of updates if Linus doesn't pick it 
up.



From: Jiri Kosina <jkosina@suse.cz>

HID: fix HIDIOCGRDESC memory access in hidraw

Fix bogus copying of data into userspace when HIDIOCGRDESC is issued. 
HID-transport layer makes sure that dev->hid->rdesc is not larger than 
HID_MAX_DESCRIPTOR_SIZE.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 8503197..11ced6a 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -229,9 +229,15 @@ static int hidraw_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 
 				if (get_user(len, (int __user *)arg))
 					return -EFAULT;
-				if (copy_to_user(*((__u8 **)(user_arg +
-							sizeof(__u32))),
-							dev->hid->rdesc, len))
+
+				if (len > HID_MAX_DESCRIPTOR_SIZE - 1)
+					return -EINVAL;
+
+				if (copy_to_user(user_arg + offsetof(
+								struct hidraw_report_descriptor,
+								value[0]),
+							dev->hid->rdesc,
+							min(dev->hid->rsize, len)))
 						return -EFAULT;
 				return 0;
 			}
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 55e51f9..edb8024 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -29,13 +29,6 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/list.h>
-#include <linux/timer.h>
-#include <linux/workqueue.h>
-#include <linux/input.h>
-
 /*
  * USB HID (Human Interface Device) interface class code
  */
@@ -69,6 +62,17 @@
 #define HID_DT_REPORT			(USB_TYPE_CLASS | 0x02)
 #define HID_DT_PHYSICAL			(USB_TYPE_CLASS | 0x03)
 
+#define HID_MAX_DESCRIPTOR_SIZE		4096
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <linux/input.h>
+
 /*
  * We parse each description item into this structure. Short items data
  * values are expanded to 32-bit signed int, long items contain a pointer
@@ -311,7 +315,6 @@ struct hid_global {
  * This is the local environment. It is persistent up the next main-item.
  */
 
-#define HID_MAX_DESCRIPTOR_SIZE		4096
 #define HID_MAX_USAGES			8192
 #define HID_DEFAULT_NUM_COLLECTIONS	16
 
@@ -560,4 +563,5 @@ static inline int hid_ff_init(struct hid_device *hid) { return -1; }
 #define err_hid(format, arg...) printk(KERN_ERR "%s: " format "\n" , \
 		__FILE__ , ## arg)
 #endif
+#endif
 
diff --git a/include/linux/hidraw.h b/include/linux/hidraw.h
index 6676cd5..0536f29 100644
--- a/include/linux/hidraw.h
+++ b/include/linux/hidraw.h
@@ -15,9 +15,11 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#include <linux/hid.h>
+
 struct hidraw_report_descriptor {
 	__u32 size;
-	__u8 *value;
+	__u8 value[HID_MAX_DESCRIPTOR_SIZE];
 };
 
 struct hidraw_devinfo {
@@ -40,8 +42,6 @@ struct hidraw_devinfo {
 /* kernel-only API declarations */
 #ifdef __KERNEL__
 
-#include <linux/hid.h>
-
 struct hidraw {
 	unsigned int minor;
 	int exist;

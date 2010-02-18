Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab0BRP7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:59:49 -0500
Received: from www.linuxtv.org ([130.149.80.248]:42267 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558Ab0BRP70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:59:26 -0500
Subject: [git:v4l-dvb/master] V4L/DVB: media/video/tlg2300: fix build when CONFIG_PM=n
From: Patch from Randy Dunlap <linuxtv-commits-bounces@linuxtv.org>
To: linuxtv-commits@linuxtv.org
Data: Fri, 12 Feb 2010 18:02:29 -0300
Cc: Mocean Laboratories <info@mocean-labs.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       linux-kernel@vger.kernel.org, Kang Yong <kangyong@telegent.com>,
       Huang Shijie <shijie8@gmail.com>, Zhang Xiaobing <xbzhang@telegent.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1Ni8UK-00086u-0J@www.linuxtv.org>
Date: Thu, 18 Feb 2010 16:40:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_PM is not enabled, tlg2300 has build errors,
so handle that case, mostly via stubs.

drivers/media/video/tlg2300/pd-alsa.c:237: error: 'struct poseidon' has no member named 'msg'
drivers/media/video/tlg2300/pd-main.c:412: error: implicit declaration of function 'find_old_poseidon'
drivers/media/video/tlg2300/pd-main.c:418: error: implicit declaration of function 'set_map_flags'
drivers/media/video/tlg2300/pd-main.c:462: error: implicit declaration of function 'get_pd'

Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 	linux-media@vger.kernel.org
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: Kang Yong <kangyong@telegent.com>
Cc: Zhang Xiaobing <xbzhang@telegent.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/video/tlg2300/pd-common.h |    4 ++++
 drivers/media/video/tlg2300/pd-main.c   |   19 ++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

---

http://git.linuxtv.org/v4l-dvb.git?a=commit;h=bfd1728c2f00600078c4681e3156c50c28d6cdf6

diff --git a/drivers/media/video/tlg2300/pd-common.h b/drivers/media/video/tlg2300/pd-common.h
index ae9cb6c..46066bd 100644
--- a/drivers/media/video/tlg2300/pd-common.h
+++ b/drivers/media/video/tlg2300/pd-common.h
@@ -254,7 +254,11 @@ void destroy_video_device(struct video_device **v_dev);
 extern int debug_mode;
 void set_debug_mode(struct video_device *vfd, int debug_mode);
 
+#ifdef CONFIG_PM
 #define in_hibernation(pd) (pd->msg.event == PM_EVENT_FREEZE)
+#else
+#define in_hibernation(pd) (0)
+#endif
 #define get_pm_count(p) (atomic_read(&(p)->interface->pm_usage_cnt))
 
 #define log(a, ...) printk(KERN_DEBUG "\t[ %s : %.3d ] "a"\n", \
diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
index fdcc500..2cf0ebf 100644
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -255,6 +255,11 @@ out:
 	return ret;
 }
 
+static inline struct poseidon *get_pd(struct usb_interface *intf)
+{
+	return usb_get_intfdata(intf);
+}
+
 #ifdef CONFIG_PM
 /* one-to-one map : poseidon{} <----> usb_device{}'s port */
 static inline void set_map_flags(struct poseidon *pd, struct usb_device *udev)
@@ -303,11 +308,6 @@ static inline int is_working(struct poseidon *pd)
 	return get_pm_count(pd) > 0;
 }
 
-static inline struct poseidon *get_pd(struct usb_interface *intf)
-{
-	return usb_get_intfdata(intf);
-}
-
 static int poseidon_suspend(struct usb_interface *intf, pm_message_t msg)
 {
 	struct poseidon *pd = get_pd(intf);
@@ -366,6 +366,15 @@ static void hibernation_resume(struct work_struct *w)
 	if (pd->pm_resume)
 		pd->pm_resume(pd);
 }
+#else /* CONFIG_PM is not enabled: */
+static inline struct poseidon *find_old_poseidon(struct usb_device *udev)
+{
+	return NULL;
+}
+
+static inline void set_map_flags(struct poseidon *pd, struct usb_device *udev)
+{
+}
 #endif
 
 static bool check_firmware(struct usb_device *udev, int *down_firmware)

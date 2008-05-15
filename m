Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbYEOLiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbYEOLiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYEOLim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:38:42 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:36898 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYEOLil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:38:41 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add Sensoray 2255 v4l driver
Date: Thu, 15 May 2008 13:38:37 +0200
User-Agent: KMail/1.9.9
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
References: <20080514205927.GA13134@kroah.com>
In-Reply-To: <20080514205927.GA13134@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805151338.38801.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

1. how about a *.h file?

2. You can inline these.

+static int norm_maxw(struct video_device *vdev)
+{
+       return (vdev->current_norm != V4L2_STD_PAL_B) ?
+           LINE_SZ_4CIFS_NTSC : LINE_SZ_4CIFS_PAL;
+}

3. The firmware stuff. That's an interesting solution. However:

a - if you don't need that delay, use a work queue

b - that's mean, use interruptible sleep

+               /* give 1 second for firmware to load in case
+                  driver loaded and then device immediately opened */
+               msleep(1000);

particularly you'd stall khubd processing an early unplug

c - obviously loading the firmware might have failed after waiting

+               if (dev->fw_data->fw_state == FWSTATE_NOTLOADED) {
+                       err("2255 firmware loading stalled\n");
+                       mutex_unlock(&usb_s2255_open_mutex);
+                       return -EAGAIN;
+               }
+       }

you need a check for failure in an else branch

d - so you'll never release firmware in the error case unless you unplug

+       /* if first open after firmware loaded, release the firmware */
+       if (dev->fw_data->fw) {
+               release_firmware(dev->fw_data->fw);
+               dev->fw_data->fw = NULL;
+       }

e - you need to report errors

+static void s2255_timer(unsigned long user_data)
+{
+       struct complete_data *data = (struct complete_data *)user_data;
+       dprintk(100, "s2255 timer\n");
+       if (usb_submit_urb(data->fw_urb, GFP_ATOMIC) < 0) {
+               printk(KERN_ERR "s2255: can't submit urb\n");
+               if (data->fw) {
+                       release_firmware(data->fw);
+                       data->fw = NULL;
+               }
+               return;
+       }
+}

f - also here

+static void s2255_fwchunk_complete(struct urb *urb)
+{
+       struct complete_data *data = urb->context;
+       struct usb_device *udev = urb->dev;
+       int len;
+       dprintk(100, "udev %p urb %p", udev, urb);
+
+       if (urb->status) {
+               dev_err(&udev->dev, "URB failed with status %d", urb->status);
+               return;
+       }

4. as a rule, init all locks before you start a timer

+       mod_timer(&dev->timer, jiffies + HZ);
+       spin_lock_init(&dev->slock);

5. Unnecessary init

+static void s2255_disconnect(struct usb_interface *interface)
+{
+       struct s2255_dev *dev = NULL;

6. The initial firmware timer may still be ticking

+       if (dev->fw_data->fw_urb) {
+               dprintk(2, "kill URB\n");
+               usb_kill_urb(dev->fw_data->fw_urb);
+               usb_free_urb(dev->fw_data->fw_urb);

You need to delete that timer and kill the firmware urb after that.

7. That's not an error you want to return in that case. It may livelock

+       if (dev->users[cur_channel] > 1) {
+               dev->users[cur_channel]--;
+               dev_err(&dev->udev->dev, "one user at a time\n");
+               mutex_unlock(&usb_s2255_open_mutex);
+               return -EAGAIN;
+       }

8. Bogus check

+       if (data->fw_urb == NULL) {
+               dev_err(&udev->dev, "early disconncect\n");
+               return;
+       }

9. This can be computed directly

+       while (*size * *count > vid_limit * 1024 * 1024)
+               (*count)--;

10. This is fishy.

+static int res_locked(struct s2255_dev *dev, struct s2255_fh *fh)
+{
+       return (dev->resources[fh->channel]);
+}
+
+static void res_free(struct s2255_dev *dev, struct s2255_fh *fh)
+{
+       dev->resources[fh->channel] = 0;
+       dprintk(1, "res: put\n");
+}

In theory out of order memory access might return false positives.
Better use memory barriers or take the mutex.

11. Coding style

+       return (0);

12. This is close to obfuscated code

+       is_ntsc =
+           (dev->vdev[fh->channel]->current_norm != V4L2_STD_PAL_B) ? 1 : 0;

13. Coding style

+       if (ret < 0)
+               return (ret);

14. GFP_KERNEL in interrupt context

+
+       if (pipe_info->state != 0) {
+               if (usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL)) {

15. Error handling in s2255_probe() is a gigantic resource leak

+       if (!dev->fw_data->fw_urb) {
+               dev_err(&interface->dev, "out of memory!\n");
+               goto error;
+       }

You must free what you allocate

	Regards
		Oliver

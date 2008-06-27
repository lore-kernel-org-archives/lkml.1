Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYF0K6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYF0K6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 06:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYF0K60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 06:58:26 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53750 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYF0K6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 06:58:24 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] add Sensoray 2255 v4l driver
Date: Fri, 27 Jun 2008 12:58:50 +0200
User-Agent: KMail/1.9.9
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, dean@sensoray.com
References: <20080626231551.GA20012@kroah.com>
In-Reply-To: <20080626231551.GA20012@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806271258.52329.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 27 Juni 2008 01:15:51 schrieb Greg KH:
> From: Dean Anderson <dean@sensoray.com>
> 
> This driver adds support for the Sensoray 2255 devices.
> 
> It was primarily developed by Dean Anderson with only a little bit of
> guidance and cleanup by Greg.
> 
> Signed-off-by: Dean Anderson <dean@sensoray.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
> 
> All of the previous review comments have been addressed in this version.
> Mauro, can you apply this to your tree if there are no other objections?

> +/* kickstarts the firmware loading. from probe
> + */
> +static void s2255_timer(unsigned long user_data)
> +{
> +	struct s2255_fw *data = (struct s2255_fw *)user_data;
> +	dprintk(100, "s2255 timer\n");
> +	if (usb_submit_urb(data->fw_urb, GFP_ATOMIC) < 0) {

In this error case the state is stuck at FW_NOTLOADED and the firmware
can never be loaded as you release it. In principle you should deregister
the device under these conditions.

> +		printk(KERN_ERR "s2255: can't submit urb\n");
> +		if (data->fw) {
> +			release_firmware(data->fw);
> +			data->fw = NULL;
> +		}
> +		return;
> +	}
> +}
> +
> +/* called when DSP is up and running.  DSP is guaranteed to
> +   be running after S2255_DSP_BOOTTIME */
> +static void s2255_dsp_running(unsigned long user_data)
> +{
> +	struct s2255_fw *data = (struct s2255_fw *)user_data;
> +	dprintk(1, "dsp running\n");
> +	atomic_set(&data->fw_state, S2255_FW_SUCCESS);
> +	wake_up(&data->wait_fw);
> +	printk(KERN_INFO "s2255: firmware loaded successfully\n");
> +	return;
> +}
> +
> +
> +/* this loads the firmware asynchronously.
> +   Originally this was done synchroously in probe.
> +   But it is better to load it asynchronously here than block
> +   inside the probe function. Blocking inside probe affects boot time.
> +   FW loading is triggered by the timer in the probe function
> +*/
> +static void s2255_fwchunk_complete(struct urb *urb)
> +{
> +	struct s2255_fw *data = urb->context;
> +	struct usb_device *udev = urb->dev;
> +	int len;
> +	dprintk(100, "udev %p urb %p", udev, urb);
> +
> +	if (urb->status) {
> +		dev_err(&udev->dev, "URB failed with status %d", urb->status);

You fail to reflect the change in status.

> +		return;
> +	}
> +	if (data->fw_urb == NULL) {
> +		dev_err(&udev->dev, "early disconncect\n");
> +		return;
> +	}
> +#define CHUNK_SIZE 512
> +	/* all USB transfers must be done with continuous kernel memory.
> +	   can't allocate more than 128k in current linux kernel, so
> +	   upload the firmware in chunks
> +	 */
> +	if (data->fw_loaded < data->fw_size) {
> +		len = (data->fw_loaded + CHUNK_SIZE) > data->fw_size ?
> +		    data->fw_size % CHUNK_SIZE : CHUNK_SIZE;
> +
> +		if (len < CHUNK_SIZE)
> +			memset(data->pfw_data, 0, CHUNK_SIZE);
> +
> +		dprintk(100, "completed len %d, loaded %d \n", len,
> +			data->fw_loaded);
> +
> +		memcpy(data->pfw_data,
> +		       (char *) data->fw->data + data->fw_loaded, len);
> +
> +		usb_fill_bulk_urb(data->fw_urb, udev, usb_sndbulkpipe(udev, 2),
> +				  data->pfw_data, CHUNK_SIZE,
> +				  s2255_fwchunk_complete, data);
> +		if (usb_submit_urb(data->fw_urb, GFP_ATOMIC) < 0) {
> +			dev_err(&udev->dev, "failed submit URB\n");
> +			atomic_set(&data->fw_state, S2255_FW_FAILED);
> +			/* wake up anything waiting for the firmware */
> +			wake_up(&data->wait_fw);
> +			return;
> +		}
> +		data->fw_loaded += len;
> +	} else {
> +		init_timer(&data->dsp_wait);
> +		data->dsp_wait.function = s2255_dsp_running;
> +		data->dsp_wait.data = (unsigned long)data;
> +		atomic_set(&data->fw_state, S2255_FW_LOADED_DSPWAIT);
> +		mod_timer(&data->dsp_wait, msecs_to_jiffies(S2255_DSP_BOOTTIME)
> +			  + jiffies);
> +	}
> +	dprintk(100, "2255 complete done\n");
> +	return;
> +
> +}

[..]

> +static void s2255_destroy(struct kref *kref)
> +{
> +	struct s2255_dev *dev = to_s2255_dev(kref);
> +	if (!dev) {
> +		printk(KERN_ERR "s2255drv: kref problem\n");
> +		return;
> +	}
> +	/* prevent s2255_disconnect from racing s2255_open */
> +	mutex_lock(&dev->open_lock);
> +	s2255_exit_v4l(dev);
> +	/* device unregistered so no longer possible to open. open_mutex
> +	   can be unlocked */
> +	mutex_unlock(&dev->open_lock);
> +
> +	/* board shutdown stops the read pipe if it is running */
> +	s2255_board_shutdown(dev);
> +
> +	/* make sure firmware still not trying to load */
> +	if (dev->fw_data->fw_urb) {
> +		dprintk(2, "kill fw_urb\n");
> +		usb_kill_urb(dev->fw_data->fw_urb);
> +		usb_free_urb(dev->fw_data->fw_urb);
> +		dev->fw_data->fw_urb = NULL;

You are potentially leaving both timers alive.

> +	}
> +
> +	/* make sure we aren't waiting for the DSP */
> +	if (atomic_read(&dev->fw_data->fw_state) == S2255_FW_LOADED_DSPWAIT) {
> +		/* if we are, wait for the wakeup for fw_success or timeout */
> +		wait_event_timeout(dev->fw_data->wait_fw,
> +				   (atomic_read(&dev->fw_data->fw_state)
> +				   == S2255_FW_SUCCESS),
> +				   msecs_to_jiffies(S2255_LOAD_TIMEOUT));

If a timeout happens you cannot simply ignore it.

> +	}
> +
> +	if (dev->fw_data) {
> +		kfree(dev->fw_data->pfw_data);
> +		kfree(dev->fw_data);
> +	}
> +
> +	if (dev->fw_data->fw) {

Stone cold access after kfree()

> +		release_firmware(dev->fw_data->fw);
> +		dev->fw_data->fw = NULL;
> +	}
> +
> +	usb_put_dev(dev->udev);
> +	dprintk(1, "%s", __func__);
> +	kfree(dev);
> +}

	Regards
		Oliver


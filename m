Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbXIZNJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbXIZNJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbXIZNIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:08:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49144 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXIZNIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:08:51 -0400
Subject: Re: Oops in pwc v4l driver
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alex Smith <lkml@alex-smith.me.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <200709021502.17458.oliver@neukum.org>
References: <a0738740709020457n3490ee52l49d29712f3ddbb75@mail.gmail.com>
	 <200709021502.17458.oliver@neukum.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 26 Sep 2007 10:07:21 -0300
Message-Id: <1190812041.5076.7.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

May you send your Signed-off-by for the patch?

Cheers,
Mauro.

Em Dom, 2007-09-02 às 15:02 +0200, Oliver Neukum escreveu:
> Am Sonntag 02 September 2007 schrieb Alex Smith:
> > Hi,
> > 
> > I found an old Philips Askey VC010 webcam and attempted to get it
> > working on Linux (latest git, x86_64). It worked fine, I could view
> > the camera in mplayer. But, however, when I went to move the camera, I
> > unplugged it and forgot to close mplayer. I didn't notice, moved it,
> 
> Yes,
> 
> this is a known issue. This patch should fix it. Does it work for you?
> 
> 	Regards
> 		Oliver
> ---
> 
> --- a/drivers/media/video/pwc/pwc-if.c	2007-08-24 10:16:38.000000000 +0200
> +++ b/drivers/media/video/pwc/pwc-if.c	2007-08-24 11:01:26.000000000 +0200
> @@ -908,31 +908,49 @@ int pwc_isoc_init(struct pwc_device *pde
>  	return 0;
>  }
>  
> -void pwc_isoc_cleanup(struct pwc_device *pdev)
> +static void pwc_iso_stop(struct pwc_device *pdev)
>  {
>  	int i;
>  
> -	PWC_DEBUG_OPEN(">> pwc_isoc_cleanup()\n");
> -	if (pdev == NULL)
> -		return;
> -	if (pdev->iso_init == 0)
> -		return;
> -
>  	/* Unlinking ISOC buffers one by one */
>  	for (i = 0; i < MAX_ISO_BUFS; i++) {
>  		struct urb *urb;
>  
>  		urb = pdev->sbuf[i].urb;
>  		if (urb != 0) {
> -			if (pdev->iso_init) {
> -				PWC_DEBUG_MEMORY("Unlinking URB %p\n", urb);
> -				usb_kill_urb(urb);
> -			}
> +			PWC_DEBUG_MEMORY("Unlinking URB %p\n", urb);
> +			usb_kill_urb(urb);
> +		}
> +	}
> +}
> +
> +static void pwc_iso_free(struct pwc_device *pdev)
> +{
> +	int i;
> +
> +	/* Freeing ISOC buffers one by one */
> +	for (i = 0; i < MAX_ISO_BUFS; i++) {
> +		struct urb *urb;
> +
> +		urb = pdev->sbuf[i].urb;
> +		if (urb != 0) {
>  			PWC_DEBUG_MEMORY("Freeing URB\n");
>  			usb_free_urb(urb);
>  			pdev->sbuf[i].urb = NULL;
>  		}
>  	}
> +}
> +
> +void pwc_isoc_cleanup(struct pwc_device *pdev)
> +{
> +	PWC_DEBUG_OPEN(">> pwc_isoc_cleanup()\n");
> +	if (pdev == NULL)
> +		return;
> +	if (pdev->iso_init == 0)
> +		return;
> +
> +	pwc_iso_stop(pdev);
> +	pwc_iso_free(pdev);
>  
>  	/* Stop camera, but only if we are sure the camera is still there (unplug
>  	   is signalled by EPIPE)
> @@ -1212,6 +1230,7 @@ static int pwc_video_close(struct inode 
>  
>  	PWC_DEBUG_OPEN(">> video_close called(vdev = 0x%p).\n", vdev);
>  
> +	lock_kernel();
>  	pdev = (struct pwc_device *)vdev->priv;
>  	if (pdev->vopen == 0)
>  		PWC_DEBUG_MODULE("video_close() called on closed device?\n");
> @@ -1231,7 +1250,6 @@ static int pwc_video_close(struct inode 
>  	pwc_isoc_cleanup(pdev);
>  	pwc_free_buffers(pdev);
>  
> -	lock_kernel();
>  	/* Turn off LEDS and power down camera, but only when not unplugged */
>  	if (!pdev->unplugged) {
>  		/* Turn LEDs off */
> @@ -1277,7 +1295,7 @@ static ssize_t pwc_video_read(struct fil
>  	struct pwc_device *pdev;
>  	int noblock = file->f_flags & O_NONBLOCK;
>  	DECLARE_WAITQUEUE(wait, current);
> -	int bytes_to_read;
> +	int bytes_to_read, rv = 0;
>  	void *image_buffer_addr;
>  
>  	PWC_DEBUG_READ("pwc_video_read(vdev=0x%p, buf=%p, count=%zd) called.\n",
> @@ -1287,8 +1305,12 @@ static ssize_t pwc_video_read(struct fil
>  	pdev = vdev->priv;
>  	if (pdev == NULL)
>  		return -EFAULT;
> -	if (pdev->error_status)
> -		return -pdev->error_status; /* Something happened, report what. */
> +
> +	mutex_lock(&pdev->modlock);
> +	if (pdev->error_status) {
> +		rv = -pdev->error_status; /* Something happened, report what. */
> +		goto err_out;
> +	}
>  
>  	/* In case we're doing partial reads, we don't have to wait for a frame */
>  	if (pdev->image_read_pos == 0) {
> @@ -1299,17 +1321,20 @@ static ssize_t pwc_video_read(struct fil
>  			if (pdev->error_status) {
>  				remove_wait_queue(&pdev->frameq, &wait);
>  				set_current_state(TASK_RUNNING);
> -				return -pdev->error_status ;
> +				rv = -pdev->error_status ;
> +				goto err_out;
>  			}
>  			if (noblock) {
>  				remove_wait_queue(&pdev->frameq, &wait);
>  				set_current_state(TASK_RUNNING);
> -				return -EWOULDBLOCK;
> +				rv = -EWOULDBLOCK;
> +				goto err_out;
>  			}
>  			if (signal_pending(current)) {
>  				remove_wait_queue(&pdev->frameq, &wait);
>  				set_current_state(TASK_RUNNING);
> -				return -ERESTARTSYS;
> +				rv = -ERESTARTSYS;
> +				goto err_out;
>  			}
>  			schedule();
>  			set_current_state(TASK_INTERRUPTIBLE);
> @@ -1318,8 +1343,10 @@ static ssize_t pwc_video_read(struct fil
>  		set_current_state(TASK_RUNNING);
>  
>  		/* Decompress and release frame */
> -		if (pwc_handle_frame(pdev))
> -			return -EFAULT;
> +		if (pwc_handle_frame(pdev)) {
> +			rv = -EFAULT;
> +			goto err_out;
> +		}
>  	}
>  
>  	PWC_DEBUG_READ("Copying data to user space.\n");
> @@ -1334,14 +1361,20 @@ static ssize_t pwc_video_read(struct fil
>  	image_buffer_addr = pdev->image_data;
>  	image_buffer_addr += pdev->images[pdev->fill_image].offset;
>  	image_buffer_addr += pdev->image_read_pos;
> -	if (copy_to_user(buf, image_buffer_addr, count))
> -		return -EFAULT;
> +	if (copy_to_user(buf, image_buffer_addr, count)) {
> +		rv = -EFAULT;
> +		goto err_out;
> +	}
>  	pdev->image_read_pos += count;
>  	if (pdev->image_read_pos >= bytes_to_read) { /* All data has been read */
>  		pdev->image_read_pos = 0;
>  		pwc_next_image(pdev);
>  	}
> +	mutex_unlock(&pdev->modlock);
>  	return count;
> +err_out:
> +	mutex_unlock(&pdev->modlock);
> +	return rv;
>  }
>  
>  static unsigned int pwc_video_poll(struct file *file, poll_table *wait)
> @@ -1367,7 +1400,20 @@ static unsigned int pwc_video_poll(struc
>  static int pwc_video_ioctl(struct inode *inode, struct file *file,
>  			   unsigned int cmd, unsigned long arg)
>  {
> -	return video_usercopy(inode, file, cmd, arg, pwc_video_do_ioctl);
> +	struct video_device *vdev = file->private_data;
> +	struct pwc_device *pdev; 
> +	int r = -ENODEV;
> +
> +	if (!vdev)
> +		goto out;
> +	pdev = vdev->priv;
> +
> +	mutex_lock(&pdev->modlock);
> +	if (!pdev->unplugged)
> +		r = video_usercopy(inode, file, cmd, arg, pwc_video_do_ioctl);
> +	mutex_unlock(&pdev->modlock);
> +out:
> +	return r;
>  }
>  
>  static int pwc_video_mmap(struct file *file, struct vm_area_struct *vma)
> @@ -1810,7 +1856,10 @@ static void usb_pwc_disconnect(struct us
>  	wake_up_interruptible(&pdev->frameq);
>  	/* Wait until device is closed */
>  	if(pdev->vopen) {
> +		mutex_lock(&pdev->modlock);
>  		pdev->unplugged = 1;
> +		mutex_unlock(&pdev->modlock);
> +		pwc_iso_stop(pdev);
>  	} else {
>  		/* Device is closed, so we can safely unregister it */
>  		PWC_DEBUG_PROBE("Unregistering video device in disconnect().\n");
> @@ -1828,7 +1877,6 @@ disconnect_out:
>  	unlock_kernel();
>  }
>  
> -
>  /* *grunt* We have to do atoi ourselves :-( */
>  static int pwc_atoi(const char *s)
>  {
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Cheers,
Mauro


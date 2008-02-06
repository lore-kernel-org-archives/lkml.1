Return-Path: <linux-kernel-owner+w=401wt.eu-S1759187AbYBFRro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187AbYBFRro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYBFRqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:46:39 -0500
Received: from matups.math.u-psud.fr ([129.175.50.4]:63265 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbYBFRqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:46:37 -0500
X-Greylist: delayed 1516 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 12:46:36 EST
From: Duncan Sands <baldrick.bulk@free.fr>
To: Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH][USBATM]: convert heavy init dances to kthread API
Date: Wed, 6 Feb 2008 18:20:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47A9DD30.5040604@openvz.org>
In-Reply-To: <47A9DD30.5040604@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802061820.54870.baldrick.bulk@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> The problem is that I couldn't find the maintainer for the code 
> in drivers/usb/atm/.

that would be me (though since I haven't used this modem in years I would
be more than happy to hand it off to someone else).

> Besides, I don't have a proper hardware to test this.

I will try to find where I put my old modem and test your patch this weekend.

> @@ -1014,11 +1015,7 @@ static int usbatm_do_heavy_init(void *arg)
>  	struct usbatm_data *instance = arg;
>  	int ret;
>  
> -	daemonize(instance->driver->driver_name);
>  	allow_signal(SIGTERM);
> -	instance->thread_pid = current->pid;
> -
> -	complete(&instance->thread_started);

One reason the completion existed to make sure that the thread was not
sent SIGTERM before the above call to allow_signal(SIGTERM).  So I think
you have opened up a (tiny) race by deleting it.

>  static int usbatm_heavy_init(struct usbatm_data *instance)
>  {
> -	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_FS | CLONE_FILES);
> -
> -	if (ret < 0) {
> -		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);

Please don't delete this message.

> -		return ret;
> -	}
> +	struct task_struct *t;
>  
> -	wait_for_completion(&instance->thread_started);
> +	t = kthread_create(usbatm_do_heavy_init, instance,
> +			instance->driver->driver_name);
> +	if (IS_ERR(t))
> +		return PTR_ERR(t);
>  
> +	instance->thread = t;
> +	wake_up_process(t);

Does the kthread API guarantee that the kthread is not running until you call
wake_up_process?  Because if not then what is to stop the kthread finishing before
this thread does "instance->thread = t", resulting in an attempt to send a signal
to a dead process later on in disconnect?

Otherwise it looks fine - thanks!

By the way, the right thing to do is (I think) to replace the thread with a workqueue
and have users of usbatm register a "shut_down" callback rather than using signals: the
disconnect method would call shut_down rathering than trying to kill the thread.  That
way all this mucking around with pids etc wouldn't be needed.  All users of usbatm would
need to be modified.  I managed to convince myself once that they could all be fixed up
in a fairly simple manner thanks to a few tricks and a completion or two, but I don't
recall the details...

Best wishes,

Duncan.

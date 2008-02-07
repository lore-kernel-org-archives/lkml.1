Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYBGJ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYBGJ6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYBGJ55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:57:57 -0500
Received: from matups.math.u-psud.fr ([129.175.50.4]:40767 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbYBGJ5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:57:55 -0500
From: Duncan Sands <baldrick.bulk@free.fr>
To: Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH][USBATM]: convert heavy init dances to kthread API
Date: Thu, 7 Feb 2008 10:57:40 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47A9DD30.5040604@openvz.org> <200802061820.54870.baldrick.bulk@free.fr> <47AACE2B.2040404@openvz.org>
In-Reply-To: <47AACE2B.2040404@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802071057.41201.baldrick.bulk@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> >> @@ -1014,11 +1015,7 @@ static int usbatm_do_heavy_init(void *arg)
> >>  	struct usbatm_data *instance = arg;
> >>  	int ret;
> >>  
> >> -	daemonize(instance->driver->driver_name);
> >>  	allow_signal(SIGTERM);
> >> -	instance->thread_pid = current->pid;
> >> -
> >> -	complete(&instance->thread_started);
> > 
> > One reason the completion existed to make sure that the thread was not
> > sent SIGTERM before the above call to allow_signal(SIGTERM).  So I think
> > you have opened up a (tiny) race by deleting it.
> 
> Nope. See my answer below :)
> 
> >>  static int usbatm_heavy_init(struct usbatm_data *instance)
> >>  {
> >> -	int ret = kernel_thread(usbatm_do_heavy_init, instance, CLONE_FS | CLONE_FILES);
> >> -
> >> -	if (ret < 0) {
> >> -		usb_err(instance, "%s: failed to create kernel_thread (%d)!\n", __func__, ret);
> > 
> > Please don't delete this message.
> > 
> >> -		return ret;
> >> -	}
> >> +	struct task_struct *t;
> >>  
> >> -	wait_for_completion(&instance->thread_started);
> >> +	t = kthread_create(usbatm_do_heavy_init, instance,
> >> +			instance->driver->driver_name);
> >> +	if (IS_ERR(t))
> >> +		return PTR_ERR(t);
> >>  
> >> +	instance->thread = t;
> >> +	wake_up_process(t);
> > 
> > Does the kthread API guarantee that the kthread is not running until you call
> 
> It does. That's why the race, you mentioned above is impossible.

I don't see why it helps.  The race I mentioned occurs when the kthread creating thread
runs too fast compared to the kthread.  Let C (creator) be the thread running
usbatm_heavy_init, and K (kthread) be the created kthread.  When C calls wake_up_process,
thread K starts running, however on an SMP system C may also be running.  Now suppose
that for some reason K takes a long time to execute the command "allow_signal(SIGTERM);",
but that C runs very fast and immediately executes the disconnect callback, and sends the
signal to K before K manages to execute allow_signal.  This is the race, and it can only
be fixed by making C run slower (thus the completion).  Of course this is fantastically
unlikely which is why I described it as tiny, but as far as I can see it is a theoretical
possibility.  I don't see that wake_up_process fixes it, it just makes it even less likely.

> > By the way, the right thing to do is (I think) to replace the thread with
> > a workqueue and have users of usbatm register a "shut_down" callback
> > rather than using signals: the disconnect method would call shut_down
> > rathering than trying to kill the thread.  That way all this mucking
> > around with pids etc wouldn't be needed.  All users of usbatm would need
> > to be modified.  I managed to convince myself once that they could all be
> > fixed up in a fairly simple manner thanks to a few tricks and a
> > completion or two, but I don't recall the details...
>
> Well, that would be also great, since kill_proc will be gone - that's what
> I'm trying to achieve.

I think your patch should go in, since I'm not likely to ever implement the
scheme I suggested - I don't use this hardware anymore and have lost interest
in the driver.

Best wishes,

Duncan.

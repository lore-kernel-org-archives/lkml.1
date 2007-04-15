Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXDOKHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXDOKHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXDOKHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:07:54 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:46756 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbXDOKHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:07:53 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH] cxacru: ADSL state management
Date: Sun, 15 Apr 2007 12:08:59 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <462172E3.7030408@simon.arlott.org.uk>
In-Reply-To: <462172E3.7030408@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151208.59719.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

> +static ssize_t cxacru_sysfs_show_adsl_state(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct usb_interface *intf = to_usb_interface(dev);
> +	struct usbatm_data *usbatm_instance = usb_get_intfdata(intf);
> +	struct cxacru_data *instance = usbatm_instance->driver_data;

instance could be NULL if cxacru_sysfs_show_adsl_state is called after
the device has been unbound.  What prevents this?

> +static ssize_t cxacru_sysfs_store_adsl_state(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t count)

This is not serialized by a lock, so if two or more processes call it
simultaneously then the commands to the modem can be interleaved, which
could (a) leave it in a funky state, and (b) means that the value of poll
could be wrong when you write it to instance->poll_state, eg because the
processes could reach the poll_state writing step in reverse order to the
order in which they reached the sending-commands-to-the-modem step.

> @@ -503,6 +622,7 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
>  	struct atm_dev *atm_dev = usbatm_instance->atm_dev;
>  	*/
>  	int ret;
> +	int start_polling = 1;
>  
>  	dbg("cxacru_atm_start");
>  
> @@ -522,7 +642,25 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
>  	}
>  
>  	/* Start status polling */
> -	cxacru_poll_status(&instance->poll_work.work);
> +	mutex_lock(&instance->poll_state_serialize);
> +	switch (instance->poll_state) {

Can poll_state really have anything else than its initial
value here?

> +	mutex_unlock(&instance->poll_state_serialize);
> +
> +	if (start_polling)
> +		cxacru_poll_status(&instance->poll_work.work);

Between releasing the lock and calling cxacru_poll_status, another
process could have called cxacru_sysfs_store_adsl_state and changed
whether you want to poll or not.  I don't know if it matters.

> +	mutex_unlock(&instance->poll_state_serialize);
> +
> +	if (keep_polling)
> +		schedule_delayed_work(&instance->poll_work,
> +				round_jiffies_relative(POLL_INTERVAL*HZ));

Likewise.

> @@ -917,8 +1102,20 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
>  		return;
>  	}
>  
> -	while (!cancel_delayed_work(&instance->poll_work))
> -	       flush_scheduled_work();
> +	mutex_lock(&instance->poll_state_serialize);
> +	BUG_ON(instance->poll_state == CXPOLL_SHUTDOWN);
> +
> +	/* ensure that status polling continues unless
> +	 * it has already stopped */

Your device has been removed.  Why would you want to go on
polling?  Especially as your device structures are about to
be freed...  By the way, where do you remove the sysfs files?

> +	mutex_unlock(&instance->poll_state_serialize);
> +
> +	if (is_polling)
> +		cancel_rearming_delayed_work(&instance->poll_work);

This looks unreliable, again due to race conditions.  Better to always
shoot it down.

Ciao,

Duncan.

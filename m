Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXDON5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXDON5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 09:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXDON5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 09:57:50 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:55806 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbXDON5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 09:57:50 -0400
Message-ID: <46222F5A.4000002@simon.arlott.org.uk>
Date: Sun, 15 Apr 2007 14:57:46 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Duncan Sands <duncan.sands@math.u-psud.fr>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] cxacru: ADSL state management
References: <462172E3.7030408@simon.arlott.org.uk> <200704151208.59719.duncan.sands@math.u-psud.fr>
In-Reply-To: <200704151208.59719.duncan.sands@math.u-psud.fr>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/07 11:08, Duncan Sands wrote:
> Hi Simon,
> 
>> +static ssize_t cxacru_sysfs_show_adsl_state(struct device *dev,
>> +	struct device_attribute *attr, char *buf)
>> +{
>> +	struct usb_interface *intf = to_usb_interface(dev);
>> +	struct usbatm_data *usbatm_instance = usb_get_intfdata(intf);
>> +	struct cxacru_data *instance = usbatm_instance->driver_data;
> 
> instance could be NULL if cxacru_sysfs_show_adsl_state is called after
> the device has been unbound.  What prevents this?

When read() or write() is used after sysfs_remove_file(), it doesn't call 
the function and returns -ENODEV. I would assume that it will wait for a 
running show() or store() before leaving sysfs_remove_file() too - if it 
doesn't then it should...

>> +static ssize_t cxacru_sysfs_store_adsl_state(struct device *dev,
>> +	struct device_attribute *attr, const char *buf, size_t count)
> 
> This is not serialized by a lock, so if two or more processes call it
> simultaneously then the commands to the modem can be interleaved, which
> could (a) leave it in a funky state, and (b) means that the value of poll

a) The commands sent to the modem are serialised so there's no problem 
there.

> could be wrong when you write it to instance->poll_state, eg because the
> processes could reach the poll_state writing step in reverse order to the
> order in which they reached the sending-commands-to-the-modem step.

b) You're right here, I'll need to add a mutex for that whole function.

>> @@ -503,6 +622,7 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
>>  	struct atm_dev *atm_dev = usbatm_instance->atm_dev;
>>  	*/
>>  	int ret;
>> +	int start_polling = 1;
>>  
>>  	dbg("cxacru_atm_start");
>>  
>> @@ -522,7 +642,25 @@ static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
>>  	}
>>  
>>  	/* Start status polling */
>> -	cxacru_poll_status(&instance->poll_work.work);
>> +	mutex_lock(&instance->poll_state_serialize);
>> +	switch (instance->poll_state) {
> 
> Can poll_state really have anything else than its initial
> value here?

Yes, the sysfs attributes are set up in bind so the user can change the polling before 
atm_start is called. Also the device could be removed while usbatm is still preparing 
to call atm_start.

>> +	mutex_unlock(&instance->poll_state_serialize);
>> +
>> +	if (start_polling)
>> +		cxacru_poll_status(&instance->poll_work.work);
> 
> Between releasing the lock and calling cxacru_poll_status, another
> process could have called cxacru_sysfs_store_adsl_state and changed
> whether you want to poll or not.  I don't know if it matters.

Yes, this could happen and I designed it so that whichever process sets it to POLLING 
MUST then start polling - if something else wants it to stop it will stop at the end 
of the poll function. The only way to allow something other than the poll function to 
stop it would be to reschedule with the mutex held which I'd rather avoid doing.
 
>> +	mutex_unlock(&instance->poll_state_serialize);
>> +
>> +	if (keep_polling)
>> +		schedule_delayed_work(&instance->poll_work,
>> +				round_jiffies_relative(POLL_INTERVAL*HZ));
> 
> Likewise.

Again, it will be stopped at the next poll - it's safer than trying to cancel work 
that may not be scheduled.
 
>> @@ -917,8 +1102,20 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
>>  		return;
>>  	}
>>  
>> -	while (!cancel_delayed_work(&instance->poll_work))
>> -	       flush_scheduled_work();
>> +	mutex_lock(&instance->poll_state_serialize);
>> +	BUG_ON(instance->poll_state == CXPOLL_SHUTDOWN);
>> +
>> +	/* ensure that status polling continues unless
>> +	 * it has already stopped */
> 
> Your device has been removed.  Why would you want to go on
> polling?  Especially as your device structures are about to
> be freed...  By the way, where do you remove the sysfs files?

They are removed further down in unbind. Polling is safe to continue because 
it is stopped below, and it must continue because:

>> +	mutex_unlock(&instance->poll_state_serialize);
>> +
>> +	if (is_polling)
>> +		cancel_rearming_delayed_work(&instance->poll_work);
> 
> This looks unreliable, again due to race conditions.  Better to always
> shoot it down.

Cancelling the work causes an infinite loop if the polling is never rescheduled, 
I've written it so that the polling is always either enabled/disabled at this 
point. The SHUTDOWN state prevents anything else changing it.

If it's scheduled to run then it will be cancelled, and if it's running it will 
be cancelled as soon as it gets rescheduled.

I could repeatedly acquire the mutex and check if it's shutdown itself, but 
there would be no point since it won't be any faster.

> Ciao,
> 
> Duncan.


-- 
Simon Arlott

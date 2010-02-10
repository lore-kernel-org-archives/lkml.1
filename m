Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab0BJRem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:34:42 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:42011 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755028Ab0BJRej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:34:39 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PWM PATCH 1/7] API to consolidate PWM devices behind a common user and kernel interface
Date: Wed, 10 Feb 2010 12:34:34 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902153309@mi8nycmail19.Mi8.com>
In-Reply-To: <4B723239.4090802@billgatliff.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PWM PATCH 1/7] API to consolidate PWM devices behind a common user and kernel interface
Thread-Index: AcqqB0NBPQJvJ/DqRmSmKwyhf0rOhwAaBDog
References: <cover.1265748263.git.bgat@billgatliff.com> <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE190902153279@mi8nycmail19.Mi8.com> <4B723239.4090802@billgatliff.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Bill Gatliff" <bgat@billgatliff.com>
Cc: <linux-embedded@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Feb 2010 17:34:36.0516 (UTC) FILETIME=[50B21A40:01CAAA77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 09, 2010 9:13 PM, Bill Gatliff wrote:
> H Hartley Sweeten wrote:
>>> +
>>> +static int __pwm_create_sysfs(struct pwm_device *pwm);
>>> +
>>> +static const char *REQUEST_SYSFS = "sysfs";
>>>     
>>
>> Does this static string save that much?  It's only used two places in this
>> file.
>>   
>
> It makes sure the same string is used in both places.  I do a strcmp on
> it, so I wanted to make sure I didn't screw it up!

Ok.

>>> +	p = kcalloc(pwm->nchan, sizeof(*p), GFP_KERNEL);
>>> +	if (!p)
>>> +	{
>>> +		pr_err("%s: ENOMEM\n", __func__);
>>> +		return -ENOMEM;
>>> +	}
>>>     
>>
>> I assume this pr_err is just a debug message and will be removed.
>> If not the '{' should be on the previous line.
>>   
>
> Yes, it's a debug message.  I obviously don't clean up after myself very
> well...

;-)

>>> +	list_add_tail(&pwm->list, &pwm_device_list);
>>> +	ret = __pwm_create_sysfs(pwm);
>>> +	if (ret) {
>>> +		mutex_unlock(&device_list_mutex);
>>> +		pr_err("%s: err_create_sysfs\n", __func__);
>>>     
>>
>> Another debug message?
>>  
>
> Yes.  Darn it.  :)
>
>
>>> +		goto err_create_sysfs;
>>> +	}
>>> +
>>> +	mutex_unlock(&device_list_mutex);
>>> +
>>> +	dev_info(pwm->dev, "%d channel%s\n", pwm->nchan,
>>> +		 pwm->nchan > 1 ? "s" : "");
>>> +	return 0;
>>>     
>>
>> I need to check the rest of the patch series but I assume you have
>> fixed the pwm->dev = NULL issue.
>>   
>
> Yes.  Tested it properly, even!  :)

Ok.

>>> +
>>> +	p->requester = requester;
>>> +	if (!strcmp(requester, REQUEST_SYSFS))
>>> +		p->pid = current->pid;
>>>     
>>
>> This is new.. What's the reason for saving the pid?
>>   
>
> I've gotten complaints from those who say, "Ok, so it reported 'sysfs'
> back to me, but how can I be sure that it's because *I* own it now, and
> not another user process?"  Seemed easy enough to add the PID so they
> can check.  Of course, you could argue that I could report just the PID,
> and skip the "sysfs" string altogether.  I'd be inclined to agree with you.
>
> Of course, if you are like me and do the request with cat(1), then the
> PID is pretty meaningless.  :)

I would think a userspace request would typically use cat(1).  That's why
I didn't understand why you are saving the pid.

More on this below.

>>> +
>>> +int pwm_set_polarity(struct pwm_channel *p,
>>> +		     int active_high)
>>> +{
>>> +	struct pwm_channel_config c = {
>>> +		.config_mask = PWM_CONFIG_POLARITY,
>>> +		.polarity = active_high,
>>> +	};
>>> +	return pwm_config(p, &c);
>>> +}
>>> +EXPORT_SYMBOL(pwm_set_polarity);
>>>     
>>
>> Has the 'polarity' logic been verified?
>>
>> pwm_set_polarity takes an active high flag that is passed to pwm_config.
>> A write to the sysfs 'polarity' file passes the value directly to pwm_config.
>> A read from the sysfs 'polarity' file returns struct pwm_channel ->active_low.
>>
>> Seems like a mis-match in logic.
>>   
>
> It does, indeed!  I thought I had checked this before, but I just tried
> it now again.  Not good news:
>
> opusa5:/sys/class/pwm/f0000660.timer:0# echo 1 > polarity
> opusa5:/sys/class/pwm/f0000660.timer:0# cat polarity
> 1
> opusa5:/sys/class/pwm/f0000660.timer:0# echo 0 > polarity
> opusa5:/sys/class/pwm/f0000660.timer:0# cat polarity
> 1
>
> Good catch.  I'll have to track this one down.  I have verified that the
> proper value gets out to the hardware, for all the existing drivers of
> my own, anyway.  Some of my hardware simply won't work if the polarity
> is wrong.

I thought I noticed this issue with your original patches.  Glad you
were able to verify it.

>>> +static ssize_t pwm_run_store(struct device *dev,
>>> +			     struct device_attribute *attr,
>>> +			     const char *buf,
>>> +			     size_t len)
>>> +{
>>> +	struct pwm_channel *p = dev_get_drvdata(dev);
>>> +	if (sysfs_streq(buf, "1"))
>>> +		pwm_start(p);
>>> +	else if (sysfs_streq(buf, "0"))
>>> +		pwm_stop(p);
>>> +	return len;
>>> +}
>>> +static DEVICE_ATTR(run, 0200, NULL, pwm_run_store);
>>>     
>>
>> Any reason not to add a read operation?
>>   
>
> Can't think of one.  Just haven't had a need for it myself, I suppose.

Time will tell... It can easily be added later if needed.

>>> +static ssize_t pwm_request_store(struct device *dev,
>>> +				 struct device_attribute *attr,
>>> +				 const char *buf,
>>> +				 size_t len)
>>> +{
>>> +	struct pwm_channel *p = dev_get_drvdata(dev);
>>> +	pwm_free(p);
>>> +	return len;
>>> +}
>>> +static DEVICE_ATTR(request, 0644, pwm_request_show, pwm_request_store);
>>     
>>
>> Doing a read to request the channel and a write to free it seems wrong...
>>
>> I think you should be able to read the attr to get the current 'requester'
>> and write to it to set the 'requester'.  Kind of like the 'trigger' attr
>> for the leds.
>>
>> Also, if a kernel driver has requested the pwm channel wouldn't a read
>> of the attr free it?  This seems bad...
>>
>> Just my .02
>>   
>
> A read from the attribute shows who the current requester is, and
> implies that if the channel isn't currently owned by anyone else then
> you'd like to own it.  This approach makes the locking operation atomic
> in the (unlikely) situation where two user applications are going after
> the same PWM channel at the same time.  It also means that I don't have
> to do a write, followed by a read and compare in order to determine if I
> now own the channel.
>
> If the channel is owned when you read the attribute, then the current
> owner is reported.
>
> I guess I can see an advantage to writing a unique text string to the
> attribute to indicate a request operation, and then reading back that
> same text string to confirm that you own the channel.  And then you'd
> write a null string to un-request it, perhaps?  Or would you have an
> un-request attribute?

Maybe change the attribute so that it works like the led trigger attribute.
The list of available requesters returned would be something like the
following:

If the pwm channel is free.

# cat request
[none] sysfs			<- the channel is free
# echo sysfs > request		<- request the channel for syfs use
# cat request
none [sysfs]			<- sysfs now owns the channel

If the pwm channel is owned by a kernel driver, i.e. the pwm-led.c driver:

# cat request
[cur_led->name]			<- the pwm-led driver owns the channel

I think the other attributes should also be removed then the channel is 
owned by a kernel driver since that driver is actually in control of the 
configuration.  I'm not sure if this is possible.

Also, a better name for this attribute might be 'owner' or something along
that line.

As far as making the request atomic, a user application could always just
'request' the channel without checking if it's available first.  If the
channel is unavailable the request could return an error back to user space.

The way it is now I think if a kernel driver were to request a channel,
a user app could rip it away by doing:

# cat request
cur_led->name			<- the pwm-led driver owns the channel
# echo anything > request	<- oops.. pwm_free just got called
# cat request
sysfs p->pid			<- sysfs now owns the channel

>>> +#include <linux/completion.h>
>>> +#include <linux/workqueue.h>
>>> +#include <linux/spinlock.h>
>>> +#include <linux/list.h>
>>>     
>>
>> Are these really needed in the header?  Other than <linux/list.h>, they are
>> already included in the .c file.
>>   
>
> They certainly aren't _needed_ in the header, unless someone forgets to
> include them before they include pwm.h.  Any idea what the convention is
> on this?

I think it's cleaner to require the .c file to include the necessary headers.
The only reason I can see to have an include in a header is if there is a
strict dependancy on that header, and normally this can be avoided.

>>> +
>>> +	int	(*request)	(struct pwm_channel *p);
>>> +	void	(*free)		(struct pwm_channel *p);
>>> +	int	(*config)	(struct pwm_channel *p,
>>> +				 struct pwm_channel_config *c);
>>> +	int	(*config_nosleep)(struct pwm_channel *p,
>>> +				  struct pwm_channel_config *c);
>>> +	int	(*synchronize)	(struct pwm_channel *p,
>>> +				 struct pwm_channel *to_p);
>>> +	int	(*unsynchronize)(struct pwm_channel *p,
>>> +				 struct pwm_channel *from_p);
>>> +	int	(*set_callback)	(struct pwm_channel *p,
>>> +				 pwm_callback_t callback);
>>>     
>>
>> These might be cleaner without the line breaks.
>>   
>
> Yea, they just get kinda long...

The longest is the (*config) one and it's 87 chars when pulled into
one line.  That one, and a bunch of others, could be shortened by
changing the pwm_channel_config name to pwm_config.

BTW, there has been discussion and patches on lkml to increase
the 80 character line limit.  Personaly I think it makes sense.
My laptop and desktop both have a 1920 horizontal res but my
Vertical res on the laptop is only 1080.  I would much rather
read long, easy to read, lines and see more of them than read
short, broken, lines and see less of them. ;-)


>>> +struct pwm_channel *
>>> +pwm_request(const char *bus_id, int chan,
>>> +	    const char *requester);
>>>     
>>
>> You use a mix of style in this patch set.
>>
>> <return type> <fn name> (...)
>>
>> and
>>
>> <return type>
>> <fn_name> (...)
>>
>> Makes reading a bit difficult.  Could you make them consistent?
>>   
>
> I'm trying to keep the lines from growing too long.  But if you don't
> mind them long, I can deal with it.  :)

Well, going with the above comment, making all of these one line each
makes them a lot easier to read and see what the API consists of.
Also, grouping the common ones together makes more sense than having
a white space between very function prototype, i.e.:

struct pwm_channel *pwm_request(...)
void pwm_free(...)

int pwm_config_nosleep(...)
int pwm_config(...)

unsigned long pwm_ns_to_ticks(...)
unsigned long pwm_ticks_to_ns(...)

int pwm_set_period_ns(...)
unsigned long int pwm_get_period_ns(...)	<- BTW, the 'int' is redundant

int pwm_set_duty_ns(...)
unsigned long pwm_get_duty_ns(...)

int pwm_set_duty_percent(...)

int pwm_set_polarity(...)

int pwm_start(...)
int pwm_stop(...)

int pwm_set_handler(...)

int pwm_synchronize(...)
int pwm_unsynchronize(...)

>> Regards,
>> Hartley
>>   
>
> Thanks sooo much for your reviews!

My pleasure to help.

Regards,
Hartley

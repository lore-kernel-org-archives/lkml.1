Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0BJEMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 23:12:32 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:43697 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab0BJEMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 23:12:31 -0500
Message-ID: <4B723239.4090802@billgatliff.com>
Date: Tue, 09 Feb 2010 22:12:41 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 1/7] API to consolidate PWM devices behind a common
 user and kernel interface
References: <cover.1265748263.git.bgat@billgatliff.com> <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE190902153279@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902153279@mi8nycmail19.Mi8.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
>> +
>> +static int __pwm_create_sysfs(struct pwm_device *pwm);
>> +
>> +static const char *REQUEST_SYSFS = "sysfs";
>>     
>
> Does this static string save that much?  It's only used two places in this
> file.
>   

It makes sure the same string is used in both places.  I do a strcmp on
it, so I wanted to make sure I didn't screw it up!


>> +	p = kcalloc(pwm->nchan, sizeof(*p), GFP_KERNEL);
>> +	if (!p)
>> +	{
>> +		pr_err("%s: ENOMEM\n", __func__);
>> +		return -ENOMEM;
>> +	}
>>     
>
> I assume this pr_err is just a debug message and will be removed.
> If not the '{' should be on the previous line.
>   

Yes, it's a debug message.  I obviously don't clean up after myself very
well...

>> +	list_add_tail(&pwm->list, &pwm_device_list);
>> +	ret = __pwm_create_sysfs(pwm);
>> +	if (ret) {
>> +		mutex_unlock(&device_list_mutex);
>> +		pr_err("%s: err_create_sysfs\n", __func__);
>>     
>
> Another debug message?
>   

Yes.  Darn it.  :)


>> +		goto err_create_sysfs;
>> +	}
>> +
>> +	mutex_unlock(&device_list_mutex);
>> +
>> +	dev_info(pwm->dev, "%d channel%s\n", pwm->nchan,
>> +		 pwm->nchan > 1 ? "s" : "");
>> +	return 0;
>>     
>
> I need to check the rest of the patch series but I assume you have
> fixed the pwm->dev = NULL issue.
>   

Yes.  Tested it properly, even!  :)

>> +
>> +	p->requester = requester;
>> +	if (!strcmp(requester, REQUEST_SYSFS))
>> +		p->pid = current->pid;
>>     
>
> This is new.. What's the reason for saving the pid?
>   

I've gotten complaints from those who say, "Ok, so it reported 'sysfs'
back to me, but how can I be sure that it's because *I* own it now, and
not another user process?"  Seemed easy enough to add the PID so they
can check.  Of course, you could argue that I could report just the PID,
and skip the "sysfs" string altogether.  I'd be inclined to agree with you.

Of course, if you are like me and do the request with cat(1), then the
PID is pretty meaningless.  :)

>> +
>> +int pwm_set_polarity(struct pwm_channel *p,
>> +		     int active_high)
>> +{
>> +	struct pwm_channel_config c = {
>> +		.config_mask = PWM_CONFIG_POLARITY,
>> +		.polarity = active_high,
>> +	};
>> +	return pwm_config(p, &c);
>> +}
>> +EXPORT_SYMBOL(pwm_set_polarity);
>>     
>
> Has the 'polarity' logic been verified?
>
> pwm_set_polarity takes an active high flag that is passed to pwm_config.
> A write to the sysfs 'polarity' file passes the value directly to pwm_config.
> A read from the sysfs 'polarity' file returns struct pwm_channel ->active_low.
>
> Seems like a mis-match in logic.
>   

It does, indeed!  I thought I had checked this before, but I just tried
it now again.  Not good news:

opusa5:/sys/class/pwm/f0000660.timer:0# echo 1 > polarity
opusa5:/sys/class/pwm/f0000660.timer:0# cat polarity
1
opusa5:/sys/class/pwm/f0000660.timer:0# echo 0 > polarity
opusa5:/sys/class/pwm/f0000660.timer:0# cat polarity
1

Good catch.  I'll have to track this one down.  I have verified that the
proper value gets out to the hardware, for all the existing drivers of
my own, anyway.  Some of my hardware simply won't work if the polarity
is wrong.


>> +static ssize_t pwm_run_store(struct device *dev,
>> +			     struct device_attribute *attr,
>> +			     const char *buf,
>> +			     size_t len)
>> +{
>> +	struct pwm_channel *p = dev_get_drvdata(dev);
>> +	if (sysfs_streq(buf, "1"))
>> +		pwm_start(p);
>> +	else if (sysfs_streq(buf, "0"))
>> +		pwm_stop(p);
>> +	return len;
>> +}
>> +static DEVICE_ATTR(run, 0200, NULL, pwm_run_store);
>>     
>
> Any reason not to add a read operation?
>   

Can't think of one.  Just haven't had a need for it myself, I suppose.

>> +static ssize_t pwm_request_store(struct device *dev,
>> +				 struct device_attribute *attr,
>> +				 const char *buf,
>> +				 size_t len)
>> +{
>> +	struct pwm_channel *p = dev_get_drvdata(dev);
>> +	pwm_free(p);
>> +	return len;
>> +}
>> +static DEVICE_ATTR(request, 0644, pwm_request_show, pwm_request_store);
>>     
>
> Doing a read to request the channel and a write to free it seems wrong...
>
> I think you should be able to read the attr to get the current 'requester'
> and write to it to set the 'requester'.  Kind of like the 'trigger' attr
> for the leds.
>
> Also, if a kernel driver has requested the pwm channel wouldn't a read
> of the attr free it?  This seems bad...
>
> Just my .02
>   

A read from the attribute shows who the current requester is, and
implies that if the channel isn't currently owned by anyone else then
you'd like to own it.  This approach makes the locking operation atomic
in the (unlikely) situation where two user applications are going after
the same PWM channel at the same time.  It also means that I don't have
to do a write, followed by a read and compare in order to determine if I
now own the channel.

If the channel is owned when you read the attribute, then the current
owner is reported.

I guess I can see an advantage to writing a unique text string to the
attribute to indicate a request operation, and then reading back that
same text string to confirm that you own the channel.  And then you'd
write a null string to un-request it, perhaps?  Or would you have an
un-request attribute?


>> +#include <linux/completion.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/list.h>
>>     
>
> Are these really needed in the header?  Other than <linux/list.h>, they are
> already included in the .c file.
>   

They certainly aren't _needed_ in the header, unless someone forgets to
include them before they include pwm.h.  Any idea what the convention is
on this?

>> +
>> +	int	(*request)	(struct pwm_channel *p);
>> +	void	(*free)		(struct pwm_channel *p);
>> +	int	(*config)	(struct pwm_channel *p,
>> +				 struct pwm_channel_config *c);
>> +	int	(*config_nosleep)(struct pwm_channel *p,
>> +				  struct pwm_channel_config *c);
>> +	int	(*synchronize)	(struct pwm_channel *p,
>> +				 struct pwm_channel *to_p);
>> +	int	(*unsynchronize)(struct pwm_channel *p,
>> +				 struct pwm_channel *from_p);
>> +	int	(*set_callback)	(struct pwm_channel *p,
>> +				 pwm_callback_t callback);
>>     
>
> These might be cleaner without the line breaks.
>   

Yea, they just get kinda long...


>> +struct pwm_channel *
>> +pwm_request(const char *bus_id, int chan,
>> +	    const char *requester);
>>     
>
> You use a mix of style in this patch set.
>
> <return type> <fn name> (...)
>
> and
>
> <return type>
> <fn_name> (...)
>
> Makes reading a bit difficult.  Could you make them consistent?
>   

I'm trying to keep the lines from growing too long.  But if you don't
mind them long, I can deal with it.  :)

> Regards,
> Hartley
>   

Thanks sooo much for your reviews!


b.g.

-- 
Bill Gatliff
Embedded systems training and consulting
http://billgatliff.com
bgat@billgatliff.com


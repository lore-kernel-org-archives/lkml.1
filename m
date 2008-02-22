Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbYBVGcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbYBVGcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 01:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYBVGcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 01:32:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYBVGcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 01:32:05 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, dmitry.torokhov@gmail.com,
       virtualization@lists.osdl.org, linux-input@vger.kernel.org,
       adaplas@pol.net, akpm@linux-foundation.org, jayakumar.lkml@gmail.com
Subject: Re: [PATCH 2/2] xen pvfb: Para-virtual framebuffer,	keyboard and pointer driver
References: <871w76ejdg.fsf@pike.pond.sub.org>
	<87skzmd4qc.fsf@pike.pond.sub.org> <47BDDF97.7070001@goop.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Fri, 22 Feb 2008 07:31:43 +0100
In-Reply-To: <47BDDF97.7070001@goop.org> (Jeremy Fitzhardinge's message of "Thu\, 21 Feb 2008 12\:31\:19 -0800")
Message-ID: <8763whbiy8.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Markus Armbruster wrote:
>> This is a pair of Xen para-virtual frontend device drivers:
>> drivers/video/xen-fbfront.c provides a framebuffer, and
>> drivers/input/xen-kbdfront provides keyboard and mouse.
>>   
>
> Unless they're actually inter-dependent, could you post this as two
> separate patches?  I don't know anything about these parts of the
> kernel, so it would be nice to make it very obvious which changes are
> fb vs mouse/keyboard.

I could do that do that, but the intermediate step (one driver, not
the other) is somewhat problematic: the backend in dom0 needs both
drivers, and will refuse to complete device initialization unless
they're both present.

> (I guess input/* vs video/* should make it obvious, but it looks like
> input has a config dependency on fb, so I'll avoid making too many
> presumptions...)

Framebuffer: fbif.h xen-fbfront.c
Keyboard/mouse: kbdif.h xen-kbdfront.h

I added the config dependency because having one without the other
doesn't make sense, as explained above.

Still want it split into two separate patches?

> (Couple of comments below)
>
>    J
>
>> The backends run in dom0 user space.
>>
>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>>
>> ---
[...]
>> diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
>> new file mode 100644
>> index 0000000..84f65cf
>> --- /dev/null
>> +++ b/drivers/input/xen-kbdfront.c
>> @@ -0,0 +1,337 @@
[...]
>> +static int __devinit xenkbd_probe(struct xenbus_device *dev,
>> +				  const struct xenbus_device_id *id)
>> +{
[...]
>> +	if (ret < 0)
>> +		goto error;
>> +
>> +	return 0;
>> +
>> + error_nomem:
>> +	ret = -ENOMEM;
>> +	xenbus_dev_fatal(dev, ret, "allocating device memory");
>> + error:
>> +	xenkbd_remove(dev);
>>   
>
> This is happy if dev->info is only partially initialized?

It's designed that way.  dev->info is initialized so that
xenkbd_remove() does nothing.  Then stuff is stored into dev->info
only when it's sufficiently initialized for xenkbd_remove() to clean
it up.

>> +	return ret;
>> +}
>> +
>> +static int xenkbd_resume(struct xenbus_device *dev)
>> +{
>> +	struct xenkbd_info *info = dev->dev.driver_data;
>> +
>> +	xenkbd_disconnect_backend(info);
>> +	memset(info->page, 0, PAGE_SIZE);
>> +	return xenkbd_connect_backend(dev, info);
>> +}
>> +
>> +static int xenkbd_remove(struct xenbus_device *dev)
>> +{
>> +	struct xenkbd_info *info = dev->dev.driver_data;
>> +
>> +	xenkbd_disconnect_backend(info);
>> +	input_unregister_device(info->kbd);
>> +	input_unregister_device(info->ptr);
>>   
>
> Does this free kdb and ptr?

Yes.  xenkbd_probe() initializes info->kbd and info->ptr to null, and
changes that to the device only after input_register_device()
succeeds.  If something goes wrong between input_allocate_device() and
input_register_device(), xenkbd_probe() frees the device with
input_free_device().  This is how input_register_device() wants to be
used according to its function comment:

    /**
     * input_register_device - register device with input core
     * @dev: device to be registered
     *
     * This function registers device with input core. The device must be
     * allocated with input_allocate_device() and all it's capabilities
     * set up before registering.
     * If function fails the device must be freed with input_free_device().
     * Once device has been successfully registered it can be unregistered
     * with input_unregister_device(); input_free_device() should not be
     * called in this case.
     */

There's another bug here: must not call input_unregister_device() when
the device is still null.  Man, I remember checking cleanup multiple
times when this stuff went into Xen (i.e. quite some time ago), and I
still missed this one.  Going to check cleanup *again*.

>> +	free_page((unsigned long)info->page);
>> +	kfree(info);
>> +	return 0;
>> +}
[...]

Thanks!

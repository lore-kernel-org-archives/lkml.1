Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYF0JqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYF0JqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYF0Jp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:45:56 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:51555 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYF0Jpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:45:55 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4864B6D6.3020509@cam.ac.uk>
Date: Fri, 27 Jun 2008 10:45:58 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>, hmh@hmh.eng.br,
       spi-devel-general@lists.sourceforge.net,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [lm-sensors] Accelerometer etc subsystem (Update on progress)
References: <4832A211.4040206@gmail.com>	<20080520132817.03fb74ea@hyperion.delvare> <4863D97A.9090102@gmail.com> <1214537367.8462.157.camel@moss.renham>
In-Reply-To: <1214537367.8462.157.camel@moss.renham>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:
> On Thu, 2008-06-26 at 19:01 +0100, Jonathan Cameron wrote:
> 
>> Sysfs -    Parameter Control - gain / offsets etc
>>     State control, turn interrupts on and off etc.
> 
> As in turn userspace [interrupt] event notification on and off?  I would
> have thought it'd be the kernel driver's responsibility to turn the
> device's interrupt generation on and off according to needs for
> data/events etc.
Ok, there is a division here between interrupt handling on the host side
which indeed should be turned on and off transparently by the driver 
and actually telling the sensor which interrupts to generate.  In a sense
this is simply a case of terminology and what is actually being requested
is event notifications (which then match with those sent up to userspace).
> 
> I know this is in a rough state but a few comments anyway.  First, there
> are heaps of casts-of-void-pointers (eg casts of kmalloc returns) which
> are superfluous and hard readability 'coz you have to split the line to
> fit in 80cols.
Oops, silly habit that one - I'll clean those out.
> And hardcoded type-size assumptions everywhere.  Don't be scared of
> sizeof ;-)
Yup, definitely need to clean them up.
>> Anyhow, all comments welcome.  Can anyone think of a better name?
>> (I'm not keen on industrialio. It's too long if nothing else!
>>  It will do as a working title for now)
> 
> I don't mind industrial io but as a function prefix, iio works better.
> I can't see it being used elsewhere.
Good point - I'd droped to indio in some cases but iio will make those 80
character limits even easier ;)

> also:
> 
> +/* As the ring buffer contents are device dependent this functionality
> + * must remain part of the driver and not the ring buffer subsystem */
> +static ssize_t
> +lis3l02dq_read_accel_from_ring(struct industrialio_ring_buffer *ring,
> +			       int element, char *buf)
> +{
> +	int val, ret, len;
> +	uint16_t temp;
> +	char *data, *datalock;
> +
> +	data = kmalloc(8, GFP_KERNEL);
> +	if (data == NULL) {
> +		ret = -ENOMEM;
> +		goto error_ret;
> +	}
> +	ret = industrialio_read_last_from_ring(ring, data);
> +	datalock = data + 2*element;
> 
> I haven't looked deeply at the ringbuffer code but can you guarantee
> that later elements are at higher addresses than the lower ones?  As in,
> can one datum in the the ring buffer wrap to the beginning again?
At the moment the ring buffer has to be a whole number of datums big.
I'm inclined to keep it way and move more towards dynamic allocation
such that it is true than to try handling split data reading sets.
 
> +	kfree(data);
> 
> You free the data before you use it?  Though you are using it through a
> different pointer below.  I wouldn't be scared of allocating 8 bytes on
> the stack rather than kmalloc'ing (unless you expect this to be called
> in a deep callchain)
Ouch.  That's an out and out bug!
> 
> +	temp = (((uint16_t)((datalock[1]))) << 8)
> +		| (uint16_t)(datalock[0]);
> +	val = *((int16_t *)(&temp));
> 
> All this data/datalock/bitshuffle nonsense would be nicer if you just
> used structs and unions, yeah?
> 
> union channel {
> 	char data[2];
> 	int16_t val;
> }
Good point, I'd forgotten you could do that with unions.
> 
> struct datum {
> 	union channel elements[3];
> }
> 
> or something.
> 
> +	len = sprintf(buf, "ring %d\n", val);
> +
> +	return len;
> +error_ret:
> +	return ret;
> +}
Good approach, I'll switch to that.

> 
> Incidentally, is there much that your ringbuffer can do which kfifo
> can't?  Apart from having a bunch of extra nice accessor-helpers sitting
> on the top.
Not sure, I'll look into it.
> 
> Overall looking good and useful, can't wait 'till it's done :-)
Thanks for the comments.

Jonathan


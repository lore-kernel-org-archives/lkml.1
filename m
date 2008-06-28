Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYF1Iek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYF1Iek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 04:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYF1IeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 04:34:25 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:55760
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbYF1IeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 04:34:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoAAJOUZUjLrQkK/2dsb2JhbAAIsR0
X-IronPort-AV: E=Sophos;i="4.27,719,1204470000"; 
   d="scan'208";a="335052449"
Subject: Re: [lm-sensors] Accelerometer etc subsystem (Update on progress)
From: Ben Nizette <bn@niasdigital.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>, hmh@hmh.eng.br,
       spi-devel-general@lists.sourceforge.net,
       Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <4864B6D6.3020509@cam.ac.uk>
References: <4832A211.4040206@gmail.com>
	 <20080520132817.03fb74ea@hyperion.delvare> <4863D97A.9090102@gmail.com>
	 <1214537367.8462.157.camel@moss.renham>  <4864B6D6.3020509@cam.ac.uk>
Content-Type: text/plain
Organization: Nias Digital
Date: Sat, 28 Jun 2008 18:34:17 +1000
Message-Id: <1214642057.4265.7.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-27 at 10:45 +0100, Jonathan Cameron wrote:
> Ben Nizette wrote:
> > On Thu, 2008-06-26 at 19:01 +0100, Jonathan Cameron wrote:
> > 
> >> Sysfs -    Parameter Control - gain / offsets etc
> >>     State control, turn interrupts on and off etc.
> > 
> > As in turn userspace [interrupt] event notification on and off?  I would
> > have thought it'd be the kernel driver's responsibility to turn the
> > device's interrupt generation on and off according to needs for
> > data/events etc.
> Ok, there is a division here between interrupt handling on the host side
> which indeed should be turned on and off transparently by the driver 
> and actually telling the sensor which interrupts to generate.  In a sense
> this is simply a case of terminology and what is actually being requested
> is event notifications (which then match with those sent up to userspace).

Righteo, I suspected as much :-)

< snip good replies :-) >

> 
> > also:
> > 
> > +/* As the ring buffer contents are device dependent this functionality
> > + * must remain part of the driver and not the ring buffer subsystem */
> > +static ssize_t
> > +lis3l02dq_read_accel_from_ring(struct industrialio_ring_buffer *ring,
> > +			       int element, char *buf)
> > +{
> > +	int val, ret, len;
> > +	uint16_t temp;
> > +	char *data, *datalock;
> > +
> > +	data = kmalloc(8, GFP_KERNEL);
> > +	if (data == NULL) {
> > +		ret = -ENOMEM;
> > +		goto error_ret;
> > +	}
> > +	ret = industrialio_read_last_from_ring(ring, data);
> > +	datalock = data + 2*element;
> > 
> > I haven't looked deeply at the ringbuffer code but can you guarantee
> > that later elements are at higher addresses than the lower ones?  As in,
> > can one datum in the the ring buffer wrap to the beginning again?
> At the moment the ring buffer has to be a whole number of datums big.
> I'm inclined to keep it way and move more towards dynamic allocation
> such that it is true than to try handling split data reading sets.

Yup, agreed.  Just so long as your code thinks about :-)

>  
> > +	kfree(data);
> > 
> > You free the data before you use it?  Though you are using it through a
> > different pointer below.  I wouldn't be scared of allocating 8 bytes on
> > the stack rather than kmalloc'ing (unless you expect this to be called
> > in a deep callchain)
> Ouch.  That's an out and out bug!
> > 
> > +	temp = (((uint16_t)((datalock[1]))) << 8)
> > +		| (uint16_t)(datalock[0]);
> > +	val = *((int16_t *)(&temp));
> > 
> > All this data/datalock/bitshuffle nonsense would be nicer if you just
> > used structs and unions, yeah?
> > 
> > union channel {
> > 	char data[2];
> > 	int16_t val;
> > }
> Good point, I'd forgotten you could do that with unions.

Cool, just watch endianness of course :-)

> > 
> > struct datum {
> > 	union channel elements[3];
> > }
> > 
> > or something.
> > 
> > +	len = sprintf(buf, "ring %d\n", val);
> > +
> > +	return len;
> > +error_ret:
> > +	return ret;
> > +}
> Good approach, I'll switch to that.
> 
> > 
> > Incidentally, is there much that your ringbuffer can do which kfifo
> > can't?  Apart from having a bunch of extra nice accessor-helpers sitting
> > on the top.
> Not sure, I'll look into it.

kfifo won't be a drop in replacement, it's just a very simple ring fifo.
I suspect your higher level ring buffer accessors and allocators could
live on top of it though.

> > 
> > Overall looking good and useful, can't wait 'till it's done :-)
> Thanks for the comments.
> 
> Jonathan

np,
	--Ben.


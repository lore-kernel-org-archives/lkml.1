Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYGXKdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYGXKdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYGXKdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:33:10 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:49994 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYGXKdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:33:09 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48885A6B.6080905@cam.ac.uk>
Date: Thu, 24 Jul 2008 11:33:15 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>, hmh@hmh.eng.br,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 1/4] Industrialio Core
References: <488763AD.4050400@gmail.com> <488765A5.3040703@gmail.com> <20080723194230.GE26938@trinity.fluff.org>
In-Reply-To: <20080723194230.GE26938@trinity.fluff.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Firstly thanks for taking a look at this.

Ben Dooks wrote:
>> +/* The actual event being pushed ot userspace */
>> +struct iio_event_data {
>> +	int id;
>> +	s64 timestamp;
>> +};
> 
> So is this an header for an event? Where is the data in this, this
> is confusing... Also, should we have a framework to produce an
> key/pair data, so that an single event can export multiple values
> from one event...
> 
> ie:
> 
> struct event_header {
> 	unsigned int 	id;
> 	unsigned int	nr_data;	/* number of event_data after */
> 	s64		timestamp;
> 
> struct event {
> 	struct event_header	header;
> 	struct event_data	data[0];
> };
 
At the current time at least the purpose of events in this subsystem is rather
different from those in say the input system.  So far they have all
corresponded to things that don't actually have any data associated with them.

The list so far is:
Ring bufer 50% full, Ring buffer 75% full (due to the support for escalating
events, only the highest of these will ever be in the queue).

Motion detected, device dependent on whether this is for specific axis.

Thresholds breached.

Tap detection (common on accelerometers)

Anyhow I did originally start our with a similar layout to you have suggested
(based in input subsystem) but removed it for now as it is currently unecessary.

 
> the naming of these structures is rather long.
> 
>> +/* Requires high resolution timers */
>> +/*  TODO - provide alternative if not available? */
>> +static inline s64 iio_get_time_ns(void)
>> +{
>> +	struct timespec ts;
>> +	ktime_get_ts(&ts);
>> +	return timespec_to_ns(&ts);
>> +}
> 
> do we really need something that accurate? we should at-least have
> the option to remove the timestamp or choose something of lower
> accuracy?

Not necessarily, hence the TODO.  I've been wondering about using an approach
similar to the 'scan' modes seen in the max1363 driver in which the time stamp
will simply be another 'input' recorded to the ring buffer as necessary.  Within
the event structure, this is certainly something that needs to be configurable.

>> +
>> +#define INIT_IIO_SW_RING_BUFFER(ring, _bytes_per_datum, _length) {	\
>> +		INIT_IIO_RING_BUFFER(&(ring)->buf,			\
>> +				     _bytes_per_datum,			\
>> +				     _length);				\
>> +		(ring)->read_p = 0;					\
>> +		(ring)->write_p = 0;					\
>> +		(ring)->last_written_p = 0;				\
>> +		(ring)->data = kmalloc(_length*(ring)->buf.size,	\
>> +				       GFP_KERNEL);			\
>> +		(ring)->use_count = 0;					\
>> +		(ring)->use_lock = __SPIN_LOCK_UNLOCKED((ring)->use_lock); \
>> +	}
> 
> these should be inlined functions.
Oops, I'll clean them up. Thanks for pointing that out.
>> +
>> +int iio_request_sw_ring_buffer(int bytes_per_datum,
>> +			       int length,
>> +			       struct iio_sw_ring_buffer **ring,
>> +			       int id,
>> +			       struct module *owner,
>> +			       struct device *dev);
>> +
> 
> how about tying this to a driver, where you already know the owner
> and the dev?
Good point.

>> +
>> +struct iio_work_cont {
>> +	struct work_struct ws;
>> +	struct work_struct ws_nocheck;
>> +	int address;
>> +	int mask;
>> +	void *st;
>> +};
>> +#define INIT_IIO_WORK_CONT(cont, _checkfunc, _nocheckfunc, _add, _mask, _st)\
>> +	do {								\
>> +	INIT_WORK(&(cont)->ws, _checkfunc);				\
>> +	INIT_WORK(&(cont)->ws_nocheck, _nocheckfunc);			\
>> +	(cont)->address = _add;						\
>> +	(cont)->mask = _mask;						\
>> +	(cont)->st = _st;						\
>> +	} while (0)
> 
> more nasty macros.
Yes, definitely need to get rid of most of them.
[ring buffer code]
> Nice idea, I just don't get what is actually going on in
> here. This needs more planning.

I definitely should have put together some more explanatory documents explaining
the aims and approach taken for the ring buffer handling. I'll get some initial
stuff writen and posted here shortly.

Thanks for taking a look and your suggestions,

--
Jonathan Cameron

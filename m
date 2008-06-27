Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbYF0D3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbYF0D3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 23:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYF0D3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 23:29:22 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:51827
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbYF0D3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 23:29:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMAAOj7Y0jLrQkK/2dsb2JhbAAIszk
X-IronPort-AV: E=Sophos;i="4.27,713,1204470000"; 
   d="scan'208";a="348244524"
Subject: Re: Accelerometer etc subsystem (Update on progress)
From: Ben Nizette <bn@niasdigital.com>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, Dmitry Torokhov <dtor@mail.ru>,
       Ben Dooks <ben@fluff.org>, mgross@linux.intel.com, hmh@hmh.eng.br,
       "Hans J. Koch" <hjk@linutronix.de>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <4863D97A.9090102@gmail.com>
References: <4832A211.4040206@gmail.com>
	 <20080520132817.03fb74ea@hyperion.delvare>  <4863D97A.9090102@gmail.com>
Content-Type: text/plain
Organization: Nias Digital
Date: Fri, 27 Jun 2008 13:29:27 +1000
Message-Id: <1214537367.8462.157.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-26 at 19:01 +0100, Jonathan Cameron wrote:

> Sysfs -    Parameter Control - gain / offsets etc
>     State control, turn interrupts on and off etc.

As in turn userspace [interrupt] event notification on and off?  I would
have thought it'd be the kernel driver's responsibility to turn the
device's interrupt generation on and off according to needs for
data/events etc.

I know this is in a rough state but a few comments anyway.  First, there
are heaps of casts-of-void-pointers (eg casts of kmalloc returns) which
are superfluous and hard readability 'coz you have to split the line to
fit in 80cols.

And hardcoded type-size assumptions everywhere.  Don't be scared of
sizeof ;-)


> Anyhow, all comments welcome.  Can anyone think of a better name?
> (I'm not keen on industrialio. It's too long if nothing else!
>  It will do as a working title for now)

I don't mind industrial io but as a function prefix, iio works better.
I can't see it being used elsewhere.

also:

+/* As the ring buffer contents are device dependent this functionality
+ * must remain part of the driver and not the ring buffer subsystem */
+static ssize_t
+lis3l02dq_read_accel_from_ring(struct industrialio_ring_buffer *ring,
+			       int element, char *buf)
+{
+	int val, ret, len;
+	uint16_t temp;
+	char *data, *datalock;
+
+	data = kmalloc(8, GFP_KERNEL);
+	if (data == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+	ret = industrialio_read_last_from_ring(ring, data);
+	datalock = data + 2*element;

I haven't looked deeply at the ringbuffer code but can you guarantee
that later elements are at higher addresses than the lower ones?  As in,
can one datum in the the ring buffer wrap to the beginning again?

+	kfree(data);

You free the data before you use it?  Though you are using it through a
different pointer below.  I wouldn't be scared of allocating 8 bytes on
the stack rather than kmalloc'ing (unless you expect this to be called
in a deep callchain)

+	temp = (((uint16_t)((datalock[1]))) << 8)
+		| (uint16_t)(datalock[0]);
+	val = *((int16_t *)(&temp));

All this data/datalock/bitshuffle nonsense would be nicer if you just
used structs and unions, yeah?

union channel {
	char data[2];
	int16_t val;
}

struct datum {
	union channel elements[3];
}

or something.

+	len = sprintf(buf, "ring %d\n", val);
+
+	return len;
+error_ret:
+	return ret;
+}


Incidentally, is there much that your ringbuffer can do which kfifo
can't?  Apart from having a bunch of extra nice accessor-helpers sitting
on the top.

Overall looking good and useful, can't wait 'till it's done :-)
	--Ben.



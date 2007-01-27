Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbXA0KWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbXA0KWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 05:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXA0KWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 05:22:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35894 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbXA0KWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 05:22:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45BB27AF.7030007@s5r6.in-berlin.de>
Date: Sat, 27 Jan 2007 11:21:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Pieter Palmers <pieterp@joow.be>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC] cycle timer read extension for raw1394/libraw1394
References: <45BA5CFD.6070900@joow.be>
In-Reply-To: <45BA5CFD.6070900@joow.be>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc lkml)

Pieter Palmers wrote to linux1394-devel:
> Attached are two patches containing an extension to libraw1394 and the
> kernel stack, implementing the simultaneous read of the isochronous
> cycle timer and the system clock (in usecs). This implements what has
> been requested before on the list.
> 
> There is one issue left, namely that I didn't disable preemption when
> doing the timer reads. In order to have a reliable simultaneous read of
> both values, I think IRQ's and preemption should be disabled while
> reading them.

Thus?
	preempt_disable();
	local_irq_save(flags);

	read_cycle_timer;
	read_time_of_day;

	local_irq_restore(flags);
	preempt_enable();

in hpsb_read_cycle_timer.

> Kernel patch applies against 2.6.20-rc6.
> libraw1394 patch applies against SVN.
> 
> Please comment.
> 
> Greets,
> 
> Pieter Palmers
> 
> 
> ------------------------------------------------------------------------
> 
> diff -u ../linux-2.6/drivers/ieee1394/ieee1394_core.c ieee1394-2.6.20/ieee1394_core.c
> --- ../linux-2.6/drivers/ieee1394/ieee1394_core.c	2007-01-26 18:29:07.000000000 +0100
> +++ ieee1394-2.6.20/ieee1394_core.c	2007-01-26 18:37:16.000000000 +0100
> @@ -34,6 +34,8 @@
>  #include <linux/suspend.h>
>  #include <linux/kthread.h>
>  
> +#include <linux/time.h>
> +
>  #include <asm/byteorder.h>
>  
>  #include "ieee1394_types.h"

No empty line necessary above #include <linux/time.h>.

> @@ -940,6 +942,13 @@
>  	}
>  }
>  
> +void hpsb_read_cycle_timer(struct hpsb_host *host, u32 *ctr, u64 *local_time)
> +{
> +	struct timeval tv;

Empty line would be OK here.

> +	*ctr = host->driver->devctl(host, GET_CYCLE_COUNTER, 0);
> +	do_gettimeofday(&tv);
> +	*local_time=tv.tv_sec*1000000+tv.tv_usec;
> +}

Couldn't this overflow?
	*local_time = tv.tv_sec * 1000000L + tv.tv_usec;
or
	*local_time = tv.tv_sec * USEC_PER_SEC + tv.tv_usec;

>  static void abort_requests(struct hpsb_host *host)
>  {
> @@ -1209,6 +1218,7 @@
>  EXPORT_SYMBOL(hpsb_read);
>  EXPORT_SYMBOL(hpsb_write);
>  EXPORT_SYMBOL(hpsb_packet_success);
> +EXPORT_SYMBOL(hpsb_read_cycle_timer);
>  
>  /** highlevel.c **/
>  EXPORT_SYMBOL(hpsb_register_highlevel);
> diff -u ../linux-2.6/drivers/ieee1394/ieee1394_core.h ieee1394-2.6.20/ieee1394_core.h
> --- ../linux-2.6/drivers/ieee1394/ieee1394_core.h	2007-01-26 18:11:17.000000000 +0100
> +++ ieee1394-2.6.20/ieee1394_core.h	2007-01-26 18:37:16.000000000 +0100
> @@ -227,4 +227,8 @@
>  extern struct class hpsb_host_class;
>  extern struct class *hpsb_protocol_class;
>  
> +/* Reads the cycle timer, and the local time at which it was read.
> + */
> +void hpsb_read_cycle_timer(struct hpsb_host *host, u32 *ctr, u64 *local_time);
> +
>  #endif /* _IEEE1394_CORE_H */

(This reminds me that many of ieee1394's exported symbols lack kerneldoc
comments.)

Alas I can't comment on the design & implementation of the userspace
ABI, that's out of my league.

> diff -u ../linux-2.6/drivers/ieee1394/ieee1394-ioctl.h ieee1394-2.6.20/ieee1394-ioctl.h
> --- ../linux-2.6/drivers/ieee1394/ieee1394-ioctl.h	2007-01-26 18:11:17.000000000 +0100
> +++ ieee1394-2.6.20/ieee1394-ioctl.h	2007-01-26 18:40:04.000000000 +0100
> @@ -100,5 +100,6 @@
>  	_IO  ('#', 0x28)
>  #define RAW1394_IOC_ISO_RECV_FLUSH		\
>  	_IO  ('#', 0x29)
> -
> +#define RAW1394_IOC_GET_CYCLE_TIMER		\
> +	_IOR ('#', 0x30, struct _raw1394_cycle_timer)
>  #endif /* __IEEE1394_IOCTL_H */
> diff -u ../linux-2.6/drivers/ieee1394/raw1394.c ieee1394-2.6.20/raw1394.c
> --- ../linux-2.6/drivers/ieee1394/raw1394.c	2007-01-26 18:11:17.000000000 +0100
> +++ ieee1394-2.6.20/raw1394.c	2007-01-26 18:37:16.000000000 +0100
> @@ -2675,7 +2675,22 @@
>  	return dma_region_mmap(&fi->iso_handle->data_buf, file, vma);
>  }
>  
> -/* ioctl is only used for rawiso operations */
> +/* read the Isochronous Cycle Counter along with the cpu time */
> +static int raw1394_read_cycle_timer(struct file_info *fi, void __user * uaddr)
> +{
> +	struct _raw1394_cycle_timer ctr;
> +	struct hpsb_host *host = fi->host;
> +
> +	hpsb_read_cycle_timer(host, &ctr.cycle_timer, &ctr.local_time);
> +	if (copy_to_user(uaddr, &ctr, sizeof(ctr)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/* ioctl is only used for rawiso operations,
> + * and to read the cycle timer
> + */
>  static int raw1394_ioctl(struct inode *inode, struct file *file,
>  			 unsigned int cmd, unsigned long arg)
>  {
> @@ -2772,6 +2787,13 @@
>  		break;
>  	}
>  
> +	switch(cmd) {
> +		case RAW1394_IOC_GET_CYCLE_TIMER:
> +			return raw1394_read_cycle_timer(fi, argp);
> +		default:
> +		break;
> +	}
> +
>  	return -EINVAL;
>  }
>  
> diff -u ../linux-2.6/drivers/ieee1394/raw1394.h ieee1394-2.6.20/raw1394.h
> --- ../linux-2.6/drivers/ieee1394/raw1394.h	2007-01-26 13:15:58.000000000 +0100
> +++ ieee1394-2.6.20/raw1394.h	2007-01-26 18:37:16.000000000 +0100
> @@ -178,4 +178,11 @@
>  	__s16 xmit_cycle;
>  };
>  
> +/* Simultanous Isochronous Cycle Timer read and local clock read */
> +struct _raw1394_cycle_timer {
> +	__u32 cycle_timer;
> +
> +	/* local time in microseconds */
> +	__u64 local_time;
> +};
>  #endif /* IEEE1394_RAW1394_H */
> 
> 
> ------------------------------------------------------------------------
> 
> Index: src/ieee1394-ioctl.h
> ===================================================================
> --- src/ieee1394-ioctl.h	(revision 168)
> +++ src/ieee1394-ioctl.h	(working copy)
> @@ -106,6 +106,6 @@
>  	_IO  ('#', 0x28)
>  #define RAW1394_IOC_ISO_RECV_FLUSH              \
>  	_IO  ('#', 0x29)
> -
> -
> +#define RAW1394_IOC_GET_CYCLE_TIMER		\
> +	_IOR ('#', 0x30, struct _raw1394_cycle_timer)
>  #endif /* __IEEE1394_IOCTL_H */
> Index: src/raw1394.h
> ===================================================================
> --- src/raw1394.h	(revision 168)
> +++ src/raw1394.h	(working copy)
> @@ -118,7 +118,14 @@
>  	RAW1394_MODIFY_FREE
>  };
>  
> +/* Simultanous Isochronous Cycle Timer read and local clock read */
> +struct raw1394_cycle_timer {
> +	u_int32_t cycle_timer;
>  
> +	/* local time in microseconds */
> +	u_int64_t local_time;
> +};
> +
>  #ifdef __cplusplus
>  extern "C" {
>  #endif
> @@ -328,6 +335,18 @@
>   **/
>  void raw1394_iso_shutdown(raw1394handle_t handle);
>  
> +/**
> + * raw1394_get_cycle_timer - get the current value of the cycle timer
> + * @handle: libraw1394 handle
> + * @ctr: pointer to the target raw1394_cycle_timer struct
> + *
> + * Reads the cycle timer register, together with the system clock. It returns
> + * a reasonable estimate of the system time the cycle timer was read.
> + *
> + * Returns: the error code of the ioctl, or 0 if successful.
> + **/

The comment on accuracy could be dropped if preemption and IRQs are
disabled, right?

> +int raw1394_read_cycle_timer(raw1394handle_t handle, struct raw1394_cycle_timer *ctr);
> +
>  typedef int raw1394_errcode_t;
>  #define raw1394_make_errcode(ack, rcode) (((ack) << 16) | rcode)
>  #define raw1394_internal_err(errcode) ((errcode) < 0)
> Index: src/main.c
> ===================================================================
> --- src/main.c	(revision 168)
> +++ src/main.c	(working copy)
> @@ -478,3 +478,15 @@
>          return 0;
>  }
>  
> +int raw1394_read_cycle_timer(raw1394handle_t handle, struct raw1394_cycle_timer *ctr) 
> +{
> +	int err;
> +
> +	err = ioctl(handle->fd, RAW1394_IOC_GET_CYCLE_TIMER, ctr);
> +	if(err != 0) {
> +		return err;
> +	}
> +
> +    return 0;
> +}
> +
> Index: src/kernel-raw1394.h
> ===================================================================
> --- src/kernel-raw1394.h	(revision 168)
> +++ src/kernel-raw1394.h	(working copy)
> @@ -177,4 +177,11 @@
>  	__s16 xmit_cycle;
>  };
>  
> +/* Simultanous Isochronous Cycle Timer read and local clock read */
> +struct _raw1394_cycle_timer {
> +	__u32 cycle_timer;
> +
> +	/* local time in microseconds */
> +	__u64 local_time;
> +};
>  #endif /* IEEE1394_RAW1394_H */
> 
> 

-- 
Stefan Richter
-=====-=-=== ---= ==-==
http://arcgraph.de/sr/

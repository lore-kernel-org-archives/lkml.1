Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbYBHRUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbYBHRUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965025AbYBHRJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:09:10 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:54841 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759772AbYBHRJG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:09:06 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Xilinx: hwicap driver comments
Date: Fri, 8 Feb 2008 09:08:15 -0800
In-Reply-To: <47AB6552.7040503@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Xilinx: hwicap driver comments
Thread-Index: AchpxVM6xD+jeJ4USqWK9s4znIgH7wAHOLTQ
References: <47AB6552.7040503@gmail.com>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "Jiri Slaby" <jirislaby@gmail.com>,
       "Grant Likely" <grant.likely@secretlab.ca>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 08 Feb 2008 17:08:16.0713 (UTC) FILETIME=[32448B90:01C86A75]
Message-Id: <20080208170829.AD23B30805D@mail3-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed the 'send' button on this last night.

> -----Original Message-----
> From: Jiri Slaby [mailto:jirislaby@gmail.com]
> Sent: Thursday, February 07, 2008 12:09 PM
> To: Stephen Neuendorffer; Grant Likely
> Cc: Linux Kernel Mailing List; Andrew Morton
> Subject: Xilinx: hwicap driver comments
> 
> Hi,
> 
> first of all, I think that the driver should go through lkml before
upstream
> merge or at least be in -mm for a while (I think this used to be a
rule some
> time ago), correct me if I'm wrong, but none of it happened.
> 
> Few comments I have:
> - release f_op retval is silently ignored, I guess you will get your
device into
> undefined state when the first function fails (esp. when you interrupt
the sem)

Fixed.

> - semaphores are deprecated
converted to mutexes.

> - class_device_create is deprecated
Fixed.

> - module_init/exit functions should be __init, not __devinit/exit (not
a bug,
> it's subset)
Fixed.

> - this piece:
>          drvdata = kmalloc(sizeof(struct hwicap_drvdata), GFP_KERNEL);
>          if (!drvdata) {
>                  dev_err(dev, "Couldn't allocate device private
record\n");
>                  return -ENOMEM;
>          }
>   memset((void *)drvdata, 0, sizeof(struct hwicap_drvdata));
> 
>   kmalloc + memset = kzalloc
Fixed.

>   null probed_devices[id] on that fail path and on failed1 label
Fixed.
 
> - from/to (void *) casts are useless
> - io resources are at least ulong
Fixed to be resource_size_t.

> - don't understand this:
>                  memcpy(kbuf, drvdata->read_buffer, bytes_remaining);
>                  drvdata->read_buffer_in_use = bytes_remaining;
>                  free_page((unsigned long)kbuf);
Yeow.  Fixed so the sense of the memcpy correct.

> - can this overlap (=>memmove)?
>                  memcpy(drvdata->read_buffer + bytes_to_read,
>                                  drvdata->read_buffer, 4 -
bytes_to_read);
Yes, it can!  fixed.

Given the length of time that these errors have been there, I'm really
wondering if the added complexity of this buffer is worth it.

> - is platform probing function race-proof (like pci)?
Added another mutex around access to probed_devices

> - run sparse on it, you mix __user with non-__user at least
Fixed.  There is one warning (related to a function that is not called),
but I'd like to leave this in, as it should get bound to an ioctl, most
likely.

Thanks alot for the comments!

Steve



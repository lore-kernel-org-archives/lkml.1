Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbYBGWcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbYBGWcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbYBGWby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:31:54 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:49623 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754570AbYBGWbw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:31:52 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Xilinx: hwicap driver comments
Date: Thu, 7 Feb 2008 14:31:47 -0800
In-Reply-To: <47AB6552.7040503@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Xilinx: hwicap driver comments
Thread-Index: AchpxVM6xD+jeJ4USqWK9s4znIgH7wACKGHg
References: <47AB6552.7040503@gmail.com>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "Jiri Slaby" <jirislaby@gmail.com>,
       "Grant Likely" <grant.likely@secretlab.ca>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 07 Feb 2008 22:31:48.0224 (UTC) FILETIME=[3A045000:01C869D9]
Message-Id: <20080207223148.D0757DD807E@mail15-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



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

Hmm..  hadn't realized that.  I'm open to suggestions on how to do this
better.  The real reason why the synchronization is there is to make
sure that only one client is using the device at a time, using the
is_open flag.

> - semaphores are deprecated
> - class_device_create is deprecated

What is preferred?

> - module_init/exit functions should be __init, not __devinit/exit (not
a bug,
> it's subset)
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
>   null probed_devices[id] on that fail path and on failed1 label
> 
> - from/to (void *) casts are useless
> - io resources are at least ulong

easily fixed.

> - don't understand this:
>                  memcpy(kbuf, drvdata->read_buffer, bytes_remaining);
>                  drvdata->read_buffer_in_use = bytes_remaining;
>                  free_page((unsigned long)kbuf);

The physical device only generates/accepts complete words, the intention
is to account for the possibility that a read does not read complete
words, and to fulfill the read whenever possible.
It's arguable that read() and write() should not accept or return
partial words, I suppose

> - can this overlap (=>memmove)?
>                  memcpy(drvdata->read_buffer + bytes_to_read,
>                                  drvdata->read_buffer, 4 -
bytes_to_read);
> - is platform probing function race-proof (like pci)?

no idea.  even if it is, it's unlikely that the of_driver probing is
protected by the same lock as the platform_driver probing.

> - run sparse on it, you mix __user with non-__user at least

I thought I had been.... hmm... looks like a few other things to fix
there, too.

Steve



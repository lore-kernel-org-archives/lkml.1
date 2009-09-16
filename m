Return-Path: <linux-kernel-owner+w=401wt.eu-S1758425AbZIPWUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbZIPWUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbZIPWUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:20:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:40745 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073AbZIPWUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:20:15 -0400
Message-ID: <4AB164A0.8000402@codemonkey.ws>
Date: Wed, 16 Sep 2009 17:20:16 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Amit Shah <amit.shah@redhat.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic
 guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>	<20090911170010.34c80f2d@linux.intel.com>	<20090911163806.GB25535@amit-x200.redhat.com>	<4AAA8838.1080106@codemonkey.ws>	<20090911173307.GB27046@amit-x200.redhat.com>	<4AAA8A56.3040707@codemonkey.ws> <20090916112332.6bf981a5@linux.intel.com>
In-Reply-To: <20090916112332.6bf981a5@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> This device is very much a serial port.  I don't see any reason not
>> to treat it like one.
>>     
>
> Here are a few
>
> - You don't need POSIX multi-open semantics, hangup and the like
>   

We do actually want hangup and a few other of the tty specific ops.  The 
only thing we really don't want is a baud rate.

> - Seek makes sense on some kinds of fixed attributes
>   

I don't think we're dealing with fixed attributes.  These are streams.  
Fundamentally, this is a paravirtual uart.  The improvement over a 
standard uart is that there can be a larger number of ports, ports can 
have some identification associated with them, and we are not 
constrained to the emulated hardware interface which doesn't exist on 
certain platforms (like s390).

> - TTY has a relatively large memory overhead per device
> - Sysfs is what everything else uses
> - Sysfs has some rather complete lifetime management you'll need to
>   redo by hand
>   

sysfs doesn't model streaming data which is what this driver provides.

> - You don't need idiotic games with numbering spaces
>
> Abusing tty for this is ridiculous.

If the argument is that tty is an awkward interface that should only be 
used for legacy purposes, then sure, we should just implement a new 
userspace interface for this.  In fact, this is probably supported by 
the very existence of hvc.

On the other hand, this is fundamentally a paravirtual serial device.  
Since serial devices are exposed via the tty subsystem, it seems like a 
logical choice.

>  In some ways putting much of it in
> kernel is ridiculous too as you can do it with a FUSE fs or simply
> export the info guest-guest using SNMP.
>   

This device cannot be implemented as-is in userspace because it depends 
on DMA which precludes the use of something like uio_pci.  We could 
modify the device to avoid dma if the feeling was that there was no 
interest in putting this in the kernel.

Regards,

Anthony Liguori

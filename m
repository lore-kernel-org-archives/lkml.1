Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbXFMSJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbXFMSJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758641AbXFMSJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:09:44 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58980
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446AbXFMSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:09:43 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Valdis.Kletnieks@vt.edu
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Date: Wed, 13 Jun 2007 14:09:37 -0400
User-Agent: KMail/1.9.6
Cc: holzheu@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, akpm@osdl.org, gregkh@suse.de,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <1181747217.29512.9.camel@localhost.localdomain> <17542.1181753455@turing-police.cc.vt.edu>
In-Reply-To: <17542.1181753455@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131409.38636.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 12:50:55 Valdis.Kletnieks@vt.edu wrote:
> > In general we think, that also for Linux it is a good thing to have
> > documentation for the most important kernel/driver messages. Even
> > kernel hackers not always are aware of the meaning of kernel messages
> > for components, which they don't know in detail. Most of the messages
> > are self explaining but sometimes you get something like "Clocksource
> > tsc unstable (delta = 7304132729 ns)" and you wonder if your system is
> > going to explode.

Isn't this what the severity levels are for?  Not just filtering messages out 
but telling you whether or not it's important?

> This is probably best addressed by cleaning up the actual messages so
> they're a bit more informative.

Seconded.

The point of a diagnostic message is to convey information.  Deep in the 
bowels of chipsets there are diagnostic messages that get spit out as 
hexcodes that some program needs to interpret, but that's why we have tools 
like http://kernel.org/pub/linux/kernel/people/davej/tools/parsemce.c and 
such.

If the diagnostic messages need a talmud, I see this is as more of a problem 
with said diagnostic messages, rather than excuse to add another layer.

> > New macros KMSG_ERR(), KMSG_WARN(), etc. are defined, which have to be
> > used in printk. These macros have as parameter the message number and
> > are using a per c-file defined macro KMSG_COMPONENT.
>
> Gaak. *NO*.

If you're going to tweak printk, please make the darn thing take an integer 
first argument rather than a string first argument, so we can use clever 
macros to remove them at compile time rather than having them compiled in but 
not displaying.

This is one of those things buried down on my todo list.  I think it can be 
converted incrementally

Going back to the original patch here, there are exactly two examples of what 
this brave new infrastructure would be used for:

> +/**
> + * message
> + * @0: Device number of device
> + * @1: Status of device
> + *
> + * Description:
> + * Information message about the status of our virtual msgtest device. The
> + * following values for the status parameter are available.
> + *
> + *   0 - Device is offline
> + *
> + *   1 - Device is online
> + *
> + *   2 - Device is broken
> + *
> + * User Response:
> + * If device is broken, replace it or fix it.
> + */
> +
> +KMSG_DOC(kmsgtest, 1, "device %x has status %i");

This is just a thought: why not have the actual kprintf say "Device number %x 
is %s" where %s is "online", "offline", or "broken"?

I.E. have the kernel output a user readable message in the first place.

> +/**
> + * message
> + * @0: Device number of device.
> + *
> + * Description:
> + * An operation has been performed on the msgtest device, but the device
> has + * not been set online. Therefore the operation failed.
> + *
> + * User Response:
> + * Operator should set device online. Issue "chccwdev -e <device number>".
> + */
> +
> +KMSG_DOC(kmsgtest, 2, "device %x not online");

kprintf(LEVEL "device %x not online, try 'chccwdev -e %x'", devnum, devnum)

Rob

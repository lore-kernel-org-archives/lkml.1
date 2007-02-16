Return-Path: <linux-kernel-owner+w=401wt.eu-S1946156AbXBPUvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946156AbXBPUvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946163AbXBPUvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:51:43 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2681 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946156AbXBPUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:51:42 -0500
Date: Fri, 16 Feb 2007 20:51:35 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070216205134.GF2572@flint.arm.linux.org.uk>
Mail-Followup-To: Rodolfo Giometti <giometti@enneenne.com>,
	linux-kernel@vger.kernel.org
References: <20070216185230.GO8882@enneenne.com> <20070216191207.GC2572@flint.arm.linux.org.uk> <20070216204336.GB4641@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216204336.GB4641@enneenne.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 09:43:36PM +0100, Rodolfo Giometti wrote:
> On Fri, Feb 16, 2007 at 07:12:08PM +0000, Russell King wrote:
> > 
> > Yuck.  Please.  No.  Doing it this way means you have to modify every
> > single serial driver out there which is a mamouth task.
> > 
> > >  			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
> > 
> > Did you not look to see what's in this helper?  You'll find within here
> > the following code:
> > 
> > #ifdef CONFIG_HARD_PPS
> >         if ((port->flags & UPF_HARDPPS_CD) && status)
> >                 hardpps();
> > #endif
> > 
> > which should've been a big sign lit up in bright lights in Times Square
> > pointing you towards the right place to put your code.
> 
> Ok.
> 
> > Why not continue to leave it as a decision of the administrator - if
> > you want ports to default to having PPS support enabled, change all
> > the registration to set UPF_HARDPPS_CD.  But leave the admin with
> > the ability to disable it.
> 
> Ok.
> 
> > This means that PPS support is not available for any port which wasn't
> > autoprobed at device discovery time.  That seems quite restrictive.
> 
> How I can force probing for a specified uart port?

You can't because it doesn't go through the interfaces you're hooking
into.  Existing interfaces are "changed" to point at the UARTs using
setserial, which does its work via an ioctl.

> > Maybe it needs to be coupled with the setting/clearing of UPF_HARDPPS_CD ?
> 
> What do you think about? I should enable the PPS support only if the
> userland sets the UPF_HARDPPS_CD flag?

Not specifically only userland - if it happens to be set when the port
is registered then enable PPS support then as well.

So:

1. uart_configure_port - if UPF_HARDPPS_CD is set, register the port
   for PPS support.
2. uart_remove_one_port - if UPF_HARDPPS_CD is set, unregister the port
   for PPS support.
3. uart_set_info - if changing UPF_HARDPPS_CD, appropriately register or
   unregister the port for PPS support.

PS, linuxpps@ml.enneenne.com dropped from the cc: since it rejects my
postings.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

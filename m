Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbXGXSKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbXGXSKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbXGXSKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:10:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753340AbXGXSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:10:31 -0400
Date: Tue, 24 Jul 2007 11:09:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu?= =?ISO-8859-1?Q?=E9?= 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
Message-Id: <20070724110946.8678d202.akpm@linux-foundation.org>
In-Reply-To: <46A63BC3.3050208@garzik.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
	<200707240948.45916.bjorn.helgaas@hp.com>
	<46A63BC3.3050208@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 13:49:55 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Bjorn Helgaas wrote:
> > On Tuesday 24 July 2007 08:28:05 am S__bastien Dugu__ wrote:
> >>  your commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26 broke the serial console
> >> on my box. Adding 'legacy_serial.force=1' to my boot param as a workaround
> >> solves the issue, but this may be hiding bugs in Linux PnP support or
> >> in my firmware.
> > 
> > Thanks for your report.  We need to figure out why the 8250_pnp driver
> > didn't find your serial console device.  Can you confirm that you also
> > have CONFIG_ACPI and CONFIG_PNPACPI in your .config?
> > 
> > If you have those, and it still doesn't work, can you collect the DSDT
> > dump, the output of "grep . /sys/bus/pnp/devices/*/*", and the dmesg
> > from your "legacy_serial.force=1" boot?  Then we can tell which port
> > the blind probe finds and whether it's described somewhere by ACPI.
> 
> hrm...
> 
>      x86, serial: convert legacy COM ports to platform devices
> 
>      Make x86 COM ports into platform devices and don't probe for them
>      if we have PNP.
> 
> This seems like it will break decades-long-working stuff, in favor of 
> breaking new ground in our favorite area, "trusting the BIOS."
> 
> It's just not worth it for serial ports, IMO.  Serial ports are 
> something that just shouldn't break at this late stage in the game.  My 
> new Intel platform boxes don't even have serial ports, so I question the 
> value of messing with serial port probing even more... because... just 
> wait a year, and your box won't have a serial port either!  :)
> 
> I certainly don't object to the use of platform devices (or isa_driver), 
> but the probe change seems questionable.  That's sorta analagous to 
> rewriting the floppy driver probe routine.  Sure you could do it... but 
> why risk all that damage and go through debugging all over again?
> 
> It seems clear from this report that we cannot, should not, trust BIOS 
> for something (a) so simple and (b) that has been working for over a decade.
> 

Well I queued up a tentative revert patch but then I re-read the changlog:

    x86, serial: convert legacy COM ports to platform devices
    
    Make x86 COM ports into platform devices and don't probe for them
    if we have PNP.
    
    This prevents double discovery, where a device was found both by
    the legacy probe and by 8250_pnp, e.g.,
    
        serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
        00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
    
    This also means IRDA devices without a UART PNP ID will no longer be
    claimed by the serial driver, which might require changes in IRDA
    drivers and administration.
    
    In addition to this patch, you may need to configure a setserial init
    script, e.g., /etc/init.d/setserial, so it doesn't poke legacy UART
    stuff back in.  On Debian, "dpkg-reconfigure setserial" with the "kernel"
    option does this.
    
    To force the old legacy probe behavior even when we have PNPBIOS or
    ACPI, load the new legacy_serial module (or build 8250 static) with
    the "legacy_serial.force" option.

So 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26 fixed a bunch of longstanding
nasties while breaking Sebastien's machine (at least).

We of course want the best of both worlds here, so I'll keep the revert
patch in -mm for a while, see what happens.  Although I can't immediately
see any way in which this can be fixed...

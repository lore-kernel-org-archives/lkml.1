Return-Path: <linux-kernel-owner+w=401wt.eu-S2992727AbXDDHrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992727AbXDDHrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 03:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992723AbXDDHrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 03:47:52 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3302 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992722AbXDDHrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 03:47:51 -0400
Date: Wed, 4 Apr 2007 08:47:36 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, paulus@samba.org, dwmw2@infradead.org,
       linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404074736.GA3440@flint.arm.linux.org.uk>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	alan@lxorguk.ukuu.org.uk, paulus@samba.org, dwmw2@infradead.org,
	linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
	linux-kernel@vger.kernel.org
References: <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <20070403.165518.55726194.davem@davemloft.net> <20070404021924.71e87580@the-village.bc.nu> <20070403.182125.77058566.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403.182125.77058566.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 06:21:25PM -0700, David Miller wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Wed, 4 Apr 2007 02:19:24 +0100
> 
> > > I totally agree with Paul, the onboard serial device should get
> > > ttyS0 regardless of what hardare is used to drive it.
> > 
> > Thats between you and udev.
> 
> That might be true when udev exists, but it doesn't for the console
> specification on the kernel command line.

FACT: you can only have one struct console with one name.

FACT: If you have two struct consoles using the same name, the driver
 which wins the priviledge of console is unpredictable.

FACT: there is no way to know at any particular driver registration time
 how many "generic" serial ports will be available - as required for the
 chardev and tty layers.

There are very real issues that need fixing deep within the kernel
before you can even think about the possibility of *PROPERLY* supporting
all serial ports beneath one namespace.

Before someone whinges "we did it in 2.4" my answer is: yes, you hacked
around the problem in 2.4 creating an utter mess in the process.

If you want to see what an utter mess pushing all serial ports towards
ttyS* creates in 2.5 kernels (which will be similar for 2.6), look at
these patches:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=1427/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=1428/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=1429/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=1431/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=1432/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=1433/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=1435/2
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=1436/2

Moreover, note that the serial core is statically configured with the
*maximum* number of ports it will ever support.  Tough luck if you're
a distro and wanting to allow users to support multi-port serial cards.

Since we've been where we are for years and years, my take on this
subject has always been: we should *not* abuse any of the existing
allocations.  If we want to create a single namespace for serial ports
we should obtain a *new* allocation and migrate drivers over to that
namespace, avoiding any bastardisation of existing drivers.  Modulo
fixing the very real issues mentioned above first.

Feel free to continue whinging about it for a few more years.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

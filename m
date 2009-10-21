Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZJUIis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZJUIis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 04:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZJUIis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 04:38:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbZJUIiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 04:38:46 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
Date: Wed, 21 Oct 2009 10:38:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alexander Huemer <alexander.huemer@sbg.ac.at>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
References: <4ABBB8C2.2080901@sbg.ac.at> <4AD422F2.4080308@sbg.ac.at> <4AD473F9.7090606@kernel.org>
In-Reply-To: <4AD473F9.7090606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910211038.47653.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun, Alexander,

Le mardi 13 octobre 2009, Tejun Heo a écrit :
> Alexander Huemer wrote:
> > i compiled gcc in a loop over night, 14 times. no error.
> > it really seams i2c_i801 was the cause...
> > unfortunately i still don't know how i can extract the part of the gcc
> > compilation process that causes the error on an affected kernel.
> > that would enable me to create a simple test program.
> 
> Given that i2c is used for temperature monitoring, I think it is not
> triggered by any single step of the compiling but rather by the
> accumulated heat load during compilation.  Let's wait for Jean to
> chime in.  :-)

OK, here I am, sorry for the delay. I've read the discussion thread.
Here are the few data points I can offer, in the hope it will help:

* While the i2c-i801 driver received some changes in kernel 2.6.30,
  none of these are related to PCI nor interrupts. So as the problem
  is new in kernel 2.6.30, the i2c-i801 driver alone is unlikely to
  cause it. This may, however, be a combination of something i2c-i801
  does and something the pci subsystem does since kernel 2.6.30. For
  this reason, I would still recommend a bisection if the problem can
  be reliably reproduced. I know it takes time, but it is always
  easier to fix a bug when we know which commit introduced it.

* The i2c-i801 driver does _not_ make use of interrupts. It is
  poll-based (I am not exactly proud of that, but that's the way it
  is.)

  #define ENABLE_INT9		0	/* set to 0x01 to enable - untested */

  So I am very surprised to read that this driver would cause an IRQ
  storm.

* One thing the i2c-i801 driver does on the PCI device is:

  err = pci_enable_device(dev);

  I presume this is what causes the following message in dmesg:

  i801_smbus 0000:00:1f.3: PCI INT B -> GSI 23 (level, low) -> IRQ 23

  Basically, even though the driver doesn't make use of interrupts,
  the IRQ is still registered because this is how the hardware is
  setup.

As a conclusion, I suspect that 2 things may be happening: either
the SMBus is triggering interrupts when told not to. The ICH6 is a
bit different from all the other supported chips, I'll double check
if we may have missed something. Or, something else is triggering
SMBus transactions. SMI and ACPI come to mind. If this is the case
then you do not want to use i2c-i801 on this motherboard.

Questions to Alexander :

* Can I please see the output of "sensors" on your system?
* What are the brand and model of your motherboard?
* Can we get an acpidump for your system?

-- 
Jean Delvare
Suse L3

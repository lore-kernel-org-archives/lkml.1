Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbXA2XFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbXA2XFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXA2XFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:05:54 -0500
Received: from ozlabs.org ([203.10.76.45]:39440 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbXA2XFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:05:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17854.32201.131104.928581@cargo.ozlabs.ibm.com>
Date: Tue, 30 Jan 2007 10:05:45 +1100
From: Paul Mackerras <paulus@samba.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: tony.luck@intel.com, grundler@parisc-linux.org, jeff@garzik.org,
       greg@kroah.com, linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz,
       brice@myri.com, shaohua.li@intel.com, mingo@elte.hu,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/6] MSI portability cleanups
In-Reply-To: <1170102158.26655.273.camel@localhost.localdomain>
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	<20070128.153707.30184351.davem@davemloft.net>
	<m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	<20070128.212554.23015561.davem@davemloft.net>
	<1170050737.26655.233.camel@localhost.localdomain>
	<m1sldukxwm.fsf@ebiederm.dsl.xmission.com>
	<1170102158.26655.273.camel@localhost.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt writes:

> > I'd hate to hit a different Hypervisor that did something close but
> > not quite the same and have the code fail then.  So definitely
> > avoiding touching pci config space at all in the calls seems to make a
> > lot of sense.  This includes avoiding pci_find_capability right?
> 
> Quite possibly yes. I'm pretty sure it will work on IBM HV but we aren't
> really supposed to use it...

Actually, I don't know of any reason why we can't use
pci_find_capability.  We are supposed to avoid trying to touch config
space of devices (in fact, functions) that aren't assigned to our
partition, but we're not talking about that here.

I just got an answer from the hypervisor architects.  It turns out
that the hardware _does_ prevent the device from sending MSI messages
to another partition.  The OS _can_ write whatever it likes to the MSI
address and data registers.  It can potentially lose interrupts (or, I
expect, get the device isolated by EEH) but it can't disrupt another
partition.

I think the reason why the hypervisor call writes the values straight
into the MSI/MSI-X registers in the device is (a) that's convenient
for AIX, since it saves it from immediately having to do more calls
into the hypervisor to write those values to the device, and (b) there
are some ABI complications in returning a lot of values, so the device
registers provide a convenient place to return those values.

So it would be possible, although gross, to do the hypervisor call,
read the values from config space and return them to the generic code,
then let the generic code write them to config space for us. :P

The remaining point of difference then seems to be that for MSI-X, we
really want to know up-front how many interrupts the device driver is
asking for, rather than having a series of alloc requests dribble in
one at a time.

Regards,
Paul.
